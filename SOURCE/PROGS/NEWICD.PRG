 SET TALK OFF
 SET ECHO OFF
 SET EXCLUSIVE OFF
 SET UDFPARMS TO REFERENCE
 HIDE WINDOW ALL
 CLEAR
 DO openicd10
 DO openicdcm
 mdiag = SPACE(20)
 mdiag1 = SPACE(20)
 DEFINE WINDOW inst FROM 1, 5 TO 9, 75 SHADOW COLOR W+/RB
 ACTIVATE WINDOW inst
 CLEAR
 @ 0, 0 SAY PADC('คำแนะนำ', WCOLS(), ' ') COLOR GR+/RB
 @ 2, 3 SAY 'กรอก Keyword หรือรหัส ICD10/ICDCM ที่ต้องการค้นหา ลงในช่อง'
 @ 3, 3 SAY 'ถ้าเป็นรหัสหรือ Keyword ของการผ่าตัด ให้นำหน้าด้วย "*" เช่น *470,'
 @ 4, 3 SAY '*APPENDECTOMY แล้วเลือกรหัสจาก POPUP menu'
 @ 6, 0 SAY PADC('(Blank = Exit)', WCOLS(), ' ') COLOR GR+/RB
 DO WHILE .T.
    ACTIVATE SCREEN
    @ 10, 0 CLEAR
    @ 12, 7 SAY 'คำที่ต้องการค้นหา ->'
    @ 12, 30 GET mdiag PICTURE '@!'
    READ
    IF EMPTY(mdiag)
       EXIT
    ENDIF
    IF READKEY()=12 .OR. READKEY()=268
       EXIT
    ENDIF
    mdiag1 = mdiag
    = checkicd(mdiag1)
    WAIT WINDOW TIMEOUT 5 ''
    mdiag = SPACE(20)
    mname = SPACE(60)
 ENDDO
 CLOSE ALL
 RELEASE WINDOW inst
 CLEAR
*
PROCEDURE checkicd
 PARAMETER _icd
 PRIVATE mname
 ON KEY LABEL home
 ON KEY LABEL pgup
 ON KEY LABEL pgdn
 _mx = 'M'+VARREAD()
 _x = RIGHT(_mx, 1)
 mf1 = 'icd101'
 mf2 = 'icd102'
 mf3 = 'icd103'
 IF EMPTY(_icd)
    CLEAR
    RETURN
 ENDIF
 IF LASTKEY()<>5
    IF  .NOT. EMPTY(_icd)
       _icd = IIF(LEFT(_mx, 5)='MOPER' .AND. LEFT(_icd, 1)<>'*', '*'+_icd, _icd)
       IF ISDIGIT(SUBSTR(_icd, 2, 1)) .OR. LEN(TRIM(_icd))=1
          IF LEFT(_icd, 1)='*' .OR. ISDIGIT(_icd)
             _icd = IIF(ISDIGIT(_icd), LEFT(_icd, 4), SUBSTR(_icd, 2, 4))
             mf1 = 'icdcm1'
             mf2 = 'icdcm2'
             mf3 = 'icdcm3'
          ELSE
             mf1 = 'icd101'
             mf2 = 'icd102'
             mf3 = 'icd103'
          ENDIF
          _seek = ALLTRIM(_icd)
          _seek = IIF(LEN(_seek)>4, LEFT(_seek, 4), _seek)
          _seek = IIF(LEN(_seek)<3, _seek+SPACE(3-LEN(_seek)), _seek)
          slen = LEN(_seek)-1
          SELECT (mf1)
          SET ORDER TO 1
          IF  .NOT. SEEK(_seek)
             success = .F.
             FOR i = slen TO 1 STEP -1
                _seek = LEFT(_icd, i)
                IF SEEK(_seek)
                   success = .T.
                   _prompt = sicd1(code+SPACE(3)+desc)
                   FOR n = i+1 TO 3
                      _seek = LEFT(_prompt, n)
                      IF SEEK(_seek)
                         _prompt = sicd1(code+SPACE(3)+desc)
                      ELSE
                         EXIT
                      ENDIF
                   ENDFOR
                   EXIT
                ENDIF
             ENDFOR
             IF success
                _icd = LEFT(_prompt, LEN(code))
                &_mx=SUBS(_prompt,LEN(code)+4,60)
                mname=&_mx
                IF LEFT(_icd, 1)='*'
                   _CUROBJ = _CUROBJ+2
                ENDIF
             ELSE
                ?? CHR(7)
                WAIT WINDOW NOWAIT 'ไม่มีรหัสโรคนี้  '+_icd
                _CUROBJ = _CUROBJ
             ENDIF
          ELSE
             _icd = showicd(code)
             &_mx=LEFT(DESC,60)
             mname=&_mx
          ENDIF
       ELSE
          IF LEFT(_icd, 1)='*'
             _icd = SUBSTR(_icd, 2)
             mf1 = 'icdcm1'
             mf2 = 'icdcm2'
             mf3 = 'icdcm3'
          ENDIF
          SELECT (mf1)
          mprompt = keyword(_icd)
          SELECT (mf1)
          IF LASTKEY()<>27
             _icd = LEFT(mprompt, LEN(code))
             &_mx=SUBS(mprompt,LEN(code)+4,60)
             mname=&_mx
          ENDIF
       ENDIF
       IF mf1='icdcm'
          mf1 = 'icd101'
          mf2 = 'icd102'
          mf3 = 'icd103'
       ENDIF
    ELSE
       IF LASTKEY()<>5
          _icd = SPACE(LEN(_icd))
          &_mx=SPAC(LEN(&_mx))
       ENDIF
    ENDIF
 ENDIF
 SHOW GETS
 ACTIVATE SCREEN
 WAIT CLEAR
 IF  .NOT. EMPTY(_icd)
    @ 13, 3, 16, 76 BOX
    @ 14, 5 SAY 'รหัสที่เลือก คือ :' COLOR GR+/B
    @ 15, 5 SAY PADR(_icd+' '+mname, 70, ' ') COLOR W+/R
 ELSE
    @ 13, 3, 16, 76 BOX
    @ 14, 5 SAY 'รหัสที่เลือก คือ :' COLOR GR+/B
    @ 15, 5 SAY PADC(' ---> ไม่มีรหัสนี้ <--- ', 70, ' ') COLOR W+/R
 ENDIF
*
FUNCTION keyword
 PARAMETER word
 _wret = SPACE(LEN(word))
 mkwd = RTRIM(word)
 DIMENSION tmpdg( 1)
 SELECT (mf3)
 SET ORDER TO DESC
 IF  .NOT. SEEK(mkwd)
    ?? CHR(7)
    WAIT WINDOW NOWAIT '  ไม่มีคำนี้อยู่  '
    _CUROBJ = _CUROBJ
 ELSE
    num = 1
    DO WHILE UPPER(desc)=mkwd
       DIMENSION tmpdg( num)
       tmpdg( num) = desc
       num = num+1
       SKIP
    ENDDO
    choice = ''
    DEFINE WINDOW sicd FROM 0, 1 TO 23, 78 SHADOW
    ACTIVATE WINDOW sicd
    lastkey = 27
    @ 5, 5 GET choice FROM tmpdg
    KEYBOARD '{HOME}'
    READ
    IF LASTKEY()=27
       _CUROBJ = _CUROBJ
       RELEASE WINDOW sicd
       RETURN
    ENDIF
    CLEAR
    SET ORDER TO DESC
    SEEK UPPER(choice)
    mcode = kwcode
    SELECT (mf2)
    SET ORDER TO kwcode
    SEEK mcode
    num = 0
    DO WHILE mcode=kwcode
       num = num+1
       DIMENSION tmp( num)
       tmp( num) = code
       SKIP
    ENDDO
    SELECT (mf1)
    SET ORDER TO code
    FOR i = 1 TO ALEN(tmp)
       SEEK (LEFT(ALLTRIM(tmp(i)), 3))
       IF  .NOT. EMPTY(text)
          tmp( i) = code+' * '+RTRIM(desc)
       ELSE
          tmp( i) = code+'   '+RTRIM(desc)
       ENDIF
    ENDFOR
    num = ALEN(tmp)
    SET COLOR TO W+/B
    ftr = '  กดปุ่ม [F2] เพื่อดูข้อมูลเพิ่มเติม '
    DEFINE POPUP sicd FROM 0, 1 TO 12, 75 SHADOW FOOTER ftr COLOR R+/BG,W+/R
    FOR ii = 1 TO num
       DEFINE BAR ii OF sicd PROMPT PADR(tmp(ii), 70, ' ')
    ENDFOR
    mcode1 = SPACE(3)
    _seek = SPACE(4)
    keyf2 = ON('KEY', 'F2')
    ON KEY LABEL f2 DO shwmemo4 WITH PROMPT()
    ON SELECTION POPUP sicd DO  sele_sicd WITH PROMPT(),_seek
    mkey = 27
    DO WHILE mkey=27
       ACTIVATE POPUP sicd
       mkey = LASTKEY()
    ENDDO
    ON KEY LABEL f2 &keyf2
    _seek = LEFT(_seek, 3)
    SELECT (mf1)
    IF  .NOT. SEEK(_seek)
       ?? CHR(7)
       WAIT WINDOW TIMEOUT 1 'WARNING : This code is currently NOT in the ICD files!'
    ELSE
       _wret = sicd1(code+SPACE(3)+desc)
    ENDIF
    RELEASE WINDOW sicd
 ENDIF
 SELECT (mf3)
 SET ORDER TO 1
 SELECT (mf2)
 SET ORDER TO 1
 SELECT (mf1)
 SET ORDER TO 1
 RETURN _wret
*
FUNCTION showicd
 PARAMETER _showicd
 IF ISDIGIT(_showicd) .OR. LEFT(_showicd, 1)='*'
    RETURN IIF(ISDIGIT(_showicd), '*'+_showicd, _showicd)
 ELSE
    _showicd = LEFT(_showicd, 3)+IIF(ISDIGIT(SUBSTR(_showicd, 4, 1)), '.', '')+SUBSTR(_showicd, 4)
    RETURN _showicd
 ENDIF
*
PROCEDURE findicd
 PARAMETER _find
 DIMENSION tempicd( 100), tempname( 100)
 PRIVATE xx, mchoice
 xx = 1
 WAIT WINDOW NOWAIT 'กำลังค้นหาข้อมูลอยู่ กรุณาคอยสักครู่'
 SET ORDER TO 0
 SCAN FOR TRIM(_find)$name
    tempname( xx) = name
    tempicd( xx) = RECNO()
    xx = xx+1
    IF xx>100
       EXIT
    ENDIF
 ENDSCAN
 SET ORDER TO 1
 IF xx=1 .OR. xx>100
    GOTO BOTTOM
    SKIP
    ?? CHR(7)
    IF xx=1
       WAIT WINDOW NOWAIT 'ไม่มีรหัสโรคที่สะกดคล้าย '+_find
    ELSE
       WAIT WINDOW NOWAIT 'ควรพิมพ์ชื่อยาวกว่านี้ มีชื่อทำนองนี้มากเกินไป'
    ENDIF
    _CUROBJ = _CUROBJ
 ELSE
    ?? CHR(7)
    WAIT WINDOW NOWAIT 'ค้นได้แล้ว เชิญเลือกเอาได้เลย'
    mchoice = 0
    SET CONFIRM ON
    DO WHILE mchoice=0
       @ 10, 20 MENU tempname, xx-1, 10
       READ MENU TO mchoice
    ENDDO
    SET CONFIRM OFF
    GOTO tempicd(mchoice)
 ENDIF
*
FUNCTION entryicd
 PARAMETER _oldicd, _newicd
 mx = 'm'+VARREAD()
 IF EMPTY(_oldicd)
    _newicd = SPACE(60)
    &mx = SPACE(LEN(&mx))
 ELSE
    _newicd = con_icd(_newicd)
    _newicd = LEFT(_newicd+SPACE(60), 60)
 ENDIF
 SHOW GETS
 RETURN IIF(_oldicd='     ', .F., .T.)
*
FUNCTION con_icd
 PARAMETER _conicd
 RETURN IIF(SUBSTR(_conicd, 4, 1)='.', LEFT(_conicd, 3)+SUBSTR(_conicd, 5), _conicd)
*
PROCEDURE openicd10
 IF USED('ICD101')
    SELECT icd101
 ELSE
    SELECT 0
    USE lib\icd101 ORDER 1
 ENDIF
 IF USED('ICD102')
    SELECT icd102
 ELSE
    SELECT 0
    USE lib\icd102 ORDER 1
 ENDIF
 IF USED('ICD103')
    SELECT icd103
 ELSE
    SELECT 0
    USE lib\icd103 ORDER 1
 ENDIF
*
PROCEDURE openicdcm
 IF USED('ICDCM1')
    SELECT icdcm1
 ELSE
    SELECT 0
    USE lib\icdcm1 ORDER 1
 ENDIF
 IF USED('ICDCM2')
    SELECT icdcm2
 ELSE
    SELECT 0
    USE lib\icdcm2 ORDER 1
 ENDIF
 IF USED('ICDCM3')
    SELECT icdcm3
 ELSE
    SELECT 0
    USE lib\icdcm3 ORDER 1
 ENDIF
*
PROCEDURE sele_sicd
 PARAMETER _pmt, _sst
 _sst = _pmt
 DEACTIVATE POPUP sicd
*
FUNCTION sicd1
 PARAMETER _sicd1c
 _sret = _sicd1c
 SELECT (mf1)
 DEFINE WINDOW sicd FROM 0, 1 TO 23, 78 SHADOW
 ACTIVATE WINDOW sicd
 ftr = '  กดปุ่ม [F2] เพื่อดูข้อมูลเพิ่มเติม  '
 DEFINE POPUP sicd FROM 0, 1 TO 12, 75 SHADOW FOOTER ftr COLOR R+/BG,W+/R
 num = 0
 FOR ii = 0 TO 9
    IF SEEK(_seek+STR(ii, 1))
       num = num+1
       IF  .NOT. EMPTY(text)
          DEFINE BAR num OF sicd PROMPT code+' * '+RTRIM(desc)
       ELSE
          DEFINE BAR num OF sicd PROMPT code+'   '+RTRIM(desc)
       ENDIF
    ENDIF
 ENDFOR
 keyf2 = ON('KEY', 'F2')
 ON KEY LABEL f2 DO shwmemo4 WITH PROMPT()
 ON SELECTION POPUP sicd DO  sele_sicd WITH PROMPT(), _sret
 mkey = 27
 DO WHILE mkey=27 .AND. num>0
    ACTIVATE POPUP sicd
    mkey = LASTKEY()
 ENDDO
 RELEASE WINDOW sicd
 ON KEY LABEL f2 &keyf2
 RETURN _sret
*
PROCEDURE shwmemo4
 PARAMETER scode
 ON KEY LABEL f2
 scode = LEFT(scode, 4)
 DEFINE WINDOW mem FROM 15, 5 TO 23, 75 SHADOW COLOR W+/BG
 SELECT (mf1)
 SEEK scode
 IF  .NOT. EMPTY(text)
    MODIFY MEMO text NOEDIT WINDOW mem
 ENDIF
 ON KEY LABEL f2 DO shwmemo4 WITH PROMPT()
 RETURN
*
