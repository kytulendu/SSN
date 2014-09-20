 IF  .NOT. EMPTY(hn) .AND.  .NOT. EMPTY(ssn) .AND.  .NOT. EMPTY(facn)
    IF pttyp<>'11'
       m.ssn = SPACE(12)
       m.facn = SPACE(16)
    ENDIF
    SELECT iptrans
    LOCATE FOR hn=m.hn .AND. hospcare=m.hospc
    INSERT INTO iptrans FROM MEMVAR
 ELSE
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 2 'ไม่มี HN รหัส ผู้ประกันตน หรือ รหัสโรงงาน'
    WAIT WINDOW TIMEOUT 1 'กรุณากรอกใหม่'
    RETURN
 ENDIF
 INSERT INTO iptrand FROM MEMVAR
 IF  .NOT. EMPTY(an) .AND.  .NOT. EMPTY(dep)
    INSERT INTO iptrana FROM MEMVAR
 ELSE
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'ไม่มี AN หรือรหัสแผนกที่ให้บริการ'
    WAIT WINDOW TIMEOUT 1 'กรุณากรอกใหม่'
    SELECT iptrans
    GOTO BOTTOM
    DELETE
    SELECT iptrand
    GOTO BOTTOM
    DELETE
    RETURN
 ENDIF
 IF  .NOT. EMPTY(disch)
    INSERT INTO iptranc FROM MEMVAR
 ELSE
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 2 'ไม่มีรหัส discharge'
    WAIT WINDOW TIMEOUT 1 'กรุณากรอกใหม่'
    SELECT iptrans
    GOTO BOTTOM
    DELETE
    SELECT iptrand
    GOTO BOTTOM
    DELETE
    SELECT iptrana
    GOTO BOTTOM
    DELETE
    RETURN
 ENDIF
 IF  .NOT. EMPTY(m.hn)
    SELECT iptrans
    LOCATE FOR hn=m.hn
    INSERT INTO iptrans FROM MEMVAR
 ELSE
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'ไม่มี HN '
    WAIT WINDOW TIMEOUT 1 'กรุณากรอกใหม่'
 ENDIF
 SELECT iptranf
 IF ALEN(finance, 1)>0 .AND.  .NOT. EMPTY(finance(2))
    APPEND FROM ARRAY finance
 ENDIF
 SELECT iptranx
 IF ALEN(diag, 1)>0 .AND.  .NOT. EMPTY(diag(1)) .AND.  .NOT. EMPTY(diag(2))
    APPEND FROM ARRAY diag
 ENDIF
 SELECT iptrano
 IF ALEN(operate, 1)>0 .AND.  .NOT. EMPTY(operate(1)) .AND.  .NOT. EMPTY(operate(2))
    APPEND FROM ARRAY operate
 ENDIF
 DIMENSION finance( 41, 4)
 finance = ''
 DIMENSION expense( 41)
 expense = 0
 DIMENSION diag( 1, 4)
 diag = ''
 DIMENSION operate( 1, 6)
 operate = ''
 bdd = '01'
 bmm = SUBSTR(DTOC(DATE()), 4, 2)
 byy = STR(VAL(SUBSTR(DTOC(DATE()), 7, 2))+1990+543, 4)
 dd = '01'
 tmm = MONTH(DATE())-1
 IF tmm<10
    DO CASE
       CASE tmm=0
          mm = ALLTRIM('12')
       CASE tmm>0
          mm = ALLTRIM('0'+ALLTRIM(STR(tmm)))
    ENDCASE
 ELSE
    mm = ALLTRIM(STR(tmm))
 ENDIF
 IF mm='12'
    yy = RIGHT(STR(YEAR(DATE())+543-1), 2)
 ELSE
    yy = RIGHT(STR(YEAR(DATE())+543-1), 2)
 ENDIF
 pttyp = '11'
 hospm = hospcode
 hospc = hospcode
 dop1 = dd+'/'+mm+'/'+yy
 drop = '99999'
 dr = '99999'
 mssn = '99-       - '
 mhn = 0
 man = 0
 hnyy = '00'
 anyy = '00'
 mfacn = '99'+SPACE(14)
 facn1 = '9999999999999999'
 occupa = SPACE(3)
 dep = '  '
 ward = '   '
 mage = '00'
 dcstatus = '2'
 dctype = '1'
 CLEAR
*
