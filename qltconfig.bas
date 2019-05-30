100 REMark QLTERM V2.35 configuration program
110 WINDOW 448,200,32,16:MODE 4:PAPER 2:INK 7:CSIZE 1,0
120 CLS:PRINT "*** QLTERM V2.35 CONFIGURATION ***"\\
130 PRINT "Allows you to change the QLTERM initial settings"\\
140 RESTORE :DIM prog(26),opname$(8,12),opmax(8),option$(8,11,8)
150 FOR i=0 TO 8
160   READ opname$(i),opmax(i)
170   FOR j=0 TO opmax(i):READ option$(i,j)
180 END FOR i
190 REPeat getprog
200   INPUT "Filename of QLTERM program?"\"(e.g. flp1_QLTERM): ";fnam$
210   OPEN_IN#3,fnam$:FOR i=0 TO 26:prog(i)=CODE(INKEY$(#3,-1))
220   CLOSE#3
230   valid=(prog(6)=74 AND prog(7)=251 AND prog(8)=0 AND prog(9)=6)
240   n$="":FOR i=10 TO 15:n$=n$&CHR$(prog(i))
250   IF n$="QLTERM" AND valid THEN EXIT getprog
260   PRINT "This is not QLTERM"\\
270 END REPeat getprog
280 FOR i=18,20 TO 23:prog(i)=(prog(i)+1)&&255
290 CLS:PRINT 'Use ¾¿ keys to select option'
300 PRINT 'Use ¼½ keys to set selected option'
310 PRINT 'Press <ESC> to end'
320 AT 4,0:PRINT "Download Buffer (K): ";256*prog(16)+prog(17)
330 FOR i=0 TO 8:PRINT opname$(i);TO 21;option$(i,prog(i+18))
340 opt=-1
350 REPeat sel_loop
360   STRIP 7:INK 0:print_opt:STRIP 2:INK 7
370   key=CODE(INKEY$(-1)):IF key=27 THEN print_opt:EXIT sel_loop
380   SELect ON key
390     =192:REMark cursor left
400       AT opt+5,21:PRINT FILL$(" ",8);
410       IF opt=-1
420         getbuflen
430       ELSE
440         opval=prog(opt+18)-1:IF opval<0:opval=opmax(opt)
450         prog(opt+18)=opval
460       END IF
470     =200:REMark cursor right
480       AT opt+5,21:PRINT FILL$(" ",8);
490       IF opt=-1
500         getbuflen
510       ELSE
520         opval=prog(opt+18)+1:IF opval>opmax(opt):opval=0
530         prog(opt+18)=opval
540       END IF
550     =208:REMark cursor up
560       print_opt:opt=opt-1:IF opt<-1:opt=8
570     =216:REMark cursor down
580       print_opt:opt=opt+1:IF opt>8:opt=-1
590   END SELect
600 END REPeat sel_loop
610 AT 15,0:PRINT "Save new settings? (Y/N) ";
620 REPeat getreply:reply$=INKEY$(-1):IF reply$ INSTR "YN":EXIT getreply
630 PRINT reply$
640 IF reply$=="Y"
650   FOR i=18,20 TO 23:prog(i)=prog(i)-1
660   OPEN#3,fnam$
670   FOR i=0 TO 26:PRINT#3;CHR$(prog(i));
680   CLOSE#3
690 END IF
700 PRINT \"Configuration finished"
710 STOP
10000 DEFine PROCedure print_opt
10010   AT opt+5,21
10020   IF opt=-1:PRINT 256*prog(16)+prog(17);:ELSE PRINT option$(opt,prog(opt+18));
10030 END DEFine print_opt
10040 DEFine PROCedure getbuflen
10050   REPeat getbufloop
10060     AT 4,21:INPUT buflen$:buflen="0"&buflen$
10070     IF buflen>0 THEN EXIT getbufloop
10080     AT 4,21:PRINT FILL$(" ",LEN(buflen$));
10090   END REPeat getbufloop
10100   prog(16)=buflen DIV 256:prog(17)=buflen MOD 256
10110 END DEFine getbuflen
25000 DATA 'Modem: ',2,'QMODEM','MODAPTOR','BUFFERED'
25010 DATA 'Baud: ',11,'75','300','600','1200','2400','4800','9600','19200','12M75','12P75','12S75','12H75'
25020 DATA 'Parity: ',4,'NONE','ODD','EVEN','MARK','SPACE'
25030 DATA 'Local Echo: ',2,'OFF','ON','LOCAL'
25040 DATA 'Terminal: ',2,'ASCII','VT52','ANSI'
25050 DATA 'Colour: ',3,'AUTO','B&W','4-COLOUR','8-COLOUR'
25060 DATA 'Convert LF: ',1,'NO','YES'
25062 DATA 'Log mode: ',1,'RAW','COOKED'
25065 DATA 'Port: ',3,'SER1I','SER1H','SER2I','SER2H'
