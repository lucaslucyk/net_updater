import ctypes
import mmap
import shutil
import os
import re
import sqlite3
import subprocess
from pathlib import Path

def is_admin():
    """ Return True if the current user is admin. """
    
    try:
        _is_admin = os.getuid() == 0
    except AttributeError:
        _is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0

    return _is_admin

def await_confirm(continue_with: str = 'y'):
    """ Stop code to entry y/Y. """

    entry = input("Continuar? (y/n):")
    while entry.lower() != 'y':
        entry = input("Continuar? (y/n):")

    return True

def change_service(service: str = 'netTimeV4', command: str = 'start'):
    """ Change service status. """

    try:
        output = subprocess.check_output(["net", command, service])
    except Exception as e:
        output = str(e)
    return output


def get_last_log(app_folder: str):
    """ Get path of last log file in app_folder. """

    # set logs folder
    dirpath = os.path.join(app_folder, 'Logs')
    
    # get all files order by date
    paths = sorted(Path(dirpath).iterdir(), key=os.path.getmtime)
    
    # safety only
    if not paths:
        return None
    
    # return last
    return paths[-1]


def get_license(app_folder: str):
    """ Get license number reading last log in app_folder. """

    # empty default
    nro_lic = ''

    # open file
    with open(file=get_last_log(app_folder), mode='rb', buffering=0) as file, \
            mmap.mmap(file.fileno(), 0, access=mmap.ACCESS_READ) as string:
        
        # search licencia
        pos = string.find(b'Licencia: ')
        
        # if founded, set posic and read number
        if pos:
            string.seek(pos + 10)
            nro_lic = string.read(5).decode()

    # return lic
    return nro_lic


def copy_structure(app_folder: str):
    """ Copy structure v4_to_v5 to app_folder folder. """

    # build origin and destiny paths
    # orig = os.path.join(os.path.dirname(os.getcwd()), 'v4_to_v5_5')
    orig = os.path.join(os.getcwd(), 'v4_to_v5_5')
    dest = os.path.join(app_folder, 'v4_to_v5_5')

    # remove directory if exist
    try:
        shutil.rmtree(dest)
    except FileNotFoundError:
        pass

    # copy data
    return shutil.copytree(orig, dest)


def make_backup(app_folder: str, app_name: str = 'netTimeV4'):
    """
    Make necessary backups in app_folder/v4_to_v5_5/1_SegDatosV4toV5/app_name
    """

    # dest bkp folder
    seg_folder = os.path.join(
        app_folder,
        'v4_to_v5_5',
        '1_SegDatosV4toV5',
        app_name
    )

    try:
        # remove old bkps
        shutil.rmtree(seg_folder)

        # move bkp folder
        shutil.move(
            os.path.join(app_folder, 'backup'),
            os.path.join(seg_folder, 'backup')
        )
    except FileNotFoundError:
        pass

    try:
        # folders to bkp
        exclude = [
            'backup',
            'v4_to_v5_5'
        ]

        # files to bkp
        files = [file for file in os.listdir(app_folder) if file not in exclude]

        for file in files:
            # copy path
            if os.path.isdir(os.path.join(app_folder, file)):
                # copy path
                shutil.copytree(
                    os.path.join(app_folder, file),
                    os.path.join(seg_folder, file)
                )
            # copy file
            elif os.path.isfile(os.path.join(app_folder, file)):
                shutil.copy2(
                    os.path.join(app_folder, file),
                    seg_folder
                )

        # general propose
        return True

    except Exception as error:
        return error


def remove_needs(app_folder: str, app: str = 'netTime', \
        exclude_bkp_inst: bool = False):
    """ Remove database files for current app. """

    # files to removes
    files = [
        f'{app}.mov',
        f'{app}.sl3',
        f'{app}.sl3-journal',
        'workflow.sl3'
    ]

    # remove files in directory (if exists)
    for file in files:
        if os.path.exists(os.path.join(app_folder, file)):
            os.remove(os.path.join(app_folder, file))

    # folders to remove
    folders = [
        'backup'
    ]

    # files to ignore
    bkp_name = 'config_backup__INSTALACION___0000.zip'
    bkp_ignore = os.path.join(app_folder, 'backup', bkp_name)

    # remove file in folders (if exists)
    for folder in folders:
        if os.path.isdir(os.path.join(app_folder, folder)):
            _files = Path(os.path.join(app_folder, folder)).iterdir()
            for f in _files:
                if exclude_bkp_inst and str(f) == str(bkp_ignore):
                    # nothing to do
                    continue
                else:
                    os.remove(f)

    # general propose
    return True


def run_installer(version: str = 'netTime 5.5.1.16168', \
        installer: str = 'netTime_x64_es_es.msi'):
    """ Run installer. Messages to ensure steps. """

    try:
        # build path and execute file
        file = os.path.join(
            #os.path.dirname(os.getcwd()), # remove dirname in PRD
            os.getcwd(),
            'installers',
            version,
            installer
        )
        os.startfile(file)

        return True
    
    except Exception as error:
        return error


def get_last_bkp(app_folder: str, app_name: str = 'netTimeV4'):
    """ Get last backup saved in 1_SegDatosV4toV5. """

    bkp_fodler = os.path.join(
        app_folder,
        'v4_to_v5_5',
        '1_SegDatosV4toV5',
        app_name,
        'backup'
    )
    # list backup elements
    items = sorted(Path(bkp_fodler).iterdir(),
                   key=os.path.getmtime, reverse=True)

    # get last config
    for item in items:
        if re.match('config_backup_\d*_\d*\.zip', item.name):
            element = item
            break
    else:
        element = None

    # return found element or None
    return element


def db_recovery(app_folder: str, app: str = 'netTime'):
    """ Restore databases saveds in  1_SegDatosV4toV5. """

    # dest bkp folder
    seg_folder = os.path.join(
        app_folder, 
        'v4_to_v5_5',
        '1_SegDatosV4toV5', 
        f'{app}V4'
    )

    # files to restore
    sl3 = [
        f'{app}.mov',
        f'{app}.sl3',
        'workflow.sl3'
    ]

    # restore databases
    for file in sl3:
        # ensure no files
        if os.path.exists(os.path.join(app_folder, file)):
            os.remove(os.path.join(app_folder, file))

        # restore
        shutil.copy2(
            os.path.join(seg_folder, file),
            app_folder
        )

    # general propose
    return True


def verify_access(app_folder: str, app: str = 'netTime', \
        access_number: int = None):
    """ Run select query to verify employees with access profile. """

    # build database path    
    db_file = os.path.join(app_folder, f'{app}.sl3')

    with sqlite3.connect(db_file) as conn:
        cursor = conn.cursor()

        # lic accesos
        cursor.execute("{} {}{}{}".format(
                "SELECT Count(*) FROM APPDATA WHERE IDTYPE = 14",
                "AND DATA LIKE '",
                '%parent="PerfilAccesos"%',
                "';"
            )
        )
        accesos = cursor.fetchone()
        accesos = accesos[0] if accesos else -1

    # if match with saved data
    if int(accesos) == int(access_number):
        return True

    # in difference case
    return False


def query_auto_generate(errors: list, app_folder: str, app: str = 'netTime'):
    """
    Build a queries to modify EndDate property in database to 2040 from error \
    dates.
    """

    # database file
    db_file = os.path.join(app_folder, f'{app}.sl3')

    # out queries
    queries = []

    with sqlite3.connect(db_file) as conn:
        cursor = conn.cursor()

        for error in errors:
            # build and execute select query
            cursor.execute(
                "{}{}{}".format(
                    "SELECT DATA FROM APPDATA WHERE DATA LIKE '%",
                    error,
                    "%' AND IDTYPE != 27 LIMIT 1;"
                )
            )
            # view one result only
            result = cursor.fetchone()
            if not result:
                # print("Error getting data with", error)
                continue

            # find datetime in text
            re_match = re.search(f'E{error[1:]}[\d\:\.]*', result[0])
            if not re_match:
                re_match = re.search(f'e{error[1:]}[\d\:\.]*', result[0])
                if not re_match:
                    # print("Error getting hour.", error, result[0], sep="\n")
                    continue

            # str match
            match = result[0][re_match.start(): re_match.end()]

            # split to fix hours to 00:00...
            m_split = match.split('T')
            hour = re.sub('\d', '0', m_split[1])

            # upper or lower case
            replace = 'endDate="2040-12-31T'
            if match.find("EndDate") >= 0:
                replace = 'EndDate="2040-12-31T'

            # query build
            new_query = '{}{}{}{}{}{}'.format(
                "UPDATE APPDATA SET DATA = REPLACE(DATA,'",
                match,
                "','",
                replace,
                hour,
                "') WHERE IDTYPE != 27;"
            )

            # append to generated queries
            #print("Adding", new_query)
            queries.append(new_query)

    # return builds
    return queries


def run_scripts(app_folder: str, app: str = 'netTime', queries: list = []):
    """ Run 2040 verify queries and auto build queries for error elements. """

    # database path
    db_file = os.path.join(app_folder, f'{app}.sl3')

    with sqlite3.connect(db_file) as conn:
        cursor = conn.cursor()

        # run update last date commands
        for command in queries:
            cursor.execute(command)

        # commit changes
        if queries:
            conn.commit()

        # verify results
        ld_results = {'_ok': [], '_error': [], '_exec_queries': queries}

        # list of verifies
        ld_verify_commands = [
            'EndDate="2019-12-30T',
            'EndDate="2019-12-31T',
            'EndDate="2020-01-01T',
            'EndDate="2020-12-31T',
            'EndDate="2030-12-31T',
            'endDate="2019-12-30T',
            'endDate="2019-12-31T',
            'endDate="2020-01-01T',
            'endDate="2020-12-31T',
            'endDate="2030-12-31T',
        ]

        # build and execute verifies
        for command in ld_verify_commands:
            cursor.execute(
                "{}{}{}".format(
                    "SELECT Count(*) FROM APPDATA WHERE DATA LIKE '%",
                    command,
                    "%' AND IDTYPE != 27;"
                )
            )

            result = cursor.fetchone()
            if result:
                if result[0] == 0:
                    ld_results['_ok'].append(command)
                else:
                    ld_results['_error'].append(command)

    if ld_results.get('_error'):
        #print("Error en fechas. Recursivando...")

        # recursive call if errors
        return run_scripts(
            app_folder=app_folder,
            app=app,
            queries=query_auto_generate(
                errors=ld_results.get('_error'),
                app_folder=app_folder,
                app=app
            )
        )

    # return resume
    return ld_results

def update_ini(app_folder: str, app: str = 'netTime'):
    """ Append or modify setting Configuration.LastYear=2040 in .ini file. """

    # function to match setting
    def match_setting(element):
        if re.match('Configuration\.LastYear\=\d*', element):
            return element

    # setting
    setting = 'Configuration.LastYear='

    # set path
    ini_path = os.path.join(app_folder, f'{app}.ini')

    # open file
    with open(ini_path, 'r') as f:
        content = f.readlines()

    # remove if founded
    found = list(filter(match_setting, content))
    if found:
        content.remove(found[0])

    # add setting
    content.append(f'{setting}2040\n')

    # open file
    with open(ini_path, 'w') as f:
       f.writelines(content)

    return True
