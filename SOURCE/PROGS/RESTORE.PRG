 HIDE WINDOW ALL
 CLEAR
 CLOSE DATABASES
 SET TALK OFF
 ACTIVATE SCREEN
 dest = 'A'
 hdr1 = 'RESTORE all data files'
 hdr2 = '����� diskette �����ô���ѡ����'
 hdr3 = 'COMPLETE!'
 @ 1, (WCOLS()-LEN(hdr1))/2 SAY hdr1
 @ 3, 10 SAY '���͡ Drive ����������红�����'
 @ 3, 45 GET dest PICTURE 'A' VALID dest$'AaBb' MESSAGE 'Press Esc to ABORT'
 @ 5, 10 SAY '��ѧ�ҡ���¡�׹�����ŵ�ͧ�ӡ�û����żš�͹ �֧����ö���¡����§ҹ��' COLOR SCHEME 2,4
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
 WAIT WINDOW TIMEOUT 3 '��ѧ�ҡ���¡�׹�����ŵ�ͧ�ӡ��'+CHR(13)+' �����żš�͹�֧����ö���¡����§ҹ��'
 CLEAR
 @ 8, (WCOLS()-LEN(hdr3))/2 SAY hdr3
 CLEAR
 SET CONSOLE ON
 WAIT WINDOW TIMEOUT 2 ''
 RETURN
*
