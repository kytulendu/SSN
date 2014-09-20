 SELECT DISTINCT iptran.hospcare, hospcode.name, iptran.an, iptran.dg1, icd101.desc, CTOD(iptran.datedsc)-CTOD(iptran.dateadm)+1 FROM IPTRAN, ICD101, HOSPCODE WHERE icd101.code=iptran.dg1 AND hospcode.code=iptran.hospcare ORDER BY iptran.dg1, iptran.hospcare DESCENDING INTO DBF LOS.DBF
 SELECT los.hospcare, los.name, los.an, los.dg1, los.desc, AVG(los.exp_6) FROM LOS GROUP BY los.dg1, los.hospcare ORDER BY 6 DESCENDING INTO CURSOR LOS_A
 CREATE REPORT DX_LOS.FRX FROM LOS_A COLUMN NOOVERWRITE WIDTH 80
 REPORT FORMAT DX_LOS.FRX PREVIEW
*