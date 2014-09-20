*:*****************************************************************************
*:
*: Procedure file: C:\SSN24\RPFILES.PRG
*:
*:         System: Ssn
*:         Author: Thierawat Jittnoon
*:      Copyright (c) 1998, 10
*:  Last modified: 08/21/98     10:33
*:
*:         Set by: MAIN.PRG                          
*:               : MAIN.PRG                          
*:
*:           Uses: IPTMPLT1.DBF       
*:               : DEATH.DBF              Alias: DEATH
*:               : CODEFILE.DBF       
*:               : INSURER.DBF        
*:               : ERRLOG.DBF         
*:               : REFER.DBF          
*:               : MOBILE.DBF         
*:
*:   Memory Files: HOSP.MEM
*:
*:    Other Files: TARGET
*:
*:      Documented 08/24/98 at 17:12               FoxDoc  version 2.10f
*:*****************************************************************************
SET TALK OFF
SET SAFETY OFF
SET DATE BRITISH
SET EXCLUSIVE ON

HIDE WINDOW ALL
RESTORE FROM hosp ADDITIVE

tmm=month(Date())-1
If tmm < 10
rmm=Alltrim("0"+Alltrim(Str(tmm)))
Else
rmm = Alltrim(Str(tmm))
Endif

ryy=STR(VAL(SUBSTR(DTOC(DATE()),7,2))+1900+543-2500,2)
dest='A'
pass1='Creating : OP data file'
pass2='Creating : IP data file'
pass3='Creating : Hospital code file'
pass4='Creating : Doctor code file'
pass5='Creating : Insurer file'
pass6='Creating : Refer cases file'
*Pass7='Creating : Resource Utilization'
pass7='COMPLETE'

DEFINE WINDOW rp1 FROM 6,15 TO 18,65 SHADOW
ACTIVATE WINDOW rp1
hdr='ส่งรายงานส่วนกลาง'
@ 0,(WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B
DO WHILE .T.
   @ 2,2 SAY 'ส่งรายงานของเดือน '
   @ 2,21 GET rmm PICTURE '99' VALID BETWEEN(VAL(rmm),1,12)
   @ 2,24 SAY 'พ.ศ.25'
   @ 2,30 GET ryy PICTURE '99'
   @ 4,2 SAY 'เขียนแฟ้มรายงานที่ Drive : '
   @ 4,30 GET dest PICTURE 'A' VALID dest$'ABab'
   READ
   
   DO CASE
   CASE  VAL(ryy) > VAL(RIGHT(STR(YEAR(DATE())+543),2))
      ?CHR(7)
      WAIT WINDOW "กรุณากรอกปีที่ถูกต้อง" TIMEOUT 2
      LOOP
      
   CASE VAL(ryy) = VAL(RIGHT(STR(YEAR(DATE())+543),2))
      IF VAL(rmm)>MONTH(DATE())
         ?CHR(7)
         WAIT WINDOW "กรุณากรอกเดือนที่ถูกต้อง" TIMEOUT 2
         LOOP
      ELSE
         EXIT
      ENDIF
      
   CASE VAL(ryy)<34
      ?CHR(7)
      WAIT WINDOW "กรุณากรอกปีที่ถูกต้อง" TIMEOUT 2
      LOOP
   OTHERWISE
      EXIT
   ENDCASE
   IF READKEY()=12 OR READKEY()=268
      CLEAR
      RELEASE WINDOW rp1
      SET EXCLUSIVE OFF
      RETURN
   ENDIF
ENDDO
IF READKEY()=12 OR READKEY()=268
   CLEAR
   RELEASE WINDOW rp1
   SET EXCLUSIVE OFF
   RETURN
ENDIF

fname='data\ip'+ryy+rmm+'.dbf'
IF FILE(fname)
   DEFINE WINDOW sent FROM 6,8 TO 17,72 SHADOW
   ACTIVATE WINDOW sent
   ?? CHR(7)
   @ 0,0 SAY PADC('ข้อมูลส่งไปแล้ว',WCOLS(),' ') COLOR GR+/R
   @ 2,2 SAY 'ข้อมูลของเดือน  '+rmm+'/'+ryy+' ได้ส่งไปแล้ว'
   @ 3,2 SAY 'ไม่สามารถส่งซ้ำได้อีก สำหรับข้อมูลที่มีเพิ่ม ขอให้ส่งรวมไปกับ'
   @ 4,2 SAY 'แฟ้มข้อมูลเดือนถัดไป'
   @ 6,2 SAY 'ถ้าต้องการส่งข้อมูลเดิมซ้ำ ขอให้ copy จากแฟ้มข้อมูล'
   @ 7,2 SAY '\SSN24\DATA\IP'+ryy+rmm+'.DBF และ OP'+ryy+rmm+'.DBF' COLOR GR+/B
   @ 9,0 SAY PADC('Press a key to continue... ',WCOLS(),' ')
   WAIT '' WINDOW
   RELEASE WINDOW rp1
   RELEASE WINDOW sent
   RETURN
ENDIF

tmpdest='sstemp'
CLEAR
hdr='จัดทำแฟ้มรายงาน โปรดรอสักครู่'
@ 0,(WCOLS()-LEN(hdr))/2 SAY hdr COLOR GR+/B

SELECT 1
TARGET='data\ips'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   SET FILTER TO ssn<>" "
   ssr ='ips'+ryy
ENDIF

SELECT 2
TARGET='data\ipd'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   * SET FILTER TO hn= &Ssr..hn
ENDIF
SELECT 3
TARGET='data\ipa'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   * SET FILTER TO hn= &Ssr..hn
   sss='ipa'+ryy
ENDIF
SELECT 4
TARGET='data\ipc'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   *	SET FILTER TO an= &Sss..an
ENDIF

SELECT 5
TARGET='data\ipf'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   *  SET FILTER TO an= &Sss..an
ENDIF

SELECT 6
TARGET='data\ipx'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   *	SET FILTER TO an= &Sss..an
ENDIF

SELECT 7
TARGET='data\ipo'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   *	SET FILTER TO an= &Sss..an
ENDIF

SELECT 8
TARGET='data\op'+ryy+'.dbf'
IF !FILES(TARGET)
   @ 2,2 SAY 'ไม่พบแฟ้ม '+(TARGET)+'  กลับไปประมวลผลมาก่อน'
   WAIT '' WINDOW  TIMEOUT 2
   RELEASE WINDOW rp1
   RETURN
ELSE
   USE (TARGET)
   
   @ 2,(WCOLS()-LEN(pass1))/2 SAY pass1 COLOR GR+/B
   
   *** Creating Out Patient File : OPyymm.DBF
   SELECT 8
   TARGET=UPPER(tmpdest)+'\OP'+ryy+rmm+'.DBF'
   COPY STRUCTURE TO (TARGET)
   COPY TO (TARGET) FOR VAL(yymm) <= VAL(ryy+rmm)
   USE
ENDIF
@ 3,(WCOLS()-LEN(pass2))/2 SAY pass2 COLOR GR+/B

*** Creating In Patient File : IPyymm.DBF
SELECT 8
USE data\iptmplt1
SET FILTER TO pttyp ='11'
SCATTER MEMVAR BLANK
TARGET='ipc'+ryy
SELECT (TARGET)
set filter to VAl(alltrim(Left(datedsc,4)))<=val(ryy+rmm)
GO TOP
mhn=SPACE(9)
man=SPACE(8)
mhosp=SPACE(7)

DO WHILE NOT EOF(4)
   SCATTER MEMVAR
   man=m.an
   mhosp=m.hospcare
   TARGET='ipa'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR an=man AND hospcare=mhosp
   IF sent=.F.
      SCATTER MEMVAR
      mhn=m.hn
      m.sent=.T.
      GATHER MEMVAR
   ELSE
      TARGET='ipc'+ryy
      SELECT (TARGET)
      SKIP +1
      LOOP
   ENDIF
   TARGET='ips'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR hn=mhn AND hospcare=mhosp
   SCATTER MEMVAR
   TARGET='ipd'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR hn=mhn AND hospcare=mhosp
   SCATTER MEMVAR
   TARGET='ipx'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR an=man AND hospcare=mhosp
   SCATTER MEMVAR
   m.dg1=icd10
   CONTINUE
   IF FOUND()
      m.dg2=icd10
      CONTINUE
      IF FOUND()
         m.dg3=icd10
         CONTINUE
         IF FOUND()
            m.dg4=icd10
         ENDIF
      ENDIF
   ENDIF
   TARGET='ipo'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR an=man AND hospcare=mhosp
   SCATTER MEMVAR
   m.op1=icd9p
   m.dateop1=dateop
   m.drop1=drop
   CONTINUE
   IF FOUND()
      m.op2=icd9p
      m.dateop2=dateop
      m.drop2=drop
      CONTINUE
      IF FOUND()
         m.op3=icd9p
         m.dateop3=dateop
         m.drop3=drop
         CONTINUE
         IF FOUND()
            m.op4=icd9p
            m.dateop4=dateop
            m.drop4=drop
         ENDIF
      ENDIF
   ENDIF
   TARGET='ipf'+ryy
   SELECT (TARGET)
   GO TOP
   LOCATE FOR an=man AND hospcare=mhosp
   DO WHILE FOUND()
      temp=fincode
      m.&temp=charge
      CONTINUE
   ENDDO
   m.hospcare=mhosp
   m.an=man
   m.hn=mhn
   m.hospmain=hospcode
   INSERT INTO data\iptmplt1 FROM MEMVAR
   SELECT 8
   SCATTER MEMVAR BLANK
   TARGET='ipc'+ryy
   SELECT (TARGET)
   SKIP +1
ENDDO
SELECT 8
COPY STRUC TO 'data\IP'+ryy+rmm+'.DBF'

SELE 9
USE 'data\IP'+ryy+rmm+'.DBF'
ZAP
APPEND FROM  data\iptmplt1.dbf

SELE 8
USE
TARGET=UPPER(tmpdest)+'\IP'+ryy+rmm+'.DBF'
COPY FILE data\iptmplt1.dbf TO (TARGET)


SELECT 8
USE data\iptmplt1
ZAP
USE
TARGET=UPPER(tmpdest)+'\DEAD'+ryy+'.DBF'
COPY FILE data\death.dbf TO (TARGET) FOR SUBSTR(datedsc,1,2)<=ryy


CLOSE DATABASE
SELECT 25
USE lib\codefile ORDER TAG code

@ 4,(WCOLS()-LEN(pass3))/2 SAY pass3 COLOR GR+/B
TARGET=UPPER(tmpdest)+'\HOSPCODE.DBF'
COPY STRUCTURE TO (TARGET) FIELD code,name
COPY TO (TARGET) ALL FOR varname='CARE'

@ 5,(WCOLS()-LEN(pass4))/2 SAY pass4 COLOR GR+/B
TARGET=UPPER(tmpdest)+'\DOCCODE.DBF'
COPY STRUCTURE TO (TARGET) FIELD code,name
COPY TO (TARGET) ALL FOR varname='DR'
USE

@ 6,(WCOLS()-LEN(pass5))/2 SAY pass5 COLOR GR+/B
SELECT 0
USE data\insurer
TARGET=UPPER(tmpdest)+'\INSURER.DBF'
COPY TO (TARGET)
USE

SELECT 0
USE data\errlog
TARGET=UPPER(tmpdest)+'\ERRLOG.DBF'
COPY TO (TARGET)
ZAP
USE

@ 7,(WCOLS()-LEN(pass6))/2 SAY pass6 COLOR GR+/B
SELECT 0
USE data\refer
TARGET=UPPER(tmpdest)+'\REFER'+ryy+'.DBF'
COPY TO (TARGET) ALL FOR SUBSTR(yymm,1,2)<=ryy
USE data\mobile
TARGET=UPPER(tmpdest)+'\MOBILE'+ryy+'.DBF'
COPY TO (TARGET) FOR SUBSTR(DATE,7,2)<=ryy
USE

*@ 8,(wcols()-len(Pass7))/2 say Pass7 color gr+/b
*select 0
*use data\finance
*target=upper(tmpdest)+'\FINANCE.DBF'
*copy to (target) for yymm=ryy+rmm
*use data\resrc1
*target=upper(tmpdest)+'\RESRC1.DBF'
*copy to (target) for yymm=ryy+rmm
*use

IF UPPER(dest)='A'
   WAIT 'กำลัง ZIP files.... โปรดรอสักครู่' WINDOW TIMEOUT 0.5
   RUN FOXSWAP /256k pkzip -ap A:REPORT sstemp\*.* >nul
   RUN del sstemp\*.dbf >nul
ENDIF

IF UPPER(dest)='B'
   WAIT 'กำลัง ZIP files.... โปรดรอสักครู่' WINDOW TIMEOUT 0.5
   RUN FOXSWAP /256k pkzip -ap B:REPORT sstemp\*.* >nul
   RUN del sstemp\*.dbf >nul
ENDIF



*************** STAMPING HOSPITAL NAME
TARGET=UPPER(dest)+':\'+SUBSTR(hospcode,1,8)+'.'+SUBSTR(hospcode,9,3)
handle=FCREATE(TARGET)
=FWRITE(handle,hospname)
=FCLOSE(handle)

*@ 9,(wcols()-len(Pass8))/2 say Pass8 color gr+/b
@ 9,(WCOLS()-LEN(pass7))/2 SAY pass7 COLOR GR+/B

WAIT '' WINDOW TIMEOUT 1
RELEASE WINDOW rp1
CLOSE DATA
SET EXCLUSIVE OFF
RETURN TO main
*: EOF: RPFILES.PRG
