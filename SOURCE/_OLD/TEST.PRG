 SET PROCEDURE TO G1
 m.date = '02\02\42'
 m.dscc = v_lyear(m.date)
 IF YEAR(m.dscc)>YEAR(DATE())
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 '�շ���͡�ҡ�ç��Һ������â�����'
    RETURN 0
 ELSE
    EXIT
 ENDIF
*