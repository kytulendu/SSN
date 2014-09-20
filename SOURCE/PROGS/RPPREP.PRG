 SET TALK OFF
 SET SAFETY OFF
 SET EXCLUSIVE ON
 CLOSE DATABASES
 HIDE WINDOW ALL
 ACTIVATE SCREEN
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
    yy = RIGHT(STR(YEAR(DATE())+543), 2)
 ENDIF
 DEFINE WINDOW askyear FROM 10, 20 TO 15, 60 SHADOW
 ACTIVATE WINDOW askyear
 askmsg = 'เลือกปีที่ออกรายงาน'
 @ 1, (WCOLS()-LEN(askmsg))/2 SAY askmsg
 @ 2, 15 SAY 'พ.ศ.25'
 @ 2, 21 GET yy PICTURE '99' VALID BETWEEN(VAL(yy), 34, 99)
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 2 'Terminate by user'
    RELEASE WINDOW askyear
    RETURN
 ENDIF
 RELEASE WINDOW askyear
 CLEAR
 DEFINE WINDOW work FROM 10, 20 TO 15, 60 SHADOW
 ACTIVATE WINDOW work
 wmsg = 'โปรดรอสักครู่'
 wmsg2 = 'กำลังอ่านแฟ้มข้อมูล'
 @ 1, (WCOLS()-LEN(wmsg))/2 SAY wmsg COLOR GR+/B
 SELECT 1
 USE data\iptrans
 SELECT 2
 USE data\iptrand
 SELECT 3
 USE data\iptrana
 SELECT 4
 USE data\iptranc
 SELECT 5
 USE data\iptranf
 SELECT 6
 USE data\iptranx
 SELECT 7
 USE data\iptrano
 SELECT 8
 USE data\optran
 IF  .NOT. FILE('data\ips'+yy+'.dbf')
    target = 'data\ips'+yy+'.dbf'
    SELECT iptrans
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipd'+yy+'.dbf')
    target = 'data\ipd'+yy+'.dbf'
    SELECT iptrand
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipa'+yy+'.dbf')
    target = 'data\ipa'+yy+'.dbf'
    SELECT iptrana
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipc'+yy+'.dbf')
    target = 'data\ipc'+yy+'.dbf'
    SELECT iptranc
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipf'+yy+'.dbf')
    target = 'data\ipf'+yy+'.dbf'
    SELECT iptranf
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipx'+yy+'.dbf')
    target = 'data\ipx'+yy+'.dbf'
    SELECT iptranx
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\ipo'+yy+'.dbf')
    target = 'data\ipo'+yy+'.dbf'
    SELECT iptrano
    COPY TO (target) STRUCTURE CDX
 ENDIF
 IF  .NOT. FILE('data\op'+yy+'.dbf')
    target = 'data\op'+yy+'.dbf'
    SELECT optran
    COPY TO (target) STRUCTURE CDX
 ENDIF
 @ 2, 13 SAY ' 10% Completed' COLOR W+/B
 SELECT iptrans
 GOTO TOP
 mhn = SPACE(9)
 mhosp = SPACE(12)
 man = SPACE(8)
 target = ' '
 @ 0, (WCOLS()-LEN(wmsg))/2 SAY wmsg2 COLOR GR+/B
 @ 1, 0 SAY PADC('โปรดรอ.. อาจใช้เวลาถึง 30 นาที', 38, ' ') COLOR GR+/B
 DO WHILE  .NOT. EOF('iptrans')
    mhn = iptrans.hn
    mhosp = iptrans.hospcare
    SELECT iptrana
    LOCATE FOR iptrana.hn=m.mhn .AND. iptrana.hospcare=m.mhosp
    IF pttyp='11'
       man = iptrana.an
       SELECT iptranc
       LOCATE FOR iptranc.an=m.man .AND. iptranc.hospcare=m.mhosp
       IF VAL(SUBSTR(iptranc.datedsc, 1, 2))>VAL(yy)
          SELECT iptrans
          SKIP 1
          LOOP
       ENDIF
       SELECT iptranf
       LOCATE FOR iptranf.an=m.man .AND. iptranf.hospcare=m.mhosp
       IF FOUND()
          SELECT iptranx
          LOCATE FOR iptranx.an=m.man .AND. iptranx.hospcare=m.mhosp
          IF FOUND()
             SELECT iptrans
             SCATTER MEMVAR
             target = 'data\ips'+yy+'.dbf'
             SELECT 0
             USE (target)
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             IF  .NOT. FOUND()
                INSERT INTO (target) FROM MEMVAR
             ENDIF
             USE
             SELECT iptrans
             DELETE
             SELECT iptrand
             GOTO TOP
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             SCATTER MEMVAR
             target = 'data\ipd'+yy+'.dbf'
             SELECT 0
             USE (target)
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             IF  .NOT. FOUND()
                INSERT INTO (target) FROM MEMVAR
             ENDIF
             USE
             SELECT iptrand
             DELETE
             SELECT iptrana
             GOTO TOP
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             SCATTER MEMVAR
             target = 'data\ipa'+yy+'.dbf'
             INSERT INTO (target) FROM MEMVAR
             DELETE
             SELECT iptranc
             GOTO TOP
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp .AND. VAL(SUBSTR(datedsc, 1, 2))<=VAL(yy)
             SCATTER MEMVAR
             target = 'data\ipc'+yy+'.dbf'
             INSERT INTO (target) FROM MEMVAR
             DELETE
             SELECT iptranf
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipf'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
             SELECT iptranx
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipx'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
             SELECT iptrano
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipo'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
          ENDIF
       ENDIF
    ELSE
       man = iptrana.an
       SELECT iptranc
       LOCATE FOR iptranc.an=m.man .AND. iptranc.hospcare=m.mhosp
       IF VAL(SUBSTR(iptranc.datedsc, 1, 2))>VAL(yy)
          SELECT iptrans
          SKIP 1
          LOOP
       ENDIF
       SELECT iptranf
       LOCATE FOR iptranf.an=m.man .AND. iptranf.hospcare=m.mhosp
       IF FOUND()
          SELECT iptranx
          LOCATE FOR iptranx.an=m.man .AND. iptranx.hospcare=m.mhosp
          IF FOUND()
             SELECT iptrans
             SCATTER MEMVAR
             target = 'data\ips'+yy+'.dbf'
             SELECT 0
             USE (target)
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             IF  .NOT. FOUND()
                INSERT INTO (target) FROM MEMVAR
             ENDIF
             USE
             SELECT iptrans
             DELETE
             SELECT iptrand
             GOTO TOP
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             SCATTER MEMVAR
             target = 'data\ipd'+yy+'.dbf'
             SELECT 0
             USE (target)
             LOCATE FOR hn=m.mhn .AND. hospcare=m.mhosp
             IF  .NOT. FOUND()
                INSERT INTO (target) FROM MEMVAR
             ENDIF
             USE
             SELECT iptrand
             DELETE
             SELECT iptrana
             GOTO TOP
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             SCATTER MEMVAR
             target = 'data\ipa'+yy+'.dbf'
             INSERT INTO (target) FROM MEMVAR
             DELETE
             SELECT iptranc
             GOTO TOP
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             SCATTER MEMVAR
             target = 'data\ipc'+yy+'.dbf'
             INSERT INTO (target) FROM MEMVAR
             DELETE
             SELECT iptranf
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipf'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
             SELECT iptranx
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipx'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
             SELECT iptrano
             LOCATE FOR an=m.man .AND. hospcare=m.mhosp
             DO WHILE FOUND()
                SCATTER MEMVAR
                target = 'data\ipo'+yy+'.dbf'
                INSERT INTO (target) FROM MEMVAR
                DELETE
                CONTINUE
             ENDDO
          ENDIF
       ENDIF
    ENDIF
    SELECT iptrans
    SKIP 1
 ENDDO
 @ 2, 13 SAY ' 30% Completed' COLOR W+/B
 @ 0, 0 SAY SPACE(38)
 @ 1, 0 SAY PADC(wmsg, 38, ' ') COLOR GR+/B
 SELECT 8
 target = 'data\op'+yy+'.dbf'
 USE (target)
 APPEND FROM data\optran
 USE data\optran
 ZAP
 @ 2, 13 SAY ' 40% Completed' COLOR W+/B
 @ 0, 0 SAY PADC('Packing Databases', 38, ' ')
 SELECT iptrans
 PACK
 SELECT iptrand
 PACK
 SELECT iptrana
 PACK
 SELECT iptranc
 PACK
 SELECT iptranf
 PACK
 SELECT iptranx
 PACK
 SELECT iptrano
 PACK
 CLOSE DATABASES
 @ 0, 0 SAY PADC('Creating Report Data', 38, ' ')
 @ 2, 13 SAY ' 50% Completed' COLOR W+/B
 SELECT 10
 USE lib\codefile
 SELECT 11
 target = 'data\ips'+yy+'.dbf'
 USE (target)
 SELECT 12
 target = 'data\ipd'+yy+'.dbf'
 USE (target)
 SELECT 13
 target = 'data\ipa'+yy+'.dbf'
 USE (target)
 SELECT 14
 target = 'data\ipc'+yy+'.dbf'
 USE (target)
 SELECT 15
 target = 'data\ipf'+yy+'.dbf'
 USE (target)
 SELECT 16
 target = 'data\ipx'+yy+'.dbf'
 USE (target)
 SELECT 17
 target = 'data\ipo'+yy+'.dbf'
 USE (target)
 SELECT 18
 USE rp\iptra
 ZAP
 SELECT 19
 USE data\iptmplt1
 SELECT 20
 target = 'data\op'+yy+'.dbf'
 USE (target)
 SELECT iptmplt1
 SCATTER BLANK MEMVAR
 SELECT 14
 GOTO TOP
 mhn = SPACE(9)
 man = SPACE(8)
 mhosp = SPACE(12)
 DO WHILE  .NOT. EOF(14)
    SCATTER MEMVAR
    man = m.an
    mhosp = m.hospcare
    target = 'ipa'+yy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    SCATTER MEMVAR
    mhn = m.hn
    target = 'ips'+yy
    SELECT (target)
    GOTO TOP
    LOCATE FOR hn=mhn .AND. hospcare=mhosp
    SCATTER MEMVAR
    target = 'ipd'+yy
    SELECT (target)
    GOTO TOP
    LOCATE FOR hn=mhn .AND. hospcare=mhosp
    SCATTER MEMVAR
    target = 'ipx'+yy
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
    target = 'ipo'+yy
    SELECT (target)
    GOTO TOP
    LOCATE FOR an=man .AND. hospcare=mhosp
    SCATTER MEMVAR
    m.op1 = icd9p
    m.drop1 = drop
    m.dateop1 = dateop
    CONTINUE
    IF FOUND()
       m.op2 = icd9p
       m.drop2 = drop
       m.dateop2 = dateop
       CONTINUE
       IF FOUND()
          m.op3 = icd9p
          m.drop3 = drop
          m.dateop3 = dateop
          CONTINUE
          IF FOUND()
             m.op4 = icd9p
             m.drop4 = drop
             m.dateop4 = dateop
          ENDIF
       ENDIF
    ENDIF
    target = 'ipf'+yy
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
    SELECT iptra
    APPEND BLANK
    REPLACE ssn WITH m.ssn, hosptyp WITH m.hosptyp, hospmain WITH m.hospmain
    REPLACE facn WITH m.facn
    REPLACE an WITH m.hospcare+m.an, hn WITH m.hn, hospcare WITH m.hospcare
    REPLACE address WITH m.address
    REPLACE sex WITH m.sex, pttyp WITH m.pttyp
    REPLACE occupa WITH m.occupa
    REPLACE dob WITH m.dob
    REPLACE dateadm WITH SUBSTR(m.dateadm, 5, 2)+'/'+SUBSTR(m.dateadm, 3, 2)+'/'+SUBSTR(m.dateadm, 1, 2)
    REPLACE datedsc WITH SUBSTR(m.datedsc, 5, 2)+'/'+SUBSTR(m.datedsc, 3, 2)+'/'+SUBSTR(m.datedsc, 1, 2)
    REPLACE dep WITH m.dep
    REPLACE ward WITH m.ward
    REPLACE dg1 WITH m.dg1
    REPLACE dg2 WITH m.dg2
    REPLACE dg3 WITH m.dg3
    REPLACE dg4 WITH m.dg4
    REPLACE cause WITH m.cause
    REPLACE dateop1 WITH SUBSTR(m.dateop1, 5, 2)+'/'+SUBSTR(m.dateop1, 3, 2)+'/'+SUBSTR(m.dateop1, 1, 2)
    REPLACE dateop2 WITH SUBSTR(m.dateop2, 5, 2)+'/'+SUBSTR(m.dateop2, 3, 2)+'/'+SUBSTR(m.dateop2, 1, 2)
    REPLACE dateop3 WITH SUBSTR(m.dateop3, 5, 2)+'/'+SUBSTR(m.dateop3, 3, 2)+'/'+SUBSTR(m.dateop3, 1, 2)
    REPLACE dateop4 WITH SUBSTR(m.dateop4, 5, 2)+'/'+SUBSTR(m.dateop4, 3, 2)+'/'+SUBSTR(m.dateop4, 1, 2)
    REPLACE op1 WITH m.op1
    REPLACE op2 WITH m.op2
    REPLACE op3 WITH m.op3
    REPLACE op4 WITH m.op4
    REPLACE drop1 WITH m.drop1
    REPLACE drop2 WITH m.drop2
    REPLACE drop3 WITH m.drop3
    REPLACE drop4 WITH m.drop4
    REPLACE disch WITH m.disch, dr WITH m.dr
    REPLACE lab WITH m.labc
    REPLACE bldb WITH m.bldbc
    REPLACE path WITH m.pathc
    REPLACE xray WITH m.xrayc
    REPLACE invt WITH m.invtc
    REPLACE oprn WITH m.oprnc
    REPLACE pros WITH m.prosc
    REPLACE anes WITH m.anesc
    REPLACE drug WITH m.drugc
    REPLACE rehb WITH m.rehbc
    REPLACE ther WITH m.therc
    REPLACE icu WITH m.icuc
    REPLACE acco WITH m.accoc
    REPLACE vhcl WITH m.vhclc
    REPLACE df WITH m.df
    REPLACE ipcap WITH m.labc+m.bldbc+m.pathc+m.xrayc+m.invtc+m.oprnc+m.prosc+m.anesc+m.drugc+m.rehbc+m.therc+m.icuc+m.accoc+m.vhclc+m.df
    REPLACE paid WITH m.paid
    REPLACE party3 WITH m.party
    REPLACE totchg WITH paid+party3+ipcap
    SELECT iptmplt1
    SCATTER BLANK MEMVAR
    SELECT 14
    SKIP 1
 ENDDO
 @ 2, 13 SAY ' 80% Completed' COLOR W+/B
 SELECT iptmplt1
 ZAP
 SELECT 10
 COPY TO rp\hospcode.dbf FIELDS code, name ALL FOR varname='CARE'
 COPY TO rp\distcode.dbf FIELDS code, name ALL FOR varname='ADDR'
 COPY TO rp\depcode.dbf FIELDS code, name ALL FOR varname='DEP'
 COPY TO rp\wardcode.dbf FIELDS code, name ALL FOR varname='WARD'
 COPY TO rp\facncode.dbf FIELDS code, name ALL FOR varname='FACN'
 COPY TO rp\doccode.dbf FIELDS code, name ALL FOR varname='DOC'
 SELECT 20
 COPY TO rp\optran.dbf
 @ 0, 0 SAY SPACE(38)
 @ 2, 13 SAY '100% Completed' COLOR W+/B
 WAIT WINDOW 'กรุณาตรวจสอบข้อมูลก่อน'
 DEFINE WINDOW dataprn FROM 3, 5 TO 23, 75 SHADOW TITLE 'Press Esc When Finish'
 ACTIVATE WINDOW dataprn
 SELECT iptra
 BROWSE
 DEACTIVATE WINDOW dataprn
 @ 1, 1 SAY SPACE(40)
 @ 2, 10 SAY 'มีข้อมูลผู้ป่วยในจำนวน'+' '+ALLTRIM(STR(RECCOUNT())) COLOR W+/B
 WAIT ''
 ACTIVATE WINDOW dataprn
 USE rp\Optran
 BROWSE
 DEACTIVATE WINDOW dataprn
 @ 2, 10 SAY 'มีข้อมูลผู้ป่วยนอกจำนวน'+' '+ALLTRIM(STR(RECCOUNT())) COLOR W+/B
 RELEASE WINDOW dataprn
 WAIT ''
 CLOSE DATABASES
 RELEASE WINDOW work
*
