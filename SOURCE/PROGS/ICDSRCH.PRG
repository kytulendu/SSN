 HIDE WINDOW ALL
 SELECT 0
 USE lib\icd101
 SELECT 0
 USE lib\icd102
 SELECT 0
 USE lib\icd103
 SELECT 0
 USE lib\index
 SELECT 0
 USE lib\icdcm1
 SELECT 0
 USE lib\icdcm2
 SELECT 0
 USE lib\icdcm3
 DIMENSION chap10( 21)
 chap10( 1) = 'A00-B99 Certain infectious and parasitic diseases'
 chap10( 2) = 'C00-D48 Neoplasms'
 chap10( 3) = 'D50-D89 Diseases of the blood and blood-forming organs'
 chap10( 4) = 'E00-E90 Endocrine, nutritional and metabolic diseases'
 chap10( 5) = 'F00-F99 Mental and behavioural disorders'
 chap10( 6) = 'G00-G99 Diseases of the nervous system'
 chap10( 7) = 'H00-H59 Diseases of the eye and adnexa'
 chap10( 8) = 'H60-H95 Diseases of the ear and mastoid process'
 chap10( 9) = 'I00-I99 Diseases of the circulatory system'
 chap10( 10) = 'J00-J99 Diseases of the respiratory system'
 chap10( 11) = 'K00-K93 Diseases of the digestive system'
 chap10( 12) = 'L00-L99 Diseases of the skin and subcutaneous tissue'
 chap10( 13) = 'M00-M99 Diseases of the musculoskeletal system and connective tissue'
 chap10( 14) = 'N00-N99 Diseases of the genitourinary system'
 chap10( 15) = 'O00-O99 Pregnancy, childbirth and the puerperium'
 chap10( 16) = 'P00-P96 Certain conditions originating in the perinatal period'
 chap10( 17) = 'Q00-Q99 Congenital malformations, deformations and chromosomal abnormal'
 chap10( 18) = 'R00-R99 Symptoms, signs and abnormal clinical and laboratory findings'
 chap10( 19) = 'S00-T98 Injury, poisoning and certain other consequences of external'
 chap10( 20) = 'V00-Y98 External causes of morbidity and mortality'
 chap10( 21) = 'Z00-Z99 Factors influencing health status and contact with health serv'
 DIMENSION chapcm( 16)
 chapcm( 1) = '01-05 Operations on the Nervous System'
 chapcm( 2) = '06-07 Operations on the Endocrine System'
 chapcm( 3) = '08-16 Operations on the Eye'
 chapcm( 4) = '18-20 Operations on the Ear'
 chapcm( 5) = '21-29 Operations on the Nose, Mouth, and Pharynx'
 chapcm( 6) = '30-34 Operations on the Respiratory System'
 chapcm( 7) = '35-39 Operations on the Cardiovascular System'
 chapcm( 8) = '40-41 Operations on the Hemic and Lymphatic System'
 chapcm( 9) = '42-54 Operations on the Digestive System'
 chapcm( 10) = '55-59 Operations on the Urinary System'
 chapcm( 11) = '60-64 Operations on the Male Genital Organs'
 chapcm( 12) = '65-71 Operations on the Female Genital Organs'
 chapcm( 13) = '72-75 Obstetrical Procedures'
 chapcm( 14) = '76-84 Operations on the Musculoskeletal System'
 chapcm( 15) = '85-86 Operations on the Integumentary System'
 chapcm( 16) = '87-99 Miscellaneous Diagnostic and Therapeutic Procedures'
 DIMENSION icdmenu( 3)
 icdmenu( 1) = 'ICD-10'
 icdmenu( 2) = 'ICD-9-CM'
 icdmenu( 3) = 'Exit'
 DO WHILE .T.
    DEFINE WINDOW ask FROM 5, 5 TO 11, 35 SHADOW
    ACTIVATE WINDOW ask
    @ 0, 0 SAY PADC(' เลือกค้นหาจาก', WCOLS(), ' ') COLOR W+/BG
    @ 1, 0 SAY REPLICATE('', WCOLS())
    choice = 1
    FOR i = 1 TO ALEN(icdmenu)
       @ i+1, 0 PROMPT PADC(icdmenu(i), WCOLS(), ' ') COLOR SCHEME 9
    ENDFOR
    MENU TO choice
    RELEASE WINDOW ask
    DO CASE
       CASE choice=1
          DO chap10
       CASE choice=2
          DO chapcm
       CASE choice=3
          EXIT
    ENDCASE
 ENDDO
 CLOSE ALL
 RETURN
*
PROCEDURE chap10
 DEFINE WINDOW indexlist FROM 2, 5 TO 14, 75 SHADOW DOUBLE
 ACTIVATE WINDOW indexlist
 ON KEY LABEL rightarrow ??CHR(7)
 ON KEY LABEL leftarrow ??CHR(7)
 CLEAR
 mchoice = ''
 @ 0, 0 GET mchoice SIZE 15, 69 FROM chap10 COLOR SCHEME 9
 KEYBOARD '{Home}'
 READ
 RELEASE WINDOW indexlist
 cstart = SUBSTR(mchoice, 1, 3)
 cend = SUBSTR(mchoice, 5, 3)
 SELECT index
 DEFINE POPUP subindex FROM 0, 0 TO 12, 70 COLOR SCHEME 9
 n = 1
 SCAN FOR BETWEEN(start, cstart, cend)
    IF  .NOT. EMPTY(text)
       DEFINE BAR n OF subindex PROMPT start+'-'+end+' * '+RTRIM(name)
    ELSE
       DEFINE BAR n OF subindex PROMPT start+'-'+end+'   '+RTRIM(name)
    ENDIF
    n = n+1
 ENDSCAN
 DEFINE WINDOW shwidx FROM 1, 4 TO 15, 76 SHADOW FOOTER ' F2 = รายละเอียดเพิ่มเติม  -,- = Exit '
 ACTIVATE WINDOW shwidx
 ON KEY LABEL rightarrow
 ON KEY LABEL leftarrow
 ON KEY LABEL f2 DO shwidxmemo WITH PROMPT()
 ON SELECTION POPUP subindex DO sele_sub WITH PROMPT()
 mkey = 27
 DO WHILE mkey=27 .AND. n>0
    ACTIVATE POPUP subindex
    mkey = LASTKEY()
 ENDDO
 DEACTIVATE POPUP subindex
 ON KEY LABEL f2
 RELEASE WINDOW shwidx
 RETURN
*
FUNCTION sele_sub
 PARAMETER mtext
 mstart = SUBSTR(mtext, 1, 3)
 mend = SUBSTR(mtext, 5, 3)
 _code = mstart
 SELECT icd101
 SET ORDER TO code
 DEFINE POPUP shwgrp FROM 0, 0 TO 12, 70 COLOR SCHEME 9
 num = 1
 SCAN FOR BETWEEN(code, mstart, mend) .AND. LEN(RTRIM(code))=3
    IF  .NOT. EMPTY(text)
       DEFINE BAR num OF shwgrp PROMPT code+' * '+RTRIM(desc)
    ELSE
       DEFINE BAR num OF shwgrp PROMPT code+'   '+RTRIM(desc)
    ENDIF
    num = num+1
 ENDSCAN
 DEFINE WINDOW shwgroup FROM 1, 4 TO 15, 76 SHADOW FOOTER ' F2 = รายละเอียดเพิ่มเติม  -,- = Back '
 ACTIVATE WINDOW shwgroup
 keyf2 = ON('KEY', 'F2')
 ON KEY LABEL f2 DO shwgrpmemo WITH PROMPT()
 ON SELECTION POPUP shwgrp DO sele_grp WITH PROMPT()
 mkey = 27
 DO WHILE mkey=27 .AND. n>0
    ACTIVATE POPUP shwgrp
    mkey = LASTKEY()
 ENDDO
 ON KEY LABEL f2 &keyf2
 RELEASE WINDOW shwgroup
 RETURN _code
*
FUNCTION sele_grp
 PARAMETER mtext1
 mstart = SUBSTR(mtext1, 1, 3)
 _code = mstart
 SELECT icd101
 SET ORDER TO code
 DEFINE POPUP shwicd FROM 0, 0 TO 12, 70 COLOR SCHEME 9
 SEEK (mstart)
 num = 1
 IF  .NOT. EMPTY(text)
    DEFINE BAR num OF shwicd PROMPT code+' * '+desc
 ELSE
    DEFINE BAR num OF shwicd PROMPT code+'   '+desc
 ENDIF
 num = num+1
 FOR i = 0 TO 9
    IF SEEK(mstart+ALLTRIM(STR(i)))
       IF  .NOT. EMPTY(text)
          DEFINE BAR num OF shwicd PROMPT code+' * '+desc
       ELSE
          DEFINE BAR num OF shwicd PROMPT code+'   '+desc
       ENDIF
       num = num+1
    ENDIF
 ENDFOR
 DEFINE WINDOW shwcode FROM 1, 4 TO 15, 76 SHADOW FOOTER ' F2 = รายละเอียดเพิ่มเติม  -,- = Back '
 ACTIVATE WINDOW shwcode
 keyf2 = ON('KEY', 'F2')
 ON KEY LABEL f2 DO shwicdmemo WITH PROMPT()
 ON SELECTION POPUP shwicd DO sele_icd WITH PROMPT()
 mkey = 27
 DO WHILE mkey=27 .AND. n>0
    ACTIVATE POPUP shwicd
    mkey = LASTKEY()
 ENDDO
 ON KEY LABEL f2 &keyf2
 RELEASE WINDOW shwcode
 RETURN _code
*
FUNCTION sele_icd
 PARAMETER mcode
 _code = SUBSTR(mcode, 1, 4)
 RETURN _code
*
PROCEDURE shwidxmemo
 PARAMETER mtext
 mstart = SUBSTR(mtext, 1, 3)
 SELECT index
 SET ORDER TO start
 SEEK (mstart)
 ON KEY LABEL f2
 DEFINE WINDOW showtext FROM 17, 4 TO 23, 76 SHADOW TITLE '  INFO  ' COLOR W+/RB
 IF EMPTY(text)
    ON KEY LABEL f2 DO shwidxmemo WITH PROMPT()
    RETURN
 ELSE
    ACTIVATE WINDOW showtext
    MODIFY MEMO text NOEDIT WINDOW showtext
 ENDIF
 RELEASE WINDOW showtext
 ON KEY LABEL f2 DO shwidxmemo WITH PROMPT()
 RETURN
*
PROCEDURE shwgrpmemo
 PARAMETER mtext
 mstart = SUBSTR(mtext, 1, 3)
 SELECT icd101
 SET ORDER TO code
 SEEK (mstart)
 ON KEY LABEL f2
 DEFINE WINDOW showtext FROM 17, 4 TO 23, 76 SHADOW TITLE '  INFO  ' COLOR W+/RB
 IF EMPTY(text)
    ON KEY LABEL f2 DO shwgrpmemo WITH PROMPT()
    RETURN
 ELSE
    ACTIVATE WINDOW showtext
    MODIFY MEMO text NOEDIT WINDOW showtext
 ENDIF
 RELEASE WINDOW showtext
 ON KEY LABEL f2 DO shwgrpmemo WITH PROMPT()
 RETURN
*
PROCEDURE shwicdmemo
 PARAMETER mtext
 mstart = SUBSTR(mtext, 1, 4)
 SELECT icd101
 SET ORDER TO code
 SEEK (mstart)
 ON KEY LABEL f2
 DEFINE WINDOW showtext FROM 17, 4 TO 23, 76 SHADOW TITLE '  INFO  ' COLOR W+/RB
 IF EMPTY(text)
    ON KEY LABEL f2 DO shwicdmemo WITH PROMPT()
    RETURN
 ELSE
    ACTIVATE WINDOW showtext
    MODIFY MEMO text NOEDIT WINDOW showtext
 ENDIF
 RELEASE WINDOW showtext
 ON KEY LABEL f2 DO shwicdmemo WITH PROMPT()
 RETURN
*
FUNCTION chapcm
 DEFINE WINDOW indexlist FROM 2, 5 TO 14, 75 SHADOW DOUBLE
 ACTIVATE WINDOW indexlist
 ON KEY LABEL rightarrow ??CHR(7)
 ON KEY LABEL leftarrow ??CHR(7)
 CLEAR
 mchoice = ''
 @ 0, 0 GET mchoice SIZE 15, 69 FROM chapcm COLOR SCHEME 9
 KEYBOARD '{Home}'
 READ
 ON KEY LABEL rightarrow
 ON KEY LABEL leftarrow
 RELEASE WINDOW indexlist
 cstart = SUBSTR(mchoice, 1, 2)+'0'
 cend = SUBSTR(mchoice, 4, 2)+'9'
 _code = cstart
 SELECT icdcm1
 SET ORDER TO code
 DEFINE POPUP shwcm FROM 0, 0 TO 12, 70 COLOR SCHEME 9
 num = 1
 SCAN FOR BETWEEN(code, cstart, cend) .AND. LEN(RTRIM(code))=3
    DEFINE BAR num OF shwcm PROMPT code+' '+RTRIM(desc)
    num = num+1
 ENDSCAN
 DEFINE WINDOW shwcm1 FROM 1, 4 TO 15, 76 SHADOW FOOTER ' Enter = select   -,- = Exit '
 ACTIVATE WINDOW shwcm1
 ON SELECTION POPUP shwcm DO sele_cm1 WITH PROMPT()
 mkey = 27
 DO WHILE mkey=27 .AND. num>0
    ACTIVATE POPUP shwcm
    mkey = LASTKEY()
 ENDDO
 RELEASE WINDOW shwcm1
 RETURN _code
*
PROCEDURE sele_cm1
 PARAMETER cmtext
 cmcode = SUBSTR(cmtext, 1, 3)
 _code = cmcode
 SELECT icdcm1
 SET ORDER TO code
 DEFINE POPUP shwcode FROM 0, 0 TO 12, 70 COLOR SCHEME 9
 num = 1
 SEEK (cmcode)
 DEFINE BAR 1 OF shwcode PROMPT code+' '+desc
 num = num+1
 FOR i = 0 TO 9
    IF SEEK(cmcode+ALLTRIM(STR(i)))
       DEFINE BAR num OF shwcode PROMPT code+' '+desc
       num = num+1
    ENDIF
 ENDFOR
 DEFINE WINDOW shwcm2 FROM 1, 4 TO 15, 76 SHADOW FOOTER ' -,- = Back '
 ACTIVATE WINDOW shwcm2
 ON SELECTION POPUP shwcode DO sele_cm2 WITH PROMPT()
 mkey = 27
 DO WHILE mkey=27 .AND. num>0
    ACTIVATE POPUP shwcode
    mkey = LASTKEY()
 ENDDO
 RELEASE WINDOW shwcm2
 RETURN TO chapcm
*
FUNCTION sele_cm2
 PARAMETER mcode
 _code = mcode
 RETURN _code
*
