 ON KEY LABEL f1 DO hlpwedit
 ACTIVATE SCREEN
 CLEAR
 IF USED('codefile')
    SELECT codefile
    USE
    SET EXCLUSIVE ON
    USE lib\codefile ORDER code
 ELSE
    SET EXCLUSIVE ON
    SELECT 0
    USE lib\codefile ORDER code
 ENDIF
 msg1 = '�������/��������ͼ�����'
 msg2 = 'F1 ���ʹ٤�͸Ժ��   Esc = EXIT'
 @ 2, (79-LEN(msg1))/2 SAY msg1 COLOR G+/B
 @ 23, (79-LEN(msg2))/2 SAY msg2 COLOR G+/B
 DEFINE WINDOW browser FROM 5, 10 TO 20, 70 SHADOW COLOR W+/B
 ACTIVATE WINDOW browser
 DO WHILE .T.
    BROWSE FOR varname='WARD' FIELDS code, name
    REPLACE varname WITH 'WARD' ALL FOR EMPTY(varname)
    PACK
    SELECT 1
    GOTO TOP
    LOCATE FOR varname='WARD' .AND. LEN(ALLTRIM(code))>3
    IF FOUND()
       WAIT WINDOW '��سҺѹ�֡�������� �����ͼ��������������ѹ�֡���Թ 3 ���'
       LOOP
    ELSE
       EXIT
    ENDIF
 ENDDO
 USE
 SET EXCLUSIVE OFF
 RELEASE WINDOW browser
 CLEAR
 ON KEY LABEL f1
*
