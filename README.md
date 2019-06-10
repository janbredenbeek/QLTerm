# QLTerm
## QL Terminal Emulator and Telnet client

QLTerm is a small and simple program that enables you to use the Sinclair QL, or a QL-compatible computer, as a terminal for communication with other computer systems (e.g. a Bulletin Board System), using the RS232 serial interface and a modem. 

QLTerm supports the plain ASCII, VT52 and ANSI terminal standard, including the PC extended character set and colour commands. 

In addition, QLTerm provides file-transfer (up- and download) using the XMODEM protocol (with and without CRC error detection).

Finally, with the advent of QL emulators which support TCP/IP access through the TCP device, such as QPC, Qemulator, SMSQmulator and uqlx, QLTerm can be used as a Telnet client to access remote systems using the Telnet protocol. This has not yet been fully implemented, but QLTerm has been tested successfully against a number of Telnet BBS and Linux systems. Please see the included TELNET_BAS file which can be used to establish a Telnet session from S*BASIC.
