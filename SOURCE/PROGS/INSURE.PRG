 SET TALK OFF
 SET DATE british
 HIDE WINDOW ALL
 RESTORE FROM hosp ADDITIVE
 DEFINE WINDOW insure FROM 5, 15 TO 15, 65 SHADOW
 ACTIVATE WINDOW insure
 hdr = '�ѹ�֡�ӹǹ����Сѹ��'
 @ 0, (WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
 number = 0
 hospmain = hospcode
 mm = SUBSTR(DTOC(DATE()), 4, 2)
 yy = STR(VAL(SUBSTR(DTOC(DATE()), 7, 2))+1900+543-2500, 2)
 yymm = yy+mm
 ans = 'Y'
 DO WHILE .T.
    @ 2, 2 SAY 'þ.����� Main contractor'
    @ 2, 30 SAY hospmain PICTURE '999999999999' COLOR GR+/B
    @ 3, 2 SAY '��͹/�.�.'
    @ 3, 30 GET mm PICTURE '99' VALID BETWEEN(VAL(mm), 1, 12) MESSAGE '��͹/�.�. ������Ѻ��§ҹ�ʹ �ҡ�ӹѡ�ҹ��Сѹ�ѧ��'
    @ 3, 32 SAY '/'
    @ 3, 33 GET yy PICTURE '99' MESSAGE '��͹/�.�. ������Ѻ��§ҹ�ʹ �ҡ�ӹѡ�ҹ��Сѹ�ѧ��'
    @ 4, 2 SAY '�ӹǹ����Сѹ��'
    @ 4, 30 GET number PICTURE '9999999' VALID number>0
    @ 6, 12 SAY '�����Ŷ١��ͧ����'
    @ 6, 30 GET ans VALID ans$'YyNn' MESSAGE ' '
    READ
    IF READKEY()=12 .OR. READKEY()=268
       CLEAR
       RELEASE WINDOW insure
       RETURN TO main
    ENDIF
    IF ans$'Yy'
       yymm = yy+mm
       INSERT INTO data\insurer.dbf FROM MEMVAR
       EXIT
    ENDIF
 ENDDO
 CLEAR
 RELEASE WINDOW insure
 RETURN
*
