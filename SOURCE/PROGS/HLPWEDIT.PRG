 SET ESCAPE OFF
 msg1 = '���ʷ���й�'
 msg2 = '���鹾���� ���ͷӧҹ���'
 DEFINE WINDOW instr FROM 1, 0 TO 22, 78 SHADOW TITLE '   �Ը��� '
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   ���������ҧ���������������' COLOR GR+/B
 @ 1, 5 SAY '����������ͼ����� 3 ��ѡ㹪�ͧ CODE ���Ǿ������͵֡������㹪�ͧ NAME'
 @ 2, 1 SAY 'Ctrl+T   ź���ʷ������ͧ�����' COLOR GR+/B
 @ 3, 5 SAY '��ѧ�ҡ��� ��������ͧ����  ��鹢�ҧ˹�� �ʴ�������������'
 @ 4, 1 SAY '��ҵ�ͧ�������������ͪ��͵֡������' COLOR GR+/B
 @ 5, 5 SAY '��������� ���ͪ������� �Ѻ仺��ͧ����µç'
 @ 6, 1, 6, 75 BOX
 @ 7, (WCOLS()-LEN(msg1))/2 SAY msg1 COLOR G+/B
 @ 9, 13 SAY '��ѡ��� 1  Ἱ�' COLOR GR+/B
 @ 10, 5 SAY '1 ����á���'
 @ 11, 5 SAY '2 ���¡���'
 @ 12, 5 SAY '3 �ٵԡ���'
 @ 13, 5 SAY '4 ����Ǫ����'
 @ 14, 5 SAY '5 ������Ǫ����'
 @ 15, 5 SAY '6 �� �� ��١'
 @ 16, 5 SAY '7 �ѡ�ء���'
 @ 17, 5 SAY '8 ���¡������д١'
 @ 10, 29 SAY ' 9 �Ե�Ǫ'
 @ 11, 29 SAY '10 �ѧ���Է��'
 @ 12, 29 SAY '11 �ѹ�����'
 @ 13, 29 SAY '12 ����'
 @ 9, 50 SAY '��ѡ��� 2  ������' COLOR GR+/B
 @ 10, 54 SAY '1 ���'
 @ 11, 54 SAY '2 ˭ԧ'
 @ 12, 54 SAY '7 CCU'
 @ 13, 54 SAY '8 ICU'
 @ 14, 54 SAY '9 ��������'
 @ 15, 54 SAY '0 ʧ��'
 @ 17, 50 SAY '��ѡ��� 3  �ӴѺ���' COLOR GR+/B
 @ 18, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
 WAIT WINDOW ''
 RELEASE WINDOW instr
 SET ESCAPE ON
 RETURN
*
