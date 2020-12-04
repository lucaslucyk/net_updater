.output verifyLicAccesos.log
SELECT Count(*) FROM APPDATA WHERE IDTYPE = 14 AND DATA LIKE '%parent="PerfilAccesos"%';