 PARAMETER varwait
 SET TALK OFF
 SET DATE british
 HIDE WINDOW ALL
 SET MESSAGE TO 24 CENTER
 SET PROCEDURE TO ipadd2
 ACTIVATE SCREEN
 CLEAR
 hospmain = m.hospcode
 hospc = hospcode
 man = SPACE(8)
 man1 = SPACE(9)
 mhn = SPACE(9)
 drop = '99999'
 dr = '99999'
 DIMENSION antemp( 1)
 ACTIVATE WINDOW ip1
 CLEAR
 DO CASE
    CASE mjob=4
       hdr1 = 'บันทึกข้อมูลผู้ป่วยใน เฉพาะข้อมูลคลีนิกที่รออยู่'
    CASE mjob=5
       hdr1 = 'บันทึกข้อมูลผู้ป่วยใน เฉพาะข้อมูลการเงินที่รออยู่'
 ENDCASE
 hdr2 = 'ข้อมูลคลีนิก'
 @ 0, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR GR+/B
 @ 1, 2, 1, 76 BOX
 @ 2, 2 SAY 'เลือก รพ.ที่ให้บริการ'
 @ 2, 30 GET hospc PICTURE '999999999999' MESSAGE 'F1 = List'
 READ
 IF READKEY()=12 .OR. READKEY()=268
    CLEAR
    HIDE WINDOW ip1
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    SET PROCEDURE TO
    RETURN TO main
 ENDIF
 hospcare = m.hospc
 SELECT iptrans
 SET FILTER TO hospcare=m.hospc
 GOTO TOP
 numwait = 0
 IF varwait='1'
    DIMENSION diag( 4, 4)
    DIMENSION operate( 4, 6)
    DO WHILE  .NOT. EOF('iptrans')
       mhn = hn
       SELECT iptrana
       LOCATE FOR hn=m.mhn .AND. hospcare=m.hospc
       man = an
       IF  .NOT. EMPTY(man)
          SELECT iptranx
          GOTO TOP
          LOCATE FOR an=m.man .AND. hospcare=m.hospc
          IF  .NOT. FOUND()
             numwait = numwait+1
             DIMENSION antemp( numwait)
             antemp( numwait) = SUBSTR(man, 1, 6)+'-'+SUBSTR(man, 7, 2)
          ENDIF
       ENDIF
       SELECT iptrans
       SKIP 1
    ENDDO
    IF numwait=0
       WAIT WINDOW TIMEOUT 1 'ไม่มี record ที่รอข้อมูล'
       CLEAR
       HIDE WINDOW ip1
       SET PROCEDURE TO
       RETURN
    ENDIF
    DO WHILE .T.
       @ 3, 2 SAY 'เลือก Admission No.'
       @ 3, 30 GET man1 FROM antemp MESSAGE 'Esc = เลิกกรอกข้อมูล'
       KEYBOARD '{HOME}'
       READ
       IF READKEY()=12 .OR. READKEY()=268
          CLEAR
          HIDE WINDOW ip1
          WAIT WINDOW TIMEOUT 1 'Terminate by user'
          SET PROCEDURE TO
          RETURN TO main
       ENDIF
       man = SUBSTR(man1, 1, 6)+SUBSTR(man1, 8, 2)
       CLEAR
       @ 2, 2 SAY 'รหัส รพ.ที่ให้บริการ'
       @ 2, 30 SAY hospc COLOR GR+/B
       @ 3, 2 SAY 'Admission number'
       @ 3, 30 SAY man COLOR GR+/B
       SELECT iptrana
       LOCATE FOR an=m.man .AND. hospcare=m.hospc
       mhn = hn
       SELECT iptrans
       LOCATE FOR hn=m.mhn .AND. hospcare=m.hospc
       mssn = ssn
       facn1 = '9999999999999999'
       addr1 = '9999'
       agtype = '1'
       ans = 'N'
       admitd = CTOD('01/'+mm+'/'+yy)
       dischd = CTOD('01/'+mm+'/'+yy)
       m.mssn = '99-9999999-9'
       m.pttyp = pttyp
       mhn2 = SUBSTR(mhn, 1, 7)
       hnyy = SUBSTR(mhn, 8, 2)
       man2 = SUBSTR(man, 1, 6)
       anyy = SUBSTR(man, 7, 2)
       m.sex = ' '
       m.dep = '  '
       m.ward = '   '
       @ 6, 2 SAY 'สิทธิการรักษา'
       @ 6, 16 GET m.pttyp PICTURE '99'
       @ 6, 20 SAY 'SS.No.'
       @ 6, 28 GET m.mssn PICTURE '99-9999999-9' MESSAGE '99-9999999-9 = ไม่ทราบ'
       @ 6, 45 SAY 'รหัสโรงงาน'
       @ 6, 56 GET m.facn1 PICTURE '99999999999999999' MESSAGE '9999......= ไม่ทราบ  F1 = List'
       @ 7, 2 SAY 'HN.'
       @ 7, 8 SAY mhn2
       @ 7, 15 SAY '/'
       @ 7, 16 SAY hnyy
       @ 7, 23 SAY 'AN.'
       @ 7, 28 SAY man2
       @ 7, 34 SAY '/'
       @ 7, 35 SAY anyy
       @ 7, 45 SAY 'เพศ'
       @ 7, 50 GET m.sex PICTURE '9' VALID m.sex$'12' MESSAGE '1=ชาย    2=หญิง'
       @ 8, 20 SAY 'ที่อยู่'
       @ 8, 28 GET m.addr1 PICTURE '999999' MESSAGE 'รหัสที่อยู่ของผู้รับบริการ'
       @ 9, 2 SAY 'ต้องการกรอก 1)วันเกิด  2)อายุ'
       @ 9, 35 GET agtype PICTURE '9' VALID v_age(agtype)
       @ 11, 2 SAY 'ADMISSION DATE'
       @ 11, 18 GET admitd VALID admitd>CTOD('01/06/34')
       @ 11, 32 SAY 'DISCHARGE DATE'
       @ 11, 48 GET dischd VALID (dischd>=admitd)
       @ 12, 2 SAY 'แผนกที่รับไว้'
       @ 12, 18 GET m.dep PICTURE '99' VALID  .NOT. EMPTY(m.dep) .AND. VAL(m.dep)>0 MESSAGE 'F1 = List'
       @ 12, 32 SAY 'Ward'
       @ 12, 48 GET m.ward PICTURE '999' VALID  .NOT. EMPTY(m.ward) MESSAGE 'F1 = List'
       @ 14, 20 SAY 'ข้อมูลถูกต้องแล้ว (Y/N)'
       @ 14, 45 GET ans VALID ans$'YyNn'
       READ
       select data\iptranc.dbf
       LOCATE FOR sex=m.sex
       IF m.sex='1'
          IF  .NOT. FOUND()
             GOTO to
             LOCATE FOR ward=m.ward$'?1?'
             IF READKEY()=12 .OR. READKEY()=268
                CLEAR
                HIDE WINDOW ip1
                = INSMODE(.T.)
                RETURN TO ipadd
             ENDIF
             m.dep = PADL(m.dep, 2, '0')
             IF  .NOT. ans$'Yy'
                LOOP
             ENDIF
             @ 2, 0 CLEAR TO 15, 76
             diag1 = SPACE(5)
             diag2 = SPACE(5)
             diag3 = SPACE(5)
             diag4 = SPACE(5)
             caus1 = SPACE(5)
             caus2 = SPACE(5)
             caus3 = SPACE(5)
             caus4 = SPACE(5)
             proc1 = SPACE(5)
             proc2 = SPACE(5)
             proc3 = SPACE(5)
             proc4 = SPACE(5)
             ON KEY LABEL Alt+1 _curobj=Objnum(diag1)
             ON KEY LABEL Alt+2 _curobj=objnum(proc1)
             ON KEY LABEL Alt+3 _curobj=objnum(dcstatus)
             @ 2, 2 SAY 'รพ.ที่ให้บริการ'
             @ 2, 18 SAY m.hospc COLOR GR+/B
             @ 2, 35 SAY m.hospname COLOR GR+/B
             @ 3, 2 SAY 'HN.'
             @ 3, 6 SAY PADL(ALLTRIM(mhn2), 7, '0') SIZE 1, 7 COLOR GR+/B
             @ 3, 13 SAY '/'
             @ 3, 14 SAY hnyy COLOR GR+/B
             @ 3, 20 SAY 'AN.'
             @ 3, 24 SAY PADL(ALLTRIM(man2), 6, '0') SIZE 1, 6 COLOR GR+/B
             @ 3, 30 SAY '/'
             @ 3, 31 SAY anyy COLOR GR+/B
             @ 3, 40 SAY 'SS.No.'
             @ 3, 47 SAY mssn COLOR GR+/B
             @ 4, 1 SAY PADC('CLINICAL DATA', 76, '-')
             @ 5, 0 SAY '1' COLOR GR+/R
             @ 5, 2 SAY 'Diagnosis 1'
             @ 5, 14 GET diag1 VALID v_diag(diag1,VARREAD(),5,14)
             @ 6, 2 SAY 'Ext.cause 1'
             @ 6, 14 GET caus1 VALID v_diag(caus1,VARREAD(),6,14)
             @ 8, 2 SAY 'Diagnosis 2'
             @ 8, 14 GET diag2 VALID v_diag(diag2,VARREAD(),8,14)
             @ 9, 2 SAY 'Diagnosis 3'
             @ 9, 14 GET diag3 VALID v_diag(diag3,VARREAD(),9,14)
             @ 10, 2 SAY 'Diagnosis 4'
             @ 10, 14 GET diag4 VALID v_diag(diag4,VARREAD(),10,14)
             @ 12, 0 SAY '2' COLOR GR+/R
             @ 12, 2 SAY 'Procedure 1'
             @ 12, 14 GET proc1 VALID v_op(proc1,VARREAD(),12,14)
             @ 13, 2 SAY 'Procedure 2'
             @ 13, 14 GET proc2 VALID v_op(proc2,VARREAD(),13,14)
             @ 14, 2 SAY 'Procedure 3'
             @ 14, 14 GET proc3 VALID v_op(proc3,VARREAD(),14,14)
             @ 15, 2 SAY 'Procedure 4'
             @ 15, 14 GET proc4 VALID v_op(proc4,VARREAD(),15,14)
             @ 18, 0 SAY '3' COLOR GR+/R
             @ 18, 2 SAY 'Discharge status : '
             @ 18, 21 GET dcstatus PICTURE '9' VALID v_dc()
             @ 18, 30 SAY 'Discharge type   : '
             @ 18, 49 GET dctype PICTURE '9' VALID v_refer()
             @ 18, 52 SAY 'แพทย์เจ้าของไข้'
             @ 18, 68 GET m.dr PICTURE '99999' VALID  .NOT. EMPTY(m.dr) MESSAGE 'รหัสเลขที่ใบอนุญาตของแพทย์   F1 = List'
             READ
             IF READKEY()=12 .OR. READKEY()=268
                WAIT WINDOW TIMEOUT 1 'Terminate by user'
                CLEAR
                RELEASE WINDOW ip1
                SET PROCEDURE TO
                ON KEY LABEL PGUP
                RETURN TO main
             ENDIF
             m.ssn = SUBSTR(m.mssn, 1, 2)+SUBSTR(m.mssn, 4, 7)+SUBSTR(m.mssn, 12, 1)
             m.facn = m.facn1
             m.hn = PADL(ALLTRIM(m.mhn2), 7, '0')+hnyy
             m.an = PADL(ALLTRIM(m.man2), 6, '0')+anyy
             m.pttyp = pttyp.code
             m.address = m.addr1
             m.disch = 'S'+dcstatus+dctype
             IF agtype='1'
                IF BETWEEN(VAL(byy), 0, 35)
                   m.dob = '25'+byy+bmm+bdd
                ELSE
                   m.dob = '24'+byy+bmm+bdd
                ENDIF
             ELSE
                diff = VAL(yy)-VAL(mage)
                DO CASE
                   CASE BETWEEN(diff, 0, 9)
                      m.dob = '250'+STR(diff, 1, 0)+bmm+'15'
                   CASE diff>=10
                      m.dob = '25'+STR(diff, 2, 0)+bmm+'15'
                   CASE diff<0
                      m.dob = '24'+STR(100+diff, 2, 0)+bmm+'15'
                ENDCASE
             ENDIF
             m.dateadm = SUBSTR(DTOS(admitd), 3)
             m.datedsc = SUBSTR(DTOS(dischd), 3)
             diag( 1, 1) = m.an
             diag( 1, 2) = UPPER(m.diag1)
             diag( 1, 3) = m.caus1
             diag( 1, 4) = m.hospc
             IF  .NOT. EMPTY(m.diag2)
                diag( 2, 1) = m.an
                diag( 2, 2) = UPPER(m.diag2)
                diag( 2, 3) = ''
                diag( 2, 4) = m.hospc
                IF  .NOT. EMPTY(m.diag3)
                   diag( 3, 1) = m.an
                   diag( 3, 2) = UPPER(m.diag3)
                   diag( 3, 3) = ''
                   diag( 3, 4) = m.hospc
                   IF  .NOT. EMPTY(m.diag4)
                      diag( 4, 1) = m.an
                      diag( 4, 2) = UPPER(m.diag4)
                      diag( 4, 3) = ''
                      diag( 4, 4) = m.hospc
                   ELSE
                      DIMENSION diag( 3, 4)
                   ENDIF
                ELSE
                   DIMENSION diag( 2, 4)
                ENDIF
             ELSE
                DIMENSION diag( 1, 4)
             ENDIF
             IF  .NOT. EMPTY(operate(1,1))
                IF  .NOT. EMPTY(operate(2,1))
                   IF  .NOT. EMPTY(operate(3,1))
                      IF  .NOT. EMPTY(operate(4,1))
                         DIMENSION operate( 4, 6)
                      ELSE
                         DIMENSION operate( 3, 6)
                      ENDIF
                   ELSE
                      DIMENSION operate( 2, 6)
                   ENDIF
                ELSE
                   DIMENSION operate( 1, 6)
                ENDIF
             ELSE
                DIMENSION operate( 1, 6)
                operate = ''
             ENDIF
             WAIT WINDOW TIMEOUT 1 'Saving data....'
             INSERT INTO data\iptrand FROM MEMVAR
             INSERT INTO data\iptranc FROM MEMVAR
             INSERT INTO data\iptranx FROM ARRAY diag
             IF  .NOT. EMPTY(operate(1,1))
                INSERT INTO data\iptrano FROM ARRAY operate
             ENDIF
             SELECT iptrans
             LOCATE FOR hn=m.hn .AND. hospcare=m.hospc
             DELETE
             INSERT INTO data\iptrans FROM MEMVAR
             DIMENSION diag( 4, 4)
             diag = ''
             DIMENSION operate( 4, 6)
             operate = ''
             @ 3, 0 CLEAR
             pos = ASCAN(antemp, man1)
             = ADEL(antemp, pos)
             numwait = numwait-1
             IF numwait=0
                CLEAR
                RELEASE WINDOW ip1
                SET PROCEDURE TO
                RETURN
             ENDIF
             DIMENSION antemp( numwait)
          ENDDO
       ELSE
          DO WHILE  .NOT. EOF('iptrans')
             mhn = hn
             SELECT iptrana
             LOCATE FOR hn=m.mhn .AND. hospcare=m.hospc
             man = an
             IF  .NOT. EMPTY(m.man)
                SELECT iptranf
                GOTO TOP
                LOCATE FOR an=m.man .AND. hospcare=m.hospc
                IF  .NOT. FOUND()
                   numwait = numwait+1
                   DIMENSION antemp( numwait)
                   antemp( numwait) = SUBSTR(m.man, 1, 6)+'-'+SUBSTR(m.man, 7, 2)
                ENDIF
             ENDIF
             SELECT iptrans
             SKIP 1
          ENDDO
          IF numwait=0
             ?? CHR(7)
             WAIT WINDOW TIMEOUT 2 'ไม่มี record ที่รอข้อมูล'
             CLEAR
             HIDE WINDOW ip1
             SET PROCEDURE TO
             RETURN
          ENDIF
          DO WHILE .T.
             @ 3, 2 SAY 'เลือก Admission No.'
             @ 3, 30 GET man1 FROM antemp MESSAGE 'Esc = เลิกกรอกข้อมูล'
             KEYBOARD '{HOME}'
             READ
             IF READKEY()=12 .OR. READKEY()=268
                CLEAR
                HIDE WINDOW ip1
                WAIT WINDOW TIMEOUT 1 'Terminate by user'
                SET PROCEDURE TO
                RETURN TO main
             ENDIF
             CLEAR
             @ 2, 2 SAY 'รหัส รพ.ที่ให้บริการ'
             @ 2, 30 SAY hospc COLOR GR+/B
             @ 3, 2 SAY 'Admission number'
             @ 3, 30 SAY man1 COLOR GR+/B
             SELECT iptrans
             LOCATE FOR hn=mhn .AND. hospcare=hospc
             mssn = ssn
             SELECT iptrana
             LOCATE FOR hn=mhn .AND. an=m.man1 .AND. hospcare=m.hospc
             DO finance
             INSERT INTO data\iptranf FROM ARRAY finance
             finance = ''
             @ 3, 0 CLEAR
             pos = ASCAN(antemp, man1)
             = ADEL(antemp, pos)
             numwait = numwait-1
             IF numwait=0
                RELEASE WINDOW ip1
                SET PROCEDURE TO
                RETURN
             ENDIF
             DIMENSION antemp( numwait)
          ENDDO
       ENDIF
*
FUNCTION v_diag
 PARAMETER mdiag, vname, rr, cc
 IF LEN(mdiag)<2
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid code!'
    RETURN 0
 ENDIF
 IF vname='DIAG1' .AND. EMPTY(mdiag)
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required!'
    RETURN 0
 ENDIF
 IF SUBSTR(vname, 1, 4)='DIAG' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(m.proc1)
    RETURN
 ENDIF
 IF vname='CAUS1' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(m.diag2)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 4)='PROC' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF vname='IMM' .AND. EMPTY(mdiag)
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required!'
    RETURN 0
 ENDIF
 IF SUBSTR(vname, 1, 4)='ANTE' .AND. EMPTY(mdiag)
    RETURN
 ENDIF
 IF USED('icd101')
    SELECT icd101
 ELSE
    SELECT 11
    USE lib\icd101 ORDER code
 ENDIF
 IF  .NOT. SEEK(UPPER(mdiag))
    DEFINE WINDOW ask FROM 10, 10 TO 15, 70 SHADOW
    ACTIVATE WINDOW ask
    ?? CHR(7)
    @ 0, 2 SAY 'WARNING : This code is currently NOT in the ICD file!'
    @ 2, 2 SAY 'Do you still want to use this code?'
    @ 2, 40 GET ans VALID ans$'YyNn'
    READ
    IF ans$'Yy'
       RELEASE WINDOW ask
       RETURN 0
    ELSE
       dgtext = UPPER(code)+' '+RTRIM(desc)
       @ rr, cc SAY PADR(ALLTRIM(SUBSTR(dgtext, 1, 50)), 50, ' ')
       RETURN
    ENDIF
 ENDIF
*
FUNCTION v_op
 PARAMETER moper, vname, rr, cc
 IF SUBSTR(vname, 1, 4)='PROC' .AND. EMPTY(moper)
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF USED('icdcm1')
    SELECT icdcm1
 ELSE
    SELECT 14
    USE lib\icdcm1 ORDER code
 ENDIF
 IF USED('icdcm2')
    SELECT icdcm2
 ELSE
    SELECT 15
    USE lib\icdcm2 ORDER kwcode
 ENDIF
 IF USED('icdcm3')
    SELECT icdcm3
 ELSE
    SELECT 16
    USE lib\icdcm3 ORDER kwcode
 ENDIF
 DIMENSION temp( 1)
 tempsize = 1
 SELECT 14
 mrec = ''
 DEFINE WINDOW choices FROM 5, 10 TO 15, 62 SHADOW
 IF  .NOT. ISDIGIT(moper)
    WAIT WINDOW TIMEOUT 1 'Invalid code'
    RETURN 0
 ELSE
    micd = ALLTRIM(PROPER(moper))
    SELECT 14
    SET ORDER TO code
    SEEK (micd)
    IF  .NOT. FOUND()
       DEFINE WINDOW warn FROM 10, 5 TO 15, 75
       ACTIVATE WINDOW warn
       ans = 'N'
       ?? CHR(7)
       @ 0, 2 SAY 'This code is NOT in the ICD9CM file' COLOR GR+/B
       @ 2, 2 SAY 'Do you want to use this code?'
       @ 2, 40 GET ans VALID ans$'YyNn'
       READ
       IF  .NOT. ans$'Yy'
          CLEAR
          RELEASE WINDOW warn
          RETURN 0
       ELSE
          temp = 'Unknown'
       ENDIF
    ENDIF
    temp = code+' '+RTRIM(desc)
    @ rr, cc SAY SUBSTR(temp, 1, 15)
    op1 = SUBSTR(temp, 1, 5)
    IF  .NOT. EMPTY(m.op1)
       dop1 = m.admitd
       @ rr, 33 SAY 'Date : '
       @ rr, 40 GET dop1 PICTURE '99/99/99' VALID m.dop1>=m.admitd .AND. m.dop1<=m.dischd
       @ rr, 63 SAY 'แพทย์'
       @ rr, 69 GET m.drop PICTURE '99999' VALID  .NOT. EMPTY(m.drop) MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
       READ
       IF READKEY()=12 .OR. READKEY()=268
          WAIT WINDOW TIMEOUT 1 'Terminate by user'
          CLEAR
          RELEASE WINDOW ip1
          SET PROCEDURE TO
          RETURN TO main
       ENDIF
       m.an = PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy
       i = VAL(SUBSTR(vname, 5, 1))
       operate( i, 1) = m.an
       operate( i, 2) = op1
       operate( i, 3) = SUBSTR(DTOS(dop1), 3)
       operate( i, 5) = m.drop
       operate( i, 6) = m.hospcare
    ENDIF
 ENDIF
 RETURN 1
*
FUNCTION v_refer
 IF  .NOT. m.dctype$'1234589'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'invalid input'
    RETURN 0
 ENDIF
 IF m.dctype='4'
    DEFINE WINDOW refer FROM 12, 15 TO 19, 65 SHADOW
    ACTIVATE WINDOW refer
    SELECT 0
    USE data\refer
    LOCATE FOR an=m.an .AND. hospcare=m.hospc
    IF FOUND()
       SCATTER MEMVAR
    ELSE
       SCATTER BLANK MEMVAR
    ENDIF
    refc = m.refcode
    hospt = m.hospto
    @ 1, 1 SAY 'รหัสการรับ/ส่งต่อ'
    @ 1, 25 GET m.refc PICTURE '9' VALID refc$'123456' MESSAGE 'F1 = List'
    @ 2, 1 SAY 'รหัสรพ.ที่ส่งมา/รับต่อ'
    @ 2, 25 GET m.hospt PICTURE '999999999999' VALID  .NOT. EMPTY(hospt) MESSAGE 'F1 = List  99 = Not in list'
    READ
    RELEASE WINDOW refer
    m.refcode = m.refc
    m.hospto = m.hospt
    GATHER MEMVAR
    USE
 ENDIF
 RETURN
*
FUNCTION v_dc
 IF  .NOT. m.dcstatus$'123456789'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid input'
    RETURN 0
 ENDIF
 IF m.dcstatus$'89'
    DEFINE WINDOW dead FROM 12, 5 TO 20, 75 SHADOW
    ACTIVATE WINDOW dead
    dhdr = 'CAUSE OF DEATH'
    SELECT 0
    USE data\death
    imm = SPACE(5)
    ante1 = SPACE(5)
    ante2 = SPACE(5)
    @ 0, (WCOLS()-LEN(dhdr))/2 SAY dhdr COLOR GR+/B
    @ 2, 2 SAY 'Immediate   : '
    @ 2, 17 GET imm VALID v_diag(imm,VARREAD(),2,17)
    @ 3, 2 SAY 'Antecedent1 : '
    @ 3, 17 GET ante1 VALID v_diag(ante1,VARREAD(),3,17)
    @ 4, 2 SAY 'Antecedent2 : '
    @ 4, 17 GET ante2 VALID v_diag(ante2,VARREAD(),4,17)
    READ
    APPEND BLANK
    m.datedsc = SUBSTR(DTOS(m.dischd), 3)
    REPLACE death.an WITH m.an
    REPLACE death.datedsc WITH m.datedsc
    REPLACE death.icd10 WITH imm
    REPLACE death.cause1 WITH ante1
    REPLACE death.cause2 WITH ante2
    REPLACE death.hospcare WITH m.hospcare
    USE
    RELEASE WINDOW dead
    RETURN
 ENDIF
*
FUNCTION v_age
 PARAMETER atype
 IF  .NOT. atype$'12'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 0.5 'Invalid input'
    RETURN 0
 ENDIF
 IF m.agtype='1'
    @ 9, 38 CLEAR TO 9, 76
    @ 9, 38 SAY 'วันเกิด'
    @ 9, 47 GET m.bdd PICTURE '99' VALID BETWEEN(VAL(bdd), 1, 31)
    @ 9, 49 SAY '/'
    @ 9, 50 GET m.bmm PICTURE '99' VALID BETWEEN(VAL(bmm), 1, 12)
    @ 9, 52 SAY '/'
    @ 9, 53 GET m.byy PICTURE '99'
 ELSE
    @ 9, 38 CLEAR TO 9, 76
    @ 9, 38 SAY 'อายุ'
    @ 9, 49 GET m.mage PICTURE '99'
    @ 9, 52 SAY 'ปี'
 ENDIF
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RELEASE WINDOW ip1
    SET PROCEDURE TO
    ON KEY LABEL PGUP
    RETURN TO main
 ENDIF
 RETURN 1
*