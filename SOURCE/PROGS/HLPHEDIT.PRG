 SET ESCAPE OFF
 msg2 = '���鹾���� ���ͷӧҹ���'
 DEFINE WINDOW instr FROM 1, 0 TO 10, 78 SHADOW TITLE '   �Ը��� '
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   ���������ҧ���������������' COLOR GR+/B
 @ 1, 5 SAY '���������þ. 7 ��ѡ㹪�ͧ CODE ���Ǿ��������ç��Һ��㹪�ͧ NAME'
 @ 2, 1 SAY 'Ctrl+T   ź���ʷ������ͧ�����' COLOR GR+/B
 @ 3, 5 SAY '��ѧ�ҡ��� ��������ͧ����  ��鹢�ҧ˹�� �ʴ�������������'
 @ 4, 1 SAY '��ҵ�ͧ�������������ͪ����ç��Һ��' COLOR GR+/B
 @ 5, 5 SAY '��������� ���ͪ������� �Ѻ仺��ͧ����µç'
 @ 7, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
 WAIT WINDOW ''
 RELEASE WINDOW instr
 SET ESCAPE ON
 RETURN
*
