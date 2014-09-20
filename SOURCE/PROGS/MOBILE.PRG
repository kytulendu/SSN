 SET TALK OFF
 SET ECHO OFF
 CLOSE DATABASES
 RESTORE FROM hosp.mem ADDITIVE
 olddate = SET('DATE')
 SET DATE british
 HIDE WINDOW ALL
 DEFINE WINDOW mobile FROM 5, 10 TO 14, 69 SHADOW
 ACTIVATE WINDOW mobile
 target = '\DATA\MOBILE.DBF'
 IF  .NOT. FILE(target)
    USE
 ENDIF
 SELECT 0
 USE data\mobile
 DIMENSION mbmenu( 3)
 mbmenu( 1) = 'หน่วยต่อไป'
 mbmenu( 2) = 'กลับรายการหลัก'
 mbmenu( 3) = 'แก้ไข'
 mdd = PADL(ALLTRIM(STR(DAY(DATE()))), 2, '0')
 mmm = PADL(ALLTRIM(STR(MONTH(DATE()))), 2, '0')
 myy = STR(YEAR(DATE())+543-2500, 2)
 mwhere = SPACE(30)
 numcase = 0
 msignature = SPACE(25)
 mcost = SPACE(6)
 DO WHILE .T.
    @ 0, 0 SAY PADC('บันทึกข้อมูลการออกหน่วยเคลื่อนที่', WCOLS(), ' ')
    @ 1, 0 SAY REPLICATE('-', WCOLS())
    @ 2, 2 SAY 'วันที่'
    @ 2, 10 GET mdd PICTURE '99' VALID BETWEEN(VAL(mdd), 1, 31)
    @ 2, 12 SAY '/'
    @ 2, 13 GET mmm PICTURE '99' VALID BETWEEN(VAL(mmm), 1, 12)
    @ 2, 15 SAY '/'
    @ 2, 16 GET myy PICTURE '99' VALID VAL(myy)>=37
    @ 3, 2 SAY 'สถานที่'
    @ 3, 16 GET mwhere
    @ 4, 2 SAY 'จำนวนผู้มารับบริการ'
    @ 4, 25 GET numcase PICTURE '9999'
    @ 4, 30 SAY 'ราย'
    @ 4, 35 SAY 'ค่าบริการ'
    @ 4, 46 GET mcost PICTURE '999999'
    @ 4, 54 SAY 'บาท'
    @ 5, 2 SAY 'ผู้รับผิดชอบ'
    @ 5, 16 GET msignature
    @ 6, 0 SAY REPLICATE('-', WCOLS())
    READ
    IF READKEY()=12 .OR. READKEY()=268
       RELEASE WINDOW mobile
       EXIT
    ENDIF
    mbchoice = 1
    @ 7, 0 PROMPT PADC(mbmenu(1), 18, ' ')
    @ 7, 20 PROMPT PADC(mbmenu(2), 18, ' ')
    @ 7, 40 PROMPT PADC(mbmenu(3), 18, ' ')
    MENU TO mbchoice
    DO CASE
       CASE mbchoice=1
          GOTO BOTTOM
          APPEND BLANK
          REPLACE mobile.hospcare WITH m.hospcode, mobile.date WITH mdd+'/'+mmm+'/'+myy, mobile.where WITH mwhere
          REPLACE mobile.case WITH numcase, mobile.signature WITH msignature
          REPLACE mobile.cost WITH VAL(mcost)
          WAIT WINDOW TIMEOUT 2 'Data saved to disk...'
          mdd = PADL(ALLTRIM(STR(DAY(DATE()))), 2, '0')
          mmm = PADL(ALLTRIM(STR(MONTH(DATE()))), 2, '0')
          myy = STR(YEAR(DATE())+543-2500, 2)
          mwhere = SPACE(30)
          numcase = 0
          msignature = SPACE(25)
          LOOP
       CASE mbchoice=2
          GOTO BOTTOM
          APPEND BLANK
          REPLACE mobile.hospcare WITH m.hospcode, mobile.date WITH mdd+'/'+mmm+'/'+myy, mobile.where WITH mwhere
          REPLACE mobile.case WITH numcase, mobile.signature WITH msignature
          REPLACE mobile.cost WITH VAL(mcost)
          WAIT WINDOW TIMEOUT 2 'Data saved to disk...'
          EXIT
       CASE mbchoice=3
          @ 7, 0 CLEAR
          LOOP
    ENDCASE
 ENDDO
 SELECT mobile
 USE
 RELEASE WINDOW mobile
 SET DATE (olddate)
 RETURN
*
