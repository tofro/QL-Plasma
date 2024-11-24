***********************************************************************************++
* Plasma
*
* Old-school plasma demo for SMSQ/E and High-Colour
*
************************************************************************************
                INCLUDE 'win1_assembler_qdos1_in'
                INCLUDE 'win1_assembler_qdos2_in'
                INCLUDE 'win1_assembler_macro_lib'

                INCLUDE 'dataspace_in'
                INCLUDE 'generic_mac'

                XREF    sinTab

initialWavCos   EQU     7
initialWavSin   EQU     9

                SECTION Code
CodeStart:
Start:          JOBSTRT {'Plasma'},RealStart
                VERSION {'Plasma Demo for SMSQ/E 0.1'},{'tofro'}

RealStart       
                lea.l   0(a6,a4.l),a6               ; let a6 point to data space

                lea     windowDef,a1
                move.w  UT.CON,a2
                jsr     (a2)

                move.l  a0,channelId(a6)

                move.w  #initialWavSin,waveSin(a6)
                move.w  #initialWavCos,waveCos(a6)

                move.w  #9,waveSinInc(a6)           ; increment value for sin wave
                move.w  #7,waveCosInc(a6)           ; increment Value for cos wave

                move.w  winw(pc),d6
                move.w  winh(pc),d5

                move.l  #$00010001,blkDef(a6)       ; initialize blk width and height to 1

                lea     sinTab,a5

newFrame
                move.l  #0,blkX(a6)                 ; x and y coordinate 0

                move.w  waveCos(a6),d4              ; get current position
                add.w   waveCosInc(a6),d4           ; get per frame shift
                move.w  d4,waveCos(a6)              ; and shift it
                
                move.w  waveSin(a6),d4              ; same for the sine wave
                add.w   waveSinInc(a6),d4
                move.w  d4,waveSin(a6)

                move.l  channelId(a6),a0
                
colLoop
                addq    #1,blkX(a6)                 ; for each window column
                move.w  blkX(a6),d4
                cmp.w   winW(pc),d4
                beq     newFrame

                move.w  #0,blkY(a6)
rowLoop                                             ; for each window row
                move.w  waveSin(a6),d4

                move.w  blkY(a6),d3                 ; colour = sin (column)
                add.w   d3,d3
                add.w   d3,d4
                and.w   #$3ff,d4
                add.l   d4,d4
                move.w  0(a5,d4.w),d1               

                move.w  waveCos(a6),d4
                
                add.w   blkX(a6),d4                 ; colour += sin (row)
                and.w   #$3ff,d4
                add.w   d4,d4
                add.w   0(a5,d4.w),d1

                move.w  blkY(a6),d2                 ; colour += sin (row + column)
                add.w   blkX(a6),d2
                add.w   d2,d2
                and.w   #$3ff,d2
                add.w   0(a5,d2.w),d1

                asr.w   #5,d1                       ; colour /= 16


                ; plot here....
                bsr     setBlk                      ; and set the pixel

                addq    #1,blkY(a6)
                move.w  blkY(a6),d5
                cmp.w   winH(pc),d5

                bne.s   rowLoop
                bra     colLoop

setBlk
                moveq   #-1,d3
                lea.l   blkDef(a6),a1
                QDOSIO$ $2e
                rts

errout
                move.l  channelId(a6),a0
                move.w  UT.ERR,a2
                jsr     (a2)
                bra     exitProg

OKExit

exitProg
                moveq   #-1,d1
                move.l  #100,d3                 ; wait 2s for signoff mesg
                sub.l   a1,a1
                QDOSMT$ MT.SUSJB

                moveq   #-1,d1
                moveq   #0,d3
                QDOSMT$ MT.FRJOB

forever
                bra.s   forever                ; should never be reached

                

windowDef
                dc.b    4               ; Border
                dc.b    1               ; border width
                dc.b    0               ; paper
                dc.b    7               ; ink
winW            dc.w    256
winH            dc.w    256
                dc.w    0
                dc.w    0

                END
