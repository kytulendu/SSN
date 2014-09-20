 PARAMETER prog, line, emsg1, errnum, emsg
 SET DATE british
 DO CASE
    CASE ERROR()=125
       DEFINE WINDOW errmsg FROM 8, 15 TO 14, 65 SHADOW
       ACTIVATE WINDOW errmsg
       msg1 = 'Printer NOT ready!'
       choice = 1
       ?? CHR(7)
       @ 1, (WCOLS()-LEN(msg1))/2 SAY msg1 COLOR GR+/B
       @ 3, (WCOLS()-29)/2 GET choice SIZE 1, 12, 5 FUNCTION '*H Retry;\?Cancel'
       READ
       IF choice=1
          RETRY
       ELSE
          RELEASE WINDOW errmsg
          return to &prog
       ENDIF
    CASE ERROR()=1102 .OR. ERROR()=1157
       DEFINE WINDOW errmsg FROM 8, 15 TO 14, 65 SHADOW
       ACTIVATE WINDOW errmsg
       msg1 = 'Error in creating/updating file'
       msg2 = 'Possible disk full or write failure'
       choice = 1
       ?? CHR(7)
       @ 1, (WCOLS()-LEN(msg1))/2 SAY msg1 COLOR GR+/B
       @ 2, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
       @ 3, (WCOLS()-29)/2 GET choice SIZE 1, 12, 5 FUNCTION '*H Retry;\?Cancel'
       READ
       IF choice=1
          RETRY
       ELSE
          RELEASE WINDOW errmsg
          return to &prog
       ENDIF
    CASE ERROR()=1104
       DEFINE WINDOW errmsg FROM 8, 15 TO 14, 65 SHADOW
       ACTIVATE WINDOW errmsg
       msg1 = 'File read error!'
       choice = 1
       ?? CHR(7)
       @ 1, (WCOLS()-LEN(msg1))/2 SAY msg1 COLOR GR+/B
       @ 3, (WCOLS()-29)/2 GET choice SIZE 1, 12, 5 FUNCTION '*H Retry;\?Cancel'
       READ
       IF choice=1
          RETRY
       ELSE
          RELEASE WINDOW errmsg
          return to &prog
       ENDIF
    CASE ERROR()=1105
       DEFINE WINDOW errmsg FROM 8, 12 TO 14, 68 SHADOW
       ACTIVATE WINDOW errmsg
       msg1 = 'Error writing file'
       msg2 = 'Possible attempt to write to a write-protected disk'
       choice = 1
       ?? CHR(7)
       @ 1, (WCOLS()-LEN(msg1))/2 SAY msg1 COLOR GR+/B
       @ 2, (WCOLS()-LEN(msg2))/2 SAY msg2 COLOR G+/B
       @ 3, (WCOLS()-29)/2 GET choice SIZE 1, 12, 5 FUNCTION '*H Retry;\?Cancel'
       READ
       IF choice=1
          RETRY
       ELSE
          RELEASE WINDOW errmsg
          return to &prog
       ENDIF
    OTHERWISE
       DIMENSION err( 7)
       err( 1) = prog
       err( 2) = line
       err( 3) = emsg1
       err( 4) = errnum
       err( 5) = emsg
       err( 6) = DATE()
       err( 7) = TIME()
       INSERT INTO (m.errfile) FROM ARRAY err
       RELEASE err
       return to &prog
 ENDCASE
*
