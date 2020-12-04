import sys
import utils
import settings

def data_update(element):
    var = input(f'{element}: {getattr(settings, element)}\n')
    if var:
        #print("Nuevo valor:", var, type(var))
        return var

    return getattr(settings, element)

if __name__ == '__main__':

    # verify permission
    print("Verificando permisos...")
    if not utils.is_admin():
        input("ERROR - Ejecute este script como administrador!")
        sys.exit()

    # msgs before start
    print("Asegúrese de: ")
    print("1- Guardar número de licencia y datos de activación.")
    print("2- Actualizar link activación.")
    print("3- Reiniciar servicio.")
    print("4- Reactivar licencia.")
    print("5- Guardar número de empleados con accesos.")
    print("6- Desactivar terminales.")
    print("7- Desactivar licencia.")

    # entry to continue
    utils.await_confirm()

    print("Actualizando datos. Enter para omitir...")
    NT_FOLDER = data_update("NT_FOLDER")
    APP_NAME = data_update("APP_NAME")
    APP = data_update("APP")
    EMPLOYEES = data_update("EMPLOYEES")
    ACCESS_EMPLOYEES = data_update("ACCESS_EMPLOYEES")
    LIC_NUMBER = data_update("LIC_NUMBER")
    PWD_ADMIN = data_update("PWD_ADMIN")
    V55_RELEASE = data_update("V55_RELEASE")
    V55_INSTALLER = data_update("V55_INSTALLER")
    V6_RELEASE = data_update("V6_RELEASE")
    V6_INSTALLER = data_update("V6_INSTALLER")

    # entry to continue
    utils.await_confirm()

    # stopping service
    print("Deteniendo servicio...")
    stop_ser = utils.change_service(service=APP_NAME, command='stop')
    if 'returned non-zero exit status 2' in str(stop_ser):
        print(str(stop_ser))
        
        # entry to continue
        utils.await_confirm()

    # save license number
    if not LIC_NUMBER:
        print("Obteniendo número de licencia...")
        LIC_NUMBER = utils.get_license(app_folder=NT_FOLDER)

    # copy structure to nt_folder
    print("Copiando estructuras al directorio de instalación...")
    copy_result = utils.copy_structure(app_folder=NT_FOLDER)

    if not copy_result:
        print("No se pudo copiar la estructura a la carpeta de instalación.")

        # entry to continue
        utils.await_confirm()

    # run dotnet.exe verify
    print("Ejecutando verificador de dotnet...")
    dnv = utils.run_installer(version='dotnetVerify', installer='dotnet.exe')
    if 'returned non-zero exit status 2' in str(dnv):
        print(str(dnv))

        # entry to continue
        utils.await_confirm()

    # only if user requires
    decide = input('Ejecutar instalador de dotnet 4.8? (y/n):')
    if decide.lower() == 'y':
        dni = utils.run_installer(version='dotnet', installer='ndp48-web.exe')
        if 'returned non-zero exit status 2' in str(dni):
            print(str(dni))

        # entry to continue
        utils.await_confirm()

    # make backups
    print("Realizando backups...")
    bkp_res = utils.make_backup(
        app_folder=NT_FOLDER,
        app_name=APP_NAME
    )

    # only error instance
    if not bkp_res:
        print("No se pudo completar el backup.")
        
        # entry to continue
        utils.await_confirm()

    # remove database and backups to instal v5.5
    print("Removiendo datos para usar instalación...")
    rm_db = utils.remove_needs(app_folder=NT_FOLDER, app=APP)

    # only error instance
    if not rm_db:
        print("No se pudo borrar las bbdd del directorio de instalación.")

        # entry to continue
        utils.await_confirm()

    # msg to install v5.5
    print("Ejecutando instalador de NetTime v5.5...")

    print("1- Completar la instalación.")
    print("2- Iniciar el servicio.")
    print("3- Activar la licencia.")
    print("4- Logear.")

    # run installer v5.5
    run_inst = utils.run_installer(
        version=V55_RELEASE,
        installer=V55_INSTALLER
    )

    if run_inst != True:
        print("ERROR:", run_inst)

        # entry to continue
        utils.await_confirm()

    # await confirm after of install
    # entry to continue
    utils.await_confirm()

    # ensure stop service
    print("Deteniendo servicio de nettime...")
    serv = utils.change_service(service=APP_NAME, command='stop')
    if 'returned non-zero exit status 2' in str(serv):
        print(str(serv))

        # entry to continue
        utils.await_confirm()

    # remove v5.5 inst db and backups
    print("Removiendo bbdd y backups de instalación...")
    rm_d5 = utils.remove_needs(
        app_folder=NT_FOLDER,
        app=APP,
        exclude_bkp_inst=True    
    )

    # only error instance
    if not rm_d5:
        print("No se pudo borrar las bbdd del directorio de instalación.")

        # entry to continue
        utils.await_confirm()

    # recovery database from backups to apply 
    print("Recuperando bbdd de backup...")
    db_rec = utils.db_recovery(app_folder=NT_FOLDER, app=APP)

    # errors only
    if not db_rec:
        print("No se pudo recuperar la base de datos desde los backups.")

        # entry to continue
        utils.await_confirm()

    # verify access
    print("Verificando licencia de accesos...")
    access_verify = utils.verify_access(
        app_folder=NT_FOLDER,
        app=APP,
        access_number=ACCESS_EMPLOYEES
    )

    # if fail
    if not access_verify:
        print("ERROR - El número de empleados con accesos no coincide.")

        # entry to continue
        utils.await_confirm()

    # run updates to lastDate
    print("Actualizando EndDate en bbdd...")
    result = utils.run_scripts(app_folder=NT_FOLDER, app=APP)

    # error only
    if result.get('_error'):
        print('Error ejecutando scripts.')

        # entry to continue
        utils.await_confirm()

    # update lastYear ini
    print("Actualizando LastYear en .ini...")
    ini = utils.update_ini(app_folder=NT_FOLDER, app=APP)

    # error only
    if not ini:
        print("Error actualizando LastYear en .ini")

        # entry to continue
        utils.await_confirm()

    # pause to update settings
    print("Unifique settings y .exe.config antes de continuar.")

    # entry to continue
    utils.await_confirm()

    # start service
    print("Iniciando servicio de nettime...")
    ss = utils.change_service(service=APP_NAME, command='start')

    if 'returned non-zero exit status 2' in str(ss):
        print(str(ss))

        # entry to continue
        utils.await_confirm()

    # dates verify
    print("1- Verificar empleados y fechas de fin...")

    # entry to continue
    utils.await_confirm()

    # road to nettime v6
    decider = input('Ejecutar instalador netTime v6? (y/n):')
    if decider.lower() == 'y':

        print("Deteniendo servicio de nettime...")
        serv = utils.change_service(service=APP_NAME, command='stop')
        if 'returned non-zero exit status 2' in str(serv):
            print(str(serv))

            # entry to continue
            utils.await_confirm()

        print("Ejecutando instalador de nettime v6...")
        nt6i = utils.run_installer(
            version=V6_RELEASE,
            installer=V6_INSTALLER
        )
        if 'returned non-zero exit status 2' in str(nt6i):
            print(str(nt6i))

            # entry to continue
            utils.await_confirm()

        print("1- Completar la instalación.")
        
    # Enter to exit
    input("Proceso finalizado. Presione Enter para salir...")
