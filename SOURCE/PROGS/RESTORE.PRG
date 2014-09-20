 HIDE WINDOW ALL
 CLEAR
 CLOSE DATABASES
 SET TALK OFF
 ACTIVATE SCREEN
 dest = 'A'
 hdr1 = 'RESTORE all data files'
 hdr2 = 'ใส่แผ่น diskette แล้วโปรดรอสักครู่'
 hdr3 = 'COMPLETE!'
 @ 1, (WCOLS()-LEN(hdr1))/2 SAY hdr1
 @ 3, 10 SAY 'เลือก Drive ที่จะใส่แผ่นเก็บข้อมูล'
 @ 3, 45 GET dest PICTURE 'A' VALID dest$'AaBb' MESSAGE 'Press Esc to ABORT'
 @ 5, 10 SAY 'หลังจากเรียกคืนข้อมูลต้องทำการประมวลผลก่อน จึงสามารถเรียกดูรายงานได้' COLOR SCHEME 2,4
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RETURN
 ENDIF
 @ 6, (WCOLS()-LEN(hdr2))/2 SAY hdr2
 WAIT
 @ 7, 0 CLEAR
 IF UPPER(dest)='A'
    SET CONSOLE OFF
    RUN pkunzip -o A:ssback data\ *.dbf *.cdx >nul
    RUN pkunzip -o A:ssback lib\ codefile.* >nul
    SET CONSOLE ON
 ENDIF
 IF UPPER(dest)='B'
    SET CONSOLE OFF
    RUN pkunzip -o B:ssback data\ *.dbf *.cdx >nul
    RUN pkunzip -o B:ssback lib\ codefile.* >nul
    SET CONSOLE ON
 ENDIF
 WAIT WINDOW TIMEOUT 3 'หลังจากเรียกคืนข้อมูลต้องทำการ'+CHR(13)+' ประมวลผลก่อนจึงสามารถเรียกดูรายงานได้'
 CLEAR
 @ 8, (WCOLS()-LEN(hdr3))/2 SAY hdr3
 CLEAR
 SET CONSOLE ON
 WAIT WINDOW TIMEOUT 2 ''
 RETURN
*
