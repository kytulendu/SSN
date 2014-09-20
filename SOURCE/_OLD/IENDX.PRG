 CLEAR
 SET TALK OFF
 SET SAFETY OFF
 CLOSE DATABASES
 SET EXCLUSIVE ON
 DEFINE WINDOW rendx FROM 5, 5 TO 20, 75 SHADOW TITLE 'Creating Index Files'
 ACTIVATE WINDOW rendx
 DIMENSION clr( 4)
 clr( 1) = 'w+/b'
 clr( 2) = 'g+/b'
 clr( 3) = 'gr+/b'
 clr( 4) = 'r+/b'
 n = 1
 SELECT 0
 USE lib\icd101
 @ n, 15 SAY 'Indexing file : ICD101.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icd101.cdx')
    DELETE FILE lib\icd101.cdx
 ENDIF
 INDEX ON code TAG code
 n = n+1
 USE lib\icd102
 @ n, 15 SAY 'Indexing file : ICD102.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icd102.cdx')
    DELETE FILE lib\icd102.cdx
 ENDIF
 INDEX ON kwcode TAG kwcode
 INDEX ON code TAG code
 n = n+1
 USE lib\icd103
 @ n, 15 SAY 'Indexing file : ICD103.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icd103.cdx')
    DELETE FILE lib\icd103.cdx
 ENDIF
 INDEX ON kwcode TAG kwcode
 INDEX ON UPPER(desc) TAG desc
 n = n+1
 USE lib\icdcm1
 @ n, 15 SAY 'Indexing file : ICDCM1.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icdcm1.cdx')
    DELETE FILE lib\icdcm1.cdx
 ENDIF
 INDEX ON code TAG code
 n = n+1
 USE lib\icdCM2
 @ n, 15 SAY 'Indexing file : ICDCM2.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icdcm2.cdx')
    DELETE FILE lib\icdcm2.cdx
 ENDIF
 INDEX ON kwcode TAG kwcode
 n = n+1
 USE lib\icdcm3
 @ n, 15 SAY 'Indexing file : ICDCM3.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\icdcm3.cdx')
    DELETE FILE lib\icdcm3.cdx
 ENDIF
 INDEX ON kwcode TAG kwcode
 INDEX ON UPPER(desc) TAG desc
 USE lib\index
 DELETE TAG all
 IF FILE('lib\index.cdx')
    DELETE FILE lib\index.cdx
 ENDIF
 INDEX ON start TAG start
 n = n+1
 USE lib\codefile
 @ n, 15 SAY 'Indexing file : CODEFILE.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\codefile.cdx')
    DELETE FILE lib\codefile.cdx
 ENDIF
 INDEX ON code TAG code
 INDEX ON name TAG name
 INDEX ON varname TAG varname
 n = n+1
 USE lib\hospcode
 @ n, 15 SAY 'Indexing file : HOSPCODE.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\hospcode.cdx')
    DELETE FILE lib\hospcode.cdx
 ENDIF
 INDEX ON SUBSTR(code, 5, 2) TAG code
 n = n+1
 USE lib\distcode
 @ n, 15 SAY 'Indexing file : DISTCODE.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\distcode.cdx')
    DELETE FILE lib\distcode.cdx
 ENDIF
 INDEX ON code TAG code
 n = n+1
 USE lib\provcode
 @ n, 15 SAY 'Indexing file : PROVCODE.DBF' COLOR (clr(MOD(n, 4)+1))
 DELETE TAG all
 IF FILE('lib\provcode.cdx')
    DELETE FILE lib\provcode.cdx
 ENDIF
 INDEX ON code TAG code
 n = n+1
 @ n, 15 SAY 'Indexing file : Patient Transactions files' COLOR (clr(MOD(n, 4)+1))
 USE data\iptrana
 DELETE TAG all
 IF FILE('data\iptrana.cdx')
    DELETE FILE data\iptrana.cdx
 ENDIF
 INDEX ON hn TAG hn
 INDEX ON an TAG an
 USE data\iptranc
 DELETE TAG all
 IF FILE('data\iptranc.cdx')
    DELETE FILE data\iptranc.cdx
 ENDIF
 INDEX ON an TAG an
 USE data\iptrand
 DELETE TAG all
 IF FILE('data\iptrand.cdx')
    DELETE FILE data\iptrand.cdx
 ENDIF
 INDEX ON hn TAG hn
 USE data\iptranf
 DELETE TAG all
 IF FILE('data\iptranf.cdx')
    DELETE FILE data\iptranf.cdx
 ENDIF
 INDEX ON an TAG an
 USE data\iptrano
 DELETE TAG all
 IF FILE('data\iptrano.cdx')
    DELETE FILE data\iptrano.cdx
 ENDIF
 INDEX ON an TAG an
 USE data\iptrans
 DELETE TAG all
 IF FILE('data\iptrans.cdx')
    DELETE FILE data\iptrans.cdx
 ENDIF
 INDEX ON hn TAG hn
 USE data\iptranx
 DELETE TAG all
 IF FILE('data\iptranx.cdx')
    DELETE FILE data\iptranx.cdx
 ENDIF
 INDEX ON an TAG an
 n = n+1
 @ n, 15 SAY 'Indexing file : Patient files' COLOR (clr(MOD(n, 4)+1))
 yy = STR(VAL(SUBSTR(DTOC(DATE()), 7, 2))+43-100, 2)
 target = 'data\ipa'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptrana
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON hn TAG hn
 INDEX ON an TAG an
 target = 'data\ipc'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptranc
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON an TAG an
 target = 'data\ipd'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptrand
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 USE (target)
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON hn TAG hn
 target = 'data\ipf'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptranf
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 USE (target)
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON an TAG an
 target = 'data\ipo'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptrano
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 USE (target)
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON an TAG an
 target = 'data\ips'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptrans
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 USE (target)
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON hn TAG hn
 target = 'data\ipx'+yy
 IF FILE(target)
    USE (target)
 ELSE
    USE data\iptranx
    COPY TO (target) STRUCTURE
    USE (target)
 ENDIF
 USE (target)
 cdxfile = target+'.cdx'
 DELETE TAG all
 IF FILE(cdxfile)
    DELETE FILE (cdxfile)
 ENDIF
 INDEX ON an TAG an
 USE rp\iptra
 DELETE TAG all
 IF FILE('rp\iptra.cdx')
    DELETE FILE rp\iptra.cdx
 ENDIF
 INDEX ON hospcare TAG hospcare
 INDEX ON pttyp TAG pttyp
 USE
 WAIT WINDOW TIMEOUT 1 'COMPLETED'
 RELEASE WINDOW rendx
 SET SAFETY ON
 SET EXCLUSIVE OFF
*