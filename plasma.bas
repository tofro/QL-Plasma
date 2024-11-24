100 DIM sin256 (256)
110 :
115 COLOUR_PAL
120 DEFine PROCedure InitSin
130   LOCal i, v
140   OPEN_NEW#4,dos2_plasma_sintab_asm
150   PRINT #4,CHR$(9);"SECTION DATA"
160   PRINT #4,CHR$(9);"XDEF sinTab"
170   PRINT #4;"sinTab:"
180   FOR i = 0 TO 256
190     v = (SIN (2 * PI * i / 256))*127 + 127
200     sin256 (i) = INT (v)
210     IF i MOD 16 = 0 OR i = 1 THEN
220        PRINT#4:PRINT#4,CHR$(9);"dc.b";CHR$(9);
230     ELSE
235        PRINT#4;",";
237     END IF
240     PRINT#4;INT(v);
250   END FOR i
255   CLOSE#4
260 END DEFine InitSin
270 :
280 DEFine PROCedure drawPlasma (x, y, w, h, t)
290   LOCal c, c1, c2, c3, v1, v2, i%, j%
300   v1 = sin256 ((t * 3) MOD 256)
310   v2 = sin256 ((64 + t * 5) MOD 256)
320   FOR j% = y TO y + h
330     c3 = sin256((j% * 3 + t * 3) MOD 256)
340     FOR i% = x TO x + w
350       c1 = sin256 ((i% * 3 + t * 2) MOD 256)
360       c2 = sin256 (((i% * v1) / w + (j% * v2) / h + t) MOD 256)
370       c = (c1 + c2 + c3)
380       WM_BLOCK 1, 1, i%, j%, c
390     END FOR i%
400   END FOR j%
410 END DEFine drawPlasma
420 :
430 do_quit = 0
440 InitSin
450 t = RND (4096)
460 REPeat PlasLoop
470   IF INKEY$ <> "" : EXIT PlasLoop
480   drawPlasma 0,0,160, 100, t
490   t = t + 1
500 END REPeat PlasLoop
