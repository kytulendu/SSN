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
 DEFINE WINDOW instr FROM 19, 0 TO 24, 79 SHADOW TITLE '   วิธีใช้ ' FOOTER 'Esc = exit'
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   เพิ่มที่ว่างเพื่อใส่รหัสใหม่' COLOR GR+/B
 @ 1, 7 SAY 'พิมพ์รหัสท้องที่ในช่อง CODE แล้วพิมพ์ชื่อท้องที่ในช่อง NAME'
 @ 2, 1 SAY 'Ctrl+T   ลบรหัสที่ไม่ต้องการใช้' COLOR GR+/B
 @ 3, 7 SAY 'หลังจากนั้น จะมีเครื่องหมาย  ขึ้นข้างหน้า แสดงว่าไม่ใช้แล้ว'
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
