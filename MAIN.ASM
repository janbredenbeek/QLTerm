* QLTERM TERMINAL EMULATOR
* Licenced under GPL v3 Licence (2019)
* See https://github.com/janbredenbeek/QLTerm for latest version from the author
* This should be assembled and linked using the GST/Quanta Assembler and Linker
* (see http://www.dilwyn.me.uk/asm/index.html)

* V2.0 -  20 April 1987
* V2.30 - 16 July 1988
* V2.31 - 23 July 1992
* V2.32 - 20 December 1993
* V2.33 - 27 September 1994
* v2.34 - 28 October 2016
* v2.35 - 09 November 2016

         INCLUDE  WIN1_MACRO_LIB
         INCLUDE  WIN1_QDOS_IN_MAC
         INCLUDE  WIN3_QLTDEV_QLTERM_IN

         XDEF     PRINTAUX,TXCHR_A,TXCHR,TXSTR,TERMBASE,T_WAIT,GETREPLY,MAINWINP

         XREF     SCRJOB,DOWNLOAD,UPLOAD,OPENFILE,GR_SET1

PRMSG    MACRO    A
[.LAB]   LEA      .S.[.L],A1
         JSR      PRINTAUX
         SECTION  MSG
.S.[.L]  STRING$  {[A]}
         SECTION  CODE
         ENDM

         SECTION  CODE

TERMBASE JMP      START
         DC.W     0
         DC.W     $4AFB
         STRING$  {'QLTERM'}
DEFBUFLN DC.W     32             FOR 32K BUFFER
DEFMODEM DC.B     1              FOR "BUFFERED"
DEFBAUD  DC.B     4              FOR 2400 BAUD
DEFPAR   DC.B     -1             FOR "NONE"
DEFECHO  DC.B     -1             FOR "FULL DUPLEX"
DEFSCR   DC.B     1              FOR "ANSI TERMINAL"
DEFCOLR  DC.B     -1             FOR "COLOUR AUTO"
DEFCONLF DC.B     1              FOR "CONVERT LINEFEEDS"
DEFCOOKD DC.B     1              FOR "COOKED LOG"
DEFPORT  DC.B     2
PORTNAME STRING$  'SER1I'
         DS.B     15
         STRING$  'SER1H'
         DS.B     15
         STRING$  'SER2I'
         DS.B     15
         STRING$  'SER2H'
         DS.B     15

         DS.W     0

MAINWINP DC.B     2,1,0,7
         DC.W     484,242,14,2
CMDWINP  DC.B     2,1,0,7
         DC.W     484,12,14,244
GWINNAM  STRING$  'SCR_484X254A014X002'
START    ADDA.L   A6,A5
         ADDA.L   A4,A6
         LEA      DEFBUFLN,A0
         LEA      BUFLEN(A6),A1
         MOVE.W   (A0)+,(A1)+    SET BUFFER LEN
         MOVE.L   (A0)+,(A1)+    SET MODEM, BAUD, PARITY & ECHO
         MOVE.L   (A0)+,(A1)+    SET SCREEN, COLOUR, LF & COOKED
         MOVE.B   (A0)+,(A1)+    SET PORT
         SF       REDIR(A6)
         SF       USE_PIPE(A6)
         MOVE.W   (A7)+,D0
         BEQ.S    TSTCMD
         ST       REDIR(A6)
         MOVE.L   (A7),TSERIN(A6)
         SUBQ.W   #2,D0
         BGT.S    EX_ERR
         BNE.S    SET_OUT
         ADDQ.W   #4,A7
         ST       USE_PIPE(A6)
SET_OUT  MOVE.L   (A7)+,TSEROUT(A6)
         SUBA.L   A4,A4
         BRA.S    SET_STK
TSTCMD   MOVE.L   A7,A4
         TST.W    (A4)
         BNE.S    SER_CMD
         BSR      OPEN_SER
         BNE.S    SER_FAIL
         BRA.S    SET_STK
SER_CMD  MOVE.L   A4,A0
         MOVEQ    #-1,D1
         MOVEQ    #0,D3
         QDOS     IO.OPEN
         MOVE.L   A0,TSERIN(A6)
         MOVE.L   A0,TSEROUT(A6)
         TST.L    D0
         BEQ.S    SET_STK
SER_FAIL SUBA.L   A0,A0
         PRINT    {'Unable to open channel to '}
         MOVE.L   A4,A1
         MOVE.W   UT_MTEXT,A2
         JSR      (A2)
         MOVEQ    #LF,D1
         QDOS     IO.SBYTE
         BRA      QUIT2
EX_ERR   SUBA.L   A0,A0
         PRINT    {'Too many files specified in EX/EW command',LF}
         BRA      QUIT2
SET_STK  MOVE.L   A4,SERNAME(A6)
         MOVEQ    #-1,D1
         MOVEQ    #-1,D2
         QDOS     MT.DMODE
         CMPI.B   #8,D1
         IF EQ THEN
            SUBA.L   A0,A0
            PRINT    {'This program cannot be run in MODE 8',LF}
            BRA      QUIT2
         ENDIF
         TST.B    COLRMOD(A6)
         BGE.S    OPEN_WIN          Pre-set colour mode, skip autodetect
         CLR.B    COLRMOD(A6)       Assume Black & White
         CMPI.B   #2,D1             Test for 2-colour mode (SMS)
         BEQ.S    OPEN_WIN
         ADDQ.B   #1,COLRMOD(A6)    We have at least 4 colours available
         TST.B    D1                Zero means MODE 4
         BEQ.S    OPEN_WIN
         ADDQ.B   #1,COLRMOD(A6)    We're lucky - more than 4 colours
OPEN_WIN LEA      GWINNAM,A0        Open guard window for PE
         MOVEQ    #-1,D1
         MOVEQ    #0,D3
         QDOS     IO.OPEN
         MOVE.L   A0,GUARDWIN(A6)
         MOVEQ    #-1,D3
         QDOS     SD.CLEAR
         LEA      MAINWINP,A1
         MOVE.W   UT_CON,A2
         JSR      (A2)
         MOVE.L   A0,MAINWIN(A6)
         SUBA.L   A1,A1
         LEA      GR_SET1,A2        Set character set for hi-bit characters
         QDOS     SD.FOUNT
         PRINT    {'QLTERM Version [version]  Release [.date]',LF,LF}
*         PRINT    {'Beta test version; NOT for general distribution!',LF,LF}
         PRINT    {'Copyright  1987-2016 by Jan Bredenbeek',LF,LF}
         PRINT    {'Colour mode: '}
         TST.B    COLRMOD(A6)
         IF EQ THEN
            PRINT    {'Black and White',LF}
         ELSE
            CMPI.B   #1,COLRMOD(A6)
            IF EQ THEN
               PRINT    {'4-colour',LF}
            ELSE
               PRINT    {'8-colour',LF}
            ENDIF
         ENDIF
         LEA      CMDWINP,A1
         MOVE.W   UT_CON,A2
         JSR      (A2)
         MOVE.L   A0,CMDWIN(A6)
         MOVEQ    #-1,D0
         MOVE.L   D0,LOGCHID(A6)
         MOVE.L   D0,SERJBID(A6)
         SF       XOFFMOD(A6)
         SF       DLMOD(A6)
         SF       ESCMOD(A6)
         SF       TXBUSY(A6)
         SF       PARNUM(A6)
         SF       CONECTED(A6)
         SF       IN_EOF(A6)
         LEA      RXQ(A6),A2
         MOVE.L   A2,RXQ_BASE(A6)
         MOVE.L   A2,RXQ_HEAD(A6)
         MOVE.L   A2,RXQ_TAIL(A6)
         ADDA.L   #RXQ_SIZE,A2
         MOVE.L   A2,RXQ_TOP(A6)
         MOVEQ    #-1,D1
         MOVEQ    #32,D2
         QDOS     MT.PRIOR
         LEA      SCRJOB,A1
         BSR      MAKE_JOB
         MOVE.L   D1,SCRJBID(A6)
         TST.B    REDIR(A6)
         IF EQ THEN
            BSR      SETBAUD
         ENDIF
         TST.B    USE_PIPE(A6)
         BNE.S    ACT_SCR
         LEA      SERJOB,A1
         BSR      MAKE_JOB
         MOVE.L   D1,SERJBID(A6)
         MOVEQ    #127,D2
         MOVEQ    #0,D3
         QDOS     MT.ACTIV
ACT_SCR  MOVE.L   SCRJBID(A6),D1
         MOVEQ    #32,D2
         MOVEQ    #0,D3
         QDOS     MT.ACTIV
MAIN_MSG BSR      STATUS
         MOVE.L   MAINWIN(A6),A0
         MOVEQ    #-1,D3
         QDOS     SD.CURE

* Main execution loop

MAIN_LP  TST.B    IN_EOF(A6)
         BNE.S    MAIN_EOF
         MOVE.L   MAINWIN(A6),A0
         MOVEQ    #0,D3
         QDOS     IO.FBYTE          Get keystroke, if any
         TST.L    D0
         BEQ.S    TST_KEY
         MOVEQ    #2,D3             If no key, wait 100 ms and retry
         BSR      T_WAIT
         BRA      MAIN_LP

MAIN_EOF MOVEQ    #ERR.EF,D3        EOF in input detected
         TST.B    REDIR(A6)
         BNE      QUIT3             if redirected, commit suicide now
         MOVE.L   TSERIN(A6),A0
         QDOS     IO.CLOSE
         MOVEQ    #-1,D1
         MOVEQ    #0,D3
         MOVE.L   SERNAME(A6),A0
         QDOS     IO.OPEN
         MOVE.L   D0,D3
         BNE      QUIT3
         MOVE.L   A0,TSERIN(A6)
         MOVE.L   A0,TSEROUT(A6)
         SF       IN_EOF(A6)
         BRA      MAIN_LP

TST_KEY  CMPI.B   #F3,D1            F3 key pressed for Menu?
         BNE.S    KEY2
         ST       DLMOD(A6)
         MOVE.L   MAINWIN(A6),A0
         MOVEQ    #-1,D3
         QDOS     SD.CURS
CMD_AGN  PRMSG    {'Buffer, Call, Download, Hangup, Interface, Log, Options, Quit, Transmit, Upload'}
         QDOS     SD.CURE
         QDOS     IO.FBYTE
         MOVE.B   D1,D2
         QDOS     SD.CURS
         CMPI.B   #ESC,D2
         BEQ.S    CMD_END
         BCLR     #5,D2
         LEA      CMDTBL-2,A2
CMDLOOP  ADDQ.W   #2,A2
         MOVE.W   (A2)+,D1
         BEQ      CMD_AGN
         CMP.B    D2,D1
         BNE      CMDLOOP
         QDOS     SD.CLEAR
         ADDA.W   (A2),A2
         JSR      (A2)
CMD_END  SF       DLMOD(A6)
         BRA      MAIN_MSG

* 'Ordinary' key press - look for generic conversion first

KEY2     LEA      K_GEN,A1
KEY2LOOP MOVE.W   (A1)+,D0
         BEQ.S    KEY3
         CMP.B    D1,D0
         BNE      KEY2LOOP
         MOVE.W   D0,D1
         LSR.W    #8,D1
         BRA.S    SENDKEY

* Depending on mode, do additional conversion

KEY3     LEA      K_ASC,A1
         TST.B    SCRMOD(A6)
         BLT.S    S_KTABLE
         LEA      K_VT52,A1
         BEQ.S    S_KTABLE
         LEA      K_ANSI,A1
S_KTABLE MOVE.B   (A1)+,D0
         BEQ.S    SENDKEY
         CMP.B    D1,D0
         BEQ.S    CTLFOUND
         MOVE.B   (A1)+,D0
         ADDA.W   D0,A1
         BRA      S_KTABLE
CTLFOUND MOVEQ    #0,D2
         MOVE.B   (A1)+,D2          number of chars to send
         BSR.S    TXSTR
         BRA      MAIN_LP

* No more conversions needed - finally send character

SENDKEY  BSR.S    TXCHR
         BRA      MAIN_LP

* This code is added so that VT52/ANSI escape sequences are sent as one
* string - needed for some Telnet systems
* Send string: A1 pointer, D2 length

TXSTR    TST.B    REDIR(A6)
         BEQ.S    TXSTR_LP          .. but only if redirected I/O
         TST.B    ECHOMOD(A6)
         BGT.S    TXS_LOC           .. 'Local Only' mode
         MOVE.L   TSEROUT(A6),A0
         MOVEQ    #-1,D3
         QDOS     IO.SSTRG
         TST.B    ECHOMOD(A6)
         BLT.S    TXS_RTS           Done if no local echo to do
         SUBA.W   D2,A1             restore original A1
TXS_LOC  MOVE.B   (A1)+,D1
         BSR.S    PUT_RXQ           put char in RX queue for local echo
         SUBQ.W   #1,D2
         BGT      TXS_LOC
TXS_RTS  RTS

TXSTR_LP MOVE.B   (A1)+,D1          For serial I/O, just call TXCHR
         BSR.S    TXCHR
         SUBQ.W   #1,D2
         BNE      TXSTR_LP
         RTS

SETPAR   MOVEQ    #0,D0
         MOVE.B   PARITY(A6),D0
         BLT.S    SP_END
         ANDI.B   #$7F,D1
         MOVE.B   PARTBL(PC,D0.W),D0
         JSR      PARTBL(PC,D0.W)
SP_END   RTS

PARTBL   DC.B     SP_ODD-PARTBL
         DC.B     SP_EVEN-PARTBL
         DC.B     SP_MARK-PARTBL
         DC.B     SP_SPACE-PARTBL

SP_ODD   BSR.S    SP_EVEN
         EORI.B   #$80,D1
SP_SPACE RTS
SP_EVEN  MOVEQ    #6,D0
         MOVE.B   D1,D2
SP_LOOP  ROR.B    #1,D1
         EOR.B    D1,D2
         DBF      D0,SP_LOOP
         ROXL.B   #1,D2
         ROXR.B   #1,D1
         RTS
SP_MARK  ORI.B    #$80,D1
         RTS

* Transmit a character, taking care of echo status

TXCHR    MOVEQ    #-1,D3
         TST.B    ECHOMOD(A6)
         BLT.S    TXCHR_A           jump if ECHO OFF
         BSR.S    PUT_RXQ           Otherwise, put char in terminal queue
         TST.B    ECHOMOD(A6)
         BEQ.S    TXCHR_A           Finished if 'Local Only', else xmit char
         RTS

* Put character in receive queue to be picked up by screen job

PUT_RXQ  MOVEM.L  D1/A1,-(A7)
         TRAP     #0
         MOVE.L   RXQ_HEAD(A6),A1
         MOVE.B   D1,(A1)+
         CMPA.L   RXQ_TOP(A6),A1
         BLO.S    PUTRXQ_2
         MOVE.L   RXQ_BASE(A6),A1
PUTRXQ_2 MOVE.L   A1,RXQ_HEAD(A6)
         ANDI     #$DFFF,SR
         MOVEM.L  (A7)+,D1/A1
         RTS

* Transmit character in D1, taking care of all transmit modes
* On entry, D3 holds timeout - nonzero for 'wait until complete'

TXCHR_A  MOVEM.L  D1-D3/A0-A3,-(A7)
TXCHR_1  TAS      TXBUSY(A6)
         BEQ.S    TXCHR_2
         TST.B    11(A7)
         BEQ.S    TXCHR_NC
         BSR.S    PAUSE4
         BRA      TXCHR_1
TXCHR_2  MOVE.L   TSEROUT(A6),A0
         BSR      SETPAR
         BSR.S    TXSUB
         SF       TXBUSY(A6)
         MOVEQ    #0,D0
         BRA.S    TXCHREND
TXCHR_NC MOVEQ    #ERR.NC,D0
TXCHREND MOVEM.L  (A7)+,D1-D3/A0-A3
         TST.L    D0
         RTS

* Wait 4 frames (80 ms)

PAUSE4   MOVEQ    #4,D3
T_WAIT   MOVEM.L  D1/A0-A1,-(A7)
         MOVEQ    #-1,D1
         SUBA.L   A1,A1
         QDOS     MT.SUSJB
         MOVEM.L  (A7)+,D1/A0-A1
         RTS

* Subroutine to transmit char

TXSUB    TST.B    MODEMTYP(A6)
         BGT.S    TXSER3            MODEMTYP > 0 means 'buffered'
         MOVE.B   BAUD(A6),D0
         CMPI.B   #11,D0
         BEQ.S    TXSER3            11 = 12H75 using Hermes (tx = 75 baud)
         SUBQ.B   #8,D0
         BGE.S    TXMODAPT          8-10: Modaptor or Miracle Qmodem
TXSER3   MOVEQ    #0,D3             No tricky hardware - send plain serial I/O
         MOVE.B   D1,D2             save byte for later
         QDOS     IO.SBYTE
         TST.L    D0
         BEQ.S    TXSER3_R
         MOVE.B   D2,D1             if 'not complete', wait 80 ms and try again
         BSR      PAUSE4
         BRA      TXSER3
TXSER3_R RTS

* This code deals with the Modapter and Miracle Systems Qmodem in 1200/75 mode
* D0 holds 0 for 12M75 (Modapter), 1 for 12P75 (Qmodem) and 12S75 (direct).
* For each 2 bits of data, 3 bytes are sent at 1200 bps (i.e. 33 bits).
* This is 16 times (+ 1 bit) the rate at 75 baud.
* The electronics in the Modaptor/Qmodem do a bit of smoothing the signal so
* in the end it (hopefully) looks like a 'real' 75 bps signal.
* If you have to stick to 1200/75 and don't have these hardware, you can use 
* 12S75 to generate the 75 bps by software (NOT recommended).

TXMODAPT ANDI.W   #$00FF,D1
         ORI.W    #$0100,D1
         LSL.W    #1,D1             Insert stop bit '1' and start bit '0'
         LEA      MODAPTBL,A3
         SUBQ.B   #1,D0
         BGT.S    TXDIRECT          If 12S75, go to software processed TxD
         BLT.S    TXM_1
         LEA      QMODTBL,A3        Modapter and Qmodem require different code
TXM_1    SUBA.W   #16,A7
         MOVE.L   A7,A1             We need a 15 byte buffer (rounded)
TXMOD_LP MOVEQ    #3,D0             Each byte is 5 times 3 bytes to be sent
         AND.B    D1,D0             (including start- and stopbit)
         LEA      (A3,D0.W),A2
         ADD.W    D0,D0
         ADDA.W   D0,A2             Index into the table and copy 3 bytes
         MOVE.B   (A2)+,(A1)+
         MOVE.B   (A2)+,(A1)+
         MOVE.B   (A2)+,(A1)+
         LSR.W    #2,D1             Shift data to get next 2 bits in LSB
         BNE      TXMOD_LP
         MOVEQ    #15,D2
         MOVE.L   A7,A1
TXMOD_TX MOVEQ    #0,D3
         QDOS     IO.SSTRG          Now send the 15 bytes
         SUB.W    D1,D2
         BEQ.S    TXMOD_EN
         BSR      PAUSE4
         BRA      TXMOD_TX
TXMOD_EN ADDA.W   #16,A7
         RTS

* Send at 75 bps by directly manipulating the TxD line
* This is not recommended as it slows down the QL considerably, but might be
* the only option if you need 1200/75 on a dumb modem.

TXDIRECT MOVE.W   D1,D3
         EORI.W   #$07FF,D3         Need to invert the data bits
         QDOS     MT.INF
         TRAP     #0
         ORI.W    #$0700,SR
         LEA      $18002,A1
         LEA      $24+6(A0),A2      "Spare sysvar location"
         MOVE.W   -(A2),-(A7)       But save contents first to be sure
         MOVE.W   #$4E75,(A2)
         MOVE.L   -(A2),-(A7)
         MOVE.L   #$538066FC,(A2)   Wait loop followed by RTS
         MOVE.L   #1990,D2          Timing constant
         LEA      $A0(A0),A0        SV.TMOD
         MOVEQ    #$67,D1
         AND.B    (A0),D1
         MOVE.B   PORT(A6),D0
         LSR.B    #1,D0
         LSL.B    #3,D0
         OR.B     D0,D1
         ADD.B    D1,D1
TXD_LP   LSR.W    #1,D3
         BEQ.S    TXD_END
         MOVE.B   D1,D0
         ROXR.B   #1,D0
         MOVE.B   D0,(A1)
         MOVE.L   D2,D0
         JSR      (A2)              Execute the loop (in 'slow' RAM)
         BRA      TXD_LP
TXD_END  MOVE.B   (A0),(A1)
         MOVE.L   (A7)+,(A2)+
         MOVE.W   (A7)+,(A2)
         ANDI.W   #$D8FF,SR
         RTS

QMODTBL  DC.B     $00,$00,$00
         DC.B     $FF,$0F,$00
         DC.B     $00,$F0,$FF
         DC.B     $FF,$FF,$FF

MODAPTBL DC.B     $FE,$9E,$FE
         DC.B     $FF,$9F,$FE
         DC.B     $FE,$DE,$FF
         DC.B     $FF,$DF,$FF

* General key conversion table
* Each pair: second byte keyboard code, first byte replacement code

K_GEN    DC.B     $0D,$0A,$7F,$C2,XOFF,F4,XON,$F6,$03,F5,0,0

* Cursor keys conversion for ASCII mode

K_ASC    DC.B     $C0,1,8           Left
         DC.B     $C8,1,9           Right
         DC.B     $D0,1,$0B         Up
         DC.B     $D8,1,LF          Down
         DC.B     0

* Cursor keys conversion for VT52

K_VT52   DC.B     $C0,2,ESC,'D'     Left
         DC.B     $C1,1,8           ALT left
         DC.B     $C8,2,ESC,'C'     Right
         DC.B     $CA,2,ESC,'K'     CTRL right
         DC.B     $D0,2,ESC,'A'     Up
         DC.B     $D1,1,$0B         ALT up
         DC.B     $D4,2,ESC,'I'     SHIFT up
         DC.B     $D8,2,ESC,'B'     Down
         DC.B     $D9,1,LF          ALT down
         DC.B     0

* Cursor keys conversion for ANSI

K_ANSI   DC.B     $FD,3,ESC,$5B,'Z'    CBT
*         DC.B     9,3,ESC,$5B,'I'      CHT
         DC.B     $C0,3,ESC,$5B,'D'    CUB
         DC.B     $D8,3,ESC,$5B,'B'    CUD
         DC.B     $C8,3,ESC,$5B,'C'    CUF
         DC.B     $D0,3,ESC,$5B,'A'    CUU
         DC.B     $C3,3,ESC,$5B,'M'    DL
         DC.B     $CB,3,ESC,$5B,'K'    EL
         DC.B     $CA,3,ESC,$5B,'@'    ICH
         DC.B     $DA,3,ESC,$5B,'L'    IL
         DC.B     $DC,3,ESC,$5B,'U'    NP
         DC.B     $D4,3,ESC,$5B,'V'    PP
         DC.B     $D9,3,ESC,$5B,'T'    SD
         DC.B     $C5,4,ESC,$5B,' @'   SL
         DC.B     $CD,4,ESC,$5B,' A'   SR
         DC.B     $D1,3,ESC,$5B,'S'    SU
         DC.B     0

* Table of Commands (F3 menu)

CMDTBL   DC.W     ' B'
         DC.W     SETBUF-*
         DC.W     ' C'
         DC.W     CALL-*
         DC.W     ' D'
         DC.W     DOWNLOAD-*
         DC.W     ' H'
         DC.W     HANGUP-*
         DC.W     ' I'
         DC.W     INTERFAC-*
         DC.W     ' L'
         DC.W     LOG-*
         DC.W     ' O'
         DC.W     OPTIONS-*
         DC.W     ' Q'
         DC.W     QUIT-*
         DC.W     ' T'
         DC.W     TRANSMIT-*
         DC.W     ' U'
         DC.W     UPLOAD-*
         DC.W     0

* Print message on bottom line

PRINTAUX MOVE.L   CMDWIN(A6),A0
         MOVEQ    #-1,D3
         MOVE.L   A1,-(A7)
         QDOS     SD.CLEAR
         MOVE.L   (A7)+,A1
         MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         RTS

* Print status on bottom line

STATUS   MOVE.L   CMDWIN(A6),A0
         MOVEQ    #-1,D3
         QDOS     SD.CLEAR
         MOVE.B   ECHOMOD(A6),D1
         ADDQ.B   #1,D1
         LEA      ECHOMSG,A1
         BSR.S    STA_ITEM
         MOVE.B   SCRMOD(A6),D1
         ADDQ.B   #1,D1
         LEA      SCRNMSG,A1
         BSR.S    STA_ITEM
*         LOAD$    {' Colour | '},A1
*         TST.B    COLRMOD(A6)
*         IF EQ THEN
*            LOAD$    {' B&W | '},A1
*         ENDIF
*         MOVE.W   (A1)+,D2
*         QDOS     IO.SSTRG
         MOVE.B   COLRMOD(A6),D1
         LEA      COLRMSG,A1
         BSR.S    STA_ITEM
         MOVEQ    #' ',D1
         QDOS     IO.SBYTE
         MOVE.L   SERNAME(A6),A1
         MOVE.L   A1,D0
         IF EQ THEN
            LOAD$    {'ReDir'},A1
         ENDIF
         MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         MOVEQ    #' ',D1
         QDOS     IO.SBYTE
         MOVEQ    #'|',D1
         QDOS     IO.SBYTE
         MOVE.B   BAUD(A6),D1
         LEA      BAUDMSG,A1
         BSR.S    STA_ITEM
         MOVE.B   PARITY(A6),D1
         ADDQ.B   #1,D1
         LEA      PARITMSG,A1
         BSR.S    STA_ITEM
         MOVE.B   MODEMTYP(A6),D1
         ADDQ.B   #1,D1
         LEA      MODEMMSG,A1
         BSR.S    STA_ITEM
         LOAD$    {' F3 - Menu'},A1
         MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         RTS

STA_ITEM ADDQ.L   #2,A1
STA_LP   SUBQ.B   #1,D1
         BLO.S    STA_OUT
         MOVE.W   (A1)+,D0
         ADDQ.W   #1,D0
         ANDI.B   #$FE,D0
         ADDA.W   D0,A1
         BRA      STA_LP
STA_OUT  MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         MOVEQ    #'|',D1
         QDOS     IO.SBYTE
         RTS

* Create a (daughter) job of current job
* A1 points to start of code

MAKE_JOB MOVEQ    #-1,D1
         MOVEQ    #11,D2
         ADD.W    8(A1),D2
         BCLR     #0,D2             Code space = 10 bytes + job name (rounded)
         MOVEQ    #$7E,D3           126 bytes for stack space
         MOVE.L   A1,-(A7)
         SUBA.L   A1,A1             Note- this creates a job with its own small
         QDOS     MT.CJOB           code space. I could have set A1 to the real
         MOVE.L   D0,D3             start of code and specify 0 bytes codespace
         BNE      QUIT3             but this breaks MT.CJOB on QDOS < 1.10...
         MOVE.L   (A7)+,A1
         MOVE.L   A6,$58-$68(A0)    Set A6 of new job equal to our dataspace
         MOVE.L   $5C-$68(A0),A5    A5 = top of stack of new job
         MOVE.W   #$4EF9,(A0)+      Fill first 6 bytes of code space with JMP
         MOVE.L   A1,(A0)+          to actual code
         ADDQ.W   #6,A1
         SUBQ.L   #6,D2
MJOB_LP  MOVE.L   (A1)+,(A0)+       Now copy the name so job control utilities
         SUBQ.L   #4,D2             can see it
         BGT      MJOB_LP
         RTS

* Serial input job
* This continually reads the serial port and put the data in the buffer
* (Which is rather needed for the standard SER ports as their buffering sucks)
* Also handles XON/XOFF handshake

SERJOB   BRA.S    SERJB_LP
         DS.L     1
         DC.W     $4AFB
         STRING$  {'QLTERM sub 2'}
SERJB_LP MOVE.L   TSERIN(A6),A0     Serial input channel
         TRAP     #0                Enter supervisor mode
         MOVEQ    #0,D4
         MOVE.L   RXQ_HEAD(A6),A1
SJ_LP2   MOVE.L   RXQ_TOP(A6),D2
         SUB.L    A1,D2             Get number of free bytes in queue
         BGT.S    SJ_FETCH
         ADD.L    A1,D2
         MOVE.L   RXQ_BASE(A6),A1
         SUB.L    A1,D2
SJ_FETCH MOVEQ    #0,D3
         QDOS     IO.FSTRG          Get string, at most D2 bytes
         ADD.W    D1,D4
         TST.L    D0
         BEQ      SJ_LP2
SJ_WAIT  MOVE.L   A1,RXQ_HEAD(A6)
         SUBA.L   RXQ_TAIL(A6),A1
         ANDI     #$DFFF,SR
         TST.W    D4
         BEQ.S    SERJB_ER
         MOVE.L   RXQ_TOP(A6),D2
         SUB.L    RXQ_BASE(A6),D2
         MOVE.L   A1,D1
         BEQ.S    SERJB_WT
         BPL.S    SJ_POS
         ADD.L    D2,D1
SJ_POS   LSR.L    #1,D2
         MOVE.L   D2,D0
         LSR.L    #1,D0
         ADD.L    D2,D0
         CMP.L    D0,D1
         BLT.S    SERJB_WT
         TST.B    XOFFMOD(A6)
         BNE.S    SERJB_WT
         MOVEQ    #XOFF,D1
         JSR      TXCHR_A
         BNE.S    SERJB_WT
         ST       XOFFMOD(A6)
         BRA.S    SERJB_WT
SERJB_ER ADDQ.L   #1,D0
         BEQ.S    SERJB_WT
         CMPI.L   #ERR.EF+1,D0
         BNE.S    SERJB_WT
         TAS      IN_EOF(A6)
SERJB_WT MOVEQ    #1,D3
         BSR      T_WAIT
         BRA      SERJB_LP

* Get menu input
* Entry: A1 points to menu table, D1 item number (0-based)
* Exit: D1 = updated item number

GETMENU  MOVEM.L  D2-D7/A0-A3,-(A7)
         MOVE.W   (A1)+,D5          NUMBER OF ITEMS
         MOVEQ    #0,D7
         MOVE.B   D1,D7             CURRENT ITEM NO.
         MOVE.L   A1,A3
         MOVE.L   CMDWIN(A6),A0
         MOVEQ    #-1,D3
         SUBQ.L   #8,A7
         MOVE.L   A7,A1
         QDOS     SD.CHENQ
         MOVE.W   4(A7),D6          Current column pos.
         ADDQ.L   #8,A7
         MOVE.L   A3,A1
         MOVE.W   D5,D4
GM_DMENU MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         LSR.W    #1,D2
         IF CS THEN
            ADDQ.L   #1,A1
         ENDIF
         SUBQ.W   #1,D4
         BHI      GM_DMENU
GM_LOOP  MOVE.B   CMDWINP+3,D1
         QDOS     SD.SETST
         MOVE.B   CMDWINP+2,D1
         QDOS     SD.SETIN
         BSR.S    GM_ITEM
         MOVE.B   CMDWINP+2,D1
         QDOS     SD.SETST
         MOVE.B   CMDWINP+3,D1
         QDOS     SD.SETIN
         QDOS     IO.FBYTE
         CMPI.B   #LF,D1
         BEQ.S    GM_END
         MOVE.B   D1,-(A7)
         BSR.S    GM_ITEM
         MOVE.B   (A7)+,D1
         CMPI.B   #$C0,D1     CURSOR LEFT
         BEQ.S    GM_LEFT
         CMPI.B   #$C8,D1     CURSOR RIGHT
         BNE      GM_LOOP
         ADDQ.W   #1,D7
         CMP.W    D5,D7
         BLT.S    GM_LOOP
         MOVEQ    #0,D7
         BRA.S    GM_LOOP
GM_LEFT  SUBQ.W   #1,D7
         BGE.S    GM_LOOP
         MOVE.W   D5,D7
         SUBQ.W   #1,D7
         BRA      GM_LOOP
GM_END   MOVE.W   D7,D1
         MOVEM.L  (A7)+,D2-D7/A0-A3
         RTS
GM_ITEM  MOVE.L   A3,A1
         MOVE.W   D7,D4
         MOVE.W   D6,D1
GM_ILP   SUBQ.W   #1,D4
         BLO.S    GM_IDSP
         MOVE.W   (A1)+,D0
         ADD.W    D0,D1
         ADDQ.W   #1,D0
         ANDI.B   #$FE,D0
         ADDA.W   D0,A1
         BRA      GM_ILP
GM_IDSP  MOVE.L   A1,-(A7)
         QDOS     SD.TAB
         MOVE.L   (A7)+,A1
         MOVE.W   (A1)+,D2
         QDOS     IO.SSTRG
         RTS

* Quit program

QUIT     TST.B    CONECTED(A6)
         IF NE THEN
            BSR      HANGUP
         ENDIF
         MOVE.L   SCRJBID(A6),D1
         MOVEQ    #0,D2
         QDOS     MT.PRIOR
         MOVE.L   GUARDWIN(A6),A0
         QDOS     SD.CLEAR
QUIT2    MOVEQ    #0,D3
QUIT3    MOVEQ    #-1,D1
         QDOS     MT.FRJOB

* Set buffer size

SETBUF   PRINT    {'Current buffer size is '}
         MOVE.W   BUFLEN(A6),D1
         MOVE.W   UT_MINT,A2
         JSR      (A2)
         PRINT    {'K. New size (in K): '}
SETBUFLP LEA      TXMODBUF(A6),A1
         MOVEQ    #4,D2
         QDOS     IO.FLINE
         LEA      TXMODBUF(A6),A0
         MOVE.L   A7,A1
         SUBQ.W   #2,A7
         MOVE.L   A6,-(A7)
         SUBA.L   A6,A6
         SUBQ.W   #1,D1
         MOVEQ    #0,D7
         MOVE.W   D1,D7
         ADD.L    A0,D7
         MOVE.W   CN_DTOI,A2
         JSR      (A2)
         MOVE.L   (A7)+,A6
         MOVE.W   (A7)+,D1
         BLE.S    SETBF_ER
         TST.L    D0
         BEQ.S    SETBF_OK
SETBF_ER PRMSG    {'Invalid input, enter again: '}
         BRA      SETBUFLP
SETBF_OK MOVE.W   D1,BUFLEN(A6)
         RTS

ACTIVE   MOVEQ    #$20,D0
         BRA.S    ACTIV2
QMDISCON QDOS     MT.INF
         MOVEQ    #50,D3
         MOVE.W   D3,$A6(A0)
         BSR      ACTIVE
         MOVEQ    #0,D3
INACTIVE MOVEQ    #0,D0
ACTIV2   OR.B     PORT(A6),D0
         LSR.B    #1,D0
         LSL.B    #3,D0
         MOVEM.L  D0-D2/A0-A1,-(A7)
         QDOS     MT.INF
         MOVEQ    #$67,D0
         AND.B    $A0(A0),D0
         OR.B     3(A7),D0
         MOVE.B   D0,$18002
         SUBA.L   A1,A1
         MOVEQ    #-1,D1
         QDOS     MT.SUSJB
         MOVEM.L  (A7)+,D0-D2/A0-A1
ACT_RTS  RTS

* Disconnect Qmodem

DISCON   SF       CONECTED(A6)
         TST.B    MODEMTYP(A6)
         BLT      QMDISCON
         BGT      ACT_RTS
         BSR.S    HI_FREQ
         BSR.S    T3.3
         BSR.S    HI_FREQ

T5       MOVE.L   #$168,D3
         MOVEQ    #0,D4
         BRA.S    SET_TX
T3.3     MOVE.L   #$1FE,D3
         BRA.S    TX_HI
T10      MOVE.L   #$834,D3
TX_HI    MOVEQ    #$20,D4
SET_TX   OR.B     PORT(A6),D4
         LSR.B    #1,D4
         LSL.B    #3,D4
         QDOS     MT.INF
         LEA      $A0(A0),A0
         LEA      $18002,A1
         TRAP     #0
         ORI.W    #$0700,SR
         MOVEQ    #$67,D0
         AND.B    (A0),D0
         OR.B     D4,D0
         MOVE.B   D0,(A1)
SET_TX_L SUBQ.L   #1,D3
         BNE.S    SET_TX_L
         MOVE.B   (A0),(A1)
         ANDI.W   #$D8FF,SR
SET_TX_R RTS

ONLINE   TST.B    MODEMTYP(A6)
         BLT.S    QM_ONLIN
         BGT.S    SET_TX_R
         BSR.S    HI_FREQ
         CMPI.B   #1,BAUD(A6)
         BNE.S    M_ON1200
         BSR      T3.3
         BRA      T5
M_ON1200 BSR      T10
         BRA      T5

QM_ONLIN BSR.S    HI_FREQ
         MOVEQ    #50,D3
         BSR      INACTIVE
         MOVEQ    #3,D3
         BSR      ACTIVE
         MOVEQ    #0,D3
         BRA      INACTIVE

HI_FREQ  QDOS     MT.INF
         LEA      $A0(A0),A0
         LEA      $18002,A1
         TRAP     #0
         ORI      #$0700,SR
         MOVEQ    #$67,D0
         AND.B    (A0),D0
         MOVE.B   PORT(A6),D1
         LSR.B    #1,D1
         LSL.B    #3,D1
         OR.B     D1,D0
         MOVEQ    #$3F,D1
         TST.B    MODEMTYP(A6)
         BLT.S    TOGGLE_O
         MOVEQ    #$4F,D1
TOGGLE_O BCHG     #7,D0
         MOVE.B   D0,(A1)
         MOVEQ    #$0F,D2
         REPEAT
            SUBQ.L   #1,D2
         UNTIL EQ
         DBF      D1,TOGGLE_O
         MOVE.B   (A0),(A1)
         ANDI     #$D8FF,SR
         RTS

* Dial a number (works only on Qmodem)

CALL     QDOS     MT.INF
         LEA      $A6(A0),A4
         BSR      DISCON
         MOVE.L   SCRJBID(A6),D1
         MOVEQ    #0,D2
         QDOS     MT.PRIOR
         QDOS     MT.RELJB
         ST       TXBUSY(A6)
         MOVE.L   CMDWIN(A6),A0
         PRINT    {'Enter telephone number or ENTER for direct connection: '}
         LEA      TXMODBUF(A6),A1
         MOVEQ    #32,D2
         QDOS     IO.FLINE
         MOVE.W   #3000,(A4)
         SUBA.W   D1,A1
         SUBQ.W   #1,D1
         BEQ.S    CONNECT
         MOVE.W   #150,D3
         BSR      ACTIVE
         MOVE.L   A1,A2
         PRMSG    {'Dialing: '}
DIAL_LP  MOVE.B   (A2)+,D1
         CMPI.B   #LF,D1
         BEQ.S    CONNECT
         MOVE.B   D1,D2
         QDOS     IO.SBYTE
         SUBI.B   #'0',D2
         CMPI.B   #9,D2
         BHI.S    D_NONUM
         TST.B    D2
         IF EQ THEN
            MOVEQ    #10,D2
         ENDIF
         REPEAT
            MOVEQ    #3,D3
            BSR      INACTIVE
            MOVEQ    #2,D3
            BSR      ACTIVE
            SUBQ.B   #1,D2
         UNTIL EQ
         MOVEQ    #40,D3
         BRA.S    DIAL_WT
D_NONUM  MOVEQ    #100,D3
DIAL_WT  BSR      ACTIVE
         BRA      DIAL_LP
CONNECT  BSR      ONLINE
         MOVEQ    #50,D3
         BSR      T_WAIT
         MOVE.L   RXQ_HEAD(A6),RXQ_TAIL(A6)
         SF       XOFFMOD(A6)
         SF       TXBUSY(A6)
         MOVE.L   SCRJBID(A6),D1
         MOVEQ    #32,D2
         QDOS     MT.PRIOR
         CLR.W    (A4)
         ST       CONECTED(A6)
         RTS

* Tables used for menu commands
* Each table consists of number of entries(W) followed by entries (QDOS string)

ECHOMSG  DC.W     3
         STRING$  {' Echo Off '}
         STRING$  {' Echo On '}
         STRING$  {' Local Only '}

COLRMSG  DC.W     3
         STRING$  {' B&W '}
         STRING$  {' 4-Colour '}
         STRING$  {' 8-Colour '}

PORTMSG  DC.W     4
         STRING$  {' SER1I '}
         STRING$  {' SER1H '}
         STRING$  {' SER2I '}
         STRING$  {' SER2H '}

BAUDMSG  DC.W     12
         STRING$  {' 75 '}
         STRING$  {' 300 '}
         STRING$  {' 600 '}
         STRING$  {' 1200 '}
         STRING$  {' 2400 '}
         STRING$  {' 4800 '}
         STRING$  {' 9600 '}
         STRING$  {' 19200 '}
         STRING$  {' 12M75 '}
         STRING$  {' 12P75 '}
         STRING$  {' 12S75 '}
         STRING$  {' 12H75 '}

PARITMSG DC.W     5
         STRING$  {' None '}
         STRING$  {' Odd '}
         STRING$  {' Even '}
         STRING$  {' Mark '}
         STRING$  {' Space '}

MODEMMSG DC.W     3
         STRING$  {' QModem '}
         STRING$  {' Modaptor '}
         STRING$  {' Buffered '}

* Baud rates (last entry is for 1200/75 using Hermes)

BAUDTBL  DC.W     75,300,600,1200,2400,4800,9600,19200,1200,1200,1200,75

* IPC command to check if Hermes present

IPC_CHKH DC.W     $0C02
         DC.L     $0000000A
         DC.B     $9F,$F7,$02

SETBAUD  MOVEQ    #0,D1
         MOVE.B   BAUD(A6),D1
         ADD.W    D1,D1
         MOVE.W   BAUDTBL(PC,D1.W),D1
         QDOS     MT.BAUD
         CMPI.B   #11,BAUD(A6)      12H75?
         BLO.S    SB_RTS
         LEA      IPC_CHKH,A3       If 12H75, check if Hermes present
         QDOS     MT.IPCOM
         SUBQ.B   #8,D1
         BNE.S    SB_RTS
         MOVE.W   #$0200,-(A7)      Set Hermes receive baud rate to 1200
         MOVE.L   #$00080D04,-(A7)
         MOVE.B   PORT(A6),D0
         LSR.B    #1,D0
         ROR.B    #1,D0
         OR.B     D0,3(A7)
         MOVE.L   #$0C020000,-(A7)
         MOVE.L   A7,A3
         QDOS     MT.IPCOM
         ADDA.W   #10,A7
SB_RTS   RTS

INTERFAC TST.B    REDIR(A6)
         IF EQ THEN
            MOVE.L   TSERIN(A6),A0
            QDOS     IO.CLOSE
            MOVE.L   CMDWIN(A6),A0
         ENDIF
         PRINT    {'Transmit Mode: '}
         MOVE.B   ECHOMOD(A6),D1
         ADDQ.B   #1,D1
         LEA      ECHOMSG,A1
         BSR      GETMENU
         SUBQ.B   #1,D1
         MOVE.B   D1,ECHOMOD(A6)
         PRMSG    {'Modem Type: '}
         MOVE.B   MODEMTYP(A6),D1
         ADDQ.B   #1,D1
         LEA      MODEMMSG,A1
         BSR      GETMENU
         SUBQ.B   #1,D1
         MOVE.B   D1,MODEMTYP(A6)
         TST.B    REDIR(A6)
         BNE.S    IF_BAUD
         PRMSG    {'Port: '}
         MOVE.B   PORT(A6),D1
         TST.B    MODEMTYP(A6)
         IF LE THEN
            MOVEQ    #2,D1
         ENDIF
         LEA      PORTMSG,A1
         BSR      GETMENU
         MOVE.B   D1,PORT(A6)
IF_BAUD  PRMSG    {'Baud: '}
         LEA      BAUDMSG,A1
         MOVE.B   BAUD(A6),D1
         MOVE.B   MODEMTYP(A6),D0
         IF LT THEN
            MOVEQ    #9,D1
         ENDIF
         BSR      GETMENU
         MOVE.B   D1,BAUD(A6)
         BSR      SETBAUD
         PRMSG    {'Parity: '}
         MOVE.B   PARITY(A6),D1
         ADDQ.B   #1,D1
         LEA      PARITMSG,A1
         BSR      GETMENU
         SUBQ.B   #1,D1
         MOVE.B   D1,PARITY(A6)
         TST.B    REDIR(A6)
         BNE.S    IF_END
OPEN_SER LEA      PORTNAME,A0
         MOVEQ    #0,D0
         MOVE.B   PORT(A6),D0
         MULU     #22,D0
         ADDA.W   D0,A0
         MOVE.L   A0,A4
         MOVE.L   A4,SERNAME(A6)
         MOVEQ    #-1,D1
         MOVEQ    #0,D3
         QDOS     IO.OPEN
         MOVE.L   A0,TSERIN(A6)
         MOVE.L   A0,TSEROUT(A6)
         TST.L    D0
IF_END   RTS

LOG      TST.W    LOGCHID+2(A6)
         BGE.S    LOG_CLOS
         PRINT    {'Log - '}
         MOVEQ    #2,D4
         JSR      OPENFILE
         MOVE.L   A5,LOGCHID(A6)
         RTS
LOG_CLOS MOVE.L   LOGCHID(A6),A0
         QDOS     IO.CLOSE
         MOVEQ    #-1,D0
         MOVE.L   D0,LOGCHID(A6)
         MOVE.L   CMDWIN(A6),A0
         PRINT    {'Logfile closed'}
         MOVEQ    #100,D3
         BRA      T_WAIT

SCRNMSG  DC.W     3
         STRING$  {' ASCII '}
         STRING$  {' VT52 '}
         STRING$  {' ANSI '}
LOGMSG   DC.W     2
         STRING$  {' RAW '}
         STRING$  {' COOKED '}
CONVLFMS DC.W     2
         STRING$  {' NO '}
         STRING$  {' YES '}
OPTIONS  PRINT    {'Terminal Emulation: '}
         MOVE.B   SCRMOD(A6),D1
         ADDQ.B   #1,D1
         LEA      SCRNMSG,A1
         BSR      GETMENU
         SUBQ.B   #1,D1
         MOVE.B   D1,SCRMOD(A6)
         PRMSG    {'Colour: '}
         MOVE.B   COLRMOD(A6),D1
         LEA      COLRMSG,A1
         BSR      GETMENU
         MOVE.B   D1,COLRMOD(A6)
         IF EQ THEN
            MOVE.L   MAINWIN(A6),A0
            MOVE.B   MAINWINP+2,D1
            QDOS     SD.SETPA
            MOVE.B   MAINWINP+2,D1
            QDOS     SD.SETST
            MOVE.B   MAINWINP+3,D1
            QDOS     SD.SETIN
         ENDIF
         PRMSG    {'Logging: '}
         MOVE.B   L_COOKED(A6),D1
         LEA      LOGMSG,A1
         BSR      GETMENU
         MOVE.B   D1,L_COOKED(A6)
         PRMSG    {'Convert CR/LF for LOG & TRANSMIT: '}
         MOVE.B   CONVLF(A6),D1
         LEA      CONVLFMS,A1
         BSR      GETMENU
         MOVE.B   D1,CONVLF(A6)
         SF       ESCMOD(A6)
         SF       PARNUM(A6)
         RTS

TRANSMIT PRINT    {'Transmit - '}
         MOVEQ    #1,D4
         JSR      OPENFILE
XMIT_LP  MOVE.L   A5,A0
         MOVEQ    #-1,D3
         QDOS     IO.FBYTE
         TST.L    D0
         BNE.S    XMIT_END
         CMPI.B   #LF,D1
         BNE.S    XMIT_2
         TST.B    CONVLF(A6)
         BEQ.S    XMIT_2
         MOVEQ    #CR,D1
XMIT_2   JSR      TXCHR
         TST.B    ECHOMOD(A6)
         IF LE AND D1 EQ.B #CR THEN
            MOVEQ    #50,D3
            BSR      T_WAIT
         ENDIF
         MOVE.L   CMDWIN(A6),A0
         MOVEQ    #0,D3
         QDOS     IO.FBYTE
         TST.L    D0
         BNE      XMIT_LP
         CMPI.B   #ESC,D1
         BNE      XMIT_LP
XMIT_END MOVE.L   A5,A0
         QDOS     IO.CLOSE
         RTS

HANGUP   PRINT    {'Disconnect line'}
         BSR.S    GETREPLY
         BEQ      DISCON
         RTS

GETREPLY PRINT    {'? (Y/N) '}
GR_GKEY  QDOS     SD.CURE
         QDOS     IO.FBYTE
         MOVEQ    #$DF,D2
         AND.B    D1,D2
         QDOS     SD.CURS
         CMPI.B   #'Y',D2
         BEQ.S    GR_RTS
         CMPI.B   #'N',D2
         BNE      GR_GKEY
         MOVEQ    #-1,D0
GR_RTS   RTS

         END
