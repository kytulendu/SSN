 HIDE WINDOW ALL
 ACTIVATE SCREEN
 CLEAR
 SET TALK OFF
 mprov = '  '
 DO WHILE .T.
    col = 0
    row = 0
    USE lib\provcode ORDER code
    GOTO TOP
    hdr = '���������ç��Һ�� ��ѧ�Ѵ�ӹѡ�ҹ��Ѵ��з�ǧ�Ҹ�ó�آ'
    @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
    DO WHILE  .NOT. EOF()
       DO WHILE  .NOT. EOF() .AND. col<62
          @ 4+row, 1+col SAY SUBSTR(code, 1, 2)+' '+SUBSTR(name, 1, 12)
          col = col+20
          SKIP
       ENDDO
       col = 0
       row = row+1
    ENDDO
    @ 1, 6, 3, 72 BOX
    @ 2, 07 SAY '��������ʨѧ��Ѵ(10-96). ������� = exit ' GET mprov
    READ
    IF mprov='  ' .OR. mprov<'10' .OR. mprov>'96'
       USE
       EXIT
    ENDIF
    USE
    @ 3, 7 SAY mprov
    SET TALK OFF
    WAIT WINDOW NOWAIT '�ô���ѡ����'
    USE lib\codefile
    LOCATE FOR SUBSTR(code, 5, 2)=mprov .AND. varname='CARE'
    IF FOUND()
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 2 '���ʹ����������к�����'
       mprov = '  '
       LOOP
    ENDIF
    APPEND FROM lib\hospcode.dbf FOR SUBSTR(code, 5, 2)=mprov
    REPLACE varname WITH 'CARE' ALL FOR EMPTY(varname)
    USE
    mprov = '  '
    WAIT WINDOW TIMEOUT 2 '�����������º��������'
 ENDDO
 CLEAR
*
