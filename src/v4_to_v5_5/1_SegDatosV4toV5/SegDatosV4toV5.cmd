echo off
del SegDatosV4toV5.log
xcopy ..\..\backup\config_backup__INSTALACION___0000.zip netTimeV4\backup\*.*  /y >> SegDatosV4toV5.log
xcopy ..\..\bin\*.* netTimeV4\bin\*.*  /y >> SegDatosV4toV5.log
xcopy ..\..\Languages\*.* netTimeV4\Languages\*.*  /y >> SegDatosV4toV5.log
xcopy ..\..\Plantillas\*.* netTimeV4\Plantillas\*.*  /y >> SegDatosV4toV5.log
xcopy ..\..\plugins\*.* netTimeV4\plugins\*.*  /y >> SegDatosV4toV5.log
xcopy ..\..\*.* netTimeV4\*.* /y >> SegDatosV4toV5.log