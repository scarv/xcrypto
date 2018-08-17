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
'crs3'    , 'crs4'    , 'crd'     , 'crdm'    ,
'lut4',    'cs', 'cl']

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
acodes['crs4'   ] = "XT"
acodes['crd'    ] = "XD"
acodes['crdm'   ] = "XM"
acodes['lut4'   ] = "X4"
acodes['cs'     ] = "XS"
acodes['cl'     ] = "XL"
acodes['rd'     ] = "d"
acodes['rs1'    ] = "s"

arglut = {}
arglut['imm11'  ] = (31,21)
arglut['imm11hi'] = (31,25)
arglut['imm11lo'] = (10, 7)
arglut['imm5'   ] = (19,15)
arglut['cshamt' ] = (23,20)
arglut['cmshamt'] = (27,24)
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
        tp.append("#define %s(X) ((X >> OP_SH_X%s)  & OP_MASK_X%s)" %(
            ext_name,sname,mname))
        tp.append("#define %s(X) ((%s(X)) == (%s(X)))" %(
            val_name,enc_name,ext_name))
    tp.sort()


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
    
    # Generate instruction assembly logic
    print("")
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

    # Generate instruction validation logic
    print("")
    print("case 'X': /* SCARV Crypto ISE */ ")
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
    


def make_c(match,mask):
  print '/* Automatically generated by parse-opcodes.  */'
  print '#ifndef RISCV_ENCODING_H'
  print '#define RISCV_ENCODING_H'
  for name in namelist:
    name2 = name.upper().replace('.','_')
    print '#define MATCH_%s %s' % (name2, hex(match[name]))
    print '#define MASK_%s  %s' % (name2, hex(mask[name]))

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

def print_header(cmd):
  print """\\newcommand{%s}[2]{
\\begin{figure}[H]
\\centering
\\begin{bytefield}[bitwidth=1.2em,endianness=big]{32}
\\bitheader{0-31}               \\\\
""" % cmd

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
\end{bytefield}
\captionsetup{singlelinecheck=off}
\caption[x]{#1}
\label{#2}
\end{figure}}
  """


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
        print("\\BB{%d}{%s}" % (width,val))

    print("\\BH{10}{%s}\\\\" % n)


def print_insts(names):
  for n in names:
    print_inst(n)

def make_latex_table():
 
  used   = []

  mplist = [n for n in namelist if ".mp" in n]
  used   += mplist

  pxlist = [n for n in namelist if not n in used and
                                   n != "ext.px" and
                                   n != "dep.px" and (
                                    ".px" in n or \
                                    "scatter" in n or
                                    "gather" in n or
                                    "mix" in n or
                                    "bop" in n)]
  used   += pxlist
  
  ellist = [n for n in namelist if not n in used]

  print_header("\\encodingspx")
  print_insts(pxlist)
  print_footer('Instruction listing for RISC-V')
  
  print_header("\\encodingsmp")
  print_insts(mplist)
  print_footer('Instruction listing for RISC-V')
  
  print_header("\\encodingsel")
  print_insts(ellist)
  print_footer('Instruction listing for RISC-V')

  # Per-instruction encoding table commands.
  for n in namelist:
      sn = n.replace(".","")
      for d in digits:
          sn = sn.replace(d,digits[d])
      print("\\newcommand{\\ienc%s}[0]{"%(sn))
      print_inst(n)
      print("}")
      print


def print_chisel_insn(name):
  s = "  def %-18s = BitPat(\"b" % name.replace('.', '_').upper()
  for i in range(31, -1, -1):
    if yank(mask[name], i, 1):
      s = '%s%d' % (s, yank(match[name], i, 1))
    else:
      s = s + '?'
  print s + "\")"


def signed(value, width):
  if 0 <= value < (1<<(width-1)):
    return value
  else:
    return value - (1<<width)

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
elif sys.argv[1] == '-chisel':
  make_chisel()
elif sys.argv[1] == '-c':
  make_c(match,mask)
elif sys.argv[1] == '-go':
  make_go()
else:
  assert 0
