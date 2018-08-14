#!/usr/bin/env python

#
# File taken from git@github.com:riscv/riscv-opcodes.git
#
#   Modified for use with the SCARV Crypto ISE project.
#
#

import math
import sys
import tokenize

namelist = []
match = {}
mask = {}
pseudos = {}
arguments = {}

cargs= ['imm11'   , 'imm11hi' , 'imm11lo' , 'imm5'
, 'cshamt'  , 'cmshamt' , 'b0'      , 'b1'      ,
'b2'      , 'b3'      , 'ca'      , 'cb'      ,
'cc'      , 'cd'      , 'crs1'    , 'crs2'    ,
'crs3'    , 'crs4'    , 'crd'     , 'crdm'    ,
'lut4'   ]

acodes = {}
acodes['imm11'  ] = "Xl"
acodes['imm11hi'] = "Xm"
acodes['imm11lo'] = "Xn"
acodes['imm5'   ] = "Xo"
acodes['cshamt' ] = "XR"
acodes['cmshamt'] = "Xr"
acodes['b0'     ] = "Xw"
acodes['b1'     ] = "Xx"
acodes['b2'     ] = "Xy"
acodes['b3'     ] = "Xz"
acodes['ca'     ] = "Xa"
acodes['cb'     ] = "Xb"
acodes['cc'     ] = "Xc"
acodes['cd'     ] = "Xd"
acodes['crs1'   ] = "Xs"
acodes['crs2'   ] = "Xt"
acodes['crs3'   ] = "XS"
acodes['crs4'   ] = "XT"
acodes['crd'    ] = "XD"
acodes['crdm'   ] = "XM"
acodes['lut4'   ] = "Xl"
acodes['rd'     ] = "Xd"
acodes['rs1'    ] = "Xs"

arglut = {}
arglut['imm11'  ] = (31,21)
arglut['imm11hi'] = (31,25)
arglut['imm11lo'] = (10, 7)
arglut['imm5'   ] = (19,15)
arglut['cshamt' ] = (23,20)
arglut['cmshamt'] = (27,24)
arglut['b0'     ] = (31,30)
arglut['b1'     ] = (29,28)
arglut['b2'     ] = (27,26)
arglut['b3'     ] = (25,24)
arglut['ca'     ] = (24,24)
arglut['cb'     ] = (19,19)
arglut['cc'     ] = (11,11)
arglut['cd'     ] = (20,20)
arglut['crs1'   ] = (18,15)
arglut['crs2'   ] = (23,20)
arglut['crs3'   ] = (27,24)
arglut['crs4'   ] = (31,28)
arglut['crd'    ] = (10, 7)
arglut['crdm'   ] = ( 9, 7)
arglut['lut4'   ] = (28,25)

arglut['rd'] = (11,7)
arglut['rs1'] = (19,15)
arglut['rs2'] = (24,20)
arglut['rs3'] = (31,27)
arglut['aqrl'] = (26,25)
arglut['fm'] = (31,28)
arglut['pred'] = (27,24)
arglut['succ'] = (23,20)
arglut['rm'] = (14,12)
arglut['imm20'] = (31,12)
arglut['jimm20'] = (31,12)
arglut['imm12'] = (31,20)
arglut['imm12hi'] = (31,25)
arglut['bimm12hi'] = (31,25)
arglut['imm12lo'] = (11,7)
arglut['bimm12lo'] = (11,7)
arglut['zimm'] = (19,15)
arglut['shamt'] = (25,20)
arglut['shamtw'] = (24,20)
arglut['vseglen'] = (31,29)

causes = [
  (0x00, 'misaligned fetch'),
  (0x01, 'fetch access'),
  (0x02, 'illegal instruction'),
  (0x03, 'breakpoint'),
  (0x04, 'misaligned load'),
  (0x05, 'load access'),
  (0x06, 'misaligned store'),
  (0x07, 'store access'),
  (0x08, 'user_ecall'),
  (0x09, 'supervisor_ecall'),
  (0x0A, 'hypervisor_ecall'),
  (0x0B, 'machine_ecall'),
  (0x0C, 'fetch page fault'),
  (0x0D, 'load page fault'),
  (0x0F, 'store page fault'),
]

csrs = [
  # Standard User R/W
  (0x001, 'fflags'),
  (0x002, 'frm'),
  (0x003, 'fcsr'),

  # Standard User RO
  (0xC00, 'cycle'),
  (0xC01, 'time'),
  (0xC02, 'instret'),
  (0xC03, 'hpmcounter3'),
  (0xC04, 'hpmcounter4'),
  (0xC05, 'hpmcounter5'),
  (0xC06, 'hpmcounter6'),
  (0xC07, 'hpmcounter7'),
  (0xC08, 'hpmcounter8'),
  (0xC09, 'hpmcounter9'),
  (0xC0A, 'hpmcounter10'),
  (0xC0B, 'hpmcounter11'),
  (0xC0C, 'hpmcounter12'),
  (0xC0D, 'hpmcounter13'),
  (0xC0E, 'hpmcounter14'),
  (0xC0F, 'hpmcounter15'),
  (0xC10, 'hpmcounter16'),
  (0xC11, 'hpmcounter17'),
  (0xC12, 'hpmcounter18'),
  (0xC13, 'hpmcounter19'),
  (0xC14, 'hpmcounter20'),
  (0xC15, 'hpmcounter21'),
  (0xC16, 'hpmcounter22'),
  (0xC17, 'hpmcounter23'),
  (0xC18, 'hpmcounter24'),
  (0xC19, 'hpmcounter25'),
  (0xC1A, 'hpmcounter26'),
  (0xC1B, 'hpmcounter27'),
  (0xC1C, 'hpmcounter28'),
  (0xC1D, 'hpmcounter29'),
  (0xC1E, 'hpmcounter30'),
  (0xC1F, 'hpmcounter31'),

  # Standard Supervisor R/W
  (0x100, 'sstatus'),
  (0x104, 'sie'),
  (0x105, 'stvec'),
  (0x106, 'scounteren'),
  (0x140, 'sscratch'),
  (0x141, 'sepc'),
  (0x142, 'scause'),
  (0x143, 'stval'),
  (0x144, 'sip'),
  (0x180, 'satp'),

  # Standard Machine R/W
  (0x300, 'mstatus'),
  (0x301, 'misa'),
  (0x302, 'medeleg'),
  (0x303, 'mideleg'),
  (0x304, 'mie'),
  (0x305, 'mtvec'),
  (0x306, 'mcounteren'),
  (0x340, 'mscratch'),
  (0x341, 'mepc'),
  (0x342, 'mcause'),
  (0x343, 'mtval'),
  (0x344, 'mip'),
  (0x3a0, 'pmpcfg0'),
  (0x3a1, 'pmpcfg1'),
  (0x3a2, 'pmpcfg2'),
  (0x3a3, 'pmpcfg3'),
  (0x3b0, 'pmpaddr0'),
  (0x3b1, 'pmpaddr1'),
  (0x3b2, 'pmpaddr2'),
  (0x3b3, 'pmpaddr3'),
  (0x3b4, 'pmpaddr4'),
  (0x3b5, 'pmpaddr5'),
  (0x3b6, 'pmpaddr6'),
  (0x3b7, 'pmpaddr7'),
  (0x3b8, 'pmpaddr8'),
  (0x3b9, 'pmpaddr9'),
  (0x3ba, 'pmpaddr10'),
  (0x3bb, 'pmpaddr11'),
  (0x3bc, 'pmpaddr12'),
  (0x3bd, 'pmpaddr13'),
  (0x3be, 'pmpaddr14'),
  (0x3bf, 'pmpaddr15'),
  (0x7a0, 'tselect'),
  (0x7a1, 'tdata1'),
  (0x7a2, 'tdata2'),
  (0x7a3, 'tdata3'),
  (0x7b0, 'dcsr'),
  (0x7b1, 'dpc'),
  (0x7b2, 'dscratch'),
  (0xB00, 'mcycle'),
  (0xB02, 'minstret'),
  (0xB03, 'mhpmcounter3'),
  (0xB04, 'mhpmcounter4'),
  (0xB05, 'mhpmcounter5'),
  (0xB06, 'mhpmcounter6'),
  (0xB07, 'mhpmcounter7'),
  (0xB08, 'mhpmcounter8'),
  (0xB09, 'mhpmcounter9'),
  (0xB0A, 'mhpmcounter10'),
  (0xB0B, 'mhpmcounter11'),
  (0xB0C, 'mhpmcounter12'),
  (0xB0D, 'mhpmcounter13'),
  (0xB0E, 'mhpmcounter14'),
  (0xB0F, 'mhpmcounter15'),
  (0xB10, 'mhpmcounter16'),
  (0xB11, 'mhpmcounter17'),
  (0xB12, 'mhpmcounter18'),
  (0xB13, 'mhpmcounter19'),
  (0xB14, 'mhpmcounter20'),
  (0xB15, 'mhpmcounter21'),
  (0xB16, 'mhpmcounter22'),
  (0xB17, 'mhpmcounter23'),
  (0xB18, 'mhpmcounter24'),
  (0xB19, 'mhpmcounter25'),
  (0xB1A, 'mhpmcounter26'),
  (0xB1B, 'mhpmcounter27'),
  (0xB1C, 'mhpmcounter28'),
  (0xB1D, 'mhpmcounter29'),
  (0xB1E, 'mhpmcounter30'),
  (0xB1F, 'mhpmcounter31'),
  (0x323, 'mhpmevent3'),
  (0x324, 'mhpmevent4'),
  (0x325, 'mhpmevent5'),
  (0x326, 'mhpmevent6'),
  (0x327, 'mhpmevent7'),
  (0x328, 'mhpmevent8'),
  (0x329, 'mhpmevent9'),
  (0x32A, 'mhpmevent10'),
  (0x32B, 'mhpmevent11'),
  (0x32C, 'mhpmevent12'),
  (0x32D, 'mhpmevent13'),
  (0x32E, 'mhpmevent14'),
  (0x32F, 'mhpmevent15'),
  (0x330, 'mhpmevent16'),
  (0x331, 'mhpmevent17'),
  (0x332, 'mhpmevent18'),
  (0x333, 'mhpmevent19'),
  (0x334, 'mhpmevent20'),
  (0x335, 'mhpmevent21'),
  (0x336, 'mhpmevent22'),
  (0x337, 'mhpmevent23'),
  (0x338, 'mhpmevent24'),
  (0x339, 'mhpmevent25'),
  (0x33A, 'mhpmevent26'),
  (0x33B, 'mhpmevent27'),
  (0x33C, 'mhpmevent28'),
  (0x33D, 'mhpmevent29'),
  (0x33E, 'mhpmevent30'),
  (0x33F, 'mhpmevent31'),

  # Standard Machine RO
  (0xF11, 'mvendorid'),
  (0xF12, 'marchid'),
  (0xF13, 'mimpid'),
  (0xF14, 'mhartid'),
]

csrs32 = [
  # Standard User RO
  (0xC80, 'cycleh'),
  (0xC81, 'timeh'),
  (0xC82, 'instreth'),
  (0xC83, 'hpmcounter3h'),
  (0xC84, 'hpmcounter4h'),
  (0xC85, 'hpmcounter5h'),
  (0xC86, 'hpmcounter6h'),
  (0xC87, 'hpmcounter7h'),
  (0xC88, 'hpmcounter8h'),
  (0xC89, 'hpmcounter9h'),
  (0xC8A, 'hpmcounter10h'),
  (0xC8B, 'hpmcounter11h'),
  (0xC8C, 'hpmcounter12h'),
  (0xC8D, 'hpmcounter13h'),
  (0xC8E, 'hpmcounter14h'),
  (0xC8F, 'hpmcounter15h'),
  (0xC90, 'hpmcounter16h'),
  (0xC91, 'hpmcounter17h'),
  (0xC92, 'hpmcounter18h'),
  (0xC93, 'hpmcounter19h'),
  (0xC94, 'hpmcounter20h'),
  (0xC95, 'hpmcounter21h'),
  (0xC96, 'hpmcounter22h'),
  (0xC97, 'hpmcounter23h'),
  (0xC98, 'hpmcounter24h'),
  (0xC99, 'hpmcounter25h'),
  (0xC9A, 'hpmcounter26h'),
  (0xC9B, 'hpmcounter27h'),
  (0xC9C, 'hpmcounter28h'),
  (0xC9D, 'hpmcounter29h'),
  (0xC9E, 'hpmcounter30h'),
  (0xC9F, 'hpmcounter31h'),

  # Standard Machine RW
  (0xB80, 'mcycleh'),
  (0xB82, 'minstreth'),
  (0xB83, 'mhpmcounter3h'),
  (0xB84, 'mhpmcounter4h'),
  (0xB85, 'mhpmcounter5h'),
  (0xB86, 'mhpmcounter6h'),
  (0xB87, 'mhpmcounter7h'),
  (0xB88, 'mhpmcounter8h'),
  (0xB89, 'mhpmcounter9h'),
  (0xB8A, 'mhpmcounter10h'),
  (0xB8B, 'mhpmcounter11h'),
  (0xB8C, 'mhpmcounter12h'),
  (0xB8D, 'mhpmcounter13h'),
  (0xB8E, 'mhpmcounter14h'),
  (0xB8F, 'mhpmcounter15h'),
  (0xB90, 'mhpmcounter16h'),
  (0xB91, 'mhpmcounter17h'),
  (0xB92, 'mhpmcounter18h'),
  (0xB93, 'mhpmcounter19h'),
  (0xB94, 'mhpmcounter20h'),
  (0xB95, 'mhpmcounter21h'),
  (0xB96, 'mhpmcounter22h'),
  (0xB97, 'mhpmcounter23h'),
  (0xB98, 'mhpmcounter24h'),
  (0xB99, 'mhpmcounter25h'),
  (0xB9A, 'mhpmcounter26h'),
  (0xB9B, 'mhpmcounter27h'),
  (0xB9C, 'mhpmcounter28h'),
  (0xB9D, 'mhpmcounter29h'),
  (0xB9E, 'mhpmcounter30h'),
  (0xB9F, 'mhpmcounter31h'),
]

opcode_base = 0
opcode_size = 7
funct_base = 12
funct_size = 3

def binary(n, digits=0):
  rep = bin(n)[2:]
  return rep if digits == 0 else ('0' * (digits - len(rep))) + rep


def make_c_extra(match,mask):
    """
    Generates extra useful macros and the like for adding instructions
    to binutils and GAS specifically.
    """
    tp = []
    for field in arglut:
        if not field in cargs:
            continue
        # Generate encode/extract macros for each field which can be
        # dumped into riscv-binutils/include/opcode/riscv.h
        enc_name = "ENCODE_X_%s" % (field.upper())
        ext_name = "EXTRACT_X_%s" % (field.upper())
        
        fsize = 1 + (arglut[field][0] - arglut[field][1])
        flow  = arglut[field][1]
        fmask = "0b" + ("1"*fsize)
        
        tp.append("#define OP_MASK_%s %s" %(field.upper(), fmask))
        tp.append("#define OP_SH_%s %s" %(field.upper(), flow))
        tp.append("#define %s(X)  ((X &  OP_MASK_%s) << OP_SH_%d)" %(
            enc_name,fmask,flow))
        tp.append("#define %s(X) ((X >> OP_SH_%d)  & OP_MASK_%s)" %(
            ext_name,flow,fmask))
    tp.sort()


    # Generate instruction and argument definitions
    for mnemonic in namelist:
        tw  = "{\"%s\", " % mnemonic     # instr name
        tw += "\"X\", "                 # ISA / ISE

        fields = sorted(arguments[mnemonic])
        tw += "\"%s\", " % ",".join([acodes[f] for f in fields])

        tw += "MATCH_%s, " %(mnemonic.replace(".","_").upper())
        tw += "MASK_%s, "  %(mnemonic.replace(".","_").upper())
        tw += "match_opcode, 0},"
        
        tp.append(tw)

    for l in tp:
        print(l)
    


def make_c(match,mask):
  print '/* Automatically generated by parse-opcodes.  */'
  print '#ifndef RISCV_ENCODING_H'
  print '#define RISCV_ENCODING_H'
  for name in namelist:
    name2 = name.upper().replace('.','_')
    print '#define MATCH_%s %s' % (name2, hex(match[name]))
    print '#define MASK_%s  %s' % (name2, hex(mask[name]))
  for num, name in csrs+csrs32:
    print '#define CSR_%s %s' % (name.upper(), hex(num))
  for num, name in causes:
    print '#define CAUSE_%s %s' % (name.upper().replace(' ', '_'), hex(num))
  print '#endif'

  print '#ifdef DECLARE_INSN'
  for name in namelist:
    name2 = name.replace('.','_')
    print 'DECLARE_INSN(%s, MATCH_%s, MASK_%s)' % (name2, name2.upper(), name2.upper())
  print '#endif'

  print '#ifdef DECLARE_CSR'
  for num, name in csrs+csrs32:
    print 'DECLARE_CSR(%s, CSR_%s)' % (name, name.upper())
  print '#endif'

  print '#ifdef DECLARE_CAUSE'
  for num, name in causes:
    print 'DECLARE_CAUSE("%s", CAUSE_%s)' % (name, name.upper().replace(' ', '_'))
  print '#endif'
  make_c_extra(match,mask)

def yank(num,start,len):
  return (num >> start) & ((1 << len) - 1)

def str_arg(arg0,name,match,arguments):
  if arg0 in arguments:
    return name or arg0
  else:
    start = arglut[arg0][1]
    len = arglut[arg0][0] - arglut[arg0][1] + 1
    return binary(yank(match,start,len),len)

def str_inst(name,arguments):
  return name.replace('.rv32','').upper()

def print_unimp_type(name,match,arguments):
  print """
&
\\multicolumn{10}{|c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    '0'*32, \
    'UNIMP' \
  )

def print_u_type(name,match,arguments):
  print """
&
\\multicolumn{8}{|c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('imm20','imm[31:12]',match,arguments), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_uj_type(name,match,arguments):
  print """
&
\\multicolumn{8}{|c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('jimm20','imm[20$\\vert$10:1$\\vert$11$\\vert$19:12]',match,arguments), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_s_type(name,match,arguments):
  print """
&
\\multicolumn{4}{|c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('imm12hi','imm[11:5]',match,arguments), \
    str_arg('rs2','',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('imm12lo','imm[4:0]',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_sb_type(name,match,arguments):
  print """
&
\\multicolumn{4}{|c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('bimm12hi','imm[12$\\vert$10:5]',match,arguments), \
    str_arg('rs2','',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('bimm12lo','imm[4:1$\\vert$11]',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_i_type(name,match,arguments):
  print """
&
\\multicolumn{6}{|c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('imm12','imm[11:0]',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_csr_type(name,match,arguments):
  print """
&
\\multicolumn{6}{|c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('imm12','csr',match,arguments), \
    ('zimm' if name[-1] == 'i' else 'rs1'), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_ish_type(name,match,arguments):
  print """
&
\\multicolumn{3}{|c|}{%s} &
\\multicolumn{3}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    binary(yank(match,26,6),6), \
    str_arg('shamt','shamt',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_ishw_type(name,match,arguments):
  print """
&
\\multicolumn{4}{|c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    binary(yank(match,25,7),7), \
    str_arg('shamtw','shamt',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_r_type(name,match,arguments):
  print """
&
\\multicolumn{4}{|c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    binary(yank(match,25,7),7), \
    str_arg('rs2','',match,arguments), \
    'zimm' in arguments and str_arg('zimm','imm[4:0]',match,arguments) or str_arg('rs1','',match,arguments), \
    str_arg('rm','',match,arguments), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_r4_type(name,match,arguments):
  print """
&
\\multicolumn{2}{|c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('rs3','',match,arguments), \
    binary(yank(match,25,2),2), \
    str_arg('rs2','',match,arguments), \
    str_arg('rs1','',match,arguments), \
    str_arg('rm','',match,arguments), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_amo_type(name,match,arguments):
  print """
&
\\multicolumn{2}{|c|}{%s} &
\\multicolumn{1}{c|}{aq} &
\\multicolumn{1}{c|}{rl} &
\\multicolumn{2}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    binary(yank(match,27,5),5), \
    str_arg('rs2','',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_fence_type(name,match,arguments):
  print """
&
\\multicolumn{2}{|c|}{%s} &
\\multicolumn{3}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} &
\\multicolumn{1}{c|}{%s} & %s \\\\
\\cline{2-11}
  """ % \
  ( \
    str_arg('fm','fm',match,arguments), \
    str_arg('pred','pred',match,arguments), \
    str_arg('succ','',match,arguments), \
    str_arg('rs1','',match,arguments), \
    binary(yank(match,funct_base,funct_size),funct_size), \
    str_arg('rd','',match,arguments), \
    binary(yank(match,opcode_base,opcode_size),opcode_size), \
    str_inst(name,arguments) \
  )

def print_header(*types):
  print """
\\newpage

\\begin{table}[p]
\\begin{small}
\\begin{center}
\\begin{tabular}{p{0in}p{0.4in}p{0.05in}p{0.05in}p{0.05in}p{0.05in}p{0.4in}p{0.6in}p{0.4in}p{0.6in}p{0.7in}l}
& & & & & & & & & & \\\\
                      &
\\multicolumn{1}{l}{\\instbit{31}} &
\\multicolumn{1}{r}{\\instbit{27}} &
\\instbit{26} &
\\instbit{25} &
\\multicolumn{1}{l}{\\instbit{24}} &
\\multicolumn{1}{r}{\\instbit{20}} &
\\instbitrange{19}{15} &
\\instbitrange{14}{12} &
\\instbitrange{11}{7} &
\\instbitrange{6}{0} \\\\
\\cline{2-11}
"""
  if 'r' in types:
    print """
&
\\multicolumn{4}{|c|}{funct7} &
\\multicolumn{2}{c|}{rs2} &
\\multicolumn{1}{c|}{rs1} &
\\multicolumn{1}{c|}{funct3} &
\\multicolumn{1}{c|}{rd} &
\\multicolumn{1}{c|}{opcode} & R-type \\\\
\\cline{2-11}
"""
  if 'r4' in types:
    print """
&
\\multicolumn{2}{|c|}{rs3} &
\\multicolumn{2}{c|}{funct2} &
\\multicolumn{2}{c|}{rs2} &
\\multicolumn{1}{c|}{rs1} &
\\multicolumn{1}{c|}{funct3} &
\\multicolumn{1}{c|}{rd} &
\\multicolumn{1}{c|}{opcode} & R4-type \\\\
\\cline{2-11}
  """
  if 'i' in types:
    print """
&
\\multicolumn{6}{|c|}{imm[11:0]} &
\\multicolumn{1}{c|}{rs1} &
\\multicolumn{1}{c|}{funct3} &
\\multicolumn{1}{c|}{rd} &
\\multicolumn{1}{c|}{opcode} & I-type \\\\
\\cline{2-11}
"""
  if 's' in types:
    print """
&
\\multicolumn{4}{|c|}{imm[11:5]} &
\\multicolumn{2}{c|}{rs2} &
\\multicolumn{1}{c|}{rs1} &
\\multicolumn{1}{c|}{funct3} &
\\multicolumn{1}{c|}{imm[4:0]} &
\\multicolumn{1}{c|}{opcode} & S-type \\\\
\\cline{2-11}
"""
  if 'sb' in types:
    print """
&
\\multicolumn{4}{|c|}{imm[12$\\vert$10:5]} &
\\multicolumn{2}{c|}{rs2} &
\\multicolumn{1}{c|}{rs1} &
\\multicolumn{1}{c|}{funct3} &
\\multicolumn{1}{c|}{imm[4:1$\\vert$11]} &
\\multicolumn{1}{c|}{opcode} & B-type \\\\
\\cline{2-11}
"""
  if 'u' in types:
    print """
&
\\multicolumn{8}{|c|}{imm[31:12]} &
\\multicolumn{1}{c|}{rd} &
\\multicolumn{1}{c|}{opcode} & U-type \\\\
\\cline{2-11}
"""
  if 'uj' in types:
    print """
&
\\multicolumn{8}{|c|}{imm[20$\\vert$10:1$\\vert$11$\\vert$19:12]} &
\\multicolumn{1}{c|}{rd} &
\\multicolumn{1}{c|}{opcode} & J-type \\\\
\\cline{2-11}
"""

def print_subtitle(title):
  print """
&
\\multicolumn{10}{c}{} & \\\\
&
\\multicolumn{10}{c}{\\bf %s} & \\\\
\\cline{2-11}
  """ % title

def print_footer(caption=''):
  print """
\\end{tabular}
\\end{center}
\\end{small}
%s
\\label{instr-table}
\\end{table}
  """ % caption

def print_inst(n):
  if n == 'fence' or n == 'fence.i':
    print_fence_type(n, match[n], arguments[n])
  elif 'aqrl' in arguments[n]:
    print_amo_type(n, match[n], arguments[n])
  elif 'shamt' in arguments[n]:
    print_ish_type(n, match[n], arguments[n])
  elif 'shamtw' in arguments[n]:
    print_ishw_type(n, match[n], arguments[n])
  elif 'imm20' in arguments[n]:
    print_u_type(n, match[n], arguments[n])
  elif 'jimm20' in arguments[n]:
    print_uj_type(n, match[n], arguments[n])
  elif n[:3] == 'csr':
    print_csr_type(n, match[n], arguments[n])
  elif 'imm12' in arguments[n] or n == 'ecall' or n == 'ebreak':
    print_i_type(n, match[n], arguments[n])
  elif 'imm12hi' in arguments[n]:
    print_s_type(n, match[n], arguments[n])
  elif 'bimm12hi' in arguments[n]:
    print_sb_type(n, match[n], arguments[n])
  elif 'rs3' in arguments[n]:
    print_r4_type(n, match[n], arguments[n])
  else:
    print_r_type(n, match[n], arguments[n])

def print_insts(*names):
  for n in names:
    print_inst(n)

def make_supervisor_latex_table():
  print_header('i')
  print_subtitle('Environment Call and Breakpoint')
  print_insts('ecall', 'ebreak')
  print_subtitle('Trap-Return Instructions')
  print_insts('uret', 'sret', 'mret')
  print_subtitle('Interrupt-Management Instructions')
  print_insts('wfi')
  print_subtitle('Memory-Management Instructions')
  print_insts('sfence.vma')
  print_footer('\\caption{RISC-V Privileged Instructions}')

def make_latex_table():
  print_header('r','i','s','sb','u','uj')
  print_subtitle('RV32I Base Instruction Set')
  print_insts('lui', 'auipc')
  print_insts('jal', 'jalr', 'beq', 'bne', 'blt', 'bge', 'bltu', 'bgeu')
  print_insts('lb', 'lh', 'lw', 'lbu', 'lhu', 'sb', 'sh', 'sw')
  print_insts('addi', 'slti', 'sltiu', 'xori', 'ori', 'andi', 'slli.rv32', 'srli.rv32', 'srai.rv32')
  print_insts('add', 'sub', 'sll', 'slt', 'sltu', 'xor', 'srl', 'sra', 'or', 'and')
  print_insts('fence', 'fence.i')
  print_insts('ecall', 'ebreak')
  print_insts('csrrw', 'csrrs', 'csrrc')
  print_insts('csrrwi', 'csrrsi', 'csrrci')
  print_footer()

  print_header('r','a','i','s')
  print_subtitle('RV64I Base Instruction Set (in addition to RV32I)')
  print_insts('lwu', 'ld', 'sd')
  print_insts('slli', 'srli', 'srai')
  print_insts('addiw', 'slliw', 'srliw', 'sraiw')
  print_insts('addw', 'subw', 'sllw', 'srlw', 'sraw')
  print_subtitle('RV32M Standard Extension')
  print_insts('mul', 'mulh', 'mulhsu', 'mulhu')
  print_insts('div', 'divu', 'rem', 'remu')
  print_subtitle('RV64M Standard Extension (in addition to RV32M)')
  print_insts('mulw', 'divw', 'divuw', 'remw', 'remuw')
  print_subtitle('RV32A Standard Extension')
  print_insts('lr.w', 'sc.w')
  print_insts('amoswap.w')
  print_insts('amoadd.w', 'amoxor.w', 'amoand.w', 'amoor.w')
  print_insts('amomin.w', 'amomax.w', 'amominu.w', 'amomaxu.w')
  print_footer()

  print_header('r','r4','i','s')
  print_subtitle('RV64A Standard Extension (in addition to RV32A)')
  print_insts('lr.d', 'sc.d')
  print_insts('amoswap.d')
  print_insts('amoadd.d', 'amoxor.d', 'amoand.d', 'amoor.d')
  print_insts('amomin.d', 'amomax.d', 'amominu.d', 'amomaxu.d')
  print_subtitle('RV32F Standard Extension')
  print_insts('flw', 'fsw')
  print_insts('fmadd.s', 'fmsub.s', 'fnmsub.s', 'fnmadd.s')
  print_insts('fadd.s', 'fsub.s', 'fmul.s', 'fdiv.s', 'fsqrt.s')
  print_insts('fsgnj.s', 'fsgnjn.s', 'fsgnjx.s', 'fmin.s', 'fmax.s')
  print_insts('fcvt.w.s', 'fcvt.wu.s', 'fmv.x.w')
  print_insts('feq.s', 'flt.s', 'fle.s', 'fclass.s')
  print_insts('fcvt.s.w', 'fcvt.s.wu', 'fmv.w.x')
  print_footer()

  print_header('r','r4','i','s')
  print_subtitle('RV64F Standard Extension (in addition to RV32F)')
  print_insts('fcvt.l.s', 'fcvt.lu.s')
  print_insts('fcvt.s.l', 'fcvt.s.lu')
  print_subtitle('RV32D Standard Extension')
  print_insts('fld', 'fsd')
  print_insts('fmadd.d', 'fmsub.d', 'fnmsub.d', 'fnmadd.d')
  print_insts('fadd.d', 'fsub.d', 'fmul.d', 'fdiv.d', 'fsqrt.d')
  print_insts('fsgnj.d', 'fsgnjn.d', 'fsgnjx.d', 'fmin.d', 'fmax.d')
  print_insts('fcvt.s.d', 'fcvt.d.s')
  print_insts('feq.d', 'flt.d', 'fle.d', 'fclass.d')
  print_insts('fcvt.w.d', 'fcvt.wu.d')
  print_insts('fcvt.d.w', 'fcvt.d.wu')
  print_subtitle('RV64D Standard Extension (in addition to RV32D)')
  print_insts('fcvt.l.d', 'fcvt.lu.d', 'fmv.x.d')
  print_insts('fcvt.d.l', 'fcvt.d.lu', 'fmv.d.x')
  print_footer('\\caption{Instruction listing for RISC-V}')

def print_chisel_insn(name):
  s = "  def %-18s = BitPat(\"b" % name.replace('.', '_').upper()
  for i in range(31, -1, -1):
    if yank(mask[name], i, 1):
      s = '%s%d' % (s, yank(match[name], i, 1))
    else:
      s = s + '?'
  print s + "\")"

def make_chisel():
  print '/* Automatically generated by parse-opcodes */'
  print 'object Instructions {'
  for name in namelist:
    print_chisel_insn(name)
  print '}'
  print 'object Causes {'
  for num, name in causes:
    print '  val %s = %s' % (name.lower().replace(' ', '_'), hex(num))
  print '  val all = {'
  print '    val res = collection.mutable.ArrayBuffer[Int]()'
  for num, name in causes:
    print '    res += %s' % (name.lower().replace(' ', '_'))
  print '    res.toArray'
  print '  }'
  print '}'
  print 'object CSRs {'
  for num, name in csrs+csrs32:
    print '  val %s = %s' % (name, hex(num))
  print '  val all = {'
  print '    val res = collection.mutable.ArrayBuffer[Int]()'
  for num, name in csrs:
    print '    res += %s' % (name)
  print '    res.toArray'
  print '  }'
  print '  val all32 = {'
  print '    val res = collection.mutable.ArrayBuffer(all:_*)'
  for num, name in csrs32:
    print '    res += %s' % (name)
  print '    res.toArray'
  print '  }'
  print '}'

def signed(value, width):
  if 0 <= value < (1<<(width-1)):
    return value
  else:
    return value - (1<<width)

def print_go_insn(name):
  print '\tcase A%s:' % name.upper().replace('.', '')
  m = match[name]
  opcode = yank(m, 0, 7)
  funct3 = yank(m, 12, 3)
  rs2 = yank(m, 20, 5)
  csr = yank(m, 20, 12)
  funct7 = yank(m, 25, 7)
  print '\t\treturn &inst{0x%x, 0x%x, 0x%x, %d, 0x%x}, true' % (opcode, funct3, rs2, signed(csr, 12), funct7)

def make_go():
  print '// Automatically generated by parse-opcodes'
  print
  print 'package riscv'
  print
  print 'import "cmd/internal/obj"'
  print
  print 'type inst struct {'
  print '\topcode uint32'
  print '\tfunct3 uint32'
  print '\trs2    uint32'
  print '\tcsr    int64'
  print '\tfunct7 uint32'
  print '}'
  print
  print 'func encode(a obj.As) (i *inst, ok bool) {'
  print '\tswitch a {'
  for name in namelist:
    print_go_insn(name)
  print '\t}'
  print '\treturn nil, false'
  print '}'

for line in sys.stdin:
  line = line.partition('#')
  tokens = line[0].split()

  if len(tokens) == 0:
    continue
  assert len(tokens) >= 2

  name = tokens[0]
  pseudo = name[0] == '@'
  if pseudo:
    name = name[1:]
  mymatch = 0
  mymask = 0
  cover = 0

  if not name in arguments.keys():
    arguments[name] = []

  for token in tokens[1:]:
    if len(token.split('=')) == 2:
      tokens = token.split('=')
      if len(tokens[0].split('..')) == 2:
        tmp = tokens[0].split('..')
        hi = int(tmp[0])
        lo = int(tmp[1])
        if hi <= lo:
          sys.exit("%s: bad range %d..%d" % (name,hi,lo))
      else:
        hi = lo = int(tokens[0])

      if tokens[1] != 'ignore':
        val = int(tokens[1], 0)
        if val >= (1 << (hi-lo+1)):
          sys.exit("%s: bad value %d for range %d..%d" % (name,val,hi,lo))
        mymatch = mymatch | (val << lo)
        mymask = mymask | ((1<<(hi+1))-(1<<lo))

      if cover & ((1<<(hi+1))-(1<<lo)):
        sys.exit("%s: overspecified" % name)
      cover = cover | ((1<<(hi+1))-(1<<lo))

    elif token in arglut:
      if cover & ((1<<(arglut[token][0]+1))-(1<<arglut[token][1])):
        sys.exit("%s: overspecified" % name)
      cover = cover | ((1<<(arglut[token][0]+1))-(1<<arglut[token][1]))
      arguments[name].append(token)

    else:
      sys.exit("%s: unknown token %s" % (name,token))

  if not (cover == 0xFFFFFFFF or cover == 0xFFFF):
    sys.exit("%s: not all bits are covered: %s" % (name, bin(cover)))

  if pseudo:
    pseudos[name] = 1
  else:
    for name2,match2 in match.iteritems():
      if name2 not in pseudos and (match2 & mymask) == mymatch:
        sys.exit("%s and %s overlap" % (name,name2))

  mask[name] = mymask
  match[name] = mymatch
  namelist.append(name)

if sys.argv[1] == '-tex':
  make_latex_table()
elif sys.argv[1] == '-privtex':
  make_supervisor_latex_table()
elif sys.argv[1] == '-chisel':
  make_chisel()
elif sys.argv[1] == '-c':
  make_c(match,mask)
elif sys.argv[1] == '-go':
  make_go()
else:
  assert 0
