 SET ESCAPE OFF
 msg2 = '���鹾���� ���ͷӧҹ���'
 DEFINE WINDOW instr FROM 1, 0 TO 11, 78 SHADOW TITLE '   �Ը��� '
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   ���������ҧ���������������' COLOR GR+/B
 @ 1, 5 SAY '����������ç�ҹ 16 ��ѡ㹪�ͧ CODE ���Ǿ��������ç�ҹ㹪�ͧ NAME'
 @ 2, 5 SAY '�� �ҧ�͡�Ѻ����ӡѴ,����ѷ'
 @ 3, 1 SAY 'Ctrl+T   ź���ʷ������ͧ�����' COLOR GR+/B
 @ 4, 5 SAY '��ѧ�ҡ��� ��������ͧ����  ��鹢�ҧ˹�� �ʴ�������������'
 @ 5, 1 SAY '��ҵ�ͧ�������������ͪ����ç�ҹ' COLOR GR+/B
 @ 6, 5 SAY '��������� ���ͪ������� �Ѻ仺��ͧ����µç'
 @ 8, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
 WAIT WINDOW ''
 RELEASE WINDOW instr
 SET ESCAPE ON
 RETURN
*
