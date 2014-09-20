 PARAMETER vname
 ON KEY LABEL f1 ??CHR(7)
 SET TALK OFF
 lastwin = WLAST()
 oldarea = SELECT()
 DO CASE
    CASE SUBSTR(vname, 1, 4)='DIAG' .OR. SUBSTR(vname, 1, 4)='CAUS'
       WAIT WINDOW TIMEOUT 1 'NO help available'
       ON KEY LABEL f1 DO mhelp WITH VARREAD()
       RETURN
    CASE SUBSTR(vname, 1, 4)='PROC'
       WAIT WINDOW TIMEOUT 1 'NO help available'
       ON KEY LABEL f1 DO mhelp WITH VARREAD()
       RETURN
    CASE SUBSTR(vname, 1, 4)='IMM' .OR. SUBSTR(vname, 1, 4)='ANTE'
       WAIT WINDOW TIMEOUT 1 'NO help available'
       ON KEY LABEL f1 DO mhelp WITH VARREAD()
       RETURN
    CASE ALLTRIM(vname)='DROP' .OR. ALLTRIM(vname)='DR1' .OR. SUBSTR(vname, 1, 8)='OPERATE('
       vsearch = 'DR  '
    CASE SUBSTR(vname, 1, 6)='HOSPTY'
       vsearch = 'XXXX'
    CASE SUBSTR(vname, 1, 5)='HOSPM' .OR. SUBSTR(vname, 1, 6)='MHOSPM'
       vsearch = 'MAIN'
    CASE SUBSTR(vname, 1, 5)='HOSPC' .OR. SUBSTR(vname, 1, 6)='MHOSPC'
       vsearch = 'CARE'
    CASE SUBSTR(vname, 1, 5)='HOSPT'
       vsearch = 'CARE'
    OTHERWISE
       vsearch = vname
 ENDCASE
 IF USED('codefile')
    SELECT codefile
    SET ORDER TO
    SET FILTER TO
 ELSE
    SELECT 25
    USE lib\codefile
    SET ORDER TO
    SET FILTER TO
 ENDIF
 IF WEXIST('helpwin')
    ACTIVATE WINDOW helpwin
    CLEAR
 ELSE
    DEFINE WINDOW helpwin FROM 5, 10 TO 15, 70 SHADOW NONE
    DEFINE POPUP helppop FROM 0, 0 TO 10, 59 PROMPT FIELDS SUBSTR(name, 1, 35)+code MARGIN COLOR N/W
 ENDIF
 SELECT codefile
 SET ORDER TO varname
 IF  .NOT. SEEK(SUBSTR(vsearch, 1, 4))
    ? CHR(7)+CHR(7)
    WAIT WINDOW TIMEOUT 1 'ไม่มีตัวเลือกอยู่ในระบบ'
    DEACTIVATE WINDOW helpwin
    ON KEY LABEL f1 DO mhelp WITH VARREAD()
    SELECT (oldarea)
    RETURN 0
 ENDIF
 ON KEY LABEL pgup
 SET FILTER TO varname=SUBSTR(vsearch, 1, 4)
 SET ORDER TO name
 ACTIVATE WINDOW helpwin
 choice2 = ''
 @ 0, 0 GET choice2 POPUP helppop
 KEYBOARD '{HOME}'
 READ
 CLEAR
 RELEASE WINDOW helpwin
 &vname=RTRIM(SUBSTR(choice2,36))
 IF SUBSTR(vname, 1, 8)='OPERATE('
    SHOW GET &vname
 ELSE
    SHOW GET m.&vname
 ENDIF
 SET FILTER TO
 KEYBOARD '{Enter}'
 ON KEY LABEL f1 DO mhelp WITH VARREAD()
 SELECT (oldarea)
 RETURN 1
*
