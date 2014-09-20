 ON KEY LABEL F1 do hlpwedit
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
 msg1 = 'เพิ่มเติม/แก้ไขรหัสหอผู้ป่วย'
 msg2 = 'F1 เพื่อดูคำอธิบาย   Esc = EXIT'
 @ 2, (79-LEN(msg1))/2 SAY msg1 COLOR G+/B
 @ 23, (79-LEN(msg2))/2 SAY msg2 COLOR G+/B
 DEFINE WINDOW browser FROM 5, 10 TO 20, 70 SHADOW COLOR W+/B
 ACTIVATE WINDOW browser
 BROWSE FOR varname='WARD' FIELDS code, name
 REPLACE varname WITH 'WARD' ALL FOR EMPTY(varname)
 PACK
 USE
 SET EXCLUSIVE OFF
 RELEASE WINDOW browser
 CLEAR
 ON KEY LABEL F1
*