 SET TALK OFF
 HIDE WINDOW ALL
 ACTIVATE SCREEN
 IF USED('codefile')
    SELECT codefile
    USE
    SET EXCLUSIVE ON
    USE lib\codefile ORDER code
 ELSE
    SET EXCLUSIVE ON
    SELECT 25
    USE lib\codefile ORDER code
 ENDIF
 DEFINE WINDOW instr FROM 19, 0 TO 24, 79 SHADOW TITLE '   �Ը��� ' FOOTER 'Esc = exit'
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   ���������ҧ���������������' COLOR GR+/B
 @ 1, 7 SAY '��������ʷ�ͧ���㹪�ͧ CODE ���Ǿ������ͷ�ͧ���㹪�ͧ NAME'
 @ 2, 1 SAY 'Ctrl+T   ź���ʷ������ͧ�����' COLOR GR+/B
 @ 3, 7 SAY '��ѧ�ҡ��� ��������ͧ����  ��鹢�ҧ˹�� �ʴ�������������'
 WAIT WINDOW TIMEOUT 1 ''
 ACTIVATE SCREEN
 DEFINE WINDOW browser FROM 1, 10 TO 16, 70 SHADOW COLOR W+/B
 ACTIVATE WINDOW browser
 BROWSE FOR varname='ADDR' FIELDS code, name
 REPLACE varname WITH 'ADDR' ALL FOR EMPTY(varname)
 PACK
 USE
 SET EXCLUSIVE OFF
 RELEASE WINDOW instr
 RELEASE WINDOW browser
*
