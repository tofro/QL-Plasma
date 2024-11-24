* debug_asm
* dumps the variable area

*******************************************************************************************
* debug_asm
* debug print raycaster variables
*******************************************************************************************
                INCLUDE 'win1_assembler_macro_lib'
                INCLUDE 'win1_assembler_qdos1_in'
                INCLUDE 'win1_assembler_qdos2_in'

                INCLUDE 'dataSpace_in'
                INCLUDE 'debug_mac'

                XDEF    DebOpen
                XDEF    DebDump                        
                XDEF    DebDump1
                XDef    DebClose

DUMPVAR         MACRO   varName
                EXPAND
                lea     [varName]Str,a1 
                bsr     DebugOut
                bsr     DebugTab
                move.l  [varName](a6),d0
                bsr     debugOutHex
                bsr     DebugTab
                ENDM
                
                SECTION  debug



                dc.w    0

UT.MTEXT        EQU     $d0
UT.MINT         EQU     $ce
CN.ITOHL        EQU     $fe

deblogname      STRING$ {'dos2_raycast_asmlog_log'}
                ds.w 0

debOpen
                DEBUG   {'debOpen'}
                lea.l   deblogname,a0 
                move.l  #-1,d1
                move.l  #3,d3
                QDOSOC$ IO.OPEN
                move.l  a0,dumpChannel(a6)
                rts     

debClose
                DEBUG   'DumpClose'  
                move.l  dumpChannel(a6),a0 
                QDOSOC$ IO.CLOSE
                rts           

* Dumps the same variables at the same points than the C logfile
DEBDUMPREGS     REG     d1-d4
debdump         
                DEBUG   {'debDump'} 
                movem.l DEBDUMPREGS,-(sp)
                move.l  dumpChannel(a6),a0 
                lea     ItTitle,a1 
                bsr     DebugOut
                move.w  x(a6),d0
                bsr     debugOutInt
                lea     ItTitleEnd,a1 
                bsr     DebugOut
                bsr     DebugNL
                DUMPVAR {mapX}
                DumpVar {mapY}
                DumpVar {rayDirX}
                DumpVar {rayDirY}
                DumpVar {cameraX}
                bsr     DebugNL
                DumpVar {planeX}
                DumpVar {planeY}
                DumpVar {dirX}
                DumpVar {dirY}
                bsr     DebugNL
                DumpVar {posX}
                DumpVar {PosY}
                DumpVar {sideDistX}
                DumpVar {sideDistY}
                bsr     DebugNL
                DumpVar {deltaDistX}
                DumpVar {deltaDistY}
                DumpVar {StepX}
                DumpVar {StepY}

                bsr     DebugNL
                bsr     DebugNL


                movem.l (sp)+,DEBDUMPREGS
                rts

                GENIF 0 = 0
DEBDMPR1    REG     d1-d4
debdump1         
                DEBUG   {'debDump1'} 
                move.l  dumpChannel(a6),a0 
                lea     DDATitle,a1 
                bsr     DebugOut
                movem.l DEBDMPR1,-(sp)
                DumpVar {mapX}
                DumpVar {mapY}
                DumpVar {sideDistX}
                DumpVar {sideDistY}
                DumpVar {side}

                bsr     DebugNL 

                movem.l (sp)+,DEBDMPR1
                rts

ItTitle         STRING$ {'------- Iteration '}
ItTitleEnd      STRING$ {'-------',10}

DDATitle        STRING$ {'DDA Iteration, '}

                ds.w    0


DebugOutRegs    REG     d1-d3/a1-a2
DebugOut
                movem.l DebugOutRegs,-(sp)
                move.l  dumpChannel(a6),a0
                move.w  UT.MTEXT,a2 
                jsr     (a2)
                movem.l (sp)+,DebugOutRegs
                rts

***************************************************************************************
* debugOutHex
* dumps contents of d0 as 8-digit hex number to logfile
***************************************************************************************
dumpHexregs     REG     d0-d3/a0-a3
debugOutHex
                ; DEBUG   {'dumpd0'}
                movem.l dumpHexregs,-(sp)
                move.l  #stack,a1               ; a6-relative!
                move.l  #hexbuf,a0
                move.l  d0,0(a6,a1.l)           ; put number on stack
                move.w  CN.ITOHL,a2
                jsr     (a2)
                move.w  #8,hexbuflen(a6)
                move.l  dumpChannel(a6),a0
                move.w  UT.MTEXT,a2
                lea.l   hexbuflen(a6),a1
                jsr     (a2)

                movem.l (sp)+,dumpHexregs
                rts

DebugTab
                movem.l d1/a0-a1,-(sp)
                move.l  dumpChannel(a6),a0 
                move.b  #9,d1
                move.l  #-1,d3
                QDOSIO$ IO.SBYTE
                movem.l (sp)+,d1/a0-a1
                rts

DebugNL
                movem.l d1/a0-a1,-(sp)
                move.l  dumpChannel(a6),a0 
                move.b  #10,d1
                move.l  #-1,d3
                QDOSIO$ IO.SBYTE
                movem.l (sp)+,d1/a0-a1
                rts


***************************************************************************************
* debugOutInt
* dumps contents of d0 as integer to logfile
***************************************************************************************
dumpIntregs        REG     d1-d3/a0-a3
debugOutInt
                DEBUG   {'debugOutInt'}
                movem.l dumpIntregs,-(sp)
                move.w  d0,d1
                move.l  dumpChannel(a6),a0 
                move.w  UT.MINT,a2 
                jsr     (a2)
                movem.l (sp)+,dumpIntregs
                rts

                END


