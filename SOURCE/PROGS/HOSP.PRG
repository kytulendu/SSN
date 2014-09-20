 HIDE WINDOW ALL
 ACTIVATE SCREEN
 CLEAR
 SET TALK OFF
 ON KEY LABEL f1 ?? CHR(7)
 IF FILE('HOSP.MEM')
    RESTORE FROM hosp.mem ADDITIVE
 ELSE
    hosppref = '17N'
    hospname = SPACE(30)
    hospadd1 = SPACE(30)
    hospadd2 = SPACE(30)
    hospprov = SPACE(2)
    hospcode = SPACE(12)
    hospphon = '(   )-       '
    hospfax = '(   )-       '
 ENDIF
 DEFINE WINDOW hospinfo FROM 5, 15 TO 14, 64 SHADOW TITLE '  ข้อมูลโรงพยาบาล '
 ACTIVATE WINDOW hospinfo
 @ 1, 2 SAY 'ชื่อโรงพยาบาล ' GET hospname
 @ 2, 2 SAY 'ที่อยู่       ' GET hospadd1
 @ 3, 2 SAY '              ' GET hospadd2
 @ 4, 2 SAY 'โทรศัพท์      ' GET hospphon PICTURE '(999)-999999x'
 @ 5, 2 SAY 'โทรสาร        ' GET hospfax PICTURE '(999)-999999x'
 @ 6, 2 SAY 'รหัสโรงพยาบาล ' GET hospcode PICTURE '999999999999'
 @ 7, 2 SAY 'รหัสจังหวัด   ' GET hospprov PICTURE '99'
 READ
 SAVE TO hosp ALL LIKE hosp*
 SELECT 0
 USE lib\codefile
 SET ORDER TO code
 SET FILTER TO RTRIM(varname)='MAIN'
 IF  .NOT. SEEK(m.hospcode)
    APPEND BLANK
    REPLACE code WITH hospcode, name WITH RTRIM(m.hospname), varname WITH 'MAIN'
    APPEND BLANK
    REPLACE code WITH hospcode, name WITH RTRIM(m.hospname), varname WITH 'CARE'
 ENDIF
 WAIT WINDOW TIMEOUT 1 'Completed'
 RELEASE WINDOW hospinfo
 ON KEY LABEL f1
*
