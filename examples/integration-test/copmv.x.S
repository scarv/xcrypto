

.global __move_to_cop
__move_to_cop:             # Move GPR a0 to CPR c0
	mv2cop  c0, a0
    ret

.global __move_to_gpr
__move_to_gpr:             # Move CPR c0 to GPR a0
	mv2gpr  a0, c0
    ret
