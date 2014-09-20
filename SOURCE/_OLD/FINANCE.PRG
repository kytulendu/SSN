 SET TALK OFF
 HIDE WINDOW ALL
 ACTIVATE SCREEN
 ON KEY LABEL PGUP ?? chr(7)
 ON KEY LABEL PgDn ?? chr(7)
 ON KEY LABEL LEFTARROW ?? chr(7)
 ON KEY LABEL RIGHTARROW ?? chr(7)
 ON KEY LABEL UPARROW ?? chr(7)
 ON KEY LABEL DNARROW ?? chr(7)
 CLEAR
 IF  .NOT. WEXIST('expense')
    DEFINE WINDOW expense FROM 1, 1 TO 25, 80
 ENDIF
 DIMENSION fmenu( 16)
 fmenu( 1) = 'A. ชันสูตร              '
 fmenu( 2) = 'B. คลังเลือด            '
 fmenu( 3) = 'C. พยาธิวิทยา           '
 fmenu( 4) = 'D. รังสีวิทยา           '
 fmenu( 5) = 'E. ตรวจวินิจฉัยอื่นๆ    '
 fmenu( 6) = 'F. ผ่าตัด               '
 fmenu( 7) = 'G. อวัยวะเทียม/อุปกรณ์ฯ '
 fmenu( 8) = 'H. ระงับความรู้สึก      '
 fmenu( 9) = 'I. ยาและเวชภัณฑ์        '
 fmenu( 10) = 'J. เวชกรรมฟื้นฟู        '
 fmenu( 11) = 'K. การบำบัดรักษาอื่นๆ   '
 fmenu( 12) = 'L. บริการหอผู้ป่วยหนัก  '
 fmenu( 13) = 'M. ค่าแพทย์             '
 fmenu( 14) = 'N. อาหารและที่พัก       '
 fmenu( 15) = 'O. พาหนะขนส่ง           '
 fmenu( 16) = '       รวม            '
 DIMENSION finance( 42, 4)
 DIMENSION expense( 42)
 expense = 0
 DIMENSION fincode( 42)
 fincode( 1) = 'LABC'
 fincode( 2) = 'LABS'
 fincode( 3) = 'LABP'
 fincode( 4) = 'BLDBC'
 fincode( 5) = 'BLDBS'
 fincode( 6) = 'BLDBP'
 fincode( 7) = 'PATHC'
 fincode( 8) = 'PATHS'
 fincode( 9) = 'PATHP'
 fincode( 10) = 'XRAYC'
 fincode( 11) = 'XRAYS'
 fincode( 12) = 'XRAYP'
 fincode( 13) = 'INVTC'
 fincode( 14) = 'INVTS'
 fincode( 15) = 'INVTP'
 fincode( 16) = 'OPRNC'
 fincode( 17) = 'OPRNS'
 fincode( 18) = 'OPRNP'
 fincode( 19) = 'PROSC'
 fincode( 20) = 'PROSS'
 fincode( 21) = 'PROSP'
 fincode( 22) = 'ANESC'
 fincode( 23) = 'ANESS'
 fincode( 24) = 'ANESP'
 fincode( 25) = 'DRUGC'
 fincode( 26) = 'DRUGS'
 fincode( 27) = 'DRUGP'
 fincode( 28) = 'REHBC'
 fincode( 29) = 'REHBS'
 fincode( 30) = 'REHBP'
 fincode( 31) = 'THERC'
 fincode( 32) = 'THERS'
 fincode( 33) = 'THERP'
 fincode( 34) = 'ICUC'
 fincode( 35) = 'ICUS'
 fincode( 36) = 'ICUP'
 fincode( 37) = 'ACCOC'
 fincode( 38) = 'ACCOS'
 fincode( 39) = 'ACCOP'
 fincode( 40) = 'VHCLC'
 fincode( 41) = 'DF'
 fincode( 42) = 'VHCLP'
 HIDE WINDOW ALL
 ACTIVATE SCREEN
 CLEAR
 IF WVISIBLE('ip1')
    HIDE WINDOW ip1
 ENDIF
 fcol = 0
 ON KEY LABEL Alt+1 do _vcol with 0
 ON KEY LABEL Alt+2 do _vcol with 1
 ON KEY LABEL Alt+3 do _vcol with 2
 ON KEY LABEL a _curobj=objnum(expense(1+fcol))
 ON KEY LABEL b _curobj=objnum(expense(4+fcol))
 ON KEY LABEL c _curobj=objnum(expense(7+fcol))
 ON KEY LABEL d _curobj=objnum(expense(10+fcol))
 ON KEY LABEL e _curobj=objnum(expense(13+fcol))
 ON KEY LABEL f _curobj=objnum(expense(16+fcol))
 ON KEY LABEL g _curobj=objnum(expense(19+fcol))
 ON KEY LABEL h _curobj=objnum(expense(22+fcol))
 ON KEY LABEL i _curobj=objnum(expense(25+fcol))
 ON KEY LABEL j _curobj=objnum(expense(28+fcol))
 ON KEY LABEL k _curobj=objnum(expense(31+fcol))
 ON KEY LABEL l _curobj=objnum(expense(34+fcol))
 ON KEY LABEL m _curobj=objnum(expense(42+fcol))
 ON KEY LABEL n _curobj=objnum(expense(37+fcol))
 ON KEY LABEL o do _vveh with fcol
 ACTIVATE WINDOW expense
 @ 0, 10 SAY 'ค่าบริการ'
 @ 0, 31 SAY '1' COLOR N/W
 @ 0, 33 SAY 'จากเงิน'
 @ 1, 33 SAY 'เหมาจ่าย'
 @ 0, 45 SAY '2' COLOR N/W
 @ 0, 47 SAY 'จากเงิน'
 @ 1, 47 SAY 'สำรอง'
 @ 0, 59 SAY '3' COLOR N/W
 @ 0, 61 SAY 'จากผู้ป่วย'
 @ 2, 1, 2, 74 BOX
 srow = 2
 FOR i = 1 TO 15
    @ srow+i, 3 SAY fmenu(i)
    @ srow+i, 3 SAY CHR(64+i) COLOR GR+/B
    @ srow+i, 31 GET expense( i*2-1)
 ENDFOR
 @ srow+16, 3 SAY fmenu(16) COLOR GR+/B
 i = 1
 FOR i = 1 TO 14
    @ srow+i, 45 GET expense( i*2-1)
 ENDFOR
 i = 1
 FOR i = 1 TO 14
    @ srow+i, 59 GET expense( i*2)
 ENDFOR
 @ srow+14, 59 GET expense( 42)
 @ 19, 1, 19, 74 BOX
 hdr3 = 'Ctrl+W หรือ Ctrl+End = Exit & Save    Esc = ยกเลิก'
 @ 20, 0 CLEAR
 @ 20, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR G+/B
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminated by user'
    RELEASE WINDOW expense
    RELEASE WINDOW ip1
    ON KEY LABEL PGUP
    ON KEY LABEL PgDn
    ON KEY LABEL UPARROW
    ON KEY LABEL DNARROW
    ON KEY LABEL LEFTARROW
    ON KEY LABEL RIGHTARROW
    ON KEY LABEL Alt+1
    ON KEY LABEL Alt+2
    ON KEY LABEL Alt+3
    ON KEY LABEL a
    ON KEY LABEL b
    ON KEY LABEL c
    ON KEY LABEL d
    ON KEY LABEL e
    ON KEY LABEL f
    ON KEY LABEL g
    ON KEY LABEL h
    ON KEY LABEL i
    ON KEY LABEL j
    ON KEY LABEL k
    ON KEY LABEL l
    ON KEY LABEL m
    ON KEY LABEL n
    ON KEY LABEL o
    RETURN TO main
 ENDIF
 @ 18, 32 SAY expense(1)+expense(4)+expense(7)+expense(10)+expense(13)+expense(16)+expense(19)+expense(22)+expense(25)+expense(28)+expense(31)+expense(34)+expense(37)+expense(40) SIZE 1, 9 PICTURE '9,999,999' COLOR GR+/B
 @ 18, 46 SAY expense(2)+expense(5)+expense(8)+expense(11)+expense(14)+expense(17)+expense(20)+expense(23)+expense(26)+expense(29)+expense(32)+expense(35)+expense(38) SIZE 1, 9 PICTURE '9,999,999' COLOR GR+/B
 @ 18, 60 SAY expense(3)+expense(6)+expense(9)+expense(12)+expense(15)+expense(18)+expense(21)+expense(24)+expense(27)+expense(30)+expense(33)+expense(36)+expense(39)+expense(41) SIZE 1, 9 PICTURE '9,999,999' COLOR GR+/B
 WAIT WINDOW TIMEOUT 2 ''
 i = 1
 notempty = 0
 FOR i = 1 TO 42
    IF expense(i)>0
       notempty = notempty+1
       finance( notempty, 1) = man
       finance( notempty, 2) = fincode(i)
       finance( notempty, 3) = expense(i)
       finance( notempty, 4) = m.hospc
    ENDIF
 ENDFOR
 IF notempty>0
    DIMENSION finance( notempty, 4)
 ELSE
    DIMENSION finance( 1, 4)
 ENDIF
 ON KEY LABEL Alt+1
 ON KEY LABEL Alt+2
 ON KEY LABEL Alt+3
 ON KEY LABEL PGUP
 ON KEY LABEL PgDn
 ON KEY LABEL UPARROW
 ON KEY LABEL DNARROW
 ON KEY LABEL LEFTARROW
 ON KEY LABEL RIGHTARROW
 ON KEY LABEL a
 ON KEY LABEL b
 ON KEY LABEL c
 ON KEY LABEL d
 ON KEY LABEL e
 ON KEY LABEL f
 ON KEY LABEL g
 ON KEY LABEL h
 ON KEY LABEL i
 ON KEY LABEL j
 ON KEY LABEL k
 ON KEY LABEL l
 ON KEY LABEL m
 ON KEY LABEL n
 ON KEY LABEL o
 CLEAR
 HIDE WINDOW expense
 ACTIVATE WINDOW ip1
 RETURN
*
PROCEDURE _vcol
 PARAMETER col
 m.fcol = col
 _CUROBJ = OBJNUM(expense(1+col))
 RETURN
*