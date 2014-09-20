 SET TALK OFF
 SET DATE british
 = INSMODE(.F.)
 RESTORE FROM hosp ADDITIVE
 ON KEY LABEL f1 do mhelp with varread()
 bdd = '01'
 bmm = SUBSTR(DTOC(DATE()), 4, 2)
 byy = STR(VAL(SUBSTR(DTOC(DATE()), 7, 2))+1990+543, 4)
 dd = '01'
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
 pttyp = '11'
 hospm = hospcode
 hospc = hospcode
 dg1 = SPACE(5)
 cause = SPACE(5)
 dg2 = 'N'
 op1 = SPACE(5)
 op2 = 'N'
 dop1 = dd+'/'+mm+'/'+yy
 drop = '99999'
 dr = '99999'
 mssn = '99-       - '
 mfacn = '99'+SPACE(14)
 mhn = 0
 man = 0
 addr1 = '9999  '
 hnyy = '00'
 anyy = '00'
 ans = '1'
 mage = '00'
 dcstatus = '2'
 dctype = '1'
 DIMENSION wmenu( 3)
 wmenu( 1) = ' บันทึกรายต่อไป '
 wmenu( 2) = ' กลับรายการหลัก '
 wmenu( 3) = '     แก้ไข      '
 DIMENSION diag( 1, 4)
 DIMENSION operate( 4, 6)
 SELECT 1
 USE data\iptrans
 SCATTER BLANK MEMVAR
 SELECT 2
 USE data\iptrand
 SCATTER BLANK MEMVAR
 SELECT 3
 USE data\iptrana
 SCATTER BLANK MEMVAR
 SELECT 4
 USE data\iptranc
 SCATTER BLANK MEMVAR
 SELECT 5
 USE data\iptranf
 SCATTER BLANK TO finance
 SELECT 6
 USE data\iptranx
 SCATTER BLANK TO diag
 SELECT 7
 USE data\iptrano
 SCATTER BLANK TO operate
 SELECT 25
 USE lib\codefile ORDER code
 SELECT 11
 USE lib\icd101 ORDER code
 SELECT 12
 USE lib\icd102 ORDER kwcode
 SELECT 13
 USE lib\icd103 ORDER kwcode
 SELECT 14
 USE lib\icdcm1 ORDER code
 SELECT 15
 USE lib\icdcm2 ORDER kwcode
 SELECT 16
 USE lib\icdcm3 ORDER kwcode
 SELECT 18
 USE rp\pttyp
 DIMENSION finance( 16, 4)
 DEFINE WINDOW ip1 FROM 0, 0 TO 22, 79
 DEFINE WINDOW expense FROM 1, 1 TO 24, 80
 HIDE WINDOW ALL
 ACTIVATE SCREEN
 DO g1 WITH '1'
 CLEAR
 CLOSE DATABASES
 RELEASE WINDOW expense
 RELEASE WINDOW ip1
 ON KEY LABEL f1
 = INSMODE(.T.)
 CLEAR
 RETURN
*
