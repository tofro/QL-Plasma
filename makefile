#
# Plasma demo for SMSQ/E
#
# Assumptions:
#   DATA_USE points to Device/Directory holding the Sources
#   LINK_TARGET environment variable holds the name of the binary to create
#
# Program filenames
#
ASM  = win1_assembler_qmac
LK   = win1_assembler_qlink
MK   = win1_c68_make
SH   = win1_c68_sh
TC   = win1_c68_touch
RM   = win1_c68_rm

#
# Assembler command line options
#
ASMCMD   = -list -link 
LINK_TARGET = plasma_exe
MAPFILE = ram1_plasma_map
LINK_OPTIONS= -prog ${LINK_TARGET} -list ${MAPFILE} -crf -filetype 1

D = dos2_plasma_
L = win1_assembler_

#
# Input files
#

# All other files
OBJS = plasma_rel sintab_rel

# The rel file that is the "main program" (and thus goes first...)
MAIN_OBJ = plasma_rel

VER = ver_in

default: ${MAIN_OBJ} ${OBJS}
  ${LK} ${MAIN_OBJ} link ${LINK_TARGET} ${LINK_OPTIONS}
clean:
  ${RM} ${MAIN_OBJ} ${OBJS} ${LINK_TARGET} ${MAPFILE} *_bin *_list ram1_err *.list *.rel
zip: ram1_plasma_exe
  zip -jD plasma_zip ram1_plasma_exe
#
# Header file dependencies
#

#
# Rule for turning _asm into _rel files
#
_asm_rel:
    ${ASM} $C$*_asm ${ASMCMD}
.asm.rel:
    ${ASM} $C$*.asm ${ASMCMD}
