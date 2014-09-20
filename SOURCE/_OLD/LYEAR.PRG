FUNCTION v_lyear
 PARAMETER ccdate
 dd = LEFT(DTOC(ccdate), 2)
 mm = SUBSTR(DTOC(ccdate), 4, 2)
 yy = RIGHT(STR(VAL(RIGHT(DTOC(ccdate), 2))+2500-543), 2)
 lddate = dd+'/'+mm+'/'+yy
 RETURN CTOD(lddate)
*