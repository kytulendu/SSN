 SET PROCEDURE TO ptrp
 SET DATE BRITISH
 SET SAFETY OFF
 SET ECHO OFF
 SET TALK OFF
 SET EXCLUSIVE ON
 PUBLIC myy
 STORE SPACE(1) TO mans
 STORE SPACE(2) TO myy
 STORE 0 TO mins, mno
 CLOSE DATABASES
 DELETE FILE rp\iptran.dbf
 RESTORE FROM hosp ADDITIVE
 oldpath = SYS(5)+SYS(2003)+'\'
 defapath = oldpath+'\rp\'
 SET DEFAULT TO (defapath)
 SELECT 1
 target = oldpath+'lib\icdcm1'
 USE (target)
 SELECT 2
 target = oldpath+'lib\icd101'
 USE (target)
 SELECT 3
 target = oldpath+'rp\iptra'
 USE (target)
 DEFINE WINDOW ptrp FROM 0, 0 TO 22, 79
 DEFINE WINDOW ip1 FROM 13, 45 TO 17, 70 SHADOW
 DEFINE WINDOW p_type FROM 13, 45 TO 17, 64 SHADOW
 DIMENSION p_type( 3)
 p_type( 1) = ' รายงานเครือข่าย '
 p_type( 2) = ' รายงานโรงพยาบาล '
 p_type( 3) = ' กลับเมนูเดิม    '
 DEFINE WINDOW c_p FROM 13, 45 TO 17, 64 SHADOW
 DIMENSION c_p( 3)
 c_p( 1) = ' พิมพ์รายงาน     '
 c_p( 2) = ' เลือกดูทางจอภาพ '
 c_p( 3) = ' กลับเมนูเดิม    '
 DEFINE WINDOW ip2 FROM 13, 45 TO 17, 70 SHADOW
 DIMENSION ip2( 3)
 ip2( 1) = ' พิมพ์ทุกรายงาน         '
 ip2( 2) = ' เลือกพิมพ์เฉพาะรายงาน  '
 ip2( 3) = ' กลับเมนูเดิม           '
 DEFINE WINDOW ip3 FROM 15, 45 TO 19, 71 SHADOW
 DIMENSION ip3( 3)
 ip3( 1) = ' พิมพ์รายงานผู้ป่วยนอก  '
 ip3( 2) = ' พิมพ์รายงานผู้ป่วยใน   '
 ip3( 3) = ' กลับเมนูเดิม           '
 DEFINE WINDOW ipo FROM 16, 36 TO 22, 77 SHADOW
 DIMENSION ipo( 5)
 ipo( 1) = ' จำนวน & ค่ารักษา จำแนกตามโรงพยาบาล    '
 ipo( 2) = ' จำนวน & ค่ารักษา จำแนกตามแผนก         '
 ipo( 3) = ' จำนวน & ค่ารักษา จำแนกตามการชันสูตร  '
 ipo( 4) = ' จำนวน & ค่ารักษา จำแนกตามบริการ      '
 ipo( 5) = ' กลับเมนูหลัก                          '
 DEFINE WINDOW ipi FROM 9, 35 TO 22, 77 SHADOW
 DIMENSION ipi( 12)
 ipi( 1) = ' โรคที่มีวันนอนสูงสุด 10 อันดับแรก   '
 ipi( 2) = ' จำนวนผู้ป่วยสูงสุด 10 อันดับแรก     '
 ipi( 3) = ' จำนวนผู้ป่วย จำแนกตามกลุ่มโรด ICD 10  '
 ipi( 4) = ' จำนวน & วันนอน จำแนกตามแผนก             '
 ipi( 5) = ' จำนวน & ค่ารักษา จำแนกตามโรงพยาบาล      '
 ipi( 6) = ' จำนวน & ค่ารักษา จำแนกตามแผนก           '
 ipi( 7) = ' จำนวน & ค่ารักษา จำแนกตามสถานประกอบการ  '
 ipi( 8) = ' จำนวน & ค่ารักษา จำแนกตามการวินิจฉัย    '
 ipi( 9) = ' จำนวน & ค่ารักษา จำแนกตามการผ่าตัด      '
 ipi( 10) = ' จำนวน & ค่ารักษา จำแนกตามการชันสูตร     '
 ipi( 11) = ' จำนวน & ค่ารักษา จำแนกตามบริการ         '
 ipi( 12) = ' กลับเมนูหลัก                            '
 DEFINE WINDOW cip3 FROM 15, 45 TO 19, 71 SHADOW
 DIMENSION cip3( 3)
 cip3( 1) = ' ดูรายงานผู้ป่วยนอก     '
 cip3( 2) = ' ดูรายงานผู้ป่วยใน      '
 cip3( 3) = ' กลับเมนูเดิม           '
 DEFINE WINDOW cipo FROM 16, 36 TO 22, 77 SHADOW
 DIMENSION cipo( 5)
 cipo( 1) = ' จำนวน & ค่ารักษา จำแนกตามโรงพยาบาล    '
 cipo( 2) = ' จำนวน & ค่ารักษา จำแนกตามแผนก         '
 cipo( 3) = ' จำนวน & ค่ารักษา จำแนกตามการชันสูตร  '
 cipo( 4) = ' จำนวน & ค่ารักษา จำแนกตามบริการ      '
 cipo( 5) = ' กลับเมนูหลัก                          '
 DEFINE WINDOW cipi FROM 9, 35 TO 22, 77 SHADOW
 DIMENSION cipi( 12)
 cipi( 1) = ' โรคที่มีวันนอนสูงสุด 10 อันดับแรก   '
 cipi( 2) = ' จำนวนผู้ป่วยสูงสุด 10 อันดับแรก     '
 cipi( 3) = ' จำนวนผู้ป่วย จำแนกตามกลุ่มโรด ICD 10  '
 cipi( 4) = ' จำนวน & วันนอน จำแนกตามแผนก             '
 cipi( 5) = ' จำนวน & ค่ารักษา จำแนกตามโรงพยาบาล      '
 cipi( 6) = ' จำนวน & ค่ารักษา จำแนกตามแผนก           '
 cipi( 7) = ' จำนวน & ค่ารักษา จำแนกตามสถานประกอบการ  '
 cipi( 8) = ' จำนวน & ค่ารักษา จำแนกตามการวินิจฉัย    '
 cipi( 9) = ' จำนวน & ค่ารักษา จำแนกตามการผ่าตัด      '
 cipi( 10) = ' จำนวน & ค่ารักษา จำแนกตามการชันสูตร     '
 cipi( 11) = ' จำนวน & ค่ารักษา จำแนกตามบริการ         '
 cipi( 12) = ' กลับเมนูหลัก                            '
 ACTIVATE WINDOW ip1
 CLEAR
 @ 1, 1 SAY 'ปี พ.ศ.      ' GET myy PICTURE '99' VALID BETWEEN(VAL(myy), 34, 99)
 READ
 IF READKEY()=12 .OR. READKEY()=268
    WAIT WINDOW TIMEOUT 1 'Terminate by user'
    CLEAR
    RELEASE WINDOW ip1
    SET DEFAULT TO (oldpath)
    RETURN TO main
 ENDIF
 HIDE WINDOW ip1
 DO WHILE .T.
    ACTIVATE WINDOW p_type
    ptyp_job = 1
    FOR n = 1 TO ALEN(p_type)
       @ n-1, 0 PROMPT p_type(n)
    ENDFOR
    MENU TO ptyp_job
    DO CASE
       CASE ptyp_job=1
          SELECT iptra
          SET ORDER TO pttyp
          GOTO TOP
          SEEK '11'
          COPY TO iptran.dbf FOR pttyp='11'
          DO rep
          DELETE FILE iptran.dbf
       CASE ptyp_job=2
          SELECT iptra
          SET ORDER TO hospcare
          GOTO TOP
          SEEK hospcode
          COPY TO iptran.dbf FOR hospcare=hospcode
          DO rep
          DELETE FILE iptran.dbf
       CASE ptyp_job=3
          RUN cd\ssn24
          EXIT
    ENDCASE
 ENDDO
*
PROCEDURE rep
 SELECT DISTINCT iptran.hospcare, hospcode.name, iptran.an, iptran.dg1, icd101.desc, CTOD(iptran.datedsc)-CTOD(iptran.dateadm)+1 FROM iptran, icd101, hospcode WHERE icd101.code=iptran.dg1 AND hospcode.code=iptran.hospcare AND RIGHT(iptran.datedsc, 2)=myy ORDER BY iptran.dg1, iptran.hospcare DESCENDING INTO DBF los.dbf
 DO WHILE .T.
    ACTIVATE WINDOW c_p
    c_pjob = 1
    FOR n = 1 TO ALEN(c_p)
       @ n-1, 0 PROMPT c_p(n)
    ENDFOR
    MENU TO c_pjob
    DO CASE
       CASE c_pjob=1
          DO WHILE .T.
             ACTIVATE WINDOW ip2
             ip2job = 1
             FOR n = 1 TO ALEN(ip2)
                @ n-1, 0 PROMPT ip2(n)
             ENDFOR
             MENU TO ip2job
             DO CASE
                CASE ip2job=1
                   DO dx_los.prg
                   DO yrp_losd.qpr
                   DO y_i_chgh.qpr
                   DO y_i_chgd.qpr
                   DO y_i_chgf.qpr
                   DO y_i_chgo.qpr
                   DO y_i_chgx.qpr
                   DO y_i_chgl.qpr
                   DO y_i_chgs.qpr
                   DO y_o_chgh.qpr
                   DO y_o_chgd.qpr
                   DO y_o_chgl.qpr
                   DO y_o_chgs.qpr
                CASE ip2job=2
                   HIDE WINDOW ip2
                   DO WHILE .T.
                      ACTIVATE WINDOW ip3
                      ip3job = 1
                      FOR n = 1 TO ALEN(ip3)
                         @ n-1, 0 PROMPT ip3(n)
                      ENDFOR
                      MENU TO ip3job
                      DO CASE
                         CASE ip3job=1
                            HIDE WINDOW ip3
                            DO WHILE .T.
                               ACTIVATE WINDOW ipo
                               ipojob = 1
                               FOR n = 1 TO ALEN(ipo)
                                  @ n-1, 0 PROMPT ipo(n)
                               ENDFOR
                               MENU TO ipojob
                               DO CASE
                                  CASE ipojob=1
                                     DO y_o_chgh.qpr
                                  CASE ipojob=2
                                     DO y_o_chgd.qpr
                                  CASE ipojob=3
                                     DO y_o_chgl.qpr
                                  CASE ipojob=4
                                     DO y_o_chgs.qpr
                                  CASE ipojob=5
                                     HIDE WINDOW ipo
                                     EXIT
                               ENDCASE
                            ENDDO
                         CASE ip3job=2
                            HIDE WINDOW ip3
                            DO WHILE .T.
                               ACTIVATE WINDOW ipi
                               ipijob = 1
                               FOR n = 1 TO ALEN(ipi)
                                  @ n-1, 0 PROMPT ipi(n)
                               ENDFOR
                               MENU TO ipijob
                               DO CASE
                                  CASE ipijob=1
                                     DO los.prg
                                  CASE ipijob=2
                                     DO dx.prg
                                  CASE ipijob=3
                                     DO group_dx.qpr
                                  CASE ipijob=4
                                     DO yrp_losd.qpr
                                  CASE ipijob=5
                                     DO y_i_chgh.qpr
                                  CASE ipijob=6
                                     DO y_i_chgd.qpr
                                  CASE ipijob=7
                                     DO y_i_chgf.qpr
                                  CASE ipijob=8
                                     DO y_i_chgx.qpr
                                  CASE ipijob=9
                                     DO y_i_chgo.qpr
                                  CASE ipijob=10
                                     DO y_i_chgl.qpr
                                  CASE ipijob=11
                                     DO y_i_chgs.qpr
                                  CASE ipijob=12
                                     HIDE WINDOW ipi
                                     EXIT
                               ENDCASE
                            ENDDO
                         CASE ip3job=3
                            HIDE WINDOW ip3
                            EXIT
                      ENDCASE
                   ENDDO
                CASE ip2job=3
                   EXIT
             ENDCASE
          ENDDO
       CASE c_pjob=2
          HIDE WINDOW c_p
          DO WHILE .T.
             ACTIVATE WINDOW cip3
             cip3job = 1
             FOR n = 1 TO ALEN(cip3)
                @ n-1, 0 PROMPT cip3(n)
             ENDFOR
             MENU TO cip3job
             DO CASE
                CASE cip3job=1
                   DO WHILE .T.
                      ACTIVATE WINDOW cipo
                      cipojob = 1
                      FOR n = 1 TO ALEN(cipo)
                         @ n-1, 0 PROMPT cipo(n)
                      ENDFOR
                      MENU TO cipojob
                      DO CASE
                         CASE cipojob=1
                            DO yco_chgh.qpr
                         CASE cipojob=2
                            DO yco_chgd.qpr
                         CASE cipojob=3
                            DO yco_chgl.qpr
                         CASE cipojob=4
                            DO yco_chgs.qpr
                         CASE cipojob=5
                            HIDE WINDOW cipo
                            EXIT
                      ENDCASE
                   ENDDO
                CASE cip3job=2
                   DO WHILE .T.
                      ACTIVATE WINDOW cipi
                      cipijob = 1
                      FOR n = 1 TO ALEN(cipi)
                         @ n-1, 0 PROMPT cipi(n)
                      ENDFOR
                      MENU TO cipijob
                      DO CASE
                         CASE cipijob=1
                            DO los_c.prg
                         CASE cipijob=2
                            DO dx_c.prg
                         CASE cipijob=3
                            DO grp_c_dx.qpr
                         CASE cipijob=4
                            DO yc_losd.qpr
                         CASE cipijob=5
                            DO yci_chgh.qpr
                         CASE cipijob=6
                            DO yci_chgd.qpr
                         CASE cipijob=7
                            DO yci_chgf.qpr
                         CASE cipijob=8
                            DO yci_chgx.qpr
                         CASE cipijob=9
                            DO yci_chgo.qpr
                         CASE cipijob=10
                            DO yci_chgl.qpr
                         CASE cipijob=11
                            DO yci_chgs.qpr
                         CASE cipijob=12
                            HIDE WINDOW cipi
                            EXIT
                      ENDCASE
                   ENDDO
                CASE cip3job=3
                   HIDE WINDOW cip3
                   EXIT
             ENDCASE
          ENDDO
       CASE c_pjob=3
          EXIT
    ENDCASE
 ENDDO
 HIDE WINDOW ALL
 CLOSE DATABASES
 DELETE FILE los.dbf
 SET SAFETY OFF
 SET SAFETY ON
 SET PROCEDURE TO
 SET DEFAULT TO (oldpath)
 SET EXCLUSIVE OFF
 RUN cd\ssn24
 RETURN TO main
*
