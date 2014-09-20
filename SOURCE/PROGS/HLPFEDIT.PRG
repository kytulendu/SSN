 SET ESCAPE OFF
 msg2 = 'กดแป้นพิมพ์ เพื่อทำงานต่อ'
 DEFINE WINDOW instr FROM 1, 0 TO 11, 78 SHADOW TITLE '   วิธีใช้ '
 ACTIVATE WINDOW instr
 @ 0, 1 SAY 'Ctrl+N   เพิ่มที่ว่างเพื่อใส่รหัสใหม่' COLOR GR+/B
 @ 1, 5 SAY 'พิมพ์รหัสโรงงาน 16 หลักในช่อง CODE แล้วพิมพ์ชื่อโรงงานในช่อง NAME'
 @ 2, 5 SAY 'เช่น บางกอกรับเบอร์จำกัด,บริษัท'
 @ 3, 1 SAY 'Ctrl+T   ลบรหัสที่ไม่ต้องการใช้' COLOR GR+/B
 @ 4, 5 SAY 'หลังจากนั้น จะมีเครื่องหมาย  ขึ้นข้างหน้า แสดงว่าไม่ใช้แล้ว'
 @ 5, 1 SAY 'ถ้าต้องการแก้ไขรหัสหรือชื่อโรงงาน' COLOR GR+/B
 @ 6, 5 SAY 'พิมพ์รหัส หรือชื่อใหม่ ทับไปบนของเดิมโดยตรง'
 @ 8, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
 WAIT WINDOW ''
 RELEASE WINDOW instr
 SET ESCAPE ON
 RETURN
*
