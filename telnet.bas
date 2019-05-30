2000 DEFine PROCedure telnet(host$)
2010 LOCal chan
2020   IF NOT ":" INSTR host$:host$=host$&":23"
2030   chan=FOP_IN("tcp_"&host$)
2040   IF chan<0:PRINT#0;"Could not open a session to ";host$;": ";:REPORT#0:RETurn
2050   PRINT#chan;CHR$(255);CHR$(253);CHR$(1);: REMark "DO ECHO"
2060   PRINT#chan;CHR$(255);CHR$(253);CHR$(0);: REMark "DO BINARY TRANSMISSION"
2070   PRINT#chan;CHR$(255);CHR$(251);CHR$(0);: REMark "WILL BINARY TRANSMISSION"
2080   EW win1_qlterm,#chan:REMark change win1_ to the device where qlterm resides!
2090   CLOSE#chan
2100 END DEFine telnet
