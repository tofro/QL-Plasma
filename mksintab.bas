100 REMark Create 1024 sine table
105 MANIFEST : sinSize = 1024
107 PRINT "Creating sine table sintab_asm"
110 s = FOP_IN ("dos2_plasma_sintab_asm")
120 IF s >= 0 THEN
130    CLOSE #s
140    DELETE "dos2_plasma_sintab_asm"
150 END IF
160 s = FOP_NEW ("dos2_plasma_sintab_asm")
170 :
180 PRINT #s; CHR$(9); "SECTION SineTab"
190 PRINT #s; CHR$(9) & "XDEF sinTab, sinSize"
195 PRINT #s; "sinSize:" & CHR$(9) & "dc.w " & CHR$ (9) &sinSize
200 PRINT #s; "sinTab:"
210 :
220 FOR i = 0 TO sinSize
230    sine = SIN (2 * PI / sinSize * i) * 128 + 128
250    IF i MOD 8 = 0 THEN
260      PRINT #s : PRINT #s; CHR$(9); "dc.w"; CHR$ (9);
270    ELSE
280      PRINT #s;",";
285    END IF
286    PRINT #s;INT (sine);
290 END FOR i
300 CLOSE #s
310 PRINT "done"
