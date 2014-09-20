 SET TALK OFF
 SET PROCEDURE TO ipedit
 HIDE WINDOW ALL
 olddate = SET('date')
 SET DATE ansi
 DEFINE WINDOW edit1 FROM 1, 2 TO 23, 78 SHADOW
 DEFINE WINDOW expen2 FROM 0, 0 TO 24, 79 DOUBLE
 SET EXCLUSIVE ON
 SELECT 1
 USE data\iptrans INDEX data\iptrans
 SELECT 2
 USE data\iptrand INDEX data\iptrand
 SELECT 3
 USE data\iptrana INDEX data\iptrana
 SELECT 4
 USE data\iptranc INDEX data\iptranc
 SELECT 5
 USE data\iptranf INDEX data\iptranf
 SELECT 6
 USE data\iptranx INDEX data\iptranx
 SELECT 7
 USE data\iptrano INDEX data\iptrano
 SELECT 25
 USE lib\codefile ORDER code
 SELECT 11
 USE lib\icd101 ORDER code
 SELECT 12
 USE lib\icd102 ORDER kwcode
 SELECT 13
 USE lib\icd103 ORDER kwcode
 SELECT 14
 USE lib\icdcm1 ORDER code
 SELECT 15
 USE lib\icdcm2 ORDER kwcode
 SELECT 16
 USE lib\icdcm3 ORDER kwcode
 hospc = hospcode
 man = SPACE(8)
 mhn = SPACE(9)
 clinic = ' '
 oper = ' '
 fin = ' '
 refer = ' '
 ans = 'Y'
 dcstatus = '2'
 dctype = '1'
 dr = '99999'
 drop = '99999'
 moper2 = SPACE(5)
 refc = '0'
 hospto = SPACE(12)
 mm = SUBSTR(DTOC(DATE()), 4, 2)
 yy = STR(VAL(SUBSTR(DTOC(DATE()), 7, 2))+1900+543-2500, 2)
 DIMENSION diag( 4, 4)
 DIMENSION proct( 4, 6)
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
 fmenu( 14) = 'ค่าบริการรถรับส่ง'
 fmenu( 15) = 'ค่าแพทย์'
 fmenu( 16) = 'เรียกเก็บจากกองทุน'
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
 fincode( 14) = 'VHCLC'
 fincode( 15) = 'df'
 fincode( 16) = 'PARTY'
 fincode( 17) = 'PAID'
 ON KEY LABEL F1
 ON KEY LABEL PGUP ?? chr(7)
 ACTIVATE WINDOW edit1
 hdr = 'แก้ไขข้อมูลผู้ป่วยใน'
 ON KEY LABEL PGDN ?? chr(7)
 ON KEY LABEL PGUP ?? chr(7)
 ON KEY LABEL F1 do mhelp with varread()
 @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 @ 1, 0, 1, 76 BOX
 @ 2, 5 SAY 'รหัส รพ.ที่ให้บริการ'
 @ 2, 30 GET hospc PICTURE '999999999999' MESSAGE 'F1 = List  Esc = exit'
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLOSE DATABASES
    RELEASE WINDOW edit1
    SET PROCEDURE TO
    ON KEY LABEL PGUP
    ON KEY LABEL F1
    SET DATE british
    RETURN TO main
 ENDIF
 SELECT iptrana
 GOTO TOP
 j = 1
 LOCATE FOR hospcare=m.hospc
 IF  .NOT. FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'NO record found!'
    RELEASE WINDOW edit1
    SET PROCEDURE TO
    ON KEY LABEL PgUp
    SET DATE british
    RETURN
 ENDIF
 DO WHILE FOUND()
    DIMENSION antemp( j)
    antemp( j) = SUBSTR(an, 1, 6)+'-'+SUBSTR(an, 7, 2)
    j = j+1
    IF j=1000
       WAIT WINDOW TIMEOUT 2 'มีจำนวน record มากกว่า 1,000'+CHR(13)+'โปรดแจ้ง AN ที่แน่นอนด้วยครับ'
       EXIT
    ENDIF
    CONTINUE
 ENDDO
 IF ALEN(antemp)>1
    = ASORT(antemp)
 ENDIF
 SET FILTER TO
 man1 = SPACE(9)
 DO WHILE .T.
    @ 3, 5 SAY 'Admission Number :'
    @ 3, 30 GET man1 FROM antemp
    ON KEY LABEL PgUp
    ON KEY LABEL PgDn
    KEYBOARD '{HOME}'
    READ
    IF READKEY()=12 .OR. READKEY()=268
       ON KEY LABEL PgUp
       ON KEY LABEL PgDn
       SET DATE british
       SET PROCEDURE TO
       RETURN
    ENDIF
    m.man = SUBSTR(man1, 1, 6)+SUBSTR(man1, 8, 2)
    SELECT iptrana
    LOCATE FOR an=man .AND. hospcare=hospc
    IF  .NOT. FOUND()
       LOOP
    ENDIF
    m.mhn = hn
    ON KEY LABEL PGDN ?? chr(7)
    ON KEY LABEL PGUP ?? chr(7)
    SCATTER MEMVAR
    dadm1 = SUBSTR(m.dateadm, 5, 2)
    dadm2 = SUBSTR(m.dateadm, 3, 2)
    dadm3 = SUBSTR(m.dateadm, 1, 2)
    SELECT iptrans
    LOCATE FOR hn=m.mhn .AND. hospcare=m.hospc
    SCATTER MEMVAR
    SELECT iptrand
    LOCATE FOR hn=m.mhn .AND. hospcare=m.hospc
    SCATTER MEMVAR
    SELECT iptranc
    LOCATE FOR an=m.man .AND. hospcare=m.hospc
    IF FOUND()
       SCATTER MEMVAR
    ELSE
       SCATTER BLANK MEMVAR
    ENDIF
    dcstatus = SUBSTR(disch, 2, 1)
    dctype = SUBSTR(disch, 3, 1)
    ddsc1 = SUBSTR(datedsc, 5, 2)
    ddsc2 = SUBSTR(datedsc, 3, 2)
    ddsc3 = SUBSTR(datedsc, 1, 2)
    SELECT iptranx
    LOCATE FOR an=m.man .AND. hospcare=m.hospc
    IF  .NOT. FOUND()
       clinic = 'N'
       WAIT WINDOW TIMEOUT 1 'WARNING : No Clinical data found!'
       m.an = m.man
       m.hospcare = m.hospc
       FOR i = 1 TO 4
          diag( i, 1) = m.an
          diag( i, 2) = SPACE(5)
          diag( i, 3) = SPACE(5)
          diag( i, 4) = m.hospc
       ENDFOR
    ELSE
       clinic = 'Y'
       m.an = m.man
       m.hospcare = m.hospc
       FOR i = 1 TO 4
          diag( i, 1) = m.an
          diag( i, 2) = SPACE(5)
          diag( i, 3) = SPACE(5)
          diag( i, 4) = m.hospc
       ENDFOR
       GOTO TOP
       LOCATE FOR an=m.man .AND. hospcare=m.hospc
       num = 1
       DO WHILE FOUND()
          diag( num, 1) = an
          diag( num, 2) = PADR(icd10, 5, ' ')
          diag( num, 3) = PADR(cause, 5, ' ')
          diag( num, 4) = hospc
          num = num+1
          CONTINUE
       ENDDO
       DIMENSION diag( 4, 4)
    ENDIF
    SELECT iptrano
    LOCATE FOR an=m.man .AND. hospcare=m.hospc
    IF  .NOT. FOUND()
       oper = 'N'
       m.an = m.man
       m.hospcare = m.hospc
       FOR i = 1 TO 4
          proct( i, 1) = m.an
          proct( i, 2) = SPACE(5)
          proct( i, 3) = SPACE(6)
          proct( i, 4) = SPACE(4)
          proct( i, 5) = SPACE(5)
          proct( i, 6) = m.hospc
       ENDFOR
    ELSE
       oper = 'Y'
       m.an = m.man
       m.hospcare = m.hospc
       FOR i = 1 TO 4
          proct( i, 1) = m.an
          proct( i, 2) = SPACE(5)
          proct( i, 3) = SPACE(6)
          proct( i, 4) = SPACE(4)
          proct( i, 5) = SPACE(5)
          proct( i, 6) = m.hospc
       ENDFOR
       GOTO TOP
       LOCATE FOR an=m.man .AND. hospcare=m.hospc
       num = 1
       DO WHILE FOUND()
          proct( num, 2) = icd9p
          proct( num, 3) = dateop
          proct( num, 4) = timeop
          proct( num, 5) = drop
          num = num+1
          CONTINUE
       ENDDO
       DIMENSION proct( 4, 6)
    ENDIF
    ON KEY LABEL Alt+1 _curobj=objnum(m.hospmain)
    ON KEY LABEL Alt+2 _curobj=objnum(diag(1,2))
    ON KEY LABEL Alt+3 _curobj=objnum(proct(1,2))
    ON KEY LABEL Alt+4 _curobj=objnum(dcstatus)
    @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
    @ 1, 0, 1, 76 BOX
    @ 2, 0 CLEAR
    @ 2, 0 SAY '1' COLOR GR+/R
    @ 2, 2 SAY 'Main contractor'
    @ 2, 20 GET m.hospmain PICTURE '999999999999' MESSAGE 'F1 = List '
    @ 2, 35 SAY 'รพ.ที่ให้บริการ'
    @ 2, 52 GET m.hospcare PICTURE '999999999999' MESSAGE 'F1 = List'
    @ 2, 66 SAY 'as'
    @ 2, 69 GET m.hosptyp PICTURE '9' VALID m.hosptyp$'0123' MESSAGE '0=Main 1=Sub 2=Supra 3=Other SS Net'
    @ 3, 2 SAY 'SS.:'
    @ 3, 7 GET m.ssn PICTURE '9999999999' MESSAGE 'เลขที่ประกันสังคม 10 ตำแหน่ง'
    @ 3, 20 SAY 'Fac. No.'
    @ 3, 30 GET m.facn PICTURE '9999999999999999' MESSAGE 'รหัสโรงงาน 16 ตำแหน่ง  F1 = List'
    @ 4, 2 SAY 'HN.:'
    @ 4, 7 GET m.hn PICTURE '999999999' MESSAGE 'เลขที่ HN 7 หลัก ต่อด้วยปีพ.ศ. 2 หลัก'
    @ 4, 20 SAY 'AN.:'
    @ 4, 26 GET m.an PICTURE '99999999' MESSAGE 'เลขที่ AN 6 หลัก ต่อด้วยปีพ.ศ. 2 หลัก'
    @ 4, 40 SAY 'ที่อยู่'
    @ 4, 52 GET m.address PICTURE '999999' MESSAGE 'รหัสที่อยู่   F1 = List'
    @ 5, 2 SAY 'เพศ'
    @ 5, 7 GET m.sex VALID m.sex$'12' MESSAGE '1=ชาย    2=หญิง'
    @ 5, 19
    @ 5, 40 SAY 'วันเกิด'
    @ 5, 52 GET m.dob VALID v_date(m.dob,VARREAD()) MESSAGE 'ปีพ.ศ. 4 หลัก เดือน 2 หลัก วันที่ 2 หลัก'
    @ 6, 2 SAY 'ADMIT'
    @ 6, 9 GET dadm3 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 11 SAY '/'
    @ 6, 12 GET dadm2 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 14 SAY '/'
    @ 6, 15 GET dadm1 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 20 SAY 'DISCHARGE'
    @ 6, 30 GET ddsc3 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 32 SAY '/'
    @ 6, 33 GET ddsc2 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 35 SAY '/'
    @ 6, 36 GET ddsc1 PICTURE '99' MESSAGE 'ปี/เดือน/วัน'
    @ 6, 40 SAY 'แผนก'
    @ 6, 45 GET m.dep PICTURE '99' MESSAGE 'F1 = List'
    @ 6, 50 SAY 'WARD'
    @ 6, 56 GET m.ward PICTURE '999' MESSAGE 'F1 = List'
    @ 8, 0, 8, 76 BOX
    hdr2 = 'ข้อมูลคลีนิก'
    @ 9, (WCOLS()-LEN(hdr2))/2 SAY hdr2 COLOR GR+/B
    @ 10, 0 SAY '2' COLOR GR+/R
    @ 10, 2 SAY 'Diagnosis 1 :'
    @ 10, 16 GET diag( 1, 2) PICTURE 'A9999' VALID v_diag1(diag(1,2),VARREAD()) MESSAGE 'รหัส ICD10 หรือ Keyword'
    @ 10, 22 SAY 'External Cause :'
    @ 10, 39 GET diag( 1, 3) PICTURE 'A9999' VALID v_diag1(diag(1,3),VARREAD()) MESSAGE 'รหัส ICD10 หรือ Keyword'
    @ 11, 2 SAY 'Diagnosis 2 :'
    @ 11, 16 GET diag( 2, 2) PICTURE 'A9999' VALID v_diag1(diag(2,2),VARREAD()) MESSAGE 'รหัส ICD10 หรือ Keyword'
    @ 12, 2 SAY 'Diagnosis 3 :'
    @ 12, 16 GET diag( 3, 2) PICTURE 'A9999' VALID v_diag1(diag(3,2),VARREAD()) MESSAGE 'รหัส ICD10 หรือ Keyword'
    @ 13, 2 SAY 'Diagnosis 4 :'
    @ 13, 16 GET diag( 4, 2) PICTURE 'A9999' VALID v_diag1(diag(4,2),VARREAD()) MESSAGE 'รหัส ICD10 หรือ Keyword'
    @ 14, 0 SAY '3' COLOR GR+/R
    @ 14, 2 SAY 'Operation 1 :'
    @ 14, 16 GET proct( 1, 2) PICTURE '99999' VALID v_op1(proct(1,2),VARREAD()) MESSAGE 'รหัส ICD9 CM หรือ Keyword'
    @ 14, 22 SAY 'Date :'
    @ 14, 29 GET proct( 1, 3) PICTURE '999999' MESSAGE 'ปี เดือน วัน'
    @ 14, 37 SAY 'Surgeon :'
    @ 14, 47 GET proct( 1, 5) PICTURE '99999' MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
    @ 15, 2 SAY 'Operation 2 :'
    @ 15, 16 GET proct( 2, 2) PICTURE '99999' VALID v_op1(proct(2,2),VARREAD()) MESSAGE 'รหัส ICD9 CM หรือ Keyword'
    @ 15, 22 SAY 'Date :'
    @ 15, 29 GET proct( 2, 3) PICTURE '999999' MESSAGE 'ปี เดือน วัน'
    @ 15, 37 SAY 'Surgeon :'
    @ 15, 47 GET proct( 2, 5) PICTURE '99999' MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
    @ 16, 2 SAY 'Operation 3 :'
    @ 16, 16 GET proct( 3, 2) PICTURE '99999' VALID v_op1(proct(3,2),VARREAD()) MESSAGE 'รหัส ICD9 CM หรือ Keyword'
    @ 16, 22 SAY 'Date :'
    @ 16, 29 GET proct( 3, 3) PICTURE '999999' MESSAGE 'ปี เดือน วัน'
    @ 16, 37 SAY 'Surgeon :'
    @ 16, 47 GET proct( 3, 5) PICTURE '99999' MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
    @ 17, 2 SAY 'Operation 4 :'
    @ 17, 16 GET proct( 4, 2) PICTURE '99999' VALID v_op1(proct(4,2),VARREAD()) MESSAGE 'รหัส ICD9 CM หรือ Keyword'
    @ 17, 22 SAY 'Date :'
    @ 17, 29 GET proct( 4, 3) PICTURE '999999' MESSAGE 'ปี เดือน วัน'
    @ 17, 37 SAY 'Surgeon :'
    @ 17, 47 GET proct( 4, 5) PICTURE '99999' MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
    @ 19, 0 SAY '4' COLOR GR+/R
    @ 19, 2 SAY 'Discharge status : '
    @ 19, 21 GET dcstatus PICTURE '9' VALID v_dc() MESSAGE 'F1 = List'
    @ 19, 30 SAY 'Discharge type   : '
    @ 19, 49 GET dctype PICTURE '9' VALID v_refer() MESSAGE 'F1 = List'
    @ 19, 52 SAY 'แพทย์เจ้าของไข้'
    @ 19, 68 GET m.dr PICTURE '99999' VALID  .NOT. EMPTY(m.dr) MESSAGE 'รหัสเลขที่ใบอนุญาต  F1 = List'
    READ
    IF READKEY()=12 .OR. READKEY()=268
       CLOSE DATABASES
       WAIT WINDOW TIMEOUT 2 'Terminate by user... No changes saved'
       RELEASE WINDOW edit1
       SET PROCEDURE TO
       ON KEY LABEL PgUp
       ON KEY LABEL PgDn
       ON KEY LABEL F1
       SET DATE british
       RETURN
    ENDIF
    m.dateadm = m.dadm3+m.dadm2+m.dadm1
    m.datedsc = m.ddsc3+m.ddsc2+m.ddsc1
    m.disch = 'S'+dcstatus+dctype
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
    ON KEY LABEL p _curobj=objnum(expense(15))
    ON KEY LABEL q _curobj=objnum(expense(16))
    SELECT iptranf
    LOCATE FOR an=m.man .AND. hospcare=m.hospcare
    IF  .NOT. FOUND()
       fin = 'N'
       expense = 0
    ELSE
       fin = 'Y'
       n = 1
       DO WHILE FOUND()
          DIMENSION temp( n, 2)
          temp( n, 1) = iptranf.fincode
          temp( n, 2) = iptranf.charge
          n = n+1
          CONTINUE
       ENDDO
       FOR i = 1 TO ALEN(temp, 1)
          pos = ASCAN(fincode, ALLTRIM(temp(i,1)))
          IF pos>0
             expense( pos) = temp(i,2)
          ENDIF
       ENDFOR
    ENDIF
    ACTIVATE WINDOW expen2
    IF fin='N'
       WAIT WINDOW TIMEOUT 1 'WARNING : No Financial data found!'
    ENDIF
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
       WAIT WINDOW TIMEOUT 1 'Terminated by user'
       RELEASE WINDOW expen2
       RELEASE WINDOW edit1
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
       ON KEY LABEL q
       SET DATE british
       SET PROCEDURE TO
       RETURN
    ENDIF
    WAIT WINDOW NOWAIT 'Updating record... please wait '
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
    ON KEY LABEL q
    SELECT iptrans
    IF EOF()
       APPEND BLANK
    ENDIF
    GATHER MEMVAR
    SELECT iptrand
    IF EOF()
       APPEND BLANK
    ENDIF
    GATHER MEMVAR
    SELECT iptrana
    IF EOF()
       APPEND BLANK
    ENDIF
    GATHER MEMVAR
    SELECT iptranc
    IF clinic='Y'
       GATHER MEMVAR
    ELSE
       GOTO BOTTOM
       APPEND BLANK
       GATHER MEMVAR
    ENDIF
    SELECT iptranx
    IF clinic='Y'
       LOCATE FOR an=man .AND. hospcare=hospc
       DO WHILE FOUND()
          DELETE
          CONTINUE
       ENDDO
    ENDIF
    FOR i = 1 TO 4
       IF EMPTY(diag(i,2))
          EXIT
       ENDIF
    ENDFOR
    IF i>1
       DIMENSION diag( i-1, 4)
       APPEND FROM ARRAY diag
       DIMENSION diag( 4, 4)
    ENDIF
    SELECT iptrano
    IF oper='Y'
       LOCATE FOR an=man .AND. hospcare=hospc
       DO WHILE FOUND()
          DELETE
          CONTINUE
       ENDDO
    ENDIF
    FOR i = 1 TO 4
       IF EMPTY(proct(i,2))
          EXIT
       ENDIF
    ENDFOR
    IF i>1
       DIMENSION proct( i-1, 6)
       APPEND FROM ARRAY proct
       DIMENSION proct( 4, 6)
    ENDIF
    SELECT iptranf
    LOCATE FOR an=man .AND. hospcare=hospc
    DO WHILE FOUND()
       DELETE
       CONTINUE
    ENDDO
    INSERT INTO data\iptranf.dbf FROM ARRAY finance
    DIMENSION finance( 16, 4)
    finance = ''
    expense = 0
    WAIT CLEAR
    @ 21, 0 CLEAR
    @ 22, 2 SAY 'ต้องการแก้ไข Record อื่นอีก  (Y/N)'
    @ 22, 38 GET ans VALID ans$'YyNn'
    READ
    IF ans$'Yy'
       CLEAR
       HIDE WINDOW expen2
       ACTIVATE WINDOW edit1
       CLEAR
       m.man = SPACE(8)
       LOOP
    ELSE
       RELEASE WINDOW expen2
       RELEASE WINDOW edit1
       EXIT
    ENDIF
 ENDDO
 SELECT iptrans
 PACK
 SELECT iptrand
 PACK
 SELECT iptrana
 PACK
 SELECT iptranc
 PACK
 SELECT iptranx
 PACK
 SELECT iptrano
 PACK
 SELECT iptranf
 PACK
 CLOSE DATABASES
 RELEASE WINDOW expen2
 RELEASE WINDOW edit1
 ON KEY LABEL Alt+1
 ON KEY LABEL Alt+2
 ON KEY LABEL Alt+3
 ON KEY LABEL Alt+4
 SET PROCEDURE TO
 SET DATE british
 SET EXCLUSIVE OFF
 RETURN
*
FUNCTION v_diag1
 PARAMETER mdiag, vname
 mdiag = RTRIM(mdiag)
 IF vname='DIAG(1,3)' .AND. EMPTY(mdiag)
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 4)='DIAG' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(proct(1,2))
    RETURN
 ENDIF
 IF SUBSTR(vname, 1, 4)='OPER' .AND. EMPTY(mdiag)
    _CUROBJ = OBJNUM(m.dcstatus)
    RETURN
 ENDIF
 IF EMPTY(mdiag) .AND. (vname='ANTE1' .OR. vname='ANTE2')
    RETURN
 ENDIF
 IF LEN(mdiag)<3
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid code!'
    RETURN 0
 ENDIF
 IF vname='DIAG(1,2)' .AND. EMPTY(mdiag)
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Diagnosis required!'
    RETURN 0
 ENDIF
 IF USED('icd101')
    SELECT icd101
 ELSE
    SELECT 11
    USE lib\icd101 ORDER code
 ENDIF
 IF  .NOT. SEEK(UPPER(mdiag))
    DEFINE WINDOW ask FROM 5, 5 TO 10, 75 SHADOW COLOR W+/RB
    ACTIVATE WINDOW ask
    ?? CHR(7)
    ans = 'Y'
    @ 1, 3 SAY 'WARNING : This code is NOT in the ICD file!'
    @ 2, 3 SAY 'Do you really want to use this code? Y/N'
    @ 2, 45 GET ans VALID ans$'YyNnํั์ื'
    READ
    IF ans$'Yyํั'
       &vname=padr(alltrim(upper(mdiag)),5,' ')
       RELEASE WINDOW ask
       show get &vname
       RETURN
    ELSE
       RELEASE WINDOW ask
       RETURN 0
    ENDIF
 ELSE
    &vname=padr(alltrim(upper(code)),5,' ')
    show get &vname
    RETURN
 ENDIF
*
FUNCTION v_op1
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
 ENDIF
 RETURN
*
FUNCTION v_refer
 IF  .NOT. m.dctype$'123456789'
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'invalid input'
    RETURN 0
 ENDIF
 IF m.dctype='4'
    SELECT 0
    USE data\refer
    LOCATE FOR an=m.man .AND. hospcare=m.hospc
    SCATTER MEMVAR
    refc = m.refcode
    DEFINE WINDOW refer FROM 12, 15 TO 19, 65 SHADOW
    ACTIVATE WINDOW refer
    @ 1, 1 SAY 'รหัสการรับ/ส่งต่อ'
    @ 1, 25 GET m.refc PICTURE '9' VALID refc$'123456' MESSAGE 'F1 = List'
    @ 2, 1 SAY 'รหัสรพ.ที่ส่งมา/รับต่อ'
    @ 2, 25 GET m.hospto PICTURE '999999999999' VALID  .NOT. EMPTY(m.hospto) MESSAGE 'F1 = List  99 = Not in list'
    READ
    refcode = m.refc
    GATHER MEMVAR
    USE
    RELEASE WINDOW refer
 ENDIF
 RETURN
*
PROCEDURE v_an
 PARAMETER anum, hosp1
 an1 = SPACE(8)
 SELECT iptrana
 LOCATE FOR hospcare=hosp1
 IF  .NOT. FOUND()
    WAIT WINDOW TIMEOUT 2 'ไม่พบข้อมูลของ รพ.นี้ โปรดเลือกใหม่'
    CLEAR
    RELEASE WINDOW edit1
    SET PROCEDURE TO
    RETURN TO main
 ELSE
    SET FILTER TO hospcare=hosp1
    SET ORDER TO an
    SEEK (anum)
    IF  .NOT. FOUND()
       WAIT WINDOW NOWAIT 'ไม่พบข้อมูลของ AN นี้ โปรดเลือก AN ใหม่'
       DEFINE POPUP an FROM 0, 0 TO 10, 14 PROMPT FIELDS an MARGIN SCROLL
       @ 3, 30 GET an1 POPUP an
       KEYBOARD '{HOME}'
       READ
    ENDIF
 ENDIF
 @ 3, 30 CLEAR
 m.man = an1
 SET FILTER TO
 RETURN
*
FUNCTION v_date
 PARAMETER dstr, varname
 SET DATE ansi
 chkdate = ' '
 IF EMPTY(dstr)
    RETURN
 ENDIF
 IF varname='DOB'
    chkyy = STR(VAL(SUBSTR(dstr, 1, 4))-543, 4)
 ELSE
    chkyy = STR(VAL(SUBSTR(dstr, 1, 2))+2500-543, 4)
 ENDIF
 chkdate = SUBSTR(chkyy, 3, 2)+'.'+SUBSTR(dstr, 5, 2)+'.'+SUBSTR(dstr, 7, 2)
 a = CTOD(chkdate)
 IF EMPTY(a)
    WAIT WINDOW TIMEOUT 2 'Invalid date!'
    RETURN 0
 ENDIF
 RETURN
*
PROCEDURE _vcol
 PARAMETER col
 m.fcol = col
 _CUROBJ = OBJNUM(expense(1+col))
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
    USE data\death ALIAS death
    LOCATE FOR an=m.an .AND. hospcare=m.hospc
    IF FOUND()
       SCATTER MEMVAR
    ELSE
       GOTO BOTTOM
       APPEND BLANK
       SCATTER BLANK MEMVAR
    ENDIF
    imm = PADR(m.icd10, 5, ' ')
    ante1 = PADR(m.cause1, 5, ' ')
    ante2 = PADR(m.cause2, 5, ' ')
    @ 0, (WCOLS()-LEN(dhdr))/2 SAY dhdr COLOR GR+/B
    @ 2, 2 SAY 'Direct cause: '
    @ 2, 17 GET imm VALID v_diag1(imm,VARREAD())
    @ 3, 2 SAY 'Antecedent  : '
    @ 3, 17 GET ante1 VALID v_diag1(ante1,VARREAD())
    @ 4, 2 SAY 'Originating : '
    @ 4, 17 GET ante2 VALID v_diag1(ante2,VARREAD())
    READ
    WAIT WINDOW TIMEOUT 1 ''
    m.icd10 = imm
    m.cause1 = ante1
    m.cause2 = ante2
    REPLACE death.icd10 WITH imm, death.cause1 WITH ante1, death.cause2 WITH ante2
    USE
    RELEASE WINDOW dead
 ENDIF
 RETURN
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