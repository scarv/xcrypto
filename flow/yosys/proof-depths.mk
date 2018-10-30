
#
# This file is used to specify specific proof depths for certain
# property contexts. This is essential for when the design functionality
# in question requires a minimum number of cycles to exercise.
#
$(SMTDIR)/instr_pmul_l_pw2.rpt : BMC_STEPS=20
$(SMTDIR)/instr_pmul_l_pw1.rpt : BMC_STEPS=36
$(SMTDIR)/protocols.rpt        : BMC_STEPS=36
