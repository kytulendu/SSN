 CLEAR
 SET TALK OFF
 SET COLOR TO BG+/B
 SET BORDER TO '*'
 SET SAFETY OFF
 CLOSE DATABASES
 DEFINE WINDOW welcome FROM 3, 3 TO 20, 76 SHADOW TITLE ' WELCOME TO SSN2 '
 ACTIVATE WINDOW NOSHOW welcome
 SET ESCAPE OFF
 hdr1 = 'SETUP : �Դ��駢����Ţͧ�к�'
 @ 1, (WCOLS()-LEN(hdr1))/2+2 SAY hdr1 COLOR GR+/B
 @ 3, 5 SAY '��͹�����������ҹ �е�ͧ��˹���ҵ���� ���'
 @ 5, 15 SAY '��Դ�ͧ���ʴ��Ҿ'
 @ 6, 15 SAY '�к������·����'
 @ 7, 15 SAY '�������ç��Һ�ż���������'
 @ 8, 15 SAY '��˹����� þ.����͢���'
 @ 9, 15 SAY '��˹����� �������'
 @ 10, 15 SAY '��˹����� ᾷ��'
 @ 11, 15 SAY '��˹����� �ͼ�����'
 @ 12, 15 SAY '��˹����� �ç�ҹ'
 hdr2 = 'Press any key to continue'
 @ 14, (WCOLS()-LEN(hdr2))/2 SAY hdr2 COLOR G+/B
 hosppref = '17'
 hospname = SPACE(30)
 hospadd1 = SPACE(30)
 hospadd2 = SPACE(30)
 hospprov = SPACE(2)
 hospcode = SPACE(7)
 hospphon = '(   )-       '
 hospfax = '(   )-       '
 vidtype = '1'
 vidcard = '1'
 SHOW WINDOW welcome
 WAIT WINDOW ''
 RELEASE WINDOW welcome
 SET ESCAPE ON
 IF INKEY()=27
    WAIT WINDOW TIMEOUT 2 'Setup aborted by user!'
    QUIT
 ENDIF
 DEFINE WINDOW general FROM 2, 2 TO 15, 77 SHADOW
 ACTIVATE WINDOW general
 @ 1, 3 SAY '���͡��Դ���Ҿ' COLOR GR+/B
 @ 1, 28 GET vidtype VALID vidtype$'12'
 @ 1, 32 SAY '1 Monochrome'
 @ 2, 32 SAY '2 Color'
 @ 4, 3 SAY '���͡�к�������'
 @ 4, 28 GET vidcard VALID vidcard$'1234567'
 @ 4, 32 SAY '1 VTHAI.COM, THAI.COM �����'
 @ 5, 32 SAY '2 TSM.EXE ��������'
 @ 6, 32 SAY '3 THAIPRO.EXE, THAIVGA.EXE    �.IRC'
 @ 7, 32 SAY '4 THAIPRO.EXE   �.PowerSoft'
 @ 8, 32 SAY '5               �.MicroWiz'
 @ 9, 32 SAY '6               �.RLAB'
 @ 10, 32 SAY '7 ����Һ'
 READ
 RELEASE WINDOW general
 hosppref = vidtype+vidcard
 viddrv = VAL(vidcard)
 DIMENSION mborder( 7)
 mborder( 1) = '--������        '
 mborder( 2) = '��������        '
 mborder( 3) = '                '
 mborder( 4) = '��������        '
 mborder( 5) = '                '
 mborder( 6) = '                '
 mborder( 7) = '********        '
 SET BORDER TO
 CLEAR
 DO rendx
 CLEAR
 SELECT 1
 USE lib\provcode ORDER code
 GOTO TOP
 hdr = '���͡�Ţ���ʨѧ��Ѵ�ͧ��ҹ'
 @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 col = 0
 row = 0
 DO WHILE  .NOT. EOF()
    DO WHILE  .NOT. EOF() .AND. col<62
       @ 3+row, 1+col SAY SUBSTR(code, 1, 2)+' '+SUBSTR(name, 1, 12)
       col = col+20
       SKIP
    ENDDO
    col = 0
    row = row+1
 ENDDO
 @ 23, 37 SAY '->'
 @ 23, 43 SAY '<-'
 @ 23, 40 GET hospprov PICTURE '99' VALID SEEK(hospprov)
 READ
 USE
 CLEAR
 USE lib\hospcode ORDER code
 SET FILTER TO SUBSTR(code, 5, 2)=hospprov
 DEFINE POPUP hospname FROM 0, 0 TO 12, 50 PROMPT FIELDS code+' '+name SHADOW MARGIN SCROLL
 hosptemp = ''
 hdr = '���͡�ç��Һ�Ţͧ��ҹ �������١�â��ŧ'
 @ 1, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 @ 4, 15 GET hosptemp POPUP hospname
 KEYBOARD '{HOME}'
 READ
 hospcode = SUBSTR(hosptemp, 1, 12)
 hospname = PADR(SUBSTR(hosptemp, 14), 30, ' ')
 RELEASE hosptemp
 USE
 IF SUBSTR(hospcode, 1, 2)<>'11'
    hospmoph = 'N'
 ELSE
    hospmoph = 'Y'
 ENDIF
 hosplrp = '01'
 SAVE TO hosp ALL LIKE hosp*
 CLEAR
 DEFINE WINDOW msg FROM 4, 5 TO 15, 74 SHADOW TITLE ' WAIT '
 ACTIVATE WINDOW msg
 hdr1 = '���仹�� ������������ʢͧ þ.㹨ѧ��Ѵ�ͧ��ҹ'
 hdr2 = '������ʷ�ͧ������㹨ѧ��Ѵ ���������Ţͧ�к�'
 hdr3 = '��ҹ����ö��� ����������ʵ�ҧ����ա �����͡'
 hdr4 = '��¡�ú��ا�ѡ���к� �ҡ��¡����ѡ'
 hdr5 = '�ô���ѡ����'
 @ 1, (WCOLS()-LEN(hdr1))/2 SAY hdr1
 @ 2, (WCOLS()-LEN(hdr2))/2 SAY hdr2
 @ 4, (WCOLS()-LEN(hdr3))/2 SAY hdr3
 @ 5, (WCOLS()-LEN(hdr4))/2 SAY hdr4
 @ 7, (WCOLS()-LEN(hdr5))/2 SAY hdr5 COLOR G+/B
 SET EXCLUSIVE ON
 USE lib\codefile ORDER varname
 IF SEEK('CARE')
    DELETE ALL FOR varname='CARE'
 ENDIF
 IF SEEK('ADDR')
    DELETE ALL FOR varname='ADDR'
 ENDIF
 SET ORDER TO code
 APPEND FROM lib\hospcode FOR SUBSTR(code, 5, 2)=hospprov
 REPLACE varname WITH 'CARE' ALL FOR EMPTY(varname)
 APPEND FROM lib\distcode FOR SUBSTR(code, 1, 2)=hospprov
 REPLACE varname WITH 'ADDR' ALL FOR EMPTY(varname)
 PACK
 USE
 RELEASE WINDOW msg
 RELEASE ALL LIKE hdr*
 RESTORE FROM hosp
 ans = 'Y'
 DEFINE WINDOW info FROM 7, 10 TO 17, 70 SHADOW
 hdr = '�ô��͡�����Ţͧ�ç��Һ�Ţͧ��ҹ'
 @ 2, (79-LEN(hdr))/2 SAY hdr COLOR GR+/B
 ACTIVATE WINDOW info
 DO WHILE .T.
    @ 0, 1 SAY '�����ç��Һ��'
    @ 0, 20 GET hospname
    @ 1, 1 SAY '�������'
    @ 1, 20 GET hospadd1
    @ 2, 20 GET hospadd2
    @ 3, 1 SAY '���ʨѧ��Ѵ'
    @ 3, 20 GET hospprov
    @ 4, 1 SAY '���Ѿ��'
    @ 4, 20 GET hospphon PICTURE '(999)-9999999'
    @ 5, 1 SAY '�����'
    @ 5, 20 GET hospfax PICTURE '(999)-9999999'
    READ
    @ 7, 1 SAY '�����Ŷ١��ͧ Y/N'
    @ 7, 20 GET ans VALID ans$'YNyn'
    READ
    IF ans$'Yy'
       EXIT
    ELSE
       @ 7, 1 CLEAR TO 7, 30
    ENDIF
 ENDDO
 SET SAFETY OFF
 SAVE TO hosp ALL LIKE hosp*
 RELEASE WINDOW info
 CLEAR
 DO wardedit
 DO dredit
 DO facedit
 DO summary
 SET EXCLUSIVE OFF
 WAIT WINDOW TIMEOUT 2 'Completed!'
 RETURN
*
