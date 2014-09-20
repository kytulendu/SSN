 SET TALK OFF
 SET SAFETY OFF
 SET DATE BRITISH
 SET EXCLUSIVE ON
 HIDE WINDOW ALL
 RESTORE FROM hosp ADDITIVE
 tmm = MONTH(DATE())-1
 IF tmm<10
    DO CASE
       CASE tmm=0
          rmm = ALLTRIM('12')
       CASE tmm>0
          rmm = ALLTRIM('0'+ALLTRIM(STR(tmm)))
    ENDCASE
 ELSE
    rmm = ALLTRIM(STR(tmm))
 ENDIF
 IF rmm='12'
    ryy = RIGHT(STR(YEAR(DATE())+543-1), 2)
 ELSE
    ryy = RIGHT(STR(YEAR(DATE())+543), 2)
 ENDIF
 dest = 'A'
 pass1 = 'Creating : OP data file'
 pass2 = 'Creating : IP data file'
 pass3 = 'Creating : Hospital code file'
 pass4 = 'Creating : Doctor code file'
 pass5 = 'Creating : Insurer file'
 pass6 = 'Creating : Refer cases file'
 pass7 = 'COMPLETE'
 DEFINE WINDOW rp1 FROM 6, 15 TO 18, 65 SHADOW
 ACTIVATE WINDOW rp1
 hdr = 'ส่งรายงานส่วนกลาง'
 @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 DO WHILE .T.
    @ 2, 2 SAY 'ส่งรายงานของเดือน '
    @ 2, 21 GET rmm PICTURE '99' VALID BETWEEN(VAL(rmm), 1, 12)
    @ 2, 24 SAY 'พ.ศ.25'
    @ 2, 30 GET ryy PICTURE '99'
    @ 4, 2 SAY 'เขียนแฟ้มรายงานที่ Drive : '
    @ 4, 30 GET dest PICTURE 'A' VALID dest$'ABab'
    READ
    DO CASE
       CASE VAL(ryy)>VAL(RIGHT(STR(YEAR(DATE())+543), 2))
          ? CHR(7)
          WAIT WINDOW TIMEOUT 2 'กรุณากรอกปีที่ถูกต้อง'
          LOOP
       CASE VAL(ryy)=VAL(RIGHT(STR(YEAR(DATE())+543), 2))
          IF VAL(rmm)>MONTH(DATE())
             ? CHR(7)
             WAIT WINDOW TIMEOUT 2 'กรุณากรอกเดือนที่ถูกต้อง'
             LOOP
          ELSE
             EXIT
          ENDIF
       CASE VAL(ryy)<34
          ? CHR(7)
          WAIT WINDOW TIMEOUT 2 'กรุณากรอกปีที่ถูกต้อง'
          LOOP
       OTHERWISE
          EXIT
    ENDCASE
    IF READKEY()=12 .OR. READKEY()=268
       CLEAR
       RELEASE WINDOW rp1
       SET EXCLUSIVE OFF
       RETURN
    ENDIF
 ENDDO
 IF READKEY()=12 .OR. READKEY()=268
    CLEAR
    RELEASE WINDOW rp1
    SET EXCLUSIVE OFF
    RETURN
 ENDIF
 fname = 'data\ip'+ryy+rmm+'.dbf'
 IF FILE(fname)
    DEFINE WINDOW sent FROM 6, 8 TO 17, 72 SHADOW
    ACTIVATE WINDOW sent
    ?? CHR(7)
    @ 0, 0 SAY PADC('ข้อมูลส่งไปแล้ว', WCOLS(), ' ') COLOR GR+/R
    @ 2, 2 SAY 'ข้อมูลของเดือน  '+rmm+'/'+ryy+' ได้ส่งไปแล้ว'
    @ 3, 2 SAY 'ไม่สามารถส่งซ้ำได้อีก สำหรับข้อมูลที่มีเพิ่ม ขอให้ส่งรวมไปกับ'
    @ 4, 2 SAY 'แฟ้มข้อมูลเดือนถัดไป'
    @ 6, 2 SAY 'ถ้าต้องการส่งข้อมูลเดิมซ้ำ ขอให้ copy จากแฟ้มข้อมูล'
    @ 7, 2 SAY '\SSN24\DATA\IP'+ryy+rmm+'.DBF และ OP'+ryy+'.DBF' COLOR GR+/B
    @ 9, 0 SAY PADC('Press a key to continue... ', WCOLS(), ' ')
    WAIT WINDOW ''
    RELEASE WINDOW rp1
    RELEASE WINDOW sent
    RETURN
 ENDIF
 tmpdest = 'sstemp'
 CLEAR
 hdr = 'จัดทำแฟ้มรายงาน โปรดรอสักครู่'
 @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 SELECT 1
 target = 'data\ips'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
    SET FILTER TO ssn<>' '
    ssr = 'ips'+ryy
 ENDIF
 SELECT 2
 target = 'data\ipd'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
 ENDIF
 SELECT 3
 target = 'data\ipa'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
    sss = 'ipa'+ryy
 ENDIF
 SELECT 4
 target = 'data\ipc'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
 ENDIF
 SELECT 5
 target = 'data\ipf'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
 ENDIF
 SELECT 6
 target = 'data\ipx'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
 ENDIF
 SELECT 7
 target = 'data\ipo'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
 ENDIF
 SELECT 8
 target = 'data\op'+ryy+'.dbf'
 IF  .NOT. FILE(target)
    @ 2, 2 SAY 'ไม่พบแฟ้ม '+(target)+'  กลับไปประมวลผลมาก่อน'
    WAIT WINDOW TIMEOUT 2 ''
    RELEASE WINDOW rp1
    RETURN
 ELSE
    USE (target)
    @ 2, (WCOLS()-LEN(pass1))/2 SAY pass1 COLOR GR+/B
    SELECT 8
    target = UPPER(tmpdest)+'\OP'+ryy+rmm+'.DBF'
    COPY TO (target) STRUCTURE
    COPY TO (target) FOR VAL(yymm)<=VAL(ryy+rmm)
    USE
 ENDIF
 @ 3, (WCOLS()-LEN(pass2))/2 SAY pass2 COLOR GR+/B
 SELECT 8
 USE data\iptmplt1
 SET FILTER TO pttyp='11'
 SCATTER BLANK MEMVAR
 target = 'ipc'+ryy
 SELECT (target)
 SET FILTER TO VAL(ALLTRIM(LEFT(datedsc, 4)))<=VAL(ryy+rmm)
 GOTO TOP
 mhn = SPACE(9)
 man = SPACE(8)
 mhosp = SPACE(7)
 DO WHILE  .NOT. EOF(4)
    SCATTER MEMVAR
    man = m.an
    mhosp = m.hospcare
    target = 'ipa'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    IF sent=.F.
       SCATTER MEMVAR
       mhn = m.hn
       m.sent = .T.
       GATHER MEMVAR
    ELSE
       target = 'ipc'+ryy
       SELECT (target)
       SKIP 1
       LOOP
    ENDIF
    target = 'ips'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR hn=mhn .AND. hospcare=mhosp
    SCATTER MEMVAR
    target = 'ipd'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR hn=mhn .AND. hospcare=mhosp
    SCATTER MEMVAR
    target = 'ipx'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    SCATTER MEMVAR
    m.dg1 = icd10
    CONTINUE
    IF FOUND()
       m.dg2 = icd10
       CONTINUE
       IF FOUND()
          m.dg3 = icd10
          CONTINUE
          IF FOUND()
             m.dg4 = icd10
          ENDIF
       ENDIF
    ENDIF
    target = 'ipo'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    SCATTER MEMVAR
    m.op1 = icd9p
    m.dateop1 = dateop
    m.drop1 = drop
    CONTINUE
    IF FOUND()
       m.op2 = icd9p
       m.dateop2 = dateop
       m.drop2 = drop
       CONTINUE
       IF FOUND()
          m.op3 = icd9p
          m.dateop3 = dateop
          m.drop3 = drop
          CONTINUE
          IF FOUND()
             m.op4 = icd9p
             m.dateop4 = dateop
             m.drop4 = drop
          ENDIF
       ENDIF
    ENDIF
    target = 'ipf'+ryy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    DO WHILE FOUND()
       temp = fincode
       m.&temp=charge
       CONTINUE
    ENDDO
    m.hospcare = mhosp
    m.an = man
    m.hn = mhn
    m.hospmain = hospcode
    INSERT INTO data\iptmplt1 FROM MEMVAR
    SELECT 8
    SCATTER BLANK MEMVAR
    target = 'ipc'+ryy
    SELECT (target)
    SKIP 1
 ENDDO
 SELECT 8
 COPY TO 'data\IP'+ryy+rmm+'.DBF' STRUCTURE
 SELECT 9
 USE 'data\IP'+ryy+rmm+'.DBF'
 ZAP
 APPEND FROM data\iptmplt1.dbf
 SELECT 8
 target = UPPER(tmpdest)+'\IP'+ryy+rmm+'.DBF'
 lcryy = ALLTRIM(STR(VAL(ryy)-1))
 targ = UPPER(tmpdest)+'\IP'+lcryy+'12'+'.DBF'
 LOCATE FOR VAL(SUBSTR(datedsc, 1, 2))<VAL(ryy)
 IF FOUND()
    COPY TO (target) STRUCTURE
    SELECT 8
    COPY TO (targ) STRUCTURE
    COPY TO (target) FOR VAL(SUBSTR(datedsc, 1, 2))=VAL(ryy)
    COPY TO (targ) FOR VAL(SUBSTR(datedsc, 1, 2))<VAL(ryy)
 ELSE
    COPY TO (target) FOR VAL(SUBSTR(datedsc, 1, 2))=VAL(ryy)
 ENDIF
 SELECT 8
 USE data\iptmplt1
 ZAP
 USE
 target = UPPER(tmpdest)+'\DEAD'+ryy+'.DBF'
 COPY FILE data\death.dbf TO (target) FOR SUBSTR(datedsc, 1, 2)<=ryy
 CLOSE DATABASES
 SELECT 25
 USE lib\codefile ORDER code
 @ 4, (WCOLS()-LEN(pass3))/2 SAY pass3 COLOR GR+/B
 target = UPPER(tmpdest)+'\HOSPCODE.DBF'
 COPY TO (target) STRUCTURE FIELDS code, name
 COPY TO (target) ALL FOR varname='CARE'
 @ 5, (WCOLS()-LEN(pass4))/2 SAY pass4 COLOR GR+/B
 target = UPPER(tmpdest)+'\DOCCODE.DBF'
 COPY TO (target) STRUCTURE FIELDS code, name
 COPY TO (target) ALL FOR varname='DR'
 USE
 @ 6, (WCOLS()-LEN(pass5))/2 SAY pass5 COLOR GR+/B
 SELECT 0
 USE data\insurer
 target = UPPER(tmpdest)+'\INSURER.DBF'
 COPY TO (target)
 USE
 SELECT 0
 USE data\errlog
 target = UPPER(tmpdest)+'\ERRLOG.DBF'
 COPY TO (target)
 ZAP
 USE
 @ 7, (WCOLS()-LEN(pass6))/2 SAY pass6 COLOR GR+/B
 SELECT 0
 USE data\refer
 target = UPPER(tmpdest)+'\REFER'+ryy+'.DBF'
 COPY TO (target) ALL FOR SUBSTR(yymm, 1, 2)<=ryy
 USE data\mobile
 target = UPPER(tmpdest)+'\MOBILE'+ryy+'.DBF'
 COPY TO (target) FOR SUBSTR(date, 7, 2)<=ryy
 USE
 IF UPPER(dest)='A'
    WAIT WINDOW TIMEOUT 0.5 'กำลัง ZIP files.... โปรดรอสักครู่'
    RUN pkzip -ap A:REPORT sstemp\*.* >nul
    RUN del sstemp\*.dbf >nul
 ENDIF
 IF UPPER(dest)='B'
    WAIT WINDOW TIMEOUT 0.5 'กำลัง ZIP files.... โปรดรอสักครู่'
    RUN pkzip -ap B:REPORT sstemp\*.* >nul
    RUN del sstemp\*.dbf >nul
 ENDIF
 target = UPPER(dest)+':\'+SUBSTR(hospcode, 1, 8)+'.'+SUBSTR(hospcode, 9, 3)
 handle = FCREATE(target)
 = FWRITE(handle, hospname)
 = FCLOSE(handle)
 @ 9, (WCOLS()-LEN(pass7))/2 SAY pass7 COLOR GR+/B
 WAIT WINDOW TIMEOUT 1 ''
 RELEASE WINDOW rp1
 CLOSE DATABASES
 SET EXCLUSIVE OFF
 RETURN TO main
*
