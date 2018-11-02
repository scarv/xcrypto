
#
# This file is used to specify specific proof depths for certain
# property contexts. This is essential for when the design functionality
# in question requires a minimum number of cycles to exercise.
#

$(SMTDIR)/instr_pmul_h.rpt     : BMC_STEPS=15
$(SMTDIR)/instr_pmul_h.cov     : BMC_STEPS=15

$(SMTDIR)/instr_pmul_h_pw2.rpt : BMC_STEPS=22
$(SMTDIR)/instr_pmul_h_pw2.cov : BMC_STEPS=22

$(SMTDIR)/instr_pmul_h_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pmul_h_pw1.cov : BMC_STEPS=37

$(SMTDIR)/instr_pmul_l.rpt     : BMC_STEPS=15
$(SMTDIR)/instr_pmul_l.cov     : BMC_STEPS=15

$(SMTDIR)/instr_pmul_l_pw2.rpt : BMC_STEPS=22
$(SMTDIR)/instr_pmul_l_pw2.cov : BMC_STEPS=22

$(SMTDIR)/instr_pmul_l_pw1.rpt : BMC_STEPS=37
$(SMTDIR)/instr_pmul_l_pw1.cov : BMC_STEPS=37

$(SMTDIR)/protocols.rpt        : BMC_STEPS=40
