 SET ESCAPE OFF
 DEFINE WINDOW summary FROM 3, 5 TO 17, 75 SHADOW COLOR W+/G
 msg1 = '��ҹ��Դ��駢����ž�鹰ҹ�ͧ�к����º��������'
 msg2 = '�ҡ��ͧ������� ��������͡��¡�� ���ا�ѡ���к�'
 msg3 = '������͡������ʷ���ͧ���'
 msg4 = 'NOTES'
 msg5 = 'F1 = Help  �������ö�ʴ���'
 msg6 = 'Esc = exit'
 msg7 = '�ҡ�ջѭ�� �ô��ҹ�����͡���������'
 ACTIVATE WINDOW summary
 @ 1, (WCOLS()-LEN(msg1))/2 SAY msg1
 @ 2, (WCOLS()-LEN(msg2))/2 SAY msg2
 @ 3, (WCOLS()-LEN(msg3))/2 SAY msg3
 @ 4, 5, 11, (WCOLS()-5) BOX
 @ 5, (WCOLS()-LEN(msg4))/2 SAY msg4 COLOR GR+/G
 @ 7, (WCOLS()-LEN(msg5))/2 SAY msg5
 @ 8, (WCOLS()-LEN(msg6))/2 SAY msg6
 @ 10, (WCOLS()-LEN(msg7))/2 SAY msg7
 WAIT WINDOW
 RELEASE WINDOW summary
 SET ESCAPE ON
*
