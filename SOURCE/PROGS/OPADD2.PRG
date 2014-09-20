 SET MESSAGE TO 22 CENTER
 SET TALK OFF
 SET PROCEDURE TO opadd2
 PUBLIC suc
 suc = 0
 m.total = 0
 RESTORE FROM hosp ADDITIVE
 ON KEY LABEL f1 do mhelp with varread()
 ON KEY LABEL alt+1 _curobj=objnum(mm)
 ON KEY LABEL alt+2 _curobj=objnum(m.plab)
 SELECT 1
 USE data\optran ORDER yymm
 SCATTER BLANK MEMVAR
 tmm = MONTH(DATE())-1
 IF tmm<10
    DO CASE
       CASE tmm=0
          mm = ALLTRIM('12')
       CASE tmm>0
          mm = ALLTRIM('0'+ALLTRIM(STR(tmm)))
    ENDCASE
 ELSE
    mm = ALLTRIM(STR(tmm))
 ENDIF
 IF mm='12'
    yy = RIGHT(STR(YEAR(DATE())+543-1), 2)
 ELSE
    yy = RIGHT(STR(YEAR(DATE())+543), 2)
 ENDIF
 hospname = ''
 DIMENSION wmenu( 3)
 wmenu( 1) = '   รพ.ต่อไป   '
 wmenu( 2) = ' กลับรายการหลัก '
 wmenu( 3) = '     แก้ไข    '
 DEFINE WINDOW opadd FROM 0, 0 TO 24, 79 TITLE ' Social Security Out Patient Summary '
 ACTIVATE WINDOW opadd
 hdr2 = 'Ctrl+W, Ctrl+End = บันทึก        Esc = ยกเลิกข้อมูล'
 hdr3 = '   Hot keys : Alt+1 ไปที่เดือน Alt+2 ไปที่จำนวนผู้รับบริการชันสูตร'
 ON KEY LABEL pgup ?? chr(7)
 ON KEY LABEL pgdn ?? chr(7)
 m.acc = 0
 DO WHILE .T.
    ACTIVATE SCREEN
    CLEAR
    ACTIVATE WINDOW opadd
    @ 2, 0, 2, 78 BOX
    @ 19, 0, 19, 78 BOX
    @ 1, 0 SAY '1' COLOR GR+/R
    @ 1, 3 SAY 'ประจำเดือน'
    @ 1, 15 GET mm VALID v_mm(mm)
    @ 1, 17 SAY '/'
    @ 1, 18 GET yy PICTURE '99' VALID v_chkyear() MESSAGE 'ปี พ.ศ.'
    @ 1, 21 SAY 'โรงพยาบาลที่ให้บริการ'
    @ 1, 44 GET m.hospcare PICTURE '999999999999' VALID v_hosp() MESSAGE 'รหัส รพ.ที่ให้บริการ F1 = List'
    @ 3, 28 SAY 'ครั้ง'
    @ 4, 3 SAY 'ผู้รับการตรวจทั้งหมด' COLOR GR+/B
    @ 4, 26 SAY ''
    @ 5, 3 SAY 'สาเหตุจากการเจ็บป่วย'
    @ 5, 27 GET m.ill PICTURE '99999' MESSAGE 'จำนวนป่วย + ได้รับอุบัติเหตุต้องไม่เกินจำนวนผู้ป่วยทั้งหมด'
    @ 6, 3 SAY 'สาเหตุจากอุบัติเหตุ'
    @ 6, 27 GET m.acc PICTURE '99999' VALID v_visit() MESSAGE 'จำนวนป่วย + ได้รับอุบัติเหตุต้องไม่เกินจำนวนผู้ป่วยทั้งหมด'
    @ 7, 5 SAY 'ห้องตรวจ GP'
    @ 7, 27 GET m.gp PICTURE '99999' VALID m.gp<=m.visit MESSAGE ' '
    @ 8, 5 SAY 'ห้องตรวจ อายุรกรรม'
    @ 8, 27 GET m.med PICTURE '99999' VALID m.med<=m.visit MESSAGE ' '
    @ 9, 5 SAY 'ห้องตรวจ ศัลยกรรม'
    @ 9, 27 GET m.surg PICTURE '99999' VALID m.surg<=m.visit
    @ 10, 5 SAY 'ห้องตรวจ Ortho'
    @ 10, 27 GET m.orth PICTURE '99999' VALID m.orth<=m.visit
    @ 11, 5 SAY 'ห้องตรวจ สูตินรีเวช'
    @ 11, 27 GET m.obg PICTURE '99999' VALID m.obg<=m.visit
    @ 12, 5 SAY 'ห้องตรวจ ตา'
    @ 12, 27 GET m.eye PICTURE '99999' VALID m.eye<=m.visit
    @ 13, 5 SAY 'ห้องตรวจ หูคอจมูก'
    @ 13, 27 GET m.ent PICTURE '99999' VALID m.ent<=m.visit
    @ 14, 5 SAY 'ห้องตรวจ อุบัติเหตุ'
    @ 14, 27 GET m.er PICTURE '99999' VALID m.er<=m.visit
    @ 15, 5 SAY 'ห้องตรวจ จิตเวช'
    @ 15, 27 GET m.psych PICTURE '99999' VALID m.psych<=m.visit
    @ 16, 5 SAY 'ห้องตรวจ ทันตกรรม'
    @ 16, 27 GET m.dent PICTURE '99999' VALID m.dent<=m.visit
    @ 17, 3 SAY 'ผู้รับบริการอื่นๆ' COLOR GR+/B
    @ 17, 27 GET m.other PICTURE '99999' MESSAGE ' '
    @ 3, 34, 19, 34 BOX
    @ 3, 52 SAY '2' COLOR GR+/R
    @ 3, 54 SAY 'จำนวนผู้ป่วย'
    @ 3, 68 SAY 'ค่าบริการ'
    @ 4, 36 SAY 'ชันสูตร'
    SET UDFPARMS TO REFERENCE
    @ 4, 58 GET m.plab PICTURE '99999' VALID v_chkmo(4,68,m.plab,m.clab)
    @ 4, 68 GET m.clab PICTURE '9999999' VALID  .NOT. EMPTY(m.clab) WHEN  .NOT. EMPTY(m.plab)
    @ 5, 36 SAY 'คลังเลือด'
    @ 5, 58 GET m.pbldb PICTURE '99999' VALID v_chkmo(5,68,m.pbldb,m.cbldb)
    @ 5, 68 GET m.cbldb PICTURE '9999999' VALID  .NOT. EMPTY(m.cbldb) WHEN  .NOT. EMPTY(m.pbldb)
    @ 6, 36 SAY 'พยาธิวิทยา'
    @ 6, 58 GET m.ppath PICTURE '99999' VALID v_chkmo(6,68,m.ppath,m.cpath)
    @ 6, 68 GET m.cpath PICTURE '9999999' VALID  .NOT. EMPTY(m.cpath) WHEN  .NOT. EMPTY(m.ppath)
    @ 7, 36 SAY 'รังสีวิทยา'
    @ 7, 58 GET m.pxray PICTURE '99999' VALID v_chkmo(7,68,m.pxray,m.cxray)
    @ 7, 68 GET m.cxray PICTURE '9999999' VALID  .NOT. EMPTY(m.cxray) WHEN  .NOT. EMPTY(m.pxray)
    @ 8, 36 SAY 'ตรวจวินิจฉัยอื่นๆ'
    @ 8, 58 GET m.pinvt PICTURE '99999' VALID v_chkmo(8,68,m.pinvt,m.cinvt)
    @ 8, 68 GET m.cinvt PICTURE '9999999' VALID  .NOT. EMPTY(m.cinvt) WHEN  .NOT. EMPTY(m.pinvt)
    @ 9, 36 SAY 'ผ่าตัด'
    @ 9, 58 GET m.poprn PICTURE '99999' VALID v_chkmo(9,68,m.poprn,m.coprn)
    @ 9, 68 GET m.coprn PICTURE '9999999' VALID  .NOT. EMPTY(m.coprn) WHEN  .NOT. EMPTY(m.poprn)
    @ 10, 36 SAY 'อวัยวะเทียมอุปกรณ์ฯ'
    @ 10, 58 GET m.ppros PICTURE '99999' VALID v_chkmo(10,68,m.ppros,m.cpros)
    @ 10, 68 GET m.cpros PICTURE '9999999' VALID  .NOT. EMPTY(m.cpros) WHEN  .NOT. EMPTY(m.ppros)
    @ 11, 36 SAY 'ระงับความรู้สึก'
    @ 11, 58 GET m.panes PICTURE '99999' VALID v_chkmo(11,68,m.panes,m.canes)
    @ 11, 68 GET m.canes PICTURE '9999999' VALID  .NOT. EMPTY(m.canes) WHEN  .NOT. EMPTY(m.panes)
    @ 12, 36 SAY 'ค่ายาและเวชภัณฑ์'
    @ 12, 58 GET m.pdrug PICTURE '99999' VALID v_chkmo(12,68,m.pdrug,m.cdrug)
    @ 12, 68 GET m.cdrug PICTURE '9999999' VALID  .NOT. EMPTY(m.cdrug) WHEN  .NOT. EMPTY(m.pdrug)
    @ 13, 36 SAY 'เวชกรรมฟื้นฟู'
    @ 13, 58 GET m.prehb PICTURE '99999' VALID v_chkmo(13,68,m.prehb,m.crehb)
    @ 13, 68 GET m.crehb PICTURE '9999999' VALID  .NOT. EMPTY(m.crehb) WHEN  .NOT. EMPTY(m.prehb)
    @ 14, 36 SAY 'การบำบัดรักษาอื่นๆ'
    @ 14, 58 GET m.pther PICTURE '99999' VALID v_chkmo(14,68,m.pther,m.cther)
    @ 14, 68 GET m.cther PICTURE '9999999' VALID  .NOT. EMPTY(m.cther) WHEN  .NOT. EMPTY(m.pther)
    @ 15, 36 SAY 'ค่าพาหนะ'
    @ 15, 58 GET m.pvhcl PICTURE '99999' VALID v_chkmo(15,68,m.pvhcl,m.cvhcl)
    @ 15, 68 GET m.cvhcl PICTURE '9999999' VALID  .NOT. EMPTY(m.cvhcl) WHEN  .NOT. EMPTY(m.pvhcl)
    @ 16, 36 SAY 'ค่าธรรมเนียมแพทย์'
    @ 16, 58 GET m.pdf PICTURE '99999' VALID v_chkmo(16,68,m.pdf,m.cdf)
    @ 16, 68 GET m.cdf PICTURE '9999999' VALID  .NOT. EMPTY(m.cdf) WHEN  .NOT. EMPTY(m.pdf)
    @ 17, 65 SAY m.total
    @ 18, 36 SAY 'เก็บเพิ่มจากผู้ป่วย'
    @ 18, 68 GET m.paid PICTURE '9999999'
    @ 20, 0 CLEAR
    @ 20, (WCOLS()-LEN(hdr2))/2 SAY hdr2 COLOR GR+/B
    @ 21, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR N+/W
    READ
    = v_sumcost()
    SET UDFPARMS TO VALUE
    IF READKEY()=12 .OR. READKEY()=268
       SET ESCAPE OFF
       ON KEY LABEL f1
       ON KEY LABEL pgup
       ON KEY LABEL pgdn
       ON KEY LABEL alt+1
       ON KEY LABEL alt+2
       ? CHR(13)
       WAIT WINDOW TIMEOUT 1 'Terminated by user, Data are NOT saved to disk!'
       SET UDFPARMS TO VALUE
       CLEAR
       RELEASE WINDOW opadd
       SET PROCEDURE TO
       RETURN TO main
    ENDIF
    m.yymm = yy+mm
    m.hospmain = hospcode
    @ 20, 0 CLEAR
    FOR i = 1 TO ALEN(wmenu)
       @ 20, 26*i-18 PROMPT wmenu(i) MESSAGE ' '
    ENDFOR
    MENU TO choice
    DO CASE
       CASE choice=1
          IF EMPTY(m.hospcare) .OR. EMPTY(m.hospmain)
             WAIT WINDOW TIMEOUT 1 'ไม่มีรหัส รพ. กรุณากรอกใหม่'
             LOOP
          ELSE
             INSERT INTO data\optran FROM MEMVAR
             SELECT optran
             SCATTER BLANK MEMVAR
             @ 1, 56 SAY SPACE(20)
             m.total = 0
             @ 4, 26 SAY SPACE(6)
             @ 20, 1 CLEAR TO 20, 76
             LOOP
          ENDIF
       CASE choice=2
          IF EMPTY(m.hospcare) .OR. EMPTY(m.hospmain)
             WAIT WINDOW TIMEOUT 1 'ไม่มีรหัส รพ. กรุณากรอกใหม่'
             LOOP
          ELSE
             INSERT INTO data\optran FROM MEMVAR
             EXIT
          ENDIF
       CASE choice=3
          @ 20, 1 CLEAR TO 20, 76
          @ 1, 56 SAY SPACE(20)
          LOOP
    ENDCASE
 ENDDO
 WAIT WINDOW TIMEOUT 2 'จบการกรอกข้อมูล'
 RELEASE WINDOW opadd
 ON KEY LABEL alt+1
 ON KEY LABEL alt+2
 ON KEY LABEL f1
 ON KEY LABEL pgup
 ON KEY LABEL pgdn
 SET PROCEDURE TO
 RETURN
*
FUNCTION v_hosp
 IF EMPTY(m.hospcare)
    ? CHR(7)
    WAIT WINDOW TIMEOUT 1 'โปรดใส่รหัส รพ.ที่ให้บริการ'
    RETURN 0
 ENDIF
 SELECT codefile
 SET ORDER TO code
 SET FILTER TO varname='CARE'
 SEEK (m.hospcare)
 IF  .NOT. FOUND()
    @ 1, 56 SAY SPACE(20)
    @ 1, 56 SAY 'Unknown'
 ELSE
    hospname = name
    @ 1, 56 SAY SPACE(20)
    @ 1, 56 SAY ALLTRIM(SUBSTR(hospname, 1, 20)) COLOR GR+/B
 ENDIF
 SET FILTER TO
 SELECT optran
 LOCATE FOR yymm=yy+mm .AND. hospcare=m.hospcare
 IF FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 2 'ข้อมูลนี้ เคยกรอกไปแล้ว กรุณาเลือกใหม่'
    _CUROBJ = OBJNUM(mm)
    RETURN
 ENDIF
 RETURN 1
*
FUNCTION v_mm
 PARAMETER mval
 IF READKEY()=4 .OR. READKEY()=260
    ?? CHR(7)
    RETURN 0
 ENDIF
 IF READKEY()=0 .OR. READKEY()=256
    ?? CHR(7)
    RETURN 0
 ENDIF
 IF VAL(mval)<1 .OR. VAL(mval)>12
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'Invalid input'
    RETURN 0
 ELSE
    m.mm = mval
 ENDIF
 RETURN
*
PROCEDURE v_visit
 m.visit = m.ill+m.acc
 @ 4, 26 SAY m.visit SIZE 1, 6 COLOR GR+/B
 RETURN
*
FUNCTION v_chkyear
 DO CASE
    CASE VAL(yy)>VAL(RIGHT(STR(YEAR(DATE())+543), 2))
       ? CHR(7)
       WAIT WINDOW TIMEOUT 2 'กรุณากรอกปีที่ถูกต้อง'
       RETURN 0
    CASE VAL(yy)=VAL(RIGHT(STR(YEAR(DATE())+543), 2))
       IF VAL(mm)>MONTH(DATE())
          ? CHR(7)
          WAIT WINDOW TIMEOUT 2 'กรุณากรอกเดือนที่ถูกต้อง'
          RETURN -1
       ENDIF
    CASE VAL(yy)<34
       ? CHR(7)
       WAIT WINDOW TIMEOUT 2 'กรุณากรอกปีที่ถูกต้อง'
       RETURN 0
    OTHERWISE
       RETURN 1
 ENDCASE
*
FUNCTION v_chkmo
 PARAMETER rr, cc, cno, cmo
 DO CASE
    CASE cno>m.visit .AND.  .NOT. EMPTY(m.ill)
       ? CHR(7)
       WAIT WINDOW 'Invalid Input'
       RETURN 0
    CASE EMPTY(cno) .AND.  .NOT. EMPTY(cmo)
       cmo = 0
       @ rr, cc GET cmo PICTURE '9999999' VALID  .NOT. EMPTY(cmo) WHEN  .NOT. EMPTY(cno)
       RETURN
 ENDCASE
*
FUNCTION v_sumcost
 m.total = m.clab+m.cbldb+m.cpath+m.cxray+m.cinvt+m.coprn+m.cpros+m.canes+m.cdrug+m.crehb+m.cther+m.cvhcl+m.cdf
 DO CASE
    CASE EMPTY(m.visit) .AND. m.total=0
       @ 17, 65 SAY m.total
       suc = '0'
       RETURN
    CASE  .NOT. EMPTY(m.visit) .AND. m.total=0
       @ 17, 65 SAY m.total
       suc = '1'
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'กรุณาบันทึกข้อมูลการเงิน'
       _CUROBJ = OBJNUM(m.plab)
       RETURN .F.
    OTHERWISE
       @ 17, 65 SAY m.total
 ENDCASE
*
