* QLTERM TERMINAL EMULATOR
* Licenced under GPL v3 Licence (2019)
* See https://github.com/janbredenbeek/QLTerm for latest version from the author
* This should be assembled and linked using the GST/Quanta Assembler and Linker
* (see http://www.dilwyn.me.uk/asm/index.html)

*
*        ibmgr_asm: Character set for PC-style graphic characters
*


         module   ibmgr
         section  code

         xdef     gr_set1

         data     0

gr_set1  dc.b     128
         dc.b     256+17-128

         dc.b     %0111000          128,80
         dc.b     %1000100
         dc.b     %1000000
         dc.b     %1000000
         dc.b     %1000000
         dc.b     %1000100
         dc.b     %0111000
         dc.b     %0010000
         dc.b     %0110000

         dc.b     %1000100          129,81,�
         dc.b     0
         dc.b     0
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111100
         dc.b     0,0

         dc.b     %0001000          130,82,�
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %0111100
         dc.b     0,0

         dc.b     %0010000          131,83,�
         dc.b     %0101000
         dc.b     0
         dc.b     %0111100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0,0

         dc.b     %1000100          132,84,�
         dc.b     0
         dc.b     %0110100
         dc.b     %1001100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0,0

         dc.b     %0100000          133,85,�
         dc.b     %0010000
         dc.b     %0110100
         dc.b     %1001100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0,0

         dc.b     %0010000          134,86,�
         dc.b     %0101000
         dc.b     %0010000
         dc.b     %0111100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0,0

         dc.b     0                 135,87
         dc.b     0
         dc.b     %0111100
         dc.b     %1000000
         dc.b     %1000000
         dc.b     %1000000
         dc.b     %0111100
         dc.b     %0001000
         dc.b     %0111000

         dc.b     %0010000          136,88,�
         dc.b     %0101000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %0111100
         dc.b     0,0

         dc.b     %1000100          137,89,�
         dc.b     0
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %0111100
         dc.b     0,0

         dc.b     %0100000          138,8A,�
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %0111100
         dc.b     0,0

         dc.b     %1000100          139,8B,�
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0001000
         dc.b     0,0

         dc.b     %0010000          140,8C,�
         dc.b     %0101000
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0001000
         dc.b     0,0

         dc.b     %0100000          141,8D,�
         dc.b     %0010000
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0001000
         dc.b     0,0

         dc.b     %1000100          142,8E,�
         dc.b     %0010000
         dc.b     %0101000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     0,0

         dc.b     %0010000          143,8F,�
         dc.b     %0101000
         dc.b     %0010000
         dc.b     %0101000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000100
         dc.b     0,0

         dc.b     %0001000          144,90,�
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %1111100
         dc.b     %1000000
         dc.b     %1111100
         dc.b     0,0

         dc.b     0                 145,91,ae
         dc.b     0
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %0111000
         dc.b     %1110000
         dc.b     %0101100
         dc.b     0,0

         dc.b     %0101100          146,92,AE
         dc.b     %1010000
         dc.b     %1010000
         dc.b     %1111100
         dc.b     %1010000
         dc.b     %1010000
         dc.b     %1011100
         dc.b     0,0

         dc.b     %0010000          147,93,�
         dc.b     %0101000
         dc.b     0
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %1000100          148,94,�
         dc.b     0
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0100000          149,95,�
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0010000          150,96,�
         dc.b     %0101000
         dc.b     %0000000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111100
         dc.b     0,0

         dc.b     %0100000          151,97,�
         dc.b     %0010000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111100
         dc.b     0,0

         dc.b     %1000100          152,98
         dc.b     %0000000
         dc.b     %1000100
         dc.b     %0101000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0111000
         dc.b     0

         dc.b     %1000100          153,99,�
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %1000100          154,9A,�
         dc.b     0
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0                 155,9B,�
         dc.b     0
         dc.b     %0001000
         dc.b     %0111100
         dc.b     %1001000
         dc.b     %1001000
         dc.b     %0111100
         dc.b     %0001000
         dc.b     0

         dc.b     %0011000          156,9C,`
         dc.b     %0100100
         dc.b     %0100000
         dc.b     %1110000
         dc.b     %0100000
         dc.b     %0100000
         dc.b     %1111100
         dc.b     0,0

         dc.b     %1000100          157,9D,�
         dc.b     %1000100
         dc.b     %0101000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0111000
         dc.b     0,0

         dc.b     %1100000          158,9E
         dc.b     %1010000
         dc.b     %1010000
         dc.b     %1111000
         dc.b     %1011100
         dc.b     %1001000
         dc.b     %1001100
         dc.b     0,0

         dc.b     %0001000          159,9F
         dc.b     %0010100
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1010000
         dc.b     %0100000
         dc.b     0

         dc.b     %0001000          160,A0,�
         dc.b     %0010000
         dc.b     %0110100
         dc.b     %1001100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0,0

         dc.b     %0001000          161,A1,�
         dc.b     %0010000
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0001000
         dc.b     0,0

         dc.b     %0001000          162,A2,�
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0001000          163,A3,�
         dc.b     %0010000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111100
         dc.b     0,0

         dc.b     %0010100          164,A4,�
         dc.b     %0101000
         dc.b     0
         dc.b     %1111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     0,0

         dc.b     %0111000          165,A5,�
         dc.b     0
         dc.b     %1000100
         dc.b     %1100100
         dc.b     %1010100
         dc.b     %1001100
         dc.b     %1000100
         dc.b     0,0

         dc.b     0                  166,A6
         dc.b     %0110100
         dc.b     %1001100
         dc.b     %1000100
         dc.b     %1001100
         dc.b     %0110100
         dc.b     0
         dc.b     %1111100
         dc.b     0

         dc.b     0                 167,A7
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0
         dc.b     %1111100
         dc.b     0

         dc.b     %0010000          168,A8
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0100000
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0,0,0             169,A9
         dc.b     %1111100
         dc.b     %1000000
         dc.b     0,0,0,0

         dc.b     0,0,0             170,AA
         dc.b     %1111100
         dc.b     %0000100
         dc.b     0,0,0,0

         dc.b     %0010000          171,AB
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0110000
         dc.b     %1001000
         dc.b     %0010000
         dc.b     %1111000
         dc.b     0

         dc.b     %0010000          172,AC
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0100000
         dc.b     %1111000
         dc.b     %0010000
         dc.b     0

         dc.b     %0010000          173,AD
         dc.b     0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     0,0

         dc.b     0                 174,AE,�
         dc.b     %0010100
         dc.b     %0101000
         dc.b     %1010000
         dc.b     %0101000
         dc.b     %0010100
         dc.b     0,0,0

         dc.b     0                 175,AF,�
         dc.b     %1010000
         dc.b     %0101000
         dc.b     %0010100
         dc.b     %0101000
         dc.b     %1010000
         dc.b     0,0,0

         dc.b     %0101000          176,B0
         dc.b     %1010100
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %0101000

         dc.b     %1101000          177,B1
         dc.b     %0100100
         dc.b     %1101000
         dc.b     %0100100
         dc.b     %1101000
         dc.b     %0100100
         dc.b     %1101000
         dc.b     %0100100
         dc.b     %1101000

         dc.b     %1101000          178,B2
         dc.b     %0101100
         dc.b     %1101000
         dc.b     %0101100
         dc.b     %1101000
         dc.b     %0101100
         dc.b     %1101000
         dc.b     %0101100
         dc.b     %1101000

         dc.b     %0010000          179,B3
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          180,B4
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          181,B5
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0101000          182,B6
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     0,0,0,0           183,B7
         dc.b     %1111000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     0,0,0             184,B8
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0101000          185,B9
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1101000
         dc.b     %0001000
         dc.b     %1101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          186,BA
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     0,0,0             187,BB
         dc.b     %1111000
         dc.b     %0001000
         dc.b     %1101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          188,BC
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1101000
         dc.b     %0001000
         dc.b     %1111000
         dc.b     0,0,0

         dc.b     %0101000          189,BD
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1111000
         dc.b     0,0,0,0

         dc.b     %0010000          190,BE
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     0,0,0

         dc.b     0,0,0,0           191,BF
         dc.b     %1110000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000


*gr_set2  dc.b     128
*         dc.b     192-255

         dc.b     %0010000          192,C0
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0011100
         dc.b     0,0,0,0

         dc.b     %0010000          193,C1
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     0,0,0,0

         dc.b     0,0,0,0           194,C2
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          195,C3
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     0,0,0,0           196,C4
         dc.b     %1111100
         dc.b     0,0,0,0

         dc.b     %0010000          197,C5
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          198,C6
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0101000          199,C7
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          200,C8
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101100
         dc.b     %0100000
         dc.b     %0111100
         dc.b     0,0,0

         dc.b     0,0,0             201,C9
         dc.b     %0111100
         dc.b     %0100000
         dc.b     %0101100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          202,CA
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1101100
         dc.b     0
         dc.b     %1111100
         dc.b     0,0,0

         dc.b     0,0,0             203,CB
         dc.b     %1111100
         dc.b     0
         dc.b     %1101100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          204,CC
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101100
         dc.b     %0100000
         dc.b     %0101100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     0,0,0             205,CD
         dc.b     %1111100
         dc.b     0
         dc.b     %1111100
         dc.b     0,0,0

         dc.b     %0101000          206,CE
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1101100
         dc.b     0
         dc.b     %1101100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0010000          207,CF
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     0
         dc.b     %1111100
         dc.b     0,0,0

         dc.b     %0101000          208,D0
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1111100
         dc.b     0,0,0,0

         dc.b     0,0,0             209,D1
         dc.b     %1111100
         dc.b     0
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     0,0,0,0           210,D2
         dc.b     %1111100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          211,D3
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0111100
         dc.b     0,0,0,0

         dc.b     %0010000          212,D4
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0011100
         dc.b     0,0,0

         dc.b     0,0,0             213,D5
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     0,0,0,0           214,D6
         dc.b     %0111100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0101000          215,D7
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %1111100
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000

         dc.b     %0010000          216,D8
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          217,D9
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     0,0,0,0

         dc.b     0,0,0,0           218,DA
         dc.b     %0011100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %1111100          219,DB
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100

         dc.b     0,0,0,0,0         220,DC
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100

         dc.b     %1110000          221,DD
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000
         dc.b     %1110000

         dc.b     %0011100          222,DE
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100
         dc.b     %0011100

         dc.b     %1111100          223,DF
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     0,0,0,0,0

         dc.b     0,0               224,E0,�
         dc.b     %0100100
         dc.b     %1011000
         dc.b     %1001000
         dc.b     %1011000
         dc.b     %0100100
         dc.b     0,0

         dc.b     0                 225,E1,�
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1011000
         dc.b     %1000100
         dc.b     %1011000
         dc.b     %1000000
         dc.b     %1000000
         dc.b     0

         dc.b     0                 226,E2
         dc.b     %1111100
         dc.b     %0100100
         dc.b     %010000
         dc.b     %010000
         dc.b     %010000
         dc.b     %111000
         dc.b     0,0

         dc.b     0,0               227,E3,�
         dc.b     %0111100
         dc.b     %1101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     0,0

         dc.b     %1111100          228,E4
         dc.b     %1000100
         dc.b     %0100000
         dc.b     %0010000
         dc.b     %0100000
         dc.b     %1000100
         dc.b     %1111100
         dc.b     0,0

         dc.b     0,0,0             229,E5
         dc.b     %0111100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0,0,0             230,E6
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111100
         dc.b     %1000000
         dc.b     %0

         dc.b     0,0               231,E7
         dc.b     %0111100
         dc.b     %1010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0011000
         dc.b     0,0

         dc.b     %0010000          232,E8
         dc.b     %0111000
         dc.b     %1010100
         dc.b     %1010100
         dc.b     %1010100
         dc.b     %0111000
         dc.b     %0010000
         dc.b     0,0

         dc.b     %0111000          233,E9
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0                 234,EA
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0101000
         dc.b     %1000100
         dc.b     0,0

         dc.b     0                 235,EB
         dc.b     %0001100
         dc.b     %0001000
         dc.b     %0101000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0,0,0             236,EC
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %1010100
         dc.b     %0101000
         dc.b     0,0

         dc.b     0                 237,ED
         dc.b     %0001000
         dc.b     %1010100
         dc.b     %1010100
         dc.b     %0111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     0,0

         dc.b     0,0               238,EE
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %0100000
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     0                 239,EF
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %1000100
         dc.b     0,0

         dc.b     0,0               240,F0
         dc.b     %1111100
         dc.b     0
         dc.b     %1111100
         dc.b     0
         dc.b     %1111100
         dc.b     0,0

         dc.b     0                 241,F1
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1111100
         dc.b     0,0

         dc.b     0                 242,F2
         dc.b     %1000000
         dc.b     %0110000
         dc.b     %0001100
         dc.b     %0110000
         dc.b     %1000000
         dc.b     %1111100
         dc.b     0,0

         dc.b     0                 243,F3
         dc.b     %0000100
         dc.b     %0011000
         dc.b     %1100000
         dc.b     %0011000
         dc.b     %0000100
         dc.b     %1111100
         dc.b     0,0

         dc.b     0                 244,F4
         dc.b     %0001000
         dc.b     %0010100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000

         dc.b     %0010000          245,F5
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1010000
         dc.b     %0100000
         dc.b     0

         dc.b     0,0               246,F6
         dc.b     %0010000
         dc.b     0
         dc.b     %1111100
         dc.b     0
         dc.b     %0010000
         dc.b     0,0

         dc.b     0,0               247,F7
         dc.b     %0100000
         dc.b     %1010100
         dc.b     %0101000
         dc.b     %1010100
         dc.b     %0001000
         dc.b     0,0

         dc.b     %0110000          248,F8
         dc.b     %1001000
         dc.b     %1001000
         dc.b     %0110000
         dc.b     0
         dc.b     0
         dc.b     0
         dc.b     0,0

         dc.b     0,0,0             249,F9
         dc.b     %0011000
         dc.b     %0011000
         dc.b     0,0,0,0

         dc.b     0                 250,FA
         dc.b     0
         dc.b     0
         dc.b     %0010000
         dc.b     0
         dc.b     0
         dc.b     0
         dc.b     0,0

         dc.b     %0000100          251,FB
         dc.b     %0001000
         dc.b     %0001000
         dc.b     %1101000
         dc.b     %0101000
         dc.b     %0101000
         dc.b     %0010000
         dc.b     0,0

         dc.b     0,0,0             252,FC
         dc.b     %1011000
         dc.b     %1101000
         dc.b     %1001000
         dc.b     %1001000
         dc.b     %0001000
         dc.b     %0000100

         dc.b     %0110000          253,FD
         dc.b     %1001000
         dc.b     %0010000
         dc.b     %1111000
         dc.b     0,0,0,0,0

         dc.b     0,0,0             254,FE
         dc.b     %0111000
         dc.b     %0111000
         dc.b     %0111000
         dc.b     0,0,0

         dc.b     0,0,0,0,0,0,0,0,0 255,FF

         dc.b     0,0,0,0,0,0,0,0,0 0,00

         dc.b     %0111000          1,01
         dc.b     %1000100
         dc.b     %1010100
         dc.b     %1000100
         dc.b     %1111100
         dc.b     %1010100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0111000          2,02
         dc.b     %1111100
         dc.b     %1101100
         dc.b     %1111100
         dc.b     %1000100
         dc.b     %1101100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0000000          3,03
         dc.b     %0000000
         dc.b     %0101000
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %0111000
         dc.b     %0010000
         dc.b     0,0

         dc.b     %0000000          4,04
         dc.b     %0000000
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1111100
         dc.b     %0111000
         dc.b     %0010000
         dc.b     0,0

         dc.b     %0000000          5,05
         dc.b     %0000000
         dc.b     %0111000
         dc.b     %1101100
         dc.b     %1101100
         dc.b     %0010000
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0000000          6,06
         dc.b     %0000000
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %0010000
         dc.b     0,0

         dc.b     %0000000          7,07
         dc.b     %0000000
         dc.b     %0000000
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %0010000
         dc.b     %0000000
         dc.b     0,0

         dc.b     %1111100          8,08
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1101100
         dc.b     %1000100
         dc.b     %1101100
         dc.b     %1111100
         dc.b     %1111100
         dc.b     %1111100

         dc.b     %0000000          9,09
         dc.b     %0000000
         dc.b     %0010000
         dc.b     %0101000
         dc.b     %1000100
         dc.b     %0101000
         dc.b     %0010000
         dc.b     0,0

         dc.b     %1111100          10,0A
         dc.b     %1111100
         dc.b     %1101100
         dc.b     %1010100
         dc.b     %0111000
         dc.b     %1010100
         dc.b     %1101100
         dc.b     %1111100
         dc.b     %1111100

         dc.b     %0001100          11,0B
         dc.b     %0001100
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     0,0

         dc.b     %0111000          12,0C
         dc.b     %1000100
         dc.b     %1000100
         dc.b     %0111000
         dc.b     %0010000
         dc.b     %0111000
         dc.b     %0010000
         dc.b     0,0

         dc.b     %0010000          13,0D
         dc.b     %0011000
         dc.b     %0010100
         dc.b     %0010000
         dc.b     %0010000
         dc.b     %1110000
         dc.b     %1100000
         dc.b     0,0

         dc.b     %0111100          14,0E
         dc.b     %0100100
         dc.b     %0111100
         dc.b     %0100100
         dc.b     %0101100
         dc.b     %1101100
         dc.b     %1100000
         dc.b     0,0

         dc.b     %0010000          15,0F
         dc.b     %1010100
         dc.b     %0111000
         dc.b     %1101100
         dc.b     %0111000
         dc.b     %1010100
         dc.b     %0010000
         dc.b     0,0

         dc.b     %1000000          16,10
         dc.b     %1100000
         dc.b     %1110000
         dc.b     %1111100
         dc.b     %1110000
         dc.b     %1100000
         dc.b     %1000000
         dc.b     0,0

         dc.b     %0000100          17,11
         dc.b     %0001100
         dc.b     %0011100
         dc.b     %1111100
         dc.b     %0011100
         dc.b     %0001100
         dc.b     %0000100
         dc.b     0,0

         end
