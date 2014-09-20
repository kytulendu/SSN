 HIDE WINDOW ALL
 SET TALK OFF
 SET DATE british
 RESTORE FROM hosp ADDITIVE
 ON KEY LABEL f1 do mhelp with varread()
 ON KEY LABEL alt+1 _curobj=objnum(m.mm)
 ON KEY LABEL alt+2 _curobj=objnum(m.plab)
 ON KEY LABEL pgup ?? chr(7)
 ON KEY LABEL pgdn ?? chr(7)
 PUBLIC suc
 suc = 0
 m.total = 0
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
 mperiod = ''
 first = 0
 last = 0
 DEFINE WINDOW ask FROM 14, 20 TO 19, 60 SHADOW
 ACTIVATE WINDOW ask
 msg = 'แก้ไขข้อมูล'
 @ 0, (WCOLS()-LEN(msg))/2 SAY msg COLOR G+/B
 @ 2, 10 SAY 'เดือน/ปี'
 @ 2, 20 GET mm PICTURE '99' VALID BETWEEN(VAL(mm), 1, 12) MESSAGE 'Esc = Exit'
 @ 2, 22 SAY '/'
 @ 2, 23 GET yy PICTURE '99'
 READ
 IF READKEY()=12 .OR. READKEY()=268
    ON KEY LABEL f1
    RELEASE WINDOW ask
    RETURN
 ENDIF
 mperiod = yy+mm
 RELEASE WINDOW ask
 SELECT 1
 USE data\optran
 GOTO TOP
 SET FILTER TO yymm=mperiod
 LOCATE FOR yymm=mperiod
 IF  .NOT. FOUND()
    ?? CHR(7)
    WAIT WINDOW TIMEOUT 1 'ไม่พบข้อมูล'
    USE
    ON KEY LABEL f1
    RETURN
 ELSE
    LOCATE FOR hospmain=m.hospcode
    num = 1
    DO WHILE FOUND()
       DIMENSION tmpname1( num)
       tmpname1( num) = hospcare
       num = num+1
       CONTINUE
    ENDDO
    DIMENSION tmpname2( num-1)
    IF USED('codefile')
       SELECT codefile
    ELSE
       SELECT 25
       USE lib\codefile ORDER code
    ENDIF
    SET FILTER TO varname='CARE'
    FOR i = 1 TO ALEN(tmpname1)
       SEEK tmpname1(i)
       IF FOUND()
          tmpname2( i) = name
       ELSE
          tmpname2( i) = tmpname1(i)
       ENDIF
    ENDFOR
    USE
 ENDIF
 DO WHILE .T.
    choice = ''
    @ 4, 15 SAY 'เลือกโรงพยาบาลที่ให้บริการ'
    @ 5, 10 GET choice FROM tmpname2 MESSAGE 'Esc = exit'
    KEYBOARD '{Home}'
    READ
    IF READKEY()=12 .OR. READKEY()=268
       CLEAR
       WAIT WINDOW TIMEOUT 1 'End of editing session'
       ON KEY LABEL f1
       RETURN TO main
    ENDIF
    CLEAR
    hospm = m.hospcode
    hpos = ASCAN(tmpname2, choice)
    hospc = tmpname1(hpos)
    SELECT 1
    SET FILTER TO
    GOTO TOP
    LOCATE FOR hospmain=hospm .AND. hospcare=hospc .AND. yymm=mperiod
    DEFINE WINDOW opedit FROM 0, 0 TO 23, 79 TITLE ' Social Security Out Patient Record Editing '
    ACTIVATE WINDOW opedit
    hdr3 = 'Hot keys : Alt+1 ไปที่เดือน Alt+2 ไปที่จำนวนผู้รับบริการชันสูตร Alt+d=Delete'
    @ 21, (WCOLS()-LEN(hdr3))/2 SAY hdr3 COLOR GR+/B
    ON KEY LABEL alt+d do delrec in opedit
    SCATTER MEMVAR
    yy = SUBSTR(yymm, 1, 2)
    mm = SUBSTR(yymm, 3, 2)
    @ 2, 0, 2, 78 BOX
    @ 19, 0, 19, 78 BOX
    @ 1, 0 SAY '1' COLOR N/W
    @ 1, 3 SAY 'ประจำเดือน'
    @ 1, 15 GET mm PICTURE '99' VALID v_mm(mm) COLOR GR+/B
    @ 1, 17 SAY '/'
    @ 1, 18 GET yy PICTURE '99' VALID v_chkyear() COLOR GR+/B
    @ 1, 21 SAY 'โรงพยาบาลที่ให้บริการ'
    @ 1, 43 GET m.hospcare PICTURE '9999999999999'
    @ 1, 56 SAY PADR(ALLTRIM(choice), 20, ' ') COLOR GR+/B
    @ 3, 28 SAY 'ครั้ง'
    @ 4, 3 SAY 'ผู้รับการตรวจทั้งหมด' COLOR GR+/B
    @ 4, 27 SAY m.visit PICTURE '99999' COLOR GR+/B
    @ 5, 3 SAY 'สาเหตุจากการเจ็บป่วย'
    @ 5, 27 GET m.ill PICTURE '99999' VALID chkvisit(VARREAD(),m.ill) MESSAGE 'จำนวนป่วย + ได้รับอุบัติเหตุต้องไม่เกินจำนวนผู้ป่วยทั้งหมด'
    @ 6, 3 SAY 'สาเหตุจากอุบัติเหตุ'
    @ 6, 27 GET m.acc PICTURE '99999' VALID chkvisit(VARREAD(),m.acc) MESSAGE 'จำนวนป่วย + ได้รับอุบัติเหตุต้องไม่เกินจำนวนผู้ป่วยทั้งหมด'
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
    @ 3, 34, 18, 34 BOX
    @ 3, 52 SAY '2' COLOR N/W
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
    READ
    = v_sumcost()
    SET UDFPARMS TO VALUE
    DO CASE
       CASE READKEY()=12 .OR. READKEY()=268
          WAIT WINDOW TIMEOUT 1 'Aborted.... '
          RELEASE WINDOW opedit
          ON KEY LABEL f1
          ON KEY LABEL pgup
          ON KEY LABEL pgdn
          EXIT
       CASE READKEY()=270
          m.yymm = yy+mm
          m.hospmain = hospcode
          GATHER MEMVAR
       OTHERWISE
          m.yymm = yy+mm
          m.hospmain = hospcode
          GATHER MEMVAR
    ENDCASE
    ans = 'Y'
    @ 20, 0 CLEAR TO 20, 76
    @ 20, 2 SAY 'Do you want to edit another record ?'
    @ 20, 60 GET ans VALID ans$'YyNn'
    READ
    IF ans$'Yy'
       CLEAR
       m.total = 0
       LOOP
    ELSE
       EXIT
    ENDIF
    CLEAR
    RELEASE WINDOW opedit
 ENDDO
 WAIT WINDOW TIMEOUT 2 'End of editing session'
 SET FILTER TO
 USE
 RELEASE WINDOW opedit
 CLEAR
 ON KEY LABEL pgup
 ON KEY LABEL pgdn
 ON KEY LABEL alt+d
 ON KEY LABEL f1
 ON KEY LABEL alt+1
 ON KEY LABEL alt+2
*
PROCEDURE delrec
 DELETE
 WAIT WINDOW TIMEOUT 2 'Record deleted!'
 SCATTER BLANK MEMVAR
 SHOW GETS
 WAIT WINDOW TIMEOUT 1 ''
 RETURN TO main
*
FUNCTION v_hosp
 IF USED('codefile')
    SELECT codefile
 ELSE
    SELECT 25
    USE lib\codefile
 ENDIF
 LOCATE FOR code=m.hospcare .AND. varname='HOSP'
 IF FOUND()
    hname = name
 ELSE
    hname = 'Unknown'
 ENDIF
 @ 1, 56 SAY SPACE(20)
 @ 1, 56 SAY SUBSTR(hname, 1, 20)
 SELECT optran
 RETURN 1
*
PROCEDURE chkvisit
 PARAMETER vname, value
 IF vname='ILL'
    total = m.acc+value
 ENDIF
 IF vname='ACC'
    total = m.ill+value
 ENDIF
 m.visit = total
 @ 4, 27 SAY m.visit PICTURE '99999' COLOR GR+/B
 RETURN
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
