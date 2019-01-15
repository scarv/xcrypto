
TEST_NAME=aes-test
OBJECTS  = $(TGT_DIR)/$(TEST_NAME).o \
           $(TGT_DIR)/boot.o \
		   $(TGT_DIR)/aes_enc_sub_gather.o \
           $(LIBSCARV)/build/lib/libscarv.a

CONF += -DCONF_AES_PRECOMP_RC 
CONF += -DCONF_AES_PRECOMP_RK
CONF += -DCONF_AES_PRECOMP_SBOX 
CONF += -DCONF_AES_PRECOMP_MULX 
CONF += -DCONF_AES_ENABLE_ENC
CONF += -DCONF_AES_ENABLE_DEC

CFLAGS += $(CONF) 
include ../common/common.mk




