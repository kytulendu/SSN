 CLEAR
 SET TALK OFF
 SET ECHO OFF
 SET DATE british
 SET COLOR OF MESSAGE TO N/W
 SET EXCLUSIVE OFF
 SET SAFETY OFF
 SET DELETED ON
 SET PATH TO data\; lib\; rp\
 SET ESCAPE OFF
 = INSMODE(.F.)
 CLOSE DATABASES
 PUBLIC errfile
 errfile = SYS(2003)+'\data\errlog'
 ON ERROR do errlog with program(), lineno(), message(1), error(), message()
 currsc = SYS(5)+SYS(2003)+'\FOXUSER.DBF'
 SET RESOURCE TO (currsc)
 SET FUNCTION 2 TO ''
 SET FUNCTION 3 TO ''
 SET FUNCTION 4 TO ''
 SET FUNCTION 5 TO ''
 SET FUNCTION 6 TO ''
 SET FUNCTION 7 TO ''
 SET FUNCTION 8 TO ''
 SET FUNCTION 9 TO ''
 SET FUNCTION 10 TO ''
 SET FUNCTION 11 TO ''
 SET FUNCTION 12 TO 'cancel;'
 IF  .NOT. FILE('HOSP.MEM')
    DO setup
 ENDIF
 RESTORE FROM hosp
 vidtype = VAL(SUBSTR(hosppref, 1, 1))
 viddrv = VAL(SUBSTR(hosppref, 2, 1))
 PUBLIC errfile
 errfile = SYS(2003)+'\data\errlog'
 DIMENSION cset( 2)
 cset( 1) = 'monochrome'
 cset( 2) = 'color'
 DIMENSION mborder( 7)
 mborder( 1) = '--•—        '
 mborder( 2) = '––••'
 mborder( 3) = '........        '
 mborder( 4) = '……€        '
 mborder( 5) = '........        '
 mborder( 6) = '........        '
 mborder( 7) = '********        '
 SET COLOR SET TO (cset(vidtype))
 SET COLOR TO W+/B
 DEFINE WINDOW ss2 FROM 5, 5 TO 18, 74 SHADOW COLOR W+/BG
 hdr1 = 'SSN -- Social Security Data Entry  Version 2.40'
 hdr2 = 'โปรแกรม บันทึกข้อมูลผู้รับบริการประกันสังคม'
 hdr3 = 'สำนักงานประกันสังคม'
 hdr4 = 'ธันวาคม 2540'
 ACTIVATE WINDOW ss2
 @ 2, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR W+/BG
 @ 4, (WCOLS()-LEN(hdr2))/2+5 SAY hdr2 COLOR GR+/BG
 @ 7, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR G+/BG
 @ 9, (WCOLS()-LEN(hdr4))/2 SAY hdr4 COLOR W+/BG
 WAIT WINDOW TIMEOUT 3 ''
 RELEASE WINDOW ss2
 CLEAR
 SET MESSAGE TO 24 CENTER
 SET COLOR TO BG+/B
 DEFINE WINDOW title FROM 0, 5 TO 3, 75 SHADOW DOUBLE COLOR W+/BG
 hdr1 = 'SSN : Social Security Data Entry Program'
 hdr2 = '     ระบบบันทึกข้อมูล ผู้รับบริการ ประกันสังคม'
 ACTIVATE WINDOW title
 @ 0, (WCOLS()-LEN(hdr1))/2 SAY hdr1 COLOR GR+/BG
 @ 1, (WCOLS()-LEN(hdr2))/2 SAY hdr2 COLOR W+/BG
 DEFINE WINDOW main FROM 5, 5 TO 12, 24 SHADOW TITLE '  รายการหลัก '
 DIMENSION mmain( 5)
 mmain( 1) = '  ผู้ป่วยนอก      '
 mmain( 2) = '  ผู้ป่วยใน       '
 mmain( 3) = '  รายงาน          '
 mmain( 4) = '  บำรุงรักษาระบบ  '
 mmain( 5) = '  เลิกงาน         '
 DIMENSION mmsg( 5)
 mmsg( 1) = 'บันทึก แก้ไข ข้อมูลผู้ป่วยนอก'
 mmsg( 2) = 'บันทึก แก้ไข ข้อมูลผู้ป่วยใน'
 mmsg( 3) = 'ประมวลผลและส่งรายงาน'
 mmsg( 4) = 'รหัสต่างๆ สร้างดัชนี สำรองข้อมูล'
 mmsg( 5) = 'เลิกการทำงาน'
 DEFINE WINDOW op FROM 7, 25 TO 14, 46 SHADOW TITLE '    ผู้ป่วยนอก '
 DIMENSION op( 5)
 op( 1) = '  บันทึก            '
 op( 2) = '  แก้ไข             '
 op( 3) = '  จำนวนผู้ประกันตน  '
 op( 4) = '  หน่วยเคลื่อนที่   '
 op( 5) = '  กลับรายการหลัก    '
 DIMENSION omsg( 5)
 omsg( 1) = 'บันทึกข้อมูลสรุป การให้บริการผู้ป่วยนอกในแต่ละเดือน'
 omsg( 2) = 'ขอดู/แก้ไข ข้อมูลที่ยังไม่ได้ประมวลผล'
 omsg( 3) = 'บันทึกจำนวนผู้ประกันตน กับรพ.ที่ใช้โปรแกรม เพื่อจัดทำรายงาน'
 omsg( 4) = 'บันทึกจำนวน/สถานที่ออกหน่วยเคลื่อนที่'
 omsg( 5) = ' '
 DEFINE WINDOW ip FROM 8, 25 TO 13, 44 SHADOW TITLE '    ผู้ป่วยใน '
 DIMENSION ip( 3)
 ip( 1) = '  บันทึก          '
 ip( 2) = '  แก้ไข           '
 ip( 3) = '  กลับรายการหลัก  '
 DIMENSION imsg( 3)
 imsg( 1) = 'บันทึกข้อมูล การให้บริการผู้ป่วยในของแต่ละเดือน'
 imsg( 2) = 'ขอดู/แก้ไข ข้อมูลที่ยังไม่ได้ประมวลผล'
 imsg( 3) = ''
 DEFINE WINDOW rp FROM 9, 25 TO 15, 47 SHADOW TITLE ' รายงาน '
 DIMENSION rp( 4)
 rp( 1) = '  ประมวลผล           '
 rp( 2) = '  ส่งรายงานส่วนกลาง  '
 rp( 3) = '  รายงานของ รพ.      '
 rp( 4) = '  กลับรายการหลัก     '
 DIMENSION rpmsg( 4)
 rpmsg( 1) = 'ประมวลผลข้อมูลที่กรอกไปแล้ว เพื่อเตรียมทำรายงาน สามารถทำได้มากกว่า 1 ครั้งต่อเดือน'
 rpmsg( 2) = 'จัดทำแฟ้มข้อมูลเพื่อส่งรายงาน สำนักงานประกันสังคม ควรทำเดือนละครั้ง'
 rpmsg( 3) = 'จัดทำรายงานเพื่อใช้บริหารจัดการในส่วนของโรงพยาบาล'
 rpmsg( 4) = ' '
 DEFINE WINDOW mt FROM 10, 25 TO 22, 48 SHADOW TITLE '  บำรุงรักษาระบบ '
 DIMENSION mt( 10)
 mt( 1) = '  ข้อมูลโรงพยาบาล     '
 mt( 2) = '  รหัส รพ.ในเครือข่าย '
 mt( 3) = '  รหัสท้องที่         '
 mt( 4) = '  รหัสแพทย์           '
 mt( 5) = '  รหัสหอผู้ป่วย       '
 mt( 6) = '  รหัสโรงงาน          '
 mt( 7) = '  Help on ICD codes   '
 mt( 8) = '  สร้างดัชนี          '
 mt( 9) = '  สำรองข้อมูล         '
 mt( 10) = '  กลับรายการหลัก      '
 DEFINE WINDOW icd FROM 18, 50 TO 22, 74 SHADOW TITLE 'CODES'
 DIMENSION icdcode( 3)
 icdcode( 1) = '    Chapter Search     '
 icdcode( 2) = '  Keyword/Code search  '
 icdcode( 3) = '     กลับรายการหลัก    '
 DEFINE WINDOW rsc FROM 11, 25 TO 16, 44 SHADOW TITLE ' 11 รง.5 '
 DIMENSION rsc( 3)
 rsc( 1) = '  บันทึก          '
 rsc( 2) = '  แก้ไข           '
 rsc( 3) = '  กลับรายการหลัก  '
 DEFINE WINDOW hosp FROM 13, 52 TO 17, 70 SHADOW TITLE ' รหัส รพ. '
 DIMENSION hosp( 2)
 hosp( 1) = '  เพิ่มเติมรหัส  '
 hosp( 2) = '  แก้ไขรหัส      '
 DEFINE WINDOW area FROM 14, 52 TO 18, 74 SHADOW TITLE '   รหัสท้องที่ '
 DIMENSION area( 2)
 area( 1) = '  เพิ่มเติมรหัส      '
 area( 2) = '  แก้ไขรหัส          '
 DEFINE WINDOW data FROM 19, 49 TO 22, 76 SHADOW
 DIMENSION data( 2)
 data( 1) = '  สำรองข้อมูล             '
 data( 2) = '  นำเข้าข้อมูลที่สำรองไว้ '
 main = 1
 DO WHILE .T.
    HIDE WINDOW ALL
    ACTIVATE SCREEN
    CLEAR
    ACTIVATE WINDOW title
    ACTIVATE WINDOW main
    FOR n = 1 TO ALEN(mmain)
       @ n, 0 PROMPT mmain(n) MESSAGE (mmsg(n))
    ENDFOR
    MENU TO main
    DO CASE
       CASE main=1
          ACTIVATE WINDOW op
          opjob = 1
          FOR n = 1 TO ALEN(op)
             @ n, 0 PROMPT op(n) MESSAGE (omsg(n))
          ENDFOR
          MENU TO opjob
          DO CASE
             CASE opjob=1
                DO opadd2
             CASE opjob=2
                DO opedit
             CASE opjob=3
                DO insure
             CASE opjob=4
                DO mobile
             CASE opjob=5
                LOOP
          ENDCASE
          HIDE WINDOW op
       CASE main=2
          ACTIVATE WINDOW ip
          ipjob = 1
          FOR n = 1 TO ALEN(ip)
             @ n, 0 PROMPT ip(n) MESSAGE (imsg(n))
          ENDFOR
          MENU TO ipjob
          DO CASE
             CASE ipjob=1
                DO ipadd
             CASE ipjob=2
                DO ipedit
             CASE ipjob=3
                CLOSE DATABASES
                CLOSE INDEX
                LOOP
          ENDCASE
          HIDE WINDOW ip
       CASE main=3
          ACTIVATE WINDOW rp
          rpjob = 1
          FOR n = 1 TO ALEN(rp)
             @ n, 0 PROMPT rp(n) MESSAGE rpmsg(n)
          ENDFOR
          MENU TO rpjob
          DO CASE
             CASE rpjob=1
                DO rpprep
             CASE rpjob=2
                DO rpfiles
             CASE rpjob=3
                DO ptrp
             CASE rpjob=4
                LOOP
          ENDCASE
          HIDE WINDOW rp
       CASE main=4
          ACTIVATE WINDOW mt
          mtjob = 1
          FOR n = 1 TO ALEN(mt)
             @ n, 0 PROMPT mt(n)
          ENDFOR
          MENU TO mtjob
          DO CASE
             CASE mtjob=1
                DO hosp
             CASE mtjob=2
                ACTIVATE WINDOW hosp
                hospjob = 1
                FOR n = 1 TO ALEN(hosp)
                   @ n, 0 PROMPT hosp(n)
                ENDFOR
                MENU TO hospjob
                DO CASE
                   CASE hospjob=1
                      DO hospcode
                   CASE hospjob=2
                      DO hospedit
                ENDCASE
                HIDE WINDOW hosp
             CASE mtjob=3
                ACTIVATE WINDOW area
                areajob = 1
                FOR n = 1 TO ALEN(area)
                   @ n, 0 PROMPT area(n)
                ENDFOR
                MENU TO areajob
                DO CASE
                   CASE areajob=1
                      DO distcode
                   CASE areajob=2
                      DO distedit
                ENDCASE
                HIDE WINDOW area
             CASE mtjob=4
                DO dredit
             CASE mtjob=5
                DO wardedit
             CASE mtjob=6
                DO facedit
             CASE mtjob=7
                ACTIVATE WINDOW icd
                icdjob = 1
                FOR n = 1 TO ALEN(icdcode)
                   @ n-1, 0 PROMPT icdcode(n)
                ENDFOR
                MENU TO icdjob
                DO CASE
                   CASE icdjob=1
                      DO icdsrch
                   CASE icdjob=2
                      DO newicd
                ENDCASE
                HIDE WINDOW area
             CASE mtjob=8
                DO rendx
             CASE mtjob=9
                ACTIVATE WINDOW data
                FOR n = 1 TO ALEN(data)
                   @ n-1, 0 PROMPT data(n)
                ENDFOR
                MENU TO djob
                DO CASE
                   CASE djob=1
                      DO backup
                   CASE djob=2
                      DO restore
                ENDCASE
                HIDE WINDOW data
             CASE mtjob=10
                LOOP
          ENDCASE
          HIDE WINDOW mt
       CASE main=5
          EXIT
    ENDCASE
 ENDDO
 RELEASE WINDOW area
 RELEASE WINDOW hosp
 RELEASE WINDOW rsc
 RELEASE WINDOW rp
 RELEASE WINDOW mt
 RELEASE WINDOW ip
 RELEASE WINDOW op
 RELEASE WINDOW main
 RELEASE WINDOW title
 RELEASE ALL
 CLOSE ALL
 CLEAR ALL
 ON ERROR
 SET EXCLUSIVE ON
 DEFINE WINDOW pro FROM 1, 0 TO 23, 79
 ACTIVATE WINDOW pro
 SET COLOR TO GR+/B
 @ 0, 30 SAY 'โปรแกรมนี้เป็นส่วนหนึ่งของ'
 @ 1, 15 SAY 'โครงการพัฒนาระบบรายงานการป่วย-ตาย กระทรวงสาธารณสุข'
 @ 2, 16 SAY 'ร่วมกับการพัฒนาระบบข้อมูลข่าวสารเพื่อรองรับพรบ.ประกันสังคม '
 @ 3, 37 SAY 'ที่ปรึกษา' COLOR R+/B
 SET COLOR TO W+/B
 @ 4, 10 SAY ': น.พ.สมศักดิ์ ชุณหรัศมิ์          ผู้อำนวยการกองสถิติสาธารณสุข'
 @ 5, 10 SAY ': น.พ.สุชาติ สรณสถาพร             คณะแพทยศาสตร์ ร.พ.รามาธิบดี'
 @ 6, 10 SAY ': น.พ.วิพุธ พูลเจริญ              นายแพทย์สาธารณสุขจังหวัดภูเก็ต'
 @ 7, 10 SAY ': น.พ.ณรงค์ กษิติประดิษฐ์                   กองสถิติสาธารณสุข'
 @ 8, 10 SAY ': น.พ.ประดิษฐ์ วงษ์คณารัตนกูล            กองโรงพยาบาลภูมิภาค'
 @ 9, 10 SAY ': น.พ.วิโรจน์ ตั้งเจริญเสถียร            กองแผนงานสาธารณสุข'
 @ 10, 10 SAY ': น.พ.ปฐม สวรรค์ปัญญาเลิศ                     กองระบาดวิทยา'
 SET COLOR TO GR+/B
 @ 12, 28 SAY 'ผู้วิเคราะห์ระบบและพัฒนาโปรแกรม'
 SET COLOR TO G+/B
 @ 13, 10 SAY ': น.พ.อนุวัฒน์ ศุภชุติกุล                 โรงพยาบาลอุดรธานี'
 @ 14, 10 SAY ': น.พ.ถาวร สกุลพานิช                   โรงพยาบาลพระพุทธบาท'
 @ 15, 10 SAY ': น.พ.ยุทธพงศ์ พตด้วง                       โรงพยาบาลเสนา'
 @ 16, 10 SAY ': น.พ.เจริญ เสรีรัตนาคร                  โรงพยาบาลกุดข้าวปุ้น'
 @ 17, 10 SAY ': น.พ.ไพศาล ธัญญะวนิชกุล                โรงพยาบาลดอยสะเก็ด'
 @ 18, 10 SAY ': นาย วารี แสงพันตา                       โรงพยาบาลอุดรธานี'
 SET COLOR TO R+/B
 hdr = 'VERSION 2.40k   ธันวาคม  2537'
 @ 20, (WCOLS()-LEN(hdr))/2 SAY hdr
 WAIT WINDOW TIMEOUT 10 ''
 RELEASE WINDOW pro
 CLOSE DATABASES
 = INSMODE(.T.)
 CLEAR
*