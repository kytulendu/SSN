 PARAMETER jobtype
 SET TALK OFF
 SET PROCEDURE TO g1
 ON KEY LABEL pgup ??CHR(7)
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
 admitd = SPACE(8)
 dischd = SPACE(8)
 admitd = '01/'+mm+'/'+yy
 dischd = '01/'+mm+'/'+yy
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
 DEFINE WINDOW expense FROM 0, 0 TO 24, 80
 DIMENSION fmenu( 18)
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
 fmenu( 14) = 'ค่าธรรมเนียมแพทย์'
 fmenu( 15) = 'ค่าบริการรถรับส่ง'
 fmenu( 16) = 'เรียกเก็บจาก พรบ.'
 fmenu( 17) = 'ค่าบริการรวมที่ผู้ป่วยจ่าย'
 fmenu( 18) = 'รวม'
 DIMENSION finance( 17, 4)
 DIMENSION expense( 17)
 expense = 0
 DIMENSION fincode( 17)
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
 fincode( 14) = 'DF'
 fincode( 15) = 'VHCLC'
 fincode( 16) = 'PARTY'
 fincode( 17) = 'PAID'
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
       ON KEY LABEL alt+1 _CUROBJ=OBJNUM(m.pttyp)
       ON KEY LABEL alt+2 _CUROBJ=OBJNUM(m.mhn)
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
       @ 7, 50 GET m.sex PICTURE '9' VALID m.sex$'12' MESSAGE 'เลือก 1=ชาย    2=หญิง'
       @ 8, 20 SAY 'ที่อยู่'
       @ 8, 28 GET m.addr1 PICTURE '999999' MESSAGE 'รหัสที่อยู่ของผู้รับบริการ F1 = List'
       DO WHILE .T.
          @ 9, 2 SAY 'ต้องการกรอก 1)วันเกิด  2)อายุ'
          @ 9, 35 GET agtype PICTURE '9' VALID v_age(agtype)
          READ
          IF agtype='1'
             m.birth = v_yyear(m.bdd+'/'+m.bmm+'/'+m.byy)
             IF EMPTY(TRIM(DTOS(m.birth)))
                WAIT WINDOW TIMEOUT 1 'กรุณาตรวจสอบวันที่ใหม่'
                LOOP
             ENDIF
             IF m.pttyp='11' .AND. YEAR(DATE())-YEAR(m.birth)<=15
                ?? CHR(7)
                WAIT WINDOW TIMEOUT 1 'กรุณาตรวจปีเกิดใหม่'
                LOOP
             ELSE
                EXIT
             ENDIF
          ELSE
             EXIT
          ENDIF
       ENDDO
       DO WHILE .T.
          @ 11, 2 SAY 'ADMISSION DATE'
          @ 11, 18 GET admitd PICTURE '99/99/99' VALID v_lyear(admitd)>{01/06/1971}
          @ 11, 32 SAY 'DISCHARGE DATE'
          @ 11, 48 GET dischd PICTURE '99/99/99' VALID v_lyear(dischd)>=v_lyear(admitd)
          READ
          m.admc = v_lyear(admitd)
          m.dscc = v_lyear(dischd)
          IF v_lyear(dischd)>DATE()
             ?? CHR(7)
             WAIT WINDOW TIMEOUT 2 'วันออกจากโรงพยาบาลไม่ถูกต้อง'
             LOOP
          ENDIF
          IF m.pttyp='11' .AND. m.dscc>m.admc+180
             ?? CHR(7)
             WAIT WINDOW TIMEOUT 2 'วันนอนไม่เกิน 180 วัน'
             LOOP
          ELSE
             EXIT
          ENDIF
       ENDDO
       @ 12, 2 SAY 'แผนกที่รับไว้'
       DO WHILE (.T.)
          @ 12, 18 GET m.dep PICTURE '99' VALID  .NOT. EMPTY(m.dep) .AND. BETWEEN(VAL(m.dep), 1, 12) MESSAGE 'F1 = List'
          READ
          SELECT 25
          IF m.sex='1'
             SET FILTER TO codefile.varname='DEP' .AND. INLIST(codefile.code, '01', '02', '05', '06', '07', '08', '09', '10', '11', '12')
          ENDIF
          LOCATE FOR ALLTRIM(codefile.code)=ALLTRIM(m.dep)
          IF  .NOT. FOUND()
             ?? CHR(7)
             WAIT WINDOW TIMEOUT 1 'INVARLID CODE FOR DEPARTMENT'
             LOOP
          ELSE
             EXIT
          ENDIF
       ENDDO
       SELECT 25
       SET FILTER TO
       @ 12, 32 SAY 'Ward'
       DO WHILE (.T.)
          @ 12, 48 GET m.ward PICTURE '999' VALID  .NOT. EMPTY(m.ward) MESSAGE 'F1 = List'
          READ
          SELECT 25
          DO CASE
             CASE m.sex='1'
                SET FILTER TO codefile.varname='WARD' .AND. SUBSTR(codefile.code, 2, 1)<>'2'
             CASE m.sex='2'
                SET FILTER TO codefile.varname='WARD' .AND. SUBSTR(codefile.code, 2, 1)<>'1'
          ENDCASE
          LOCATE FOR ALLTRIM(codefile.code)=ALLTRIM(m.ward)
          IF  .NOT. FOUND()
             ?? CHR(7)
             WAIT WINDOW TIMEOUT 1 'INVARLID CODE FOR WARD'
             LOOP
          ELSE
             EXIT
          ENDIF
       ENDDO
       SELECT 25
       SET FILTER TO
       @ 14, 20 SAY 'ข้อมูลถูกต้องแล้ว (Y/N)'
       @ 14, 45 GET ans VALID ans$'YyNn'
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
    ON KEY LABEL alt+1 _CUROBJ=OBJNUM(diag1)
    ON KEY LABEL alt+2 _CUROBJ=OBJNUM(proc1)
    ON KEY LABEL alt+3 _CUROBJ=OBJNUM(dcstatus)
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
       @ 5, 14 GET diag1 PICTURE '!9999' VALID v_diag(diag1,VARREAD(),5,14) MESSAGE ''
       @ 6, 2 SAY 'Ext.cause 1'
       @ 6, 14 GET caus1 PICTURE '!9999' VALID v_diag(caus1,VARREAD(),6,14) MESSAGE ''
       @ 8, 2 SAY 'Diagnosis 2'
       @ 8, 14 GET diag2 PICTURE '!9999' VALID v_diag(diag2,VARREAD(),8,14) MESSAGE ''
       @ 9, 2 SAY 'Diagnosis 3'
       @ 9, 14 GET diag3 PICTURE '!9999' VALID v_diag(diag3,VARREAD(),9,14) MESSAGE ''
       @ 10, 2 SAY 'Diagnosis 4'
       @ 10, 14 GET diag4 PICTURE '!9999' VALID v_diag(diag4,VARREAD(),10,14) MESSAGE ''
       @ 12, 0 SAY '2' COLOR GR+/R
       @ 12, 2 SAY 'Procedure 1'
       @ 12, 14 GET proc1 PICTURE '9999' VALID v_op(proc1,VARREAD(),12,14) MESSAGE ''
       @ 13, 2 SAY 'Procedure 2'
       @ 13, 14 GET proc2 PICTURE '9999' VALID v_op(proc2,VARREAD(),13,14) MESSAGE ''
       @ 14, 2 SAY 'Procedure 3'
       @ 14, 14 GET proc3 PICTURE '9999' VALID v_op(proc3,VARREAD(),14,14) MESSAGE ''
       @ 15, 2 SAY 'Procedure 4'
       @ 15, 14 GET proc4 PICTURE '9999' VALID v_op(proc4,VARREAD(),15,14) MESSAGE ''
       @ 18, 0 SAY '3' COLOR GR+/R
       @ 18, 2 SAY 'Discharge status : '
       @ 18, 21 GET dcstatus PICTURE '9' VALID v_dc() MESSAGE 'F1 For List'
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
          ON KEY LABEL pgup
          RETURN TO main
       ENDIF
       m.ssn = SUBSTR(m.mssn, 1, 2)+SUBSTR(m.mssn, 4, 7)+SUBSTR(m.mssn, 12, 1)
       m.facn = m.facn1
       m.hn = PADL(ALLTRIM(STR(m.mhn)), 7, '0')+hnyy
       m.an = PADL(ALLTRIM(STR(m.man)), 6, '0')+anyy
       m.pttyp = pttyp
       m.address = m.addr1
       m.disch = 'S'+dcstatus+dctype
       m.dr = PADL(ALLTRIM(m.dr1), 5, '0')
       IF agtype='1'
          m.dob = byy+bmm+bdd
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
       m.dateadm = v_ymed(admitd)
       m.datedsc = v_ymed(dischd)
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
    ON KEY LABEL pgup ?? CHR(7)
    ON KEY LABEL pgdn ?? CHR(7)
    ON KEY LABEL home ?? CHR(7)
    ON KEY LABEL END ?? CHR(7)
    ON KEY LABEL uparrow ?? CHR(7)
    ON KEY LABEL dnarrow ?? CHR(7)
    ON KEY LABEL leftarrow ?? CHR(7)
    ON KEY LABEL rightarrow ?? CHR(7)
    ON KEY LABEL A _CUROBJ=OBJNUM(expense(1))
    ON KEY LABEL B _CUROBJ=OBJNUM(expense(2))
    ON KEY LABEL C _CUROBJ=OBJNUM(expense(3))
    ON KEY LABEL D _CUROBJ=OBJNUM(expense(4))
    ON KEY LABEL E _CUROBJ=OBJNUM(expense(5))
    ON KEY LABEL F _CUROBJ=OBJNUM(expense(6))
    ON KEY LABEL G _CUROBJ=OBJNUM(expense(7))
    ON KEY LABEL H _CUROBJ=OBJNUM(expense(8))
    ON KEY LABEL i _CUROBJ=OBJNUM(expense(9))
    ON KEY LABEL j _CUROBJ=OBJNUM(expense(10))
    ON KEY LABEL K _CUROBJ=OBJNUM(expense(11))
    ON KEY LABEL l _CUROBJ=OBJNUM(expense(12))
    ON KEY LABEL m _CUROBJ=OBJNUM(expense(13))
    ON KEY LABEL N _CUROBJ=OBJNUM(expense(14))
    ON KEY LABEL o _CUROBJ=OBJNUM(expense(15))
    ON KEY LABEL p _CUROBJ=OBJNUM(expense(16))
    ON KEY LABEL q _CUROBJ=OBJNUM(expense(17))
    ACTIVATE WINDOW expense
    DO WHILE .T.
       @ 0, 20 SAY 'ค่าบริการ'
       @ 0, 50 SAY 'จำนวนเงิน'
       @ 1, 0, 1, 79 BOX
       @ 18, 0, 18, 79 BOX
       @ 17, 25 SAY fmenu(18) COLOR GR+/B
       @ 18, 1, 18, 10 BOX
       @ 21, 1, 21, 74 BOX
       hdr3 = 'Ctrl+W หรือ Ctrl+End = Exit & Save    Esc = ยกเลิก'
       @ 22, 0 CLEAR
       @ 22, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR G+/B
       FOR i = 1 TO 15
          @ i+1, 12 SAY CHR(64+i) COLOR GR+/B
          @ i+1, 15 SAY PADR(fmenu(i), 30, ' ')
          @ i+1, 50 GET expense( i) VALID v_exp()
       ENDFOR
       @ 19, 12 SAY 'P' COLOR GR+/B
       @ 19, 15 SAY PADR(fmenu(16), 30, ' ')
       @ 19, 50 GET expense( 16)
       @ 20, 12 SAY 'Q' COLOR GR+/B
       @ 20, 15 SAY PADR(fmenu(17), 30, ' ')
       @ 20, 50 GET expense( 17)
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
          ON KEY LABEL pgup
          ON KEY LABEL pgdn
          ON KEY LABEL home
          ON KEY LABEL END
          ON KEY LABEL uparrow
          ON KEY LABEL dnarrow
          ON KEY LABEL rightarrow
          ON KEY LABEL leftarrow
          ON KEY LABEL alt+1
          ON KEY LABEL alt+2
          ON KEY LABEL alt+3
          ON KEY LABEL A
          ON KEY LABEL B
          ON KEY LABEL C
          ON KEY LABEL D
          ON KEY LABEL E
          ON KEY LABEL F
          ON KEY LABEL G
          ON KEY LABEL H
          ON KEY LABEL i
          ON KEY LABEL j
          ON KEY LABEL K
          ON KEY LABEL l
          ON KEY LABEL m
          ON KEY LABEL N
          ON KEY LABEL o
          ON KEY LABEL p
          ON KEY LABEL q
          RETURN TO main
       ENDIF
       ON KEY LABEL pgup
       ON KEY LABEL pgdn
       ON KEY LABEL home
       ON KEY LABEL END
       ON KEY LABEL uparrow
       ON KEY LABEL dnarrow
       ON KEY LABEL rightarrow
       ON KEY LABEL leftarrow
       ON KEY LABEL alt+1
       ON KEY LABEL alt+2
       ON KEY LABEL alt+3
       ON KEY LABEL A
       ON KEY LABEL B
       ON KEY LABEL C
       ON KEY LABEL D
       ON KEY LABEL E
       ON KEY LABEL F
       ON KEY LABEL G
       ON KEY LABEL H
       ON KEY LABEL i
       ON KEY LABEL j
       ON KEY LABEL K
       ON KEY LABEL l
       ON KEY LABEL m
       ON KEY LABEL N
       ON KEY LABEL o
       ON KEY LABEL p
       ON KEY LABEL q
       @ 22, 0 CLEAR
       n = 1
       FOR n = 1 TO 3
          @ 22, (n-1)*25+5 PROMPT wmenu(n)
       ENDFOR
       MENU TO choice
       DO CASE
          CASE choice=1
             IF total<>0
                DO fincalc
                DO newins
                total = 0
                admitd = '01/'+mm+'/'+yy
                dischd = '01/'+mm+'/'+yy
                CLEAR
                IF WEXIST('expense')
                   RELEASE WINDOW expense
                ENDIF
                DEFINE WINDOW expense FROM 0, 0 TO 24, 80
                EXIT
             ELSE
                ? CHR(7)
                WAIT WINDOW TIMEOUT 1 'กรุณากรอกค่าใช้จ่าย'
                CLEAR
                ON KEY LABEL pgup ?? CHR(7)
                ON KEY LABEL pgdn ?? CHR(7)
                ON KEY LABEL home ?? CHR(7)
                ON KEY LABEL END ?? CHR(7)
                ON KEY LABEL uparrow ?? CHR(7)
                ON KEY LABEL dnarrow ?? CHR(7)
                ON KEY LABEL leftarrow ?? CHR(7)
                ON KEY LABEL rightarrow ?? CHR(7)
                ON KEY LABEL A _CUROBJ=OBJNUM(expense(1))
                ON KEY LABEL B _CUROBJ=OBJNUM(expense(2))
                ON KEY LABEL C _CUROBJ=OBJNUM(expense(3))
                ON KEY LABEL D _CUROBJ=OBJNUM(expense(4))
                ON KEY LABEL E _CUROBJ=OBJNUM(expense(5))
                ON KEY LABEL F _CUROBJ=OBJNUM(expense(6))
                ON KEY LABEL G _CUROBJ=OBJNUM(expense(7))
                ON KEY LABEL H _CUROBJ=OBJNUM(expense(8))
                ON KEY LABEL i _CUROBJ=OBJNUM(expense(9))
                ON KEY LABEL j _CUROBJ=OBJNUM(expense(10))
                ON KEY LABEL K _CUROBJ=OBJNUM(expense(11))
                ON KEY LABEL l _CUROBJ=OBJNUM(expense(12))
                ON KEY LABEL m _CUROBJ=OBJNUM(expense(13))
                ON KEY LABEL N _CUROBJ=OBJNUM(expense(14))
                ON KEY LABEL o _CUROBJ=OBJNUM(expense(15))
                ON KEY LABEL p _CUROBJ=OBJNUM(expense(16))
                ON KEY LABEL q _CUROBJ=OBJNUM(expense(17))
                LOOP
             ENDIF
          CASE choice=2
             IF total<>0
                DO fincalc
                DO newins
                CLEAR
                total = 0
                RELEASE WINDOW expense
                RELEASE WINDOW ip1
                ON KEY LABEL pgup
                RETURN TO main
             ELSE
                ? CHR(7)
                WAIT WINDOW TIMEOUT 1 'กรุณากรอกค่าใช้จ่าย'
                CLEAR
                ON KEY LABEL pgup ?? CHR(7)
                ON KEY LABEL pgdn ?? CHR(7)
                ON KEY LABEL home ?? CHR(7)
                ON KEY LABEL END ?? CHR(7)
                ON KEY LABEL uparrow ?? CHR(7)
                ON KEY LABEL dnarrow ?? CHR(7)
                ON KEY LABEL leftarrow ?? CHR(7)
                ON KEY LABEL rightarrow ?? CHR(7)
                ON KEY LABEL A _CUROBJ=OBJNUM(expense(1))
                ON KEY LABEL B _CUROBJ=OBJNUM(expense(2))
                ON KEY LABEL C _CUROBJ=OBJNUM(expense(3))
                ON KEY LABEL D _CUROBJ=OBJNUM(expense(4))
                ON KEY LABEL E _CUROBJ=OBJNUM(expense(5))
                ON KEY LABEL F _CUROBJ=OBJNUM(expense(6))
                ON KEY LABEL G _CUROBJ=OBJNUM(expense(7))
                ON KEY LABEL H _CUROBJ=OBJNUM(expense(8))
                ON KEY LABEL i _CUROBJ=OBJNUM(expense(9))
                ON KEY LABEL j _CUROBJ=OBJNUM(expense(10))
                ON KEY LABEL K _CUROBJ=OBJNUM(expense(11))
                ON KEY LABEL l _CUROBJ=OBJNUM(expense(12))
                ON KEY LABEL m _CUROBJ=OBJNUM(expense(13))
                ON KEY LABEL N _CUROBJ=OBJNUM(expense(14))
                ON KEY LABEL o _CUROBJ=OBJNUM(expense(15))
                ON KEY LABEL p _CUROBJ=OBJNUM(expense(16))
                ON KEY LABEL q _CUROBJ=OBJNUM(expense(17))
                LOOP
             ENDIF
          CASE choice=3
             CLEAR
             ON KEY LABEL pgup ?? CHR(7)
             ON KEY LABEL pgdn ?? CHR(7)
             ON KEY LABEL home ?? CHR(7)
             ON KEY LABEL END ?? CHR(7)
             ON KEY LABEL uparrow ?? CHR(7)
             ON KEY LABEL dnarrow ?? CHR(7)
             ON KEY LABEL leftarrow ?? CHR(7)
             ON KEY LABEL rightarrow ?? CHR(7)
             ON KEY LABEL A _CUROBJ=OBJNUM(expense(1))
             ON KEY LABEL B _CUROBJ=OBJNUM(expense(2))
             ON KEY LABEL C _CUROBJ=OBJNUM(expense(3))
             ON KEY LABEL D _CUROBJ=OBJNUM(expense(4))
             ON KEY LABEL E _CUROBJ=OBJNUM(expense(5))
             ON KEY LABEL F _CUROBJ=OBJNUM(expense(6))
             ON KEY LABEL G _CUROBJ=OBJNUM(expense(7))
             ON KEY LABEL H _CUROBJ=OBJNUM(expense(8))
             ON KEY LABEL i _CUROBJ=OBJNUM(expense(9))
             ON KEY LABEL j _CUROBJ=OBJNUM(expense(10))
             ON KEY LABEL K _CUROBJ=OBJNUM(expense(11))
             ON KEY LABEL l _CUROBJ=OBJNUM(expense(12))
             ON KEY LABEL m _CUROBJ=OBJNUM(expense(13))
             ON KEY LABEL N _CUROBJ=OBJNUM(expense(14))
             ON KEY LABEL o _CUROBJ=OBJNUM(expense(15))
             ON KEY LABEL p _CUROBJ=OBJNUM(expense(16))
             ON KEY LABEL q _CUROBJ=OBJNUM(expense(17))
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
 ON KEY LABEL pgup
 ON KEY LABEL pgdn
 ON KEY LABEL home
 ON KEY LABEL END
 ON KEY LABEL uparrow
 ON KEY LABEL dnarrow
 ON KEY LABEL rightarrow
 ON KEY LABEL leftarrow
 ON KEY LABEL alt+1
 ON KEY LABEL alt+2
 ON KEY LABEL alt+3
 ON KEY LABEL A
 ON KEY LABEL B
 ON KEY LABEL C
 ON KEY LABEL D
 ON KEY LABEL E
 ON KEY LABEL F
 ON KEY LABEL G
 ON KEY LABEL H
 ON KEY LABEL i
 ON KEY LABEL j
 ON KEY LABEL K
 ON KEY LABEL l
 ON KEY LABEL m
 ON KEY LABEL N
 ON KEY LABEL o
 ON KEY LABEL p
 ON KEY LABEL q
 RETURN
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
    @ 9, 53 GET m.byy PICTURE '9999'
 ELSE
    @ 9, 38 CLEAR TO 9, 76
    @ 9, 38 SAY 'อายุ'
    IF m.pttyp='11'
       @ 9, 49 GET m.mage PICTURE '99' VALID VAL(m.mage)>=15
    ELSE
       @ 9, 49 GET m.mage PICTURE '99'
    ENDIF
    @ 9, 52 SAY 'ปี'
 ENDIF
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RELEASE WINDOW ip1
    SET PROCEDURE TO
    ON KEY LABEL pgup
    RETURN TO main
 ENDIF
 RETURN
*
FUNCTION v_ymed
 PARAMETER ydat
 da = LEFT(ydat, 2)
 md = SUBSTR(ydat, 4, 2)
 ya = RIGHT(ydat, 2)
 yemd=ALLTRIM(STR(&ya&md&da))
 RETURN yemd
*
FUNCTION v_lyear
 PARAMETER ad_date
 da = LEFT(ad_date, 2)
 md = SUBSTR(ad_date, 4, 2)
 ya = ALLTRIM(STR(VAL(RIGHT(ad_date, 2))+2500-543))
 ccdate = CTOD(da+'/'+md+'/'+ya)
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    HIDE WINDOW ip1
    = INSMODE(.T.)
    RETURN TO main
 ENDIF
 RETURN ccdate
*
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
 RETURN ccdate1
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
 IF SUBSTR(vname, 1, 4)='DIAG' .AND. INLIST(LEFT(mdiag, 1), 'V', 'W', 'X', 'Y')
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required! not External Case'
    RETURN 0
 ENDIF
 IF SUBSTR(vname, 1, 5)='DIAG2' .AND. EMPTY(mdiag)
    @ rr, 19 CLEAR TO 10, 74
    diag3 = '     '
    diag4 = '     '
    @ 9, cc GET diag3 PICTURE '!9999'
    @ 10, cc GET diag4 PICTURE '!9999'
    READ TIMEOUT 0.01
    _CUROBJ = OBJNUM(m.proc1)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 5)='DIAG3' .AND. EMPTY(mdiag)
    @ rr, 19 CLEAR TO 10, 74
    diag4 = '     '
    @ 10, cc GET diag4 PICTURE '!9999'
    READ TIMEOUT 0.01
    _CUROBJ = OBJNUM(m.proc1)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 5)='DIAG4' .AND. EMPTY(mdiag)
    @ rr, 19 CLEAR TO 10, 74
    _CUROBJ = OBJNUM(m.proc1)
    RETURN
 ENDIF
 DO CASE
    CASE INLIST(ALLTRIM(mdiag), 'F20', 'F21', 'F22', 'F24', 'F25', 'F28', 'F29')
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
       RETURN 0
    CASE INLIST(ALLTRIM(mdiag), 'F11', 'F12', 'F14', 'F16', 'F18', 'T40', 'N46', 'N97')
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
       RETURN 0
    CASE INLIST(ALLTRIM(mdiag), 'O60', 'O80', '081', '082', 'O83', '084')
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
       RETURN 0
    CASE INLIST(ALLTRIM(mdiag), 'Z94', 'Z00', 'Y830', 'N970', 'N974', 'Z50', 'Z54', 'K02')
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
       RETURN 0
    CASE INLIST(ALLTRIM(mdiag), 'Z32', 'Z33', 'Z34', 'Z35', 'Z36', 'Z38', 'Z39', 'Z460')
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
       RETURN 0
 ENDCASE
 IF vname='CAUS1' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(m.diag2)
    IF caus1='     '
       @ 6, 19 CLEAR TO 6, 74
    ENDIF
    RETURN
 ENDIF
 IF vname='CAUS1' .AND.  .NOT. INLIST(LEFT(mdiag, 1), 'V', 'W', 'X', 'Y')
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required! not Diaginosys Case'
    RETURN 0
 ENDIF
 IF vname='IMM' .AND. EMPTY(mdiag)
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required!'
    RETURN 0
 ENDIF
 IF vname='IMM' .AND. INLIST(LEFT(mdiag, 1), 'V', 'v', 'W', 'w', 'X', 'x', 'Y', 'y')
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required! not External Case'
    RETURN 0
 ENDIF
 IF SUBSTR(vname, 1, 4)='ANTE' .AND. EMPTY(mdiag)
    RETURN
 ENDIF
 IF vname='ANTE' .AND. INLIST(LEFT(mdiag, 1), 'V', 'v', 'W', 'w', 'X', 'x', 'Y', 'y')
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required! not External Case'
    RETURN 0
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
 ENDIF
 RETURN
*
FUNCTION v_op
 PARAMETER moper, vname, rr, cc
 IF INLIST(ALLTRIM(moper), '39.95', '21.87', '85.5', '41.0', '64.5', '69.92', '23.2', '23.3', '23.4', '23.5', '23.6', '23.7')
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required! Wrong Case'
    RETURN 0
 ENDIF
 IF SUBSTR(vname, 1, 5)='PROC1' .AND. EMPTY(moper)
    @ rr, 14 CLEAR TO 15, 74
    proc2 = '     '
    proc3 = '     '
    proc4 = '     '
    @ 13, cc GET proc2 PICTURE '9999'
    @ 14, cc GET proc3 PICTURE '9999'
    @ 15, cc GET proc4 PICTURE '9999'
    READ TIMEOUT 0.01
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 5)='PROC2' .AND. EMPTY(moper)
    @ rr, 14 CLEAR TO 15, 74
    proc3 = '     '
    proc4 = '     '
    @ 14, cc GET proc3 PICTURE '9999'
    @ 15, cc GET proc4 PICTURE '9999'
    READ TIMEOUT 0.01
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 5)='PROC3' .AND. EMPTY(moper)
    @ rr, 14 CLEAR TO 15, 74
    proc4 = '     '
    @ 15, cc GET proc4 PICTURE '9999'
    READ TIMEOUT 0.01
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 5)='PROC4' .AND. EMPTY(moper)
    @ rr, 14 CLEAR TO rr, 74
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
    WAIT WINDOW TIMEOUT 1 'กรอกรหัสผิด'
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
       IF ans$'Yyัํ'
          RELEASE WINDOW warn
          temp = 'Unknown'
       ELSE
          RELEASE WINDOW warn
          RETURN 0
       ENDIF
    ENDIF
 ENDIF
 temp = code+' '+RTRIM(desc)
 @ rr, cc SAY SUBSTR(temp, 1, 15)
 op1 = SUBSTR(temp, 1, 5)
 IF  .NOT. EMPTY(m.op1)
    dop1 = m.admitd
    @ rr, 33 SAY 'Date : '
    @ rr, 40 GET dop1 PICTURE '99/99/99' VALID v_chkdop()
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
    operate( i, 3) = SUBSTR(DTOS(CTOD(dop1)), 3)
    operate( i, 5) = m.drop
    operate( i, 6) = m.hospcare
 ENDIF
 RETURN 1
*
FUNCTION v_refer
 IF  .NOT. m.dctype$'123456789'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'invalid input'
 ENDIF
 IF m.dctype='4'
    DEFINE WINDOW refer FROM 12, 16 TO 19, 65 SHADOW
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
    m.yymm = SUBSTR(dischd, 7, 2)+SUBSTR(dischd, 4, 2)
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
 FOR i = 1 TO 17
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
FUNCTION v_an
 PARAMETER num, yr
 IF VAL(yr)<34
    WAIT WINDOW TIMEOUT 1 'กรุณากรอกปี พ.ศ.ให้ถูกต้อง'
    RETURN 0
 ENDIF
 annum = PADL(ALLTRIM(STR(num)), 6, '0')+yr
 area = SELECT()
 SELECT iptrana
 LOCATE FOR an=annum .AND. hospcare=m.hospc .AND. pttyp=m.pttyp .AND. hospmain=hospm
 IF FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 2 'Error : AN นี้เคยบันทึกไปแล้ว'
    _CUROBJ = OBJNUM(man)
    RETURN
 ENDIF
 SELECT 17
 USE 'Ipa'+yr
 LOCATE FOR an=annum .AND. hospcare=m.hospc .AND. pttyp=m.pttyp .AND. hospmain=hospm
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
 SEEK (&hcode)
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
 SELECT pttyp
 LOCATE FOR ALLTRIM(code)=ALLTRIM(m.pttyp)
 IF FOUND()
    DO CASE
       CASE m.pttyp='11'
          @ 3, 2 SAY 'รหัส รพ.Main contractor'
          @ 3, 28 GET hospm PICTURE '999999999999' VALID v_hosp(VARREAD(),3,41) MESSAGE 'F1 = List  99 = นอกเครือข่าย รับบริการฉุกเฉิน'
          @ 4, 2 SAY 'รหัส รพ.ที่ให้บริการ'
          @ 4, 28 GET hospc PICTURE '999999999999' VALID v_hosp(VARREAD(),4,41) MESSAGE 'F1 = List'
          @ 6, 20 SAY 'SS.No.'
          @ 6, 26 GET m.mssn PICTURE '99-9999999-9' VALID LEFT(m.mssn, 2)>='34' MESSAGE '99-9999999-9 = ไม่ทราบ'
          @ 6, 39 SAY 'รหัสโรงงาน'
          @ 6, 50 GET m.facn1 PICTURE '9999999999999999' MESSAGE '99999.... = ไม่ทราบ  F1 = list'
       OTHERWISE
          @ 3, 2 SAY 'รหัส รพ.Main contractor'
          @ 3, 28 GET hospm PICTURE '999999999999' VALID v_hosp(VARREAD(),3,41) MESSAGE 'F1 = List  99 = นอกเครือข่าย รับบริการฉุกเฉิน'
          @ 4, 2 SAY 'รหัส รพ.ที่ให้บริการ'
          @ 4, 28 GET hospc PICTURE '999999999999' VALID v_hosp(VARREAD(),4,41) MESSAGE 'F1 = List'
    ENDCASE
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
    DEFINE WINDOW dead FROM 12, 5 TO 25, 75 SHADOW
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
    m.datedsc = SUBSTR(DTOS(CTOD(m.dischd)), 3)
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
 ENDIF
 IF m.pttyp='11'
    @ 3, 2 SAY 'รหัส รพ.Main contractor'
    @ 3, 28 GET hospm PICTURE '999999999999' VALID v_hosp(VARREAD(),3,41) MESSAGE 'F1 = List  99 = นอกเครือข่าย รับบริการฉุกเฉิน'
    READ TIMEOUT 0.01
    @ 4, 2 SAY 'รหัส รพ.ที่ให้บริการ'
    @ 4, 28 GET hospc PICTURE '999999999999' VALID v_hosp(VARREAD(),4,41) MESSAGE 'F1 = List'
 ELSE
    @ 3, 2 SAY 'รหัส รพ.Main contractor'
    @ 3, 28 GET hospm PICTURE '999999999999' VALID v_hosp(VARREAD(),3,41) MESSAGE 'F1 = List  99 = นอกเครือข่าย รับบริการฉุกเฉิน'
    READ TIMEOUT 0.01
    @ 4, 2 SAY 'รหัส รพ.ที่ให้บริการ'
    @ 4, 28 GET hospc PICTURE '999999999999' VALID v_hosp(VARREAD(),4,41) MESSAGE 'F1 = List'
 ENDIF
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RELEASE WINDOW ip1
    SET PROCEDURE TO
    ON KEY LABEL pgup
    ON KEY LABEL pgdn
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
 ENDCASE
 IF m.pttyp='11'
    @ 6, 20 SAY 'SS.No.'
    @ 6, 26 GET m.mssn PICTURE '99-9999999-9' VALID LEFT(m.mssn, 2)>='34' MESSAGE '99-9999999-9 = ไม่ทราบ'
    @ 6, 39 SAY 'รหัสโรงงาน'
    @ 6, 50 GET m.facn1 PICTURE '9999999999999999' MESSAGE '99999.... = ไม่ทราบ  F1 = list'
 ENDIF
 READ
*
PROCEDURE v_exp
 PUBLIC total
 PRIVATE totalexp
 totalexp = 0
 FOR i = 1 TO 15
    totalexp = totalexp+expense(i)
    total = totalexp+expense(i)
 ENDFOR
 @ 17, 50 SAY totalexp COLOR GR+/B
 RETURN
*
FUNCTION v_chkdop
 DO CASE
    CASE v_lyear(m.dop1)<v_lyear(m.admitd)
       WAIT WINDOW TIMEOUT 1 'วันที่ผ่าตัดต้องอยู่ในช่วงของการรับการรักษา'
       RETURN 0
    CASE v_lyear(m.dop1)>v_lyear(m.dischd)
       WAIT WINDOW TIMEOUT 1 'วันที่ผ่าตัดต้องอยู่ในช่วงของการรับการรักษา'
       RETURN 0
 ENDCASE
*
