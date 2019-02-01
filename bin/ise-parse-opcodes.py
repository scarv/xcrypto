#!/usr/bin/env python2

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
opcodebits ={}

digits = {
"0":"zero",
"1":"one",
"2":"two",
"3":"three"
}

cargs= ['imm11'   , 'imm11hi' , 'imm11lo' , 'imm5'
, 'cshamt'  , 'cmshamt' , 'b0'      , 'b1'      ,
'b2'      , 'b3'      , 'ca'      , 'cb'      ,
'cc'      , 'cd'      , 'crs1'    , 'crs2'    ,
'crs3'    ,             'crd'     , 'crdm'    ,
'lut8','lut4', 'rtamt',   'cs', 'cl']

acodes = {}
acodes['imm11'  ] = "Xl"
acodes['imm11hi'] = "Xm"
acodes['imm11lo'] = "Xn"
acodes['imm5'   ] = "X5"
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
acodes['crd'    ] = "XD"
acodes['crdm'   ] = "XM"
acodes['lut8'   ] = "X8"
acodes['lut4'   ] = "X4" # These two share the same field coding as they are
acodes['rtamt'  ] = "X4" # identical in all but name.
acodes['cs'     ] = "Xk"
acodes['cl'     ] = "XL"
acodes['rd'     ] = "d"
acodes['rs1'    ] = "s"
acodes['rs2'    ] = "t"

arglut = {}
arglut['imm11'  ] = (31,21)
arglut['imm11hi'] = (31,25)
arglut['imm11lo'] = (10, 7)
arglut['imm5'   ] = (19,15)
arglut['cshamt' ] = (23,20)
arglut['cmshamt'] = (29,24)
arglut['cs'     ] = (31,28)
arglut['cl'     ] = (27,24)
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
arglut['crd'    ] = (10, 7)
arglut['crdm'   ] = ( 9, 7)
arglut['lut4'   ] = (28,25)
arglut['lut8'   ] = (31,24)
arglut['rtamt'  ] = (28,25)

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

opcode_base = 0
opcode_size = 7
funct_base = 12
funct_size = 3


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

  # Standard Hypervisor R/w
  (0x200, 'bsstatus'),
  (0x204, 'bsie'),
  (0x205, 'bstvec'),
  (0x240, 'bsscratch'),
  (0x241, 'bsepc'),
  (0x242, 'bscause'),
  (0x243, 'bstval'),
  (0x244, 'bsip'),
  (0x280, 'bsatp'),
  (0xA00, 'hstatus'),
  (0xA02, 'hedeleg'),
  (0xA03, 'hideleg'),
  (0xA80, 'hgatp'),

  # Tentative CSR assignment for CLIC
  (0x007, 'utvt'),
  (0x045, 'unxti'),
  (0x046, 'uintstatus'),
  (0x048, 'uscratchcsw'),
  (0x049, 'uscratchcswl'),
  (0x107, 'stvt'),
  (0x145, 'snxti'),
  (0x146, 'sintstatus'),
  (0x148, 'sscratchcsw'),
  (0x149, 'sscratchcswl'),
  (0x307, 'mtvt'),
  (0x345, 'mnxti'),
  (0x346, 'mintstatus'),
  (0x348, 'mscratchcsw'),
  (0x349, 'mscratchcswl'),

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

def binary(n, digits=0):
  rep = bin(n)[2:]
  return rep if digits == 0 else ('0' * (digits - len(rep))) + rep


def make_c_extra(match,mask):
    """
    Generates extra useful macros and the like for adding instructions
    to binutils and GAS specifically.
    """
    tp = []
    print('// ----- Crypto ISE BEGIN -----')
    for field in arglut:
        if not field in cargs:
            continue
        # Generate encode/extract macros for each field which can be
        # dumped into riscv-binutils/include/opcode/riscv.h
        enc_name = "ENCODE_X_%s" % (field.upper())
        ext_name = "EXTRACT_X_%s" % (field.upper())
        val_name = "VALIDATE_X_%s" % (field.upper())
        
        fsize = 1 + (arglut[field][0] - arglut[field][1])
        flow  = arglut[field][1]
        fmask = "0b" + ("1"*fsize)

        mname = "OP_MASK_X%s" % field.upper()
        sname = "OP_SH_X%s"   % field.upper()
        
        tp.append("#define %s %s" %(mname, fmask))
        tp.append("#define %s %s" %(sname, flow))
        tp.append("#define %s(X)  ((X &  %s) << %s)" %(
            enc_name,mname,sname))
        tp.append("#define %s(X) ((X >> %s)  & %s)" %(
            ext_name,sname,mname))
        tp.append("#define %s(X) ((%s(X)) == (%s(X)))" %(
            val_name,enc_name,ext_name))
    tp.sort()
    tp.append('// ----- Crypto ISE END -------')
    tp.append('// ----- Crypto ISE BEGIN -----')


    # Generate instruction and argument definitions
    for mnemonic in namelist:
        tw  = ("{\"%s\", " % mnemonic).ljust(15)     # instr name
        tw += "\"x\", "                 # ISA / ISE

        fields = sorted(arguments[mnemonic])
        tw += ("\"%s\", " % ",".join([acodes[f] for f in fields])).ljust(22)

        tw += "MATCH_%s, " %(mnemonic.replace(".","_").upper())
        tw += "MASK_%s, "  %(mnemonic.replace(".","_").upper())
        tw += "match_opcode, 0},"
        
        tp.append(tw)
 
    for l in tp:
        print(l)
    print('// ----- Crypto ISE END -------')
    
    # Generate instruction assembly logic
    print("")
    print('// ----- Crypto ISE BEGIN -----')
    print("case 'X': /* SCARV Crypto ISE */ ")
    print("  switch (c = *++args){")

    avals = sorted([(a,acodes[a]) for a in acodes])
    for argtype,argsig in avals:
        l = argsig
        if(len(l) == 1):
            continue # These are handled by existing code.
        else:
            l = l[1:]
        print("    case '%s': /* %s */"%(l,argtype))
        print("      printf(\"  BEN: "+l+"\\n\");")
        print("      break;")
    print("""
    default:
        as_bad (_(\"bad Crypto ISE field specifier 'X%c'\"), *args);
        break;
    """)
    print("}")
    print("break;")
    print('// ----- Crypto ISE END -------')

    # Generate instruction validation logic
    print("")
    print('// ----- Crypto ISE BEGIN -----')
    print("case 'X':")
    print("  switch (c = *p++){")

    avals = sorted([(a,acodes[a]) for a in acodes])
    for argtype,argsig in avals:
        l = argsig
        if(len(l) == 1):
            continue # These are handled by existing code.
        else:
            l = l[1:]
        print("    case '%s': used_bits |= ENCODE_X_%s(-1U) ;break;/* %s */"%(
            l, argtype.upper(), argtype)
        )
    print("""
    default:
    as_bad (_("internal: bad RISC-V Crypto opcode (unknown operand type `X%c'): %s %s"),
    c, opc->name, opc->args);
return FALSE;
   }
   break;""")
    print('// ----- Crypto ISE END -------')
    


def make_c(match,mask):
  print('/* Automatically generated by parse-opcodes.  */')
  print('#ifndef RISCV_ENCODING_H')
  print('#define RISCV_ENCODING_H')
  for name in namelist:
    name2 = name.upper().replace('.','_')
    print('#define MATCH_%s %s' % (name2, hex(match[name])))
    print('#define MASK_%s  %s' % (name2, hex(mask[name])))
  for num, name in csrs+csrs32:
    print('#define CSR_%s %s' % (name.upper(), hex(num)))
  for num, name in causes:
    print('#define CAUSE_%s %s' % (name.upper().replace(' ', '_'), hex(num)))
  print('#endif')

  print('#ifdef DECLARE_INSN')
  for name in namelist:
    name2 = name.replace('.','_')
    print('DECLARE_INSN(%s, MATCH_%s, MASK_%s)' % (name2, name2.upper(), name2.upper()))
  print('#endif')

  print('#ifdef DECLARE_CSR')
  for num, name in csrs+csrs32:
    print('DECLARE_CSR(%s, CSR_%s)' % (name, name.upper()))
  print('#endif')

  print('#ifdef DECLARE_CAUSE')
  for num, name in causes:
    print('DECLARE_CAUSE("%s", CAUSE_%s)' % (name, name.upper().replace(' ', '_')))
  print('#endif')

  # Call not needed now binutils patch is well established.
  # make_c_extra(match,mask)

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

def print_inst(n):
    ifields = opcodebits[n]
    fs      = []
    for hi,lo,val in ifields:
        width = 1 + hi - lo
        val = bin(val)[2:].rjust(width,"0")
        fs.append((hi,lo,val))
    for argname in arglut:
        if(argname in arguments[n]):
            hi,lo = arglut[argname]
            fs.append((hi,lo,argname))
    
    fs.sort(key=lambda fs:fs[0],reverse=True)

    for hi,lo,val in fs:
        width = 1 + hi - lo
        print( r'\bitbox{%d}{\tt %s}%%' % (width,val))
    print( r'\bitbox{%d}{\bf\tt %s}\\%%' % ( 10,  n))

def make_latex_table():
  print  ( r'\newcommandx{\XCENCODE}[1]{' '%%'         )
  print  ( r'  \IfStrEqCase{#1}{'         '%%'         )

  # general cases

  for n in namelist :
    print( r'    {%s}{'                   '%%' % ( n ) ) 
    print_inst( n )
    print( r'    }'                       '%%'         )

  # special cases

  print  ( r'    {xc.pperm.hx}{'          '%%'         )
  print_inst( 'xc.pperm.h0' )
  print_inst( 'xc.pperm.h1' )
  print  ( r'    }'                       '%%'         )
  print  ( r'    {xc.pperm.bx}{'          '%%'         )
  print_inst( 'xc.pperm.b0' )
  print_inst( 'xc.pperm.b1' )
  print_inst( 'xc.pperm.b2' )
  print_inst( 'xc.pperm.b3' )
  print  ( r'    }'                       '%%'         )
  print  ( r'    {xc.aessub}{'            '%%'         )
  print_inst( 'xc.aessub.enc'    )
  print_inst( 'xc.aessub.encrot' )
  print_inst( 'xc.aessub.dec'    )
  print_inst( 'xc.aessub.decrot' )
  print  ( r'    }'                       '%%'         )
  print  ( r'    {xc.aesmix}{'            '%%'         )
  print_inst( 'xc.aesmix.enc'    )
  print_inst( 'xc.aesmix.dec'    )
  print  ( r'    }'                       '%%'         )

  print  ( r'  }'                         '%%'         )
  print  ( r'}'                           '%%'         )

def signed(value, width):
  if 0 <= value < (1<<(width-1)):
    return value
  else:
    return value - (1<<width)

def make_dec_wirename(instrname):
    return "dec_%s"     % instrname.lower().replace("xc.","").replace(".","_")

def make_verilog(match,mask):
    """
    Generate verilog for decoding all of the ISE instructions.
    """

    src_wire = "encoded"
    ise_args = set([])
    dec_wires= set([])

    for instr in namelist:
        wirename = make_dec_wirename(instr)
        tw       = "wire %s = " % (wirename.ljust(15))
        
        tw      += "(%s & 32'h%s) == 32'h%s;" % (
            src_wire, hex(mask[instr])[2:], hex(match[instr])[2:]
        )
        
        dec_wires.add(wirename)

        print(tw)

        for arg in arguments[instr]:
            ise_args.add(arg)

    for field in ise_args:
        wirename = "dec_arg_%s" % field.lower().replace(".","_")
        wirewidth= (arglut[field][0]-arglut[field][1])
        tw       = "wire [%d:0] %s = encoded[%d:%d];" % (
            wirewidth,
            wirename.ljust(15), arglut[field][0],arglut[field][1]
        )
        print(tw)

    invalidinstr = "wire dec_invalid_opcode = !(" + \
        " || ".join(list(dec_wires)) +  \
        ");" 
    print(invalidinstr)


def make_verilog_extra(match,mask):
    """
    Generate verilog code which will only need generating once (hopefully).
    """
    
    # Decode -> implementation function if/else tree
    for instr in namelist:
        wirename = make_dec_wirename(instr).ljust(15)

        print("else if (%s) model_do_%s();" % (wirename,wirename[4:]))

    # Empty implementation functions.
    for instr in namelist:
        fname = "model_do_%s" % instr.lower().replace(".","_")

        print("//")
        print("// Implementation function for the %s instruction." % instr)
        print("//")
        print("task %s;" % fname)
        print("begin: t_model_%s"%instr.lower().replace(".","_"))
        
        regs_read = [a for a in arguments[instr] if a.startswith("crs")]
        if(len(regs_read) > 0):
            print("    reg  [31:0] %s;" % (", ".join(regs_read)))

        for r in regs_read:
            print("    model_do_read_cpr(dec_arg_%s, %s);" %(r,r))

        print("    $display(\"ISE> ERROR: Instruction %s not implemented\");"\
            %(instr))
        print("end endtask")
        print("")
        print("")

def make_verilog_formal(match,mask):
    
    for instr in namelist:
        print("//")
        print("// Formal checks for %s" % instr)
        print("//")
        print("`VTX_CHECK_INSTR_BEGIN(%s)" % instr.lower().replace(".","_"))
        if("rd" in arguments[instr]):
            print("    `VTX_ASSERT_WEN_IS_SET")
        else:
            print("    `VTX_ASSERT_WEN_IS_CLEAR")
        print("`VTX_CHECK_END")
        print("\n")

##################################

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
    opcodebits[name] = []

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
        opcodebits[name].append((hi,lo,val))
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
elif sys.argv[1] == '-c':
  make_c(match,mask)
elif sys.argv[1] == '-verilog':
  make_verilog(match,mask)
elif sys.argv[1] == '-verilog-extra':
  make_verilog_extra(match,mask)
elif sys.argv[1] == '-verilog-formal':
  make_verilog_formal(match,mask)
else:
  assert 0
