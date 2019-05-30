* QLTerm Terminal Emulator
* Licenced under GPL v3 Licence (2019)
* See https://github.com/janbredenbeek/QLTerm for latest version from the author
* This should be assembled and linked using the GST/Quanta Assembler and Linker
* (see http://www.dilwyn.me.uk/asm/index.html)

* XMODEM DOWNLOAD/UPLOAD ROUTINES

         INCLUDE  WIN1_MACRO_LIB
         INCLUDE  WIN1_QDOS_IN_MAC
         INCLUDE  WIN3_QLTDEV_QLTERM_IN

PRMSG    MACRO    A
[.LAB]   LEA      .S.[.L],A1
         JSR      PRINTAUX
         SECTION  MSG
.S.[.L]  STRING$  {[A]}
         SECTION  CODE
         ENDM

         XDEF     DOWNLOAD,UPLOAD,OPENFILE

         XREF     TXCHR,T_WAIT,GETREPLY,PRINTAUX

         DATA     0

         SECTION  CODE

OPENFILE PRINT    {'File Name: '}
         LEA      TXMODBUF+2(A6),A1
         MOVEQ    #-1,D3
         MOVEQ    #44,D2
         QDOS     IO.FLINE
         SUBQ.W   #1,D1
         BEQ.S    OF_QUIT
         MOVE.W   D1,TXMODBUF(A6)
OF_FILE  LEA      TXMODBUF(A6),A0
         MOVE.W   D4,D3
         MOVEQ    #-1,D1
         QDOS     IO.OPEN
         MOVE.L   A0,A5
         TST.L    D0
         BEQ.S    OF_EXIT
         CMPI.L   #ERR.EX,D0
         BNE.S    FERROR
         LEA      TXMODBUF(A6),A1
         JSR      PRINTAUX
         PRINT    {' exists, overwrite'}
         JSR      GETREPLY
         BNE.S    OF_QUIT
         LEA      TXMODBUF(A6),A0
         MOVEQ    #-1,D1
         QDOS     IO.DELET
         BRA      OF_FILE
FERROR   MOVE.L   D0,-(A7)
         PRMSG    {'ERROR: '}
         MOVE.L   (A7)+,D0
         MOVE.W   UT_ERR,A2
         JSR      (A2)
OF_QUIT  ADDQ.W   #4,A7
OF_EXIT  TST.L    D0
         BNE.S    WAIT_IO
         CMPI.B   #2,D4
         BLT.S    OF_RTS
WAIT_IO  MOVEQ    #100,D3
         JSR      T_WAIT
         QDOS     MT.INF
         REPEAT
            TST.B    $EE(A0)
         UNTIL EQ
OF_RTS   RTS

BLOCKMSG PRMSG    {'Block: '}
         MOVE.W   D6,D1
         MOVE.W   UT_MINT,A2
         JSR      (A2)
         PRINT    {'  Attempt: '}
         MOVE.W   D4,D1
         MOVE.W   UT_MINT,A2
         JMP      (A2)

CALCHK   LEA      TXMODBUF(A6),A1
         MOVE.B   (A1)+,D1
         NOT.B    D1
         CMP.B    (A1)+,D1
         BNE.S    ENDCHK
         MOVEQ    #0,D2
         MOVEQ    #127,D0
         TST.B    D7
         BNE.S    CH_CRC
CHKLOOP  ADD.B    (A1)+,D2
         DBF      D0,CHKLOOP
         MOVE.B   (A1),D1
         MOVE.B   D2,(A1)
         CMP.B    D2,D1
ENDCHK   RTS
CH_CRC   MOVE.B   (A1)+,D1
         LSL.W    #8,D1
         EOR.W    D1,D2
         MOVEQ    #7,D1
CH_CRC2  ADD.W    D2,D2
         BCC.S    CH_CRC3
         EORI.W   #$1021,D2
CH_CRC3  DBF      D1,CH_CRC2
         DBF      D0,CH_CRC
         MOVE.W   (A1),D1
         MOVE.W   D2,(A1)
         CMP.W    D2,D1
         RTS

DOWNLOAD PRINT    {'Download - '}
         MOVEQ    #2,D4
         BSR      OPENFILE
         MOVEQ    #0,D2
         BSR      SP_SERJB
         MOVEQ    #1,D4       ERROR COUNTER
         MOVEQ    #0,D5       BUFFER POS.
         MOVEQ    #1,D6       BLOCK COUNTER
         MOVEQ    #1,D7       CRC MODE
         MOVEQ    #0,D1
         MOVE.W   BUFLEN(A6),D1
         SWAP     D1
         LSR.L    #6,D1
         MOVEQ    #-1,D2
         QDOS     MT.ALCHP
         TST.L    D0
         BEQ.S    DL_BF_OK
         PRMSG    {'No room for download buffer'}
         SUBA.L   A4,A4
         BRA      DL_CAN
DL_BF_OK MOVE.L   A0,A4
         ST       FILELEN(A6)
         BSR      BLOCKMSG
         MOVEQ    #3,D2
DL_CW    SUBQ.B   #1,D2
         BLT.S    DL_NO_C
         MOVEQ    #C,D1
         JSR      TXCHR
         MOVE.L   TSERIN(A6),A0
         MOVE.W   #250,D3
         QDOS     IO.FBYTE
         ADDQ.L   #1,D0
         BEQ.S    DL_CW
         BLT      DL_ABORT
         CMPI.B   #CAN,D1
         BEQ      DL_ABORT
         CMPI.B   #SOH,D1
         BNE.S    DL_CW
         BRA.S    DL_RBLK
DL_NO_C  MOVEQ    #0,D7
DL_NAK   MOVE.L   TSERIN(A6),A0
         MOVEQ    #50,D3
DL_PURGE QDOS     IO.FBYTE
         TST.L    D0
         BEQ.S    DL_PURGE
         MOVEQ    #NAK,D1
         BRA.S    DL_OUT
DL_ACK   MOVEQ    #ACK,D1
DL_OUT   JSR      TXCHR
         BSR      BLOCKMSG
DL_SOHW  MOVE.L   TSERIN(A6),A0
         MOVE.W   #500,D3
         QDOS     IO.FBYTE
         ADDQ.L   #1,D0
         BEQ.S    DL_FAIL
         BLT      DL_ABORT
         CMPI.B   #CAN,D1
         BEQ      DL_ABORT
         CMPI.B   #EOT,D1
         BEQ      DL_END
         CMPI.B   #SOH,D1
         BNE.S    DL_SOHW
DL_RBLK  MOVE.W   #130,D2
         ADD.B    D7,D2
         MOVEQ    #50,D3
         LEA      TXMODBUF(A6),A2
DL_RBLKL QDOS     IO.FBYTE
         TST.L    D0
         BNE.S    DL_FAIL
         MOVE.B   D1,(A2)+
         DBF      D2,DL_RBLKL
         BSR      CALCHK
         BEQ.S    DL_LBLK
DL_FAIL  ADDQ.B   #1,D4
         CMPI.B   #10,D4
         BLE      DL_NAK
         MOVEQ    #1,D4
         PRMSG    {'10X Transmit error. Retry'}
         JSR      GETREPLY
         BEQ      DL_NAK
         BRA.S    DL_CAN
DL_LBLK  MOVEQ    #1,D4
         LEA      TXMODBUF(A6),A1
         CMP.B    (A1),D6
         BHI      DL_ACK
         BEQ.S    DL_COPY
         TST.B    D6
         BEQ      DL_ACK
         PRMSG    {'FATAL ERROR: Synchronisation loss'}
         BRA.S    DL_CAN
DL_COPY  MOVE.L   D5,D1
         LSL.L    #6,D1
         SWAP     D1
         CMP.W    BUFLEN(A6),D1
         BLT.S    DL_COPY2
         BSR.S    DL_SAVE
         BNE.S    DL_CAN
         BSR      WAIT_IO
DL_COPY2 LEA      (A4,D5.L),A2
         LEA      TXMODBUF+2(A6),A1
         MOVEQ    #31,D0
DL_FILL  MOVE.L   (A1)+,(A2)+
         DBF      D0,DL_FILL
         ADDI.L   #128,D5
         ADDQ.W   #1,D6
         BRA      DL_ACK
DL_END   PRMSG    {'Download OK'}
         MOVEQ    #ACK,D1
         BRA.S    DL_FINAL
DL_ABORT PRMSG    {'Download aborted by remote'}
DL_CAN   MOVEQ    #CAN,D1
         JSR      TXCHR
DL_FINAL JSR      TXCHR
         MOVEQ    #32,D2
         BSR      SP_SERJB
         MOVEQ    #100,D3
         JSR      T_WAIT
         TST.L    D5
         IF NE THEN
            BSR.S    DL_SAVE
         ENDIF
         MOVE.L   A5,A0
         QDOS     IO.CLOSE
         MOVE.L   A4,D0
         IF NE THEN
            MOVE.L   D0,A0
            QDOS     MT.RECHP
         ENDIF
         RTS

DL_SAVE  MOVE.L   A5,A0
         MOVEQ    #-1,D3
         MOVEQ    #0,D1
         QDOS     FS.POSRE
         TST.L    D1
         BNE.S    DL_NOHDR
         MOVE.L   A4,A1
         MOVEQ    #64,D0
LOOK_HDR CMPI.W   #$4AFB,(A1)+
         BNE.S    DL_NOHDR
         SUBQ.B   #2,D0
         BNE      LOOK_HDR
         MOVE.L   (A1),FILELEN(A6)
         QDOS     FS.HEADS
         LEA      128(A4),A1
         SUBI.L   #128,D5
         BRA.S    DL_SBYTS
DL_NOHDR MOVE.L   A4,A1
DL_SBYTS TST.B    FILELEN(A6)
         BLT.S    DL_SBYT1
         MOVE.L   A1,-(A7)
         MOVEQ    #0,D1
         QDOS     FS.POSRE
         MOVE.L   (A7)+,A1
         ADD.L    D5,D1
         SUB.L    FILELEN(A6),D1
         BLE.S    DL_SBYT1
         SUB.L    D1,D5
         BGE.S    DL_SBYT1
         MOVEQ    #0,D5
DL_SBYT1 MOVE.L   D5,D2
         QDOS     FS.SAVE
         TST.L    D0
         IF NE THEN
            MOVE.L   D0,-(A7)
            PRMSG    {'FILE ERROR: '}
            MOVE.L   (A7)+,D0
            MOVE.W   UT_ERR,A2
            JSR      (A2)
         ENDIF
         MOVEQ    #0,D5
         TST.L    D0
         RTS

GETBUFF  LEA      TXMODBUF(A6),A1
         MOVE.B   D6,(A1)+
         MOVE.B   D6,(A1)
         NOT.B    (A1)+
         MOVE.L   A1,A0
         MOVEQ    #31,D0
         MOVE.L   #$1A1A1A1A,D1
GTB_CLR  MOVE.L   D1,(A0)+
         DBF      D0,GTB_CLR
         MOVE.L   A5,A0
         MOVE.W   #128,D2
         MOVEQ    #-1,D3
         QDOS     IO.FSTRG
         TST.L    D0
         IF NE AND D0 NE.L #ERR.EF THEN
            MOVE.L   D0,-(A7)
            PRMSG    {'FILE ERROR: '}
            MOVE.L   (A7),D0
            MOVE.W   UT_ERR,A2
            JSR      (A2)
            MOVE.L   (A7)+,D0
         ELSE
            BSR      CALCHK
            MOVEQ    #0,D0
         ENDIF
         RTS

UPLOAD   PRINT    {'Upload - '}
         MOVEQ    #1,D4
         MOVEQ    #0,D5
         MOVEQ    #1,D6
         MOVEQ    #0,D7
         BSR      OPENFILE
         MOVEQ    #0,D2
         BSR      SP_SERJB
         MOVE.L   A5,A0
         MOVEQ    #-1,D3
         MOVEQ    #64,D2
         LEA      TXMODBUF(A6),A1
         MOVE.W   #$01FE,(A1)+
         MOVE.B   D2,D0
         REPEAT
            MOVE.W   #$4AFB,(A1)+
            SUBQ.B   #2,D0
         UNTIL    EQ
         QDOS     FS.HEADR
         SUBA.W   D1,A1
         MOVE.L   (A1),D4
         SUBQ.L   #1,D4
         LSR.L    #7,D4
         ADDQ.W   #2,D4
         BSR      CALCHK
         PRMSG    {'Send header'}
         JSR      GETREPLY
         BEQ.S    UL_PRBLK
         SUBQ.W   #1,D4
         BSR      GETBUFF
         BNE      UL_QUIT
UL_PRBLK MOVE.L   CMDWIN(A6),A0
         QDOS     SD.CLEAR
         MOVE.W   D4,D1
         MOVE.W   UT_MINT,A2
         JSR      (A2)
         PRINT    {' Blocks to send. Waiting for receiver...'}
         MOVEQ    #0,D4
UL_ACKW  MOVE.L   TSERIN(A6),A0
         MOVEQ    #0,D3
         REPEAT
            QDOS     IO.FBYTE
            TST.L    D0
         UNTIL    NE
         MOVE.W   #3000,D3
         QDOS     IO.FBYTE
         TST.L    D0
         BNE.S    UL_ABORT
         CMPI.B   #CAN,D1
         BEQ.S    UL_CAN
         CMPI.B   #NAK,D1
         BEQ.S    UL_XMIT
         CMPI.B   #C,D1
         BNE.S    TST_ACK
         TST.B    D5
         BNE.S    UL_XMIT
         MOVEQ    #1,D7
         BSR      CALCHK
         BRA.S    UL_XMIT
TST_ACK  CMPI.B   #ACK,D1
         BNE.S    UL_ACKW
         ADDQ.W   #1,D6
         ST       D5
         TST.L    D5
         BLT.S    UL_OK
         MOVE.L   A5,A0
         MOVEQ    #-1,D3
         QDOS     IO.PEND
         IF D0 EQ.L #ERR.EF THEN
            MOVEQ    #-1,D5
         ELSE
            BSR      GETBUFF
            BNE.S    UL_QUIT
         ENDIF
         MOVEQ    #0,D4
UL_XMIT  ADDQ.W   #1,D4
         BSR      BLOCKMSG
         TST.L    D5
         IF LT THEN
            MOVEQ    #EOT,D1
            JSR      TXCHR
            BRA      UL_ACKW
         ENDIF
         MOVEQ    #SOH,D1
         JSR      TXCHR
         MOVE.W   #130,D2
         ADD.B    D7,D2
         LEA      TXMODBUF(A6),A2
UL_XMLP  MOVE.B   (A2)+,D1
         JSR      TXCHR
         DBF      D2,UL_XMLP
         BRA      UL_ACKW
UL_ABORT LEA      ABORTMSG,A1
         BRA.S    UL_MSG
UL_CAN   LEA      CANMSG,A1
         BRA.S    UL_MSG
UL_OK    LEA      ULOKMSG,A1
UL_MSG   JSR      PRINTAUX
         BRA.S    UL_EXIT
UL_QUIT  MOVEQ    #CAN,D1
         JSR      TXCHR
UL_EXIT  MOVEQ    #32,D2
         BSR.S    SP_SERJB
         MOVE.L   A5,A0
         QDOS     IO.CLOSE
         MOVE.L   CMDWIN(A6),A0
         MOVE.W   #100,D3
         QDOS     IO.FBYTE
         RTS

SP_SERJB MOVE.L   SERJBID(A6),D1
         TST.W    D1
         BLT.S    SP_1
         QDOS     MT.PRIOR
         RTS
SP_1     MOVE.L   SCRJBID(A6),D1
         QDOS     MT.PRIOR
         TST.B    D2
         IF EQ THEN
            QDOS     MT.RELJB
         ENDIF
         RTS

         SECTION  MSG
ULOKMSG  STRING$  {'Upload OK'}
ABORTMSG STRING$  {'Xmit Timeout - Aborted'}
CANMSG   STRING$  {'Aborted by remote'}
         DC.W     0

         END
