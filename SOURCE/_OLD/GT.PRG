FUNCTION v_yyear
 PARAMETER a_date
 da1 = LEFT(a_date, 2)
 md1 = SUBSTR(a_date, 4, 2)
 ya1 = STR(VAL(RIGHT(a_date, 4))-543)
 ccdate1 = CTOD(da1+'/'+md1+'/'+ya1)
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    HIDE WINDOW ip1
    = INSMODE(.T.)
    RETURN TO main
 ENDIF
 IF EMPTY(TRIM(DTOS(ccdate1)))
    WAIT WINDOW 'ffff'
 ENDIF
 RETURN ccdate1
*