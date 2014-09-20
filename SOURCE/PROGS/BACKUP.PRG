 HIDE WINDOW ALL
 CLEAR
 CLOSE DATABASES
 SET TALK OFF
 ACTIVATE SCREEN
 dest = 'A'
 hdr1 = 'BACKUP all data files'
 hdr2 = 'ใส่แผ่น diskette แล้วโปรดรอสักครู่'
 hdr3 = 'COMPLETE!'
 @ 1, (WCOLS()-LEN(hdr1))/2 SAY hdr1
 @ 3, 10 SAY 'เลือก Drive ที่จะใช้เก็บข้อมูล'
 @ 3, 45 GET dest PICTURE 'A' VALID dest$'AaBb' MESSAGE 'Press Esc to ABORT'
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RETURN
 ENDIF
 @ 5, (WCOLS()-LEN(hdr2))/2 SAY hdr2
 WAIT
 @ 6, 0 CLEAR
 IF UPPER(dest)='A'
    SET CONSOLE OFF
    RUN pkzip -ap A:ssback data\*.dbf data\*.cdx lib\codefile.* >nul
    SET CONSOLE ON
 ENDIF
 IF UPPER(dest)='B'
    SET CONSOLE OFF
    RUN pkzip -ap B:ssback data\*.dbf data\*.cdx lib\codefile.* >nul
    SET CONSOLE ON
 ENDIF
 CLEAR
 @ 7, (WCOLS()-LEN(hdr3))/2 SAY hdr3
 WAIT WINDOW TIMEOUT 2 ''
 CLEAR
 RETURN
*
