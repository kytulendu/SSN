 CLEAR
 SET TALK OFF
 SET ECHO OFF
 SET DATE british
 SET COLOR OF MESSAGE TO N/W
 SET EXCLUSIVE OFF
 SET SAFETY OFF
 SET DELETED ON
 SET PATH TO data\; lib\; rp\
 SET ESCAPE OFF
 = INSMODE(.F.)
 CLOSE DATABASES
 PUBLIC errfile
 errfile = SYS(2003)+'\data\errlog'
 ON ERROR do errlog with program(), lineno(), message(1), error(), message()
 currsc = SYS(5)+SYS(2003)+'\FOXUSER.DBF'
 SET RESOURCE TO (currsc)
 SET FUNCTION 2 TO ''
 SET FUNCTION 3 TO ''
 SET FUNCTION 4 TO ''
 SET FUNCTION 5 TO ''
 SET FUNCTION 6 TO ''
 SET FUNCTION 7 TO ''
 SET FUNCTION 8 TO ''
 SET FUNCTION 9 TO ''
 SET FUNCTION 10 TO ''
 SET FUNCTION 11 TO ''
 SET FUNCTION 12 TO 'cancel;'
 IF  .NOT. FILE('HOSP.MEM')
    DO setup
 ENDIF
 RESTORE FROM hosp
 vidtype = VAL(SUBSTR(hosppref, 1, 1))
 viddrv = VAL(SUBSTR(hosppref, 2, 1))
 PUBLIC errfile
 errfile = SYS(2003)+'\data\errlog'
 DIMENSION cset( 2)
 cset( 1) = 'monochrome'
 cset( 2) = 'color'
 DIMENSION mborder( 7)
 mborder( 1) = '--������        '
 mborder( 2) = '��������'
 mborder( 3) = '........        '
 mborder( 4) = '��������        '
 mborder( 5) = '........        '
 mborder( 6) = '........        '
 mborder( 7) = '********        '
 SET COLOR SET TO (cset(vidtype))
 SET COLOR TO W+/B
 DEFINE WINDOW ss2 FROM 5, 5 TO 18, 74 SHADOW COLOR W+/BG
 hdr1 = 'SSN -- Social Security Data Entry  Version 2.41'
 hdr2 = '����� �ѹ�֡�����ż���Ѻ��ԡ�û�Сѹ�ѧ��'
 hdr3 = '�ӹѡ�ҹ��Сѹ�ѧ��'
 hdr4 = '�ѹ��¹ 2541'
 ACTIVATE WINDOW ss2
 @ 2, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR W+/BG
 @ 4, (WCOLS()-LEN(hdr2))/2+5 SAY hdr2 COLOR GR+/BG
 @ 7, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR G+/BG
 @ 9, (WCOLS()-LEN(hdr4))/2 SAY hdr4 COLOR W+/BG
 WAIT WINDOW TIMEOUT 3 ''
 RELEASE WINDOW ss2
 CLEAR
 SET MESSAGE TO 24 CENTER
 SET COLOR TO BG+/B
 DEFINE WINDOW title FROM 0, 5 TO 3, 75 SHADOW DOUBLE COLOR W+/BG
 hdr1 = 'SSN : Social Security Data Entry Program'
 hdr2 = '     �к��ѹ�֡������ ����Ѻ��ԡ�� ��Сѹ�ѧ��'
 ACTIVATE WINDOW title
 @ 0, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR GR+/BG
 @ 1, (WCOLS()-LEN(hdr2))/2 SAY hdr2 COLOR W+/BG
 DEFINE WINDOW main FROM 5, 5 TO 12, 24 SHADOW TITLE '  ��¡����ѡ '
 DIMENSION mmain( 5)
 mmain( 1) = '  �����¹͡      '
 mmain( 2) = '  �������       '
 mmain( 3) = '  ��§ҹ          '
 mmain( 4) = '  ���ا�ѡ���к�  '
 mmain( 5) = '  ��ԡ�ҹ         '
 DIMENSION mmsg( 5)
 mmsg( 1) = '�ѹ�֡ ��� �����ż����¹͡'
 mmsg( 2) = '�ѹ�֡ ��� �����ż������'
 mmsg( 3) = '�����ż��������§ҹ'
 mmsg( 4) = '���ʵ�ҧ� ���ҧ�Ѫ�� ���ͧ������'
 mmsg( 5) = '��ԡ��÷ӧҹ'
 DEFINE WINDOW op FROM 7, 25 TO 14, 46 SHADOW TITLE '    �����¹͡ '
 DIMENSION op( 5)
 op( 1) = '  �ѹ�֡            '
 op( 2) = '  ���             '
 op( 3) = '  �ӹǹ����Сѹ��  '
 op( 4) = '  ˹�������͹���   '
 op( 5) = '  ��Ѻ��¡����ѡ    '
 DIMENSION omsg( 5)
 omsg( 1) = '�ѹ�֡��������ػ �������ԡ�ü����¹͡�������͹'
 omsg( 2) = '�ʹ�/��� �����ŷ���ѧ���������ż�'
 omsg( 3) = '�ѹ�֡�ӹǹ����Сѹ�� �Ѻþ.���������� ���ͨѴ����§ҹ'
 omsg( 4) = '�ѹ�֡�ӹǹ/ʶҹ����͡˹�������͹���'
 omsg( 5) = ' '
 DEFINE WINDOW ip FROM 8, 25 TO 13, 44 SHADOW TITLE '    ������� '
 DIMENSION ip( 3)
 ip( 1) = '  �ѹ�֡          '
 ip( 2) = '  ���           '
 ip( 3) = '  ��Ѻ��¡����ѡ  '
 DIMENSION imsg( 3)
 imsg( 1) = '�ѹ�֡������ �������ԡ�ü�����㹢ͧ������͹'
 imsg( 2) = '�ʹ�/��� �����ŷ���ѧ���������ż�'
 imsg( 3) = ''
 DEFINE WINDOW rp FROM 9, 25 TO 15, 47 SHADOW TITLE ' ��§ҹ '
 DIMENSION rp( 4)
 rp( 1) = '  �����ż�           '
 rp( 2) = '  ����§ҹ��ǹ��ҧ  '
 rp( 3) = '  ��§ҹ�ͧ þ.      '
 rp( 4) = '  ��Ѻ��¡����ѡ     '
 DIMENSION rpmsg( 4)
 rpmsg( 1) = '�����żŢ����ŷ���͡����� �������������§ҹ ����ö�����ҡ���� 1 ���駵����͹'
 rpmsg( 2) = '�Ѵ�������������������§ҹ �ӹѡ�ҹ��Сѹ�ѧ�� ��÷���͹�Ф���'
 rpmsg( 3) = '�Ѵ����§ҹ����������èѴ������ǹ�ͧ�ç��Һ��'
 rpmsg( 4) = ' '
 DEFINE WINDOW mt FROM 10, 25 TO 22, 48 SHADOW TITLE '  ���ا�ѡ���к� '
 DIMENSION mt( 10)
 mt( 1) = '  �������ç��Һ��     '
 mt( 2) = '  ���� þ.����͢��� '
 mt( 3) = '  ���ʷ�ͧ���         '
 mt( 4) = '  ����ᾷ��           '
 mt( 5) = '  �����ͼ�����       '
 mt( 6) = '  �����ç�ҹ          '
 mt( 7) = '  Help on ICD codes   '
 mt( 8) = '  ���ҧ�Ѫ��          '
 mt( 9) = '  ���ͧ������         '
 mt( 10) = '  ��Ѻ��¡����ѡ      '
 DEFINE WINDOW icd FROM 18, 50 TO 22, 74 SHADOW TITLE 'CODES'
 DIMENSION icdcode( 3)
 icdcode( 1) = '    Chapter Search     '
 icdcode( 2) = '  Keyword/Code search  '
 icdcode( 3) = '     ��Ѻ��¡����ѡ    '
 DEFINE WINDOW rsc FROM 11, 25 TO 16, 44 SHADOW TITLE ' 11 ç.5 '
 DIMENSION rsc( 3)
 rsc( 1) = '  �ѹ�֡          '
 rsc( 2) = '  ���           '
 rsc( 3) = '  ��Ѻ��¡����ѡ  '
 DEFINE WINDOW hosp FROM 13, 52 TO 17, 70 SHADOW TITLE ' ���� þ. '
 DIMENSION hosp( 2)
 hosp( 1) = '  �����������  '
 hosp( 2) = '  �������      '
 DEFINE WINDOW area FROM 14, 52 TO 18, 74 SHADOW TITLE '   ���ʷ�ͧ��� '
 DIMENSION area( 2)
 area( 1) = '  �����������      '
 area( 2) = '  �������          '
 DEFINE WINDOW data FROM 19, 49 TO 22, 76 SHADOW
 DIMENSION data( 2)
 data( 1) = '  ���ͧ������             '
 data( 2) = '  ����Ң����ŷ�����ͧ��� '
 main = 1
 DO WHILE .T.
    HIDE WINDOW ALL
    ACTIVATE SCREEN
    CLEAR
    ACTIVATE WINDOW title
    ACTIVATE WINDOW main
    FOR n = 1 TO ALEN(mmain)
       @ n, 0 PROMPT mmain(n) MESSAGE (mmsg(n))
    ENDFOR
    MENU TO main
    DO CASE
       CASE main=1
          ACTIVATE WINDOW op
          opjob = 1
          FOR n = 1 TO ALEN(op)
             @ n, 0 PROMPT op(n) MESSAGE (omsg(n))
          ENDFOR
          MENU TO opjob
          DO CASE
             CASE opjob=1
                DO opadd2
             CASE opjob=2
                DO opedit
             CASE opjob=3
                DO insure
             CASE opjob=4
                DO mobile
             CASE opjob=5
                LOOP
          ENDCASE
          HIDE WINDOW op
       CASE main=2
          ACTIVATE WINDOW ip
          ipjob = 1
          FOR n = 1 TO ALEN(ip)
             @ n, 0 PROMPT ip(n) MESSAGE (imsg(n))
          ENDFOR
          MENU TO ipjob
          DO CASE
             CASE ipjob=1
                DO ipadd
             CASE ipjob=2
                DO ipedit
             CASE ipjob=3
                CLOSE DATABASES
                CLOSE INDEX
                LOOP
          ENDCASE
          HIDE WINDOW ip
       CASE main=3
          ACTIVATE WINDOW rp
          rpjob = 1
          FOR n = 1 TO ALEN(rp)
             @ n, 0 PROMPT rp(n) MESSAGE rpmsg(n)
          ENDFOR
          MENU TO rpjob
          DO CASE
             CASE rpjob=1
                DO rpprep
             CASE rpjob=2
                DO rpfiles
             CASE rpjob=3
                DO ptrp
             CASE rpjob=4
                LOOP
          ENDCASE
          HIDE WINDOW rp
       CASE main=4
          ACTIVATE WINDOW mt
          mtjob = 1
          FOR n = 1 TO ALEN(mt)
             @ n, 0 PROMPT mt(n)
          ENDFOR
          MENU TO mtjob
          DO CASE
             CASE mtjob=1
                DO hosp
             CASE mtjob=2
                ACTIVATE WINDOW hosp
                hospjob = 1
                FOR n = 1 TO ALEN(hosp)
                   @ n, 0 PROMPT hosp(n)
                ENDFOR
                MENU TO hospjob
                DO CASE
                   CASE hospjob=1
                      DO hospcode
                   CASE hospjob=2
                      DO hospedit
                ENDCASE
                HIDE WINDOW hosp
             CASE mtjob=3
                ACTIVATE WINDOW area
                areajob = 1
                FOR n = 1 TO ALEN(area)
                   @ n, 0 PROMPT area(n)
                ENDFOR
                MENU TO areajob
                DO CASE
                   CASE areajob=1
                      DO distcode
                   CASE areajob=2
                      DO distedit
                ENDCASE
                HIDE WINDOW area
             CASE mtjob=4
                DO dredit
             CASE mtjob=5
                DO wardedit
             CASE mtjob=6
                DO facedit
             CASE mtjob=7
                ACTIVATE WINDOW icd
                icdjob = 1
                FOR n = 1 TO ALEN(icdcode)
                   @ n-1, 0 PROMPT icdcode(n)
                ENDFOR
                MENU TO icdjob
                DO CASE
                   CASE icdjob=1
                      DO icdsrch
                   CASE icdjob=2
                      DO newicd
                ENDCASE
                HIDE WINDOW area
             CASE mtjob=8
                DO rendx
             CASE mtjob=9
                ACTIVATE WINDOW data
                FOR n = 1 TO ALEN(data)
                   @ n-1, 0 PROMPT data(n)
                ENDFOR
                MENU TO djob
                DO CASE
                   CASE djob=1
                      DO backup
                   CASE djob=2
                      DO restore
                ENDCASE
                HIDE WINDOW data
             CASE mtjob=10
                LOOP
          ENDCASE
          HIDE WINDOW mt
       CASE main=5
          EXIT
    ENDCASE
 ENDDO
 RELEASE WINDOW area
 RELEASE WINDOW hosp
 RELEASE WINDOW rsc
 RELEASE WINDOW rp
 RELEASE WINDOW mt
 RELEASE WINDOW ip
 RELEASE WINDOW op
 RELEASE WINDOW main
 RELEASE WINDOW title
 RELEASE ALL
 CLOSE ALL
 CLEAR ALL
 ON ERROR
 SET EXCLUSIVE ON
 DEFINE WINDOW pro FROM 1, 0 TO 23, 79
 ACTIVATE WINDOW pro
 SET COLOR TO GR+/B
 @ 0, 30 SAY '������������ǹ˹�觢ͧ'
 @ 1, 15 SAY '�ç��þѲ���к���§ҹ��û���-��� ��з�ǧ�Ҹ�ó�آ'
 @ 2, 16 SAY '�����Ѻ��þѲ���к������Ţ�����������ͧ�Ѻ�ú.��Сѹ�ѧ�� '
 @ 3, 37 SAY '����֡��' COLOR R+/B
 SET COLOR TO W+/B
 @ 4, 10 SAY ': �.�.���ѡ��� �س�������          ����ӹ�¡�áͧʶԵ��Ҹ�ó�آ'
 @ 5, 10 SAY ': �.�.�تҵ� �óʶҾ�             ���ᾷ���ʵ�� �.�.���ҸԺ��'
 @ 6, 10 SAY ': �.�.�Ծظ �����ԭ              ���ᾷ���Ҹ�ó�آ�ѧ��Ѵ����'
 @ 7, 10 SAY ': �.�.�ç�� ��ԵԻ�д�ɰ�                   �ͧʶԵ��Ҹ�ó�آ'
 @ 8, 10 SAY ': �.�.��д�ɰ� ǧ�줳��ѵ����            �ͧ�ç��Һ�������Ҥ'
 @ 9, 10 SAY ': �.�.���è�� �����ԭ�ʶ���            �ͧἹ�ҹ�Ҹ�ó�آ'
 @ 10, 10 SAY ': �.�.��� ���ä�ѭ������                     �ͧ�кҴ�Է��'
 SET COLOR TO GR+/B
 @ 12, 28 SAY '������������к���оѲ�������'
 SET COLOR TO G+/B
 @ 13, 10 SAY ': �.�.͹��Ѳ�� ����صԡ��                 �ç��Һ���شøҹ�'
 @ 14, 10 SAY ': �.�.���� ʡ�žҹԪ                   �ç��Һ�ž�оط��ҷ'
 @ 15, 10 SAY ': �.�.�ط����� ����ǧ                       �ç��Һ���ʹ�'
 @ 16, 10 SAY ': �.�.��ԭ �����ѵ�Ҥ�                  �ç��Һ�šش���ǻ��'
 @ 17, 10 SAY ': �.�.���� �ѭ��ǹԪ���                �ç��Һ�Ŵ������'
 @ 18, 10 SAY ': ��� ���� �ʧ�ѹ��                       �ç��Һ���شøҹ�'
 SET COLOR TO R+/B
 hdr = 'VERSION 2.41   �ѹ��¹  2541'
 @ 20, (WCOLS()-LEN(hdr))/2 SAY hdr
 WAIT WINDOW TIMEOUT 10 ''
 RELEASE WINDOW pro
 CLOSE DATABASES
 = INSMODE(.T.)
 CLEAR
*