3000 DEFine PROCedure telnet(host$)
3010 LOCal c,chan,option,a$,option$
3020   IF NOT ":" INSTR host$:host$=host$&":23"
3030   chan=FOP_IN("tcp_"&host$)
3040   IF chan<0:PRINT#0;"Could not open a session to ";host$;": ";:REPORT#0:RETurn
3050   option$=CHR$(255)&CHR$(253)&CHR$(1): REMark "DO ECHO"
3060   option$=option$&CHR$(255)&CHR$(253)&CHR$(0): REMark "DO Binary Transmission"
3070   option$=option$&CHR$(255)&CHR$(251)&CHR$(0): REMark "WILL Binary Transmission"
3080   option$=option$&CHR$(255)&CHR$(253)&CHR$(3): REMark "DO Suppress Go-Ahead"
3090   option$=option$&CHR$(255)&CHR$(251)&CHR$(3): REMark "WILL Suppress Go-Ahead"
3100   option$=option$&CHR$(255)&CHR$(251)&CHR$(24): REMark "WILL Terminal Type"
3110   option$=option$&CHR$(255)&CHR$(251)&CHR$(31): REMark "WILL Window Size"
3120   PRINT#chan;option$;
3130   REPeat loop
3140     a$=INKEY$(#chan,50):IF CODE(a$)<>255 THEN EXIT loop
3150     c=CODE(INKEY$(#chan,-1)):REMark command code
3160     IF c>=250 AND c<=254 THEN
3170       option=CODE(INKEY$(#chan,-1))
3180       IF c=250 AND option=24:a$=INKEY$(#chan,-1)
3190       IF c=253:REMark DO command
3200         SELect ON option
3210         =0,3:REMark Binary, Suppress Go-Ahead
3220             PRINT#chan;CHR$(255)&CHR$(251)&CHR$(option);
3230         =24:REMark Terminal Type
3240             PRINT#chan;CHR$(255)&CHR$(250)&CHR$(24)&CHR$(0)&"ANSI"&CHR$(255)&CHR$(240);
3250         =31:REMark Window Size
3260             PRINT#chan;CHR$(255)&CHR$(250)&CHR$(31)&CHR$(0)&CHR$(80)&CHR$(0)&CHR$(24)&CHR$(255)&CHR$(240);
3270         =REMAINDER :PRINT#chan;CHR$(255)&CHR$(252)&CHR$(option);:REMark "WON'T specified option"
3280         END SELect
3290       END IF
3300     END IF
3310   END REPeat loop
3320   EW win1_qlterm,#chan:REMark change win1_ to the device where qlterm resides!
3330   CLOSE#chan
3340 END DEFine telnet
