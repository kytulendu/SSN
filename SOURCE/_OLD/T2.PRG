 PARAMETER jobtype
 SET TALK OFF
 SET PROCEDURE TO g1
 ON KEY LABEL PGUP ??chr(7)
 CLEAR
 hdr1 = 'บันทึกสรุปรายงานผู้ป่วยใน คลีนิกและการเงิน'
 hdr2 = 'ข้อมูลคลีนิก'
 RESTORE FROM hosp ADDITIVE
 hopsm = hospcode
 hospc = hospcode
 yymm = SPACE(4)
 facn1 = '9999999999999999'
 hospname = ''
 agtype = '2'
 admitd = CTOD('01/'+mm+'/'+yy)
 dischd = CTOD('01/'+mm+'/'+yy)
 mdiag = SPACE(5)
 mdiag2 = SPACE(5)
 moper = SPACE(5)
 moper2 = SPACE(5)
 dr = '99999'
 drop = '99999'
 refc = '1'
 hospt = '            '
 DIMENSION wmenu( 3)
 wmenu( 1) = ' บันทึกรายต่อไป '
 wmenu( 2) = ' กลับรายการหลัก '
 wmenu( 3) = '     แก้ไข      '
 IF WEXIST('expense')
    RELEASE WINDOW expense
 ENDIF
 DEFINE WINDOW expense FROM 0, 0 TO 24, 79
 DIMENSION fmenu( 17)
 fmenu( 1) = 'ค่าบริการ LAB'
 fmenu( 2) = 'ค่าบริการธนาคารเลือด'
 fmenu( 3) = 'ค่าบริการพยาธิวิทยา'
 fmenu( 4) = 'ค่าบริการรังสีวิทยา'
 fmenu( 5) = 'ค่าบริการตรวจอื่นๆ'
 fmenu( 6) = 'ค่าผ่าตัด'
 fmenu( 7) = 'ค่าบริการกายอุปกรณ์'
 fmenu( 8) = 'ค่าบริการระงับความรู้สึก'
 fmenu( 9) = 'ค่ายาและเวชภัณฑ์'
 fmenu( 10) = 'ค่าบริการกายภาพบำบัด'
 fmenu( 11) = 'ค่าบริการรักษาอื่นๆ'
 fmenu( 12) = 'ค่าห้อง ICU'
 fmenu( 13) = 'ค่าอาหารและที่พัก'
 fmenu( 14) = 'ค่าบริการรถรับส่ง'
 fmenu( 15) = 'เรียกเก็บจากกองทุน'
 fmenu( 16) = 'ค่าบริการรวมที่ผู้ป่วยจ่าย'
 fmenu( 17) = 'รวม'
 DIMENSION finance( 16, 4)
 DIMENSION expense( 16)
 expense = 0
 DIMENSION fincode( 16)
 fincode( 1) = 'LABC'
 fincode( 2) = 'BLDBC'
 fincode( 3) = 'PATHC'
 fincode( 4) = 'XRAYC'
 fincode( 5) = 'INVTC'
 fincode( 6) = 'OPRNC'
 fincode( 7) = 'PROSC'
 fincode( 8) = 'ANESC'
 fincode( 9) = 'DRUGC'
 fincode( 10) = 'REHBC'
 fincode( 11) = 'THERC'
 fincode( 12) = 'ICUC'
 fincode( 13) = 'ACCOC'
 fincode( 14) = 'VHCLC'
 fincode( 15) = 'PARTY'
 fincode( 16) = 'PAID'
 DO WHILE .T.
    ref = '0'
    agtype = '1'
    m.mssn = '99-9999999-9'
    m.pttyp = '11'
    m.addr1 = '999999'
    facn1 = '9999999999999999'
    dr1 = '99999'
    drop = '99999'
    top1 = '0001'
    ans = 'N'
    DIMENSION diag( 4, 4)
    DIMENSION operate( 4, 6)
    DO WHILE .T.
       ACTIVATE WINDOW ip1
       m.hospm = hospcode
       m.hospc = hospcode
       ON KEY LABEL Alt+1 _curobj=objnum(m.pttyp)
       ON KEY LABEL Alt+2 _curobj=objnum(m.mhn)
       CLEAR
       @ 0, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR G+/B 
       @ 1, 0, 1, 78 BOX
       @ 19, 0, 19, 78 BOX
       @ 2, 0 SAY '1' COLOR GR+/R 
       @ 2, 2 SAY 'สิทธิการรักษา'
       @ 2, 16 GET m.pttyp PICTURE '99' VALID v_pttyp()
       @ 7, 0 SAY '2' COLOR GR+/R 
       @ 7, 2 SAY 'HN.'
       @ 7, 8 GET mhn SIZE 1, 7 PICTURE '9999999' VALID  .NOT. EMPTY(mhn)
       @ 7, 15 SAY '/'
       @ 7, 16 GET hnyy DEFAULT m.hnyy='00' PICTURE '99' VALID  .NOT. EMPTY(m.hnyy)
       @ 7, 23 SAY 'AN.'
       @ 7, 28 GET man SIZE 1, 6 PICTURE '999999' VALID  .NOT. EMPTY(m.man)
       @ 7, 34 SAY '/'
       @ 7, 35 GET anyy PICTURE '99' VALID v_an(man,anyy)
       @ 7, 45 SAY 'เพศ'
       @ 7, 50 GET m.sex PICTURE '9' VALID m.sex$'12' MESSAGE '1=ชาย    2=หญิง'
       @ 8, 20 SAY 'ที่อยู่'
       @ 8, 28 GET m.addr1 PICTURE '999999' MESSAGE 'รหัสที่อยู่ของผู้รับบริการ'
       @ 9, 2 SAY 'ต้องการกรอก 1)วันเกิด  2)อายุ'
       @ 9, 35 GET agtype PICTURE '9' VALID v_age(agtype)
       @ 11, 2 SAY 'ADMISSION DATE'
       @ 11, 18 GET admitd VALID v_lyear(admitd)>v_lyear(CTOD('01/06/34'))
       @ 11, 32 SAY 'DISCHARGE DATE'
       @ 11, 48 GET dischd VALID (v_lyear(dischd)>=v_lyear(admitd)) .AND. v_lyear(dischd)<=v_lyear(admitd)+180
       @ 12, 2 SAY 'แผนกที่รับไว้'
       @ 12, 18 GET m.dep PICTURE '99' VALID  .NOT. EMPTY(m.dep) .AND. BETWEEN(VAL(m.dep), 1, 12) MESSAGE 'F1 = List'
       @ 12, 32 SAY 'Ward'
       @ 12, 48 GET m.ward PICTURE '999' VALID  .NOT. EMPTY(m.ward) MESSAGE 'F1 = List'
       @ 14, 20 SAY 'ข้อมูลถูกต้องแล้ว (Y/N)'
       @ 14, 45 GET ans VALID ans$'YyNnัํื์'
       READ
       IF READKEY()=12 .OR. READKEY()=268
          CLEAR
          HIDE WINDOW ip1
          = INSMODE(.T.)
          RETURN TO ipadd
       ENDIF
       m.dep = PADL(m.dep, 2, '0')
       IF  .NOT. ans$'Yyัํ'
          LOOP
       ELSE
          EXIT
       ENDIF
    ENDDO
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
    DO WHILE .T.
       @ 2, 2 SAY 'รพ.ที่ให้บริการ'
       @ 2, 18 SAY m.hospc COLOR GR+/B 
       @ 2, 35 SAY m.hospname COLOR GR+/B 
       @ 3, 2 SAY 'HN.'
       @ 3, 6 SAY PADL(ALLTRIM(STR(mhn)), 7, '0') SIZE 1, 7 COLOR GR+/B 
       @ 3, 13 SAY '/'
       @ 3, 14 SAY hnyy COLOR GR+/B 
       @ 3, 20 SAY 'AN.'
       @ 3, 24 SAY PADL(ALLTRIM(STR(man)), 6, '0') SIZE 1, 6 COLOR GR+/B 
       @ 3, 30 SAY '/'
       @ 3, 31 SAY anyy COLOR GR+/B 
       @ 3, 40 SAY 'SS.No.'
       @ 3, 47 SAY mssn COLOR GR+/B 
       @ 4, 1 SAY PADC('CLINICAL DATA', 76, '-')
       @ 5, 0 SAY '1' COLOR GR+/R 
       @ 5, 2 SAY 'Diagnosis 1'
       @ 5, 14 GET diag1 PICTURE '!9999' VALID v_diag(diag1,VARREAD(),5,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 6, 2 SAY 'Ext.cause 1'
       @ 6, 14 GET caus1 PICTURE '!9999' VALID v_diag(caus1,VARREAD(),6,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 8, 2 SAY 'Diagnosis 2'
       @ 8, 14 GET diag2 PICTURE '!9999' VALID v_diag(diag2,VARREAD(),8,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 9, 2 SAY 'Diagnosis 3'
       @ 9, 14 GET diag3 PICTURE '!9999' VALID v_diag(diag3,VARREAD(),9,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 10, 2 SAY 'Diagnosis 4'
       @ 10, 14 GET diag4 PICTURE '!9999' VALID v_diag(diag4,VARREAD(),10,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 12, 0 SAY '2' COLOR GR+/R 
       @ 12, 2 SAY 'Procedure 1'
       @ 12, 14 GET proc1 PICTURE '9999' VALID v_op(proc1,VARREAD(),12,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 13, 2 SAY 'Procedure 2'
       @ 13, 14 GET proc2 PICTURE '9999' VALID v_op(proc2,VARREAD(),13,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 14, 2 SAY 'Procedure 3'
       @ 14, 14 GET proc3 PICTURE '9999' VALID v_op(proc3,VARREAD(),14,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 15, 2 SAY 'Procedure 4'
       @ 15, 14 GET proc4 PICTURE '9999' VALID v_op(proc4,VARREAD(),15,14) MESSAGE 'F1 for entering Keyword/HELP'
       @ 18, 0 SAY '3' COLOR GR+/R 
       @ 18, 2 SAY 'Discharge status : '
       @ 18, 21 GET dcstatus PICTURE '9' VALID v_dc()
       @ 18, 30 SAY 'Discharge type   : '
       @ 18, 49 GET dctype PICTURE '9' VALID v_refer()
       @ 18, 52 SAY 'แพทย์เจ้าของไข้'
       @ 18, 68 GET m.dr1 PICTURE '99999' VALID  .NOT. EMPTY(m.dr1) MESSAGE 'รหัสเลขที่ใบอนุญาตของแพทย์   F1 = List'
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
       m.hn = PADL(ALLTRIM(STR(m.mhn)), 7, '0')+hnyy
       m.an = PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy
       m.address = m.addr1
       m.disch = 'S'+dcstatus+dctype
       m.dr = PADL(ALLTRIM(m.dr1), 5, '0')
       IF agtype='1'
          IF BETWEEN(VAL(byy), 0, 35)
             m.dob = '25'+byy+bmm+bdd
          ELSE
             m.dob = '24'+byy+bmm+bdd
          ENDIF
       ELSE
          diff = VAL(yy)-VAL(m.mage)
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
       diag( 1, 4) = m.hospcare
       IF  .NOT. EMPTY(m.diag2)
          diag( 2, 1) = m.an
          diag( 2, 2) = UPPER(m.diag2)
          diag( 2, 3) = ''
          diag( 2, 4) = m.hospcare
          IF  .NOT. EMPTY(m.diag3)
             diag( 3, 1) = m.an
             diag( 3, 2) = UPPER(m.diag3)
             diag( 3, 3) = ''
             diag( 3, 4) = m.hospcare
             IF  .NOT. EMPTY(m.diag4)
                diag( 4, 1) = m.an
                diag( 4, 2) = UPPER(m.diag4)
                diag( 4, 3) = ''
                diag( 4, 4) = m.hospcare
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
       ans = 'N'
       @ 20, 5 SAY 'ข้อมูลที่กรอกถูกต้องแล้ว??'
       @ 20, 40 GET ans PICTURE 'YyNn'
       READ
       IF  .NOT. ans$'Yy'
          DIMENSION diag( 4, 4)
          DIMENSION operate( 4, 6)
          LOOP
       ELSE
          EXIT
       ENDIF
    ENDDO
    HIDE WINDOW ALL
    ACTIVATE SCREEN
    CLEAR
    IF WVISIBLE('ip1')
       HIDE WINDOW ip1
    ENDIF
    fcol = 0
    ON KEY LABEL PgUp ?? chr(7)
    ON KEY LABEL Pgdn ?? chr(7)
    ON KEY LABEL HOME ?? chr(7)
    ON KEY LABEL END ?? chr(7)
    ON KEY LABEL UPARROW ?? chr(7)
    ON KEY LABEL DNARROW ?? chr(7)
    ON KEY LABEL LEFTARROW ?? chr(7)
    ON KEY LABEL RIGHTARROW ?? chr(7)
    ON KEY LABEL a _curobj=objnum(expense(1))
    ON KEY LABEL b _curobj=objnum(expense(2))
    ON KEY LABEL c _curobj=objnum(expense(3))
    ON KEY LABEL d _curobj=objnum(expense(4))
    ON KEY LABEL e _curobj=objnum(expense(5))
    ON KEY LABEL f _curobj=objnum(expense(6))
    ON KEY LABEL g _curobj=objnum(expense(7))
    ON KEY LABEL h _curobj=objnum(expense(8))
    ON KEY LABEL i _curobj=objnum(expense(9))
    ON KEY LABEL j _curobj=objnum(expense(10))
    ON KEY LABEL k _curobj=objnum(expense(11))
    ON KEY LABEL l _curobj=objnum(expense(12))
    ON KEY LABEL m _curobj=objnum(expense(13))
    ON KEY LABEL n _curobj=objnum(expense(14))
    ON KEY LABEL o _curobj=objnum(expense(15))
    ON KEY LABEL p _curobj=objnum(expense(16))
    ACTIVATE WINDOW expense
    DO WHILE .T.
       @ 0, 20 SAY 'ค่าบริการ'
       @ 0, 50 SAY 'จำนวนเงิน'
       @ 1, 0, 1, 79 BOX
       @ 16, 1, 16, 74 BOX
       @ 17, 25 SAY fmenu(17) COLOR GR+/B 
       @ 18, 1, 18, 74 BOX
       @ 21, 1, 21, 74 BOX
       hdr3 = 'Ctrl+W หรือ Ctrl+End = Exit & Save    Esc = ยกเลิก'
       @ 22, 0 CLEAR
       @ 22, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR G+/B 
       FOR i = 1 TO 14
          @ i+1, 12 SAY CHR(64+i) COLOR GR+/B 
          @ i+1, 15 SAY PADR(fmenu(i), 30, ' ')
          @ i+1, 50 GET expense( i) VALID v_exp()
       ENDFOR
       @ 19, 12 SAY 'O' COLOR GR+/B 
       @ 19, 15 SAY PADR(fmenu(15), 30, ' ')
       @ 19, 50 GET expense( 15)
       @ 20, 12 SAY 'P' COLOR GR+/B 
       @ 20, 15 SAY PADR(fmenu(16), 30, ' ')
       @ 20, 50 GET expense( 16)
       READ
       IF READKEY()=12 .OR. READKEY()=268
          WAIT WINDOW NOWAIT 'Terminated by user'
          SELECT 0
          USE data\death
          lookan = PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy
          LOCATE FOR an=lookan .AND. hospcare=m.hospc
          IF FOUND()
             DELETE
             PACK
          ENDIF
          USE data\refer
          LOCATE FOR an=lookan .AND. hospcare=m.hospc
          IF FOUND()
             DELETE
             PACK
          ENDIF
          USE
          WAIT WINDOW TIMEOUT 1 'Terminated by user'
          RELEASE WINDOW expense
          RELEASE WINDOW ip1
          ON KEY LABEL PGUP
          ON KEY LABEL PgDn
          ON KEY LABEL Home
          ON KEY LABEL End
          ON KEY LABEL UPARROW
          ON KEY LABEL DNARROW
          ON KEY LABEL RIGHTARROW
          ON KEY LABEL LEFTARROW
          ON KEY LABEL Alt+1
          ON KEY LABEL Alt+2
          ON KEY LABEL Alt+3
          ON KEY LABEL a
          ON KEY LABEL b
          ON KEY LABEL c
          ON KEY LABEL d
          ON KEY LABEL e
          ON KEY LABEL f
          ON KEY LABEL g
          ON KEY LABEL h
          ON KEY LABEL i
          ON KEY LABEL j
          ON KEY LABEL k
          ON KEY LABEL l
          ON KEY LABEL m
          ON KEY LABEL n
          ON KEY LABEL o
          ON KEY LABEL p
          RETURN TO main
       ENDIF
       ON KEY LABEL PGUP
       ON KEY LABEL PgDn
       ON KEY LABEL Home
       ON KEY LABEL End
       ON KEY LABEL UPARROW
       ON KEY LABEL DNARROW
       ON KEY LABEL RIGHTARROW
       ON KEY LABEL LEFTARROW
       ON KEY LABEL Alt+1
       ON KEY LABEL Alt+2
       ON KEY LABEL Alt+3
       ON KEY LABEL a
       ON KEY LABEL b
       ON KEY LABEL c
       ON KEY LABEL d
       ON KEY LABEL e
       ON KEY LABEL f
       ON KEY LABEL g
       ON KEY LABEL h
       ON KEY LABEL i
       ON KEY LABEL j
       ON KEY LABEL k
       ON KEY LABEL l
       ON KEY LABEL m
       ON KEY LABEL n
       ON KEY LABEL o
       ON KEY LABEL p
       @ 22, 0 CLEAR
       n = 1
       FOR n = 1 TO 3
          @ 22, (n-1)*25+5 PROMPT wmenu(n)
       ENDFOR
       MENU TO choice
       DO CASE
          CASE choice=1
             DO fincalc
             DO newins
             admitd = CTOD('01/'+mm+'/'+yy)
             dischd = CTOD('01/'+mm+'/'+yy)
             CLEAR
             EXIT
          CASE choice=2
             DO fincalc
             DO newins
             CLEAR
             RELEASE WINDOW expense
             RELEASE WINDOW ip1
             ON KEY LABEL PGUP
             RETURN TO main
          CASE choice=3
             CLEAR
             ON KEY LABEL PgUp ?? chr(7)
             ON KEY LABEL Pgdn ?? chr(7)
             ON KEY LABEL HOME ?? chr(7)
             ON KEY LABEL END ?? chr(7)
             ON KEY LABEL UPARROW ?? chr(7)
             ON KEY LABEL DNARROW ?? chr(7)
             ON KEY LABEL LEFTARROW ?? chr(7)
             ON KEY LABEL RIGHTARROW ?? chr(7)
             ON KEY LABEL a _curobj=objnum(expense(1))
             ON KEY LABEL b _curobj=objnum(expense(2))
             ON KEY LABEL c _curobj=objnum(expense(3))
             ON KEY LABEL d _curobj=objnum(expense(4))
             ON KEY LABEL e _curobj=objnum(expense(5))
             ON KEY LABEL f _curobj=objnum(expense(6))
             ON KEY LABEL g _curobj=objnum(expense(7))
             ON KEY LABEL h _curobj=objnum(expense(8))
             ON KEY LABEL i _curobj=objnum(expense(9))
             ON KEY LABEL j _curobj=objnum(expense(10))
             ON KEY LABEL k _curobj=objnum(expense(11))
             ON KEY LABEL l _curobj=objnum(expense(12))
             ON KEY LABEL m _curobj=objnum(expense(13))
             ON KEY LABEL n _curobj=objnum(expense(14))
             ON KEY LABEL o _curobj=objnum(expense(15))
             ON KEY LABEL p _curobj=objnum(expense(16))
             LOOP
       ENDCASE
    ENDDO
    LOOP
 ENDDO
 CLEAR
 HIDE WINDOW expense
 ACTIVATE WINDOW ip1
 CLEAR
 HIDE WINDOW ip1
 SET PROCEDURE TO
 ON KEY LABEL PGUP
 ON KEY LABEL PgDn
 ON KEY LABEL Home
 ON KEY LABEL End
 ON KEY LABEL UPARROW
 ON KEY LABEL DNARROW
 ON KEY LABEL RIGHTARROW
 ON KEY LABEL LEFTARROW
 ON KEY LABEL Alt+1
 ON KEY LABEL Alt+2
 ON KEY LABEL Alt+3
 ON KEY LABEL a
 ON KEY LABEL b
 ON KEY LABEL c
 ON KEY LABEL d
 ON KEY LABEL e
 ON KEY LABEL f
 ON KEY LABEL g
 ON KEY LABEL h
 ON KEY LABEL i
 ON KEY LABEL j
 ON KEY LABEL k
 ON KEY LABEL l
 ON KEY LABEL m
 ON KEY LABEL n
 ON KEY LABEL o
 ON KEY LABEL p
 RETURN
*
FUNCTION v_lyear
 PARAMETER ccdate
 dd = LEFT(DTOC(ccdate), 2)
 mm = SUBSTR(DTOC(ccdate), 4, 2)
 yy = RIGHT(STR(VAL(RIGHT(DTOC(ccdate), 2))+2500-543), 2)
 lddate = dd+'/'+mm+'/'+yy
 RETURN CTOD(lddate)
*
FUNCTION v_age
 PARAMETER atype
 IF  .NOT. atype$'12'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 0.5 'Invalid input'
    RETURN 0
 ENDIF
 IF atype='1'
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
    @ 9, 49 GET m.mage PICTURE '99' VALID VAL(m.mage)>0
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
 RETURN
*
FUNCTION v_diag
 PARAMETER mdiag, vname, rr, cc
 IF LEN(mdiag)<3
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
 IF  .NOT. ISALPHA(SUBSTR(mdiag, 1, 1))
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'ต้องการ ICD format เช่น A00 '
    RETURN 0
 ELSE
    IF  .NOT. ISDIGIT(SUBSTR(mdiag, 2, 1)) .OR.  .NOT. ISDIGIT(SUBSTR(mdiag, 3, 1))
       WAIT WINDOW TIMEOUT 1 'ต้องการ ICD format เช่น A00 '
       RETURN 0
    ENDIF
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
    @ 2, 40 GET ans VALID ans$'YyNnัํื์'
    READ
    IF ans$'Yyัํ'
       RELEASE WINDOW ask
       RETURN
    ELSE
       RELEASE WINDOW ask
       RETURN 0
    ENDIF
 ELSE
    dgtext = UPPER(code)+' '+RTRIM(desc)
    @ rr, cc SAY PADR(ALLTRIM(SUBSTR(dgtext, 1, 50)), 50, ' ')
    RETURN
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
 IF  .NOT. m.dctype$'123456789'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'invalid input'
    RETURN 0
 ENDIF
 IF m.dctype='4'
    DEFINE WINDOW refer FROM 12, 15 TO 19, 65 SHADOW
    ACTIVATE WINDOW refer
    @ 1, 1 SAY 'รหัสการรับ/ส่งต่อ'
    @ 1, 25 GET m.refc PICTURE '9' VALID refc$'12345678' MESSAGE 'F1 = List'
    @ 2, 1 SAY 'รหัสรพ.ที่ส่งมา/รับต่อ'
    @ 2, 25 GET m.hospt PICTURE '999999999999' VALID  .NOT. EMPTY(hospt) MESSAGE 'F1 = List  99 = Not in list'
    READ
    RELEASE WINDOW refer
    WAIT WINDOW NOWAIT 'Saving data ...'
    refcode = m.refc
    hospto = hospt
    m.yymm = SUBSTR(DTOC(dischd), 7, 2)+SUBSTR(DTOC(dischd), 4, 2)
    m.hn = PADL(ALLTRIM(STR(m.mhn)), 7, '0')+hnyy
    m.an = PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy
    SELECT 0
    USE data\refer
    LOCATE FOR an=PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy .AND. hospcare=m.hospc
    IF FOUND()
       GATHER MEMVAR
    ELSE
       GOTO BOTTOM
       APPEND BLANK
       GATHER MEMVAR
    ENDIF
    USE
    WAIT CLEAR
 ENDIF
 RETURN 1
*
PROCEDURE fincalc
 i = 1
 notempty = 0
 FOR i = 1 TO 16
    IF expense(i)>0
       notempty = notempty+1
       finance( notempty, 1) = m.an
       finance( notempty, 2) = fincode(i)
       finance( notempty, 3) = expense(i)
       finance( notempty, 4) = m.hospcare
    ENDIF
 ENDFOR
 IF notempty>0
    DIMENSION finance( notempty, 4)
 ELSE
    DIMENSION finance( 1, 4)
 ENDIF
*
PROCEDURE v_an
 PARAMETER num, yr
 annum = PADL(ALLTRIM(STR(num)), 6, '0')+yr
 area = SELECT()
 SELECT iptrana
 LOCATE FOR an=annum .AND. hospcare=m.hospc
 IF FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 2 'Error : AN นี้เคยบันทึกไปแล้ว'
    _CUROBJ = OBJNUM(man)
    RETURN
 ENDIF
 RETURN
*
PROCEDURE _vcol
 PARAMETER col
 m.fcol = col
 _CUROBJ = OBJNUM(expense(1+col))
 RETURN
*
PROCEDURE _vveh
 PARAMETER col
 IF col=0
    _CUROBJ = OBJNUM(expense(40))
 ELSE
    _CUROBJ = OBJNUM(expense(41))
 ENDIF
 RETURN
*
FUNCTION v_hosp
 PARAMETER hcode, rr, cc
 hospname = ''
 IF EMPTY(hcode)
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'โปรดใส่รหัสรพ.'
    RETURN 0
 ENDIF
 SELECT codefile
 SET ORDER TO code
 IF SUBSTR(hcode, 1, 5)='HOSPM'
    SET FILTER TO varname='MAIN'
 ELSE
    SET FILTER TO varname='CARE'
 ENDIF
 seek (&hcode)
 IF  .NOT. FOUND()
    @ rr, cc SAY SPACE(36)
    @ rr, cc SAY 'Unknown'
 ELSE
    hospname = ALLTRIM(SUBSTR(name, 1, 36))
    @ rr, cc SAY SPACE(36)
    @ rr, cc SAY hospname COLOR GR+/B 
 ENDIF
 SET FILTER TO
 RETURN
*
FUNCTION v_ref
 IF EMPTY(m.ref)
    ?? CHR(7)
    RETURN 0
 ENDIF
 IF VAL(m.ref)<0 .OR. VAL(m.ref)>1
    ?? CHR(7)
    RETURN 0
 ENDIF
 IF m.ref='1'
    DEFINE WINDOW refer FROM 12, 15 TO 19, 65 SHADOW
    ACTIVATE WINDOW refer
    @ 1, 1 SAY 'รหัสการรับ/ส่งต่อ'
    @ 1, 25 GET m.refc PICTURE '9' VALID refc$'12345678' MESSAGE 'F1 = List'
    @ 2, 1 SAY 'รหัสรพ.ที่ส่งมา'
    @ 2, 25 GET m.hospt PICTURE '999999999999' VALID  .NOT. EMPTY(hospt) MESSAGE 'F1 = List  99 = Not in list'
    READ
    RELEASE WINDOW refer
 ENDIF
 RETURN
*
PROCEDURE v_ss
 IF m.pttyp='11'
    @ 5, 20 SAY 'SS.No.'
    @ 5, 26 GET m.mssn PICTURE '99-9999999-9' MESSAGE '99-9999999-9 = ไม่ทราบ'
    @ 5, 30 SAY 'รหัสโรงงาน'
    @ 5, 42 GET m.facn1 PICTURE '9999999999999999' MESSAGE '99999.... = ไม่ทราบ  F1 = list'
    READ
 ENDIF
 RETURN
*
FUNCTION v_dc
 IF  .NOT. m.dcstatus$'123456789'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid input'
    RETURN 0
 ENDIF
 deadan = PADL(ALLTRIM(STR(m.man)), 6, '0')+m.anyy
 IF m.dcstatus$'89'
    DEFINE WINDOW dead FROM 12, 5 TO 20, 75 SHADOW
    ACTIVATE WINDOW dead
    dhdr = 'CAUSE OF DEATH'
    imm = SPACE(5)
    ante1 = SPACE(5)
    ante2 = SPACE(5)
    newdead = .T.
    SELECT 0
    USE data\death ALIAS death
    LOCATE FOR an=deadan .AND. hospcare=m.hospc
    IF FOUND()
       newdead = .F.
       imm = death.icd10
       ante1 = death.cause1
       ante2 = death.cause2
    ENDIF
    @ 0, (WCOLS()-LEN(dhdr))/2 SAY dhdr COLOR GR+/B 
    @ 2, 2 SAY 'Direct cause: '
    @ 2, 17 GET imm VALID v_diag(imm,VARREAD(),2,17)
    @ 3, 2 SAY 'Antecedent  : '
    @ 3, 17 GET ante1 VALID v_diag(ante1,VARREAD(),3,17)
    @ 4, 2 SAY 'Originating : '
    @ 4, 17 GET ante2 VALID v_diag(ante2,VARREAD(),4,17)
    READ
    WAIT WINDOW TIMEOUT 3 ''
    SELECT death
    IF newdead
       GOTO BOTTOM
       APPEND BLANK
    ENDIF
    m.datedsc = SUBSTR(DTOS(m.dischd), 3)
    m.an = deadan
    REPLACE an WITH m.an
    REPLACE datedsc WITH m.datedsc
    REPLACE icd10 WITH UPPER(imm)
    REPLACE cause1 WITH UPPER(ante1)
    REPLACE cause2 WITH UPPER(ante2)
    REPLACE hospcare WITH m.hospcare
    SELECT death
    USE
    RELEASE WINDOW dead
    RETURN
 ENDIF
*
FUNCTION v_pttyp
 SELECT codefile
 LOCATE FOR code=m.pttyp .AND. varname='PTTY'
 IF  .NOT. FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid code! Press F1 for help'
    RETURN 0
 ELSE
    IF m.pttyp='11'
       @ 3, 2 SAY 'รหัส รพ.Main contractor'
       @ 3, 28 GET hospm PICTURE '999999999999' VALID v_hosp(VARREAD(),3,41) MESSAGE 'F1 = List  99 = นอกเครือข่าย รับบริการฉุกเฉิน'
       @ 4, 2 SAY 'รหัส รพ.ที่ให้บริการ'
       @ 4, 28 GET hospc PICTURE '999999999999' VALID v_hosp(VARREAD(),4,41) MESSAGE 'F1 = List'
       READ
       IF READKEY()=12 .OR. READKEY()=268
          WAIT WINDOW TIMEOUT 1 'Terminate by user'
          CLEAR
          RELEASE WINDOW ip1
          SET PROCEDURE TO
          ON KEY LABEL PGUP
          ON KEY LABEL Pgdn
          RETURN TO main
       ENDIF
       SELECT codefile
       SET ORDER TO code
       SET FILTER TO varname='CARE'
       SEEK hospc
       IF FOUND()
          m.hospname = name
       ELSE
          m.hospname = 'Unknown'
       ENDIF
       SET FILTER TO
       m.hospmain = hospm
       m.hospcare = hospc
       SET FILTER TO
       DO CASE
          CASE m.hospmain=m.hospcare
             m.hosptyp = '0'
          CASE ALLTRIM(m.hospmain)='99'
             m.hosptyp = '3'
          OTHERWISE
             @ 5, 2 SAY 'ทำหน้าที่เป็น'
             @ 5, 28 GET m.hosptyp PICTURE '9' VALID m.hosptyp$'123' MESSAGE '1=Sub  2=Supra  3=Other SSNet'
             READ
             IF READKEY()=12 .OR. READKEY()=268
                WAIT WINDOW TIMEOUT 1 'Terminate by user'
                CLEAR
                RELEASE WINDOW ip1
                ON KEY LABEL PGUP
                RETURN TO main
             ENDIF
       ENDCASE
       @ 6, 2 SAY 'SS.No.'
       @ 6, 20 GET m.mssn PICTURE '99-9999999-9' MESSAGE '99-9999999-9 = ไม่ทราบ'
       @ 6, 37 SAY 'รหัสโรงงาน'
       @ 6, 48 GET m.facn1 PICTURE '99999999999999999' MESSAGE '9999......= ไม่ทราบ  F1 = List'
       READ
    ELSE
       @ 3, 0 CLEAR TO 6, 76
       m.hospmain = m.hospm
       m.hospcare = m.hospm
       m.hospc = hospcode
       SELECT codefile
       SET ORDER TO code
       SET FILTER TO varname='CARE'
       SEEK hospc
       IF FOUND()
          m.hospname = name
       ELSE
          m.hospname = 'Unknown'
       ENDIF
       SET FILTER TO
    ENDIF
    RETURN
 ENDIF
*
PROCEDURE v_exp
 PRIVATE totalexp
 totalexp = 0
 FOR i = 1 TO 14
    totalexp = totalexp+expense(i)
 ENDFOR
 @ 17, 50 SAY totalexp COLOR GR+/B 
 RETURN
*