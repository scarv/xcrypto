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
'lut4', 'rtamt',   'cs', 'cl']

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
acodes['lut4'   ] = "X4" # These two share the same field coding as they are
acodes['rtamt'  ] = "X4" # identical in all but name.
acodes['cs'     ] = "Xk"
acodes['cl'     ] = "XL"
acodes['rd'     ] = "d"
acodes['rs1'    ] = "s"

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
  print '/* Automatically generated by parse-opcodes.  */'
  print '#ifndef RISCV_ENCODING_H'
  print '#define RISCV_ENCODING_H'
  print '// ----- Crypto ISE BEGIN -----'
  for name in namelist:
    name2 = name.upper().replace('.','_')
    print '#define MATCH_%s %s' % (name2, hex(match[name]))
    print '#define MASK_%s  %s' % (name2, hex(mask[name]))
  print '// ----- Crypto ISE END -------'

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
