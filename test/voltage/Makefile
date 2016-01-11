COMPONENT=PSTestC

CFLAGS += -I$(PWD)

PLATFORM_BAUDRATE ?= 500000UL
BASE_LOG_LEVEL ?= 0xFFFF

# Avoid strange TinyOS issues
CFLAGS += -DTASKLET_IS_TASK

$(info --------------------------------------------------------------------------------)
include $(TINYOS_ROOT_DIR)/Makefile.include
$(call TOSMake_include,extras/groundlib.extra)
$(info --------------------------------------------------------------------------------)
