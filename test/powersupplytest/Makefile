COMPONENT=PSTestC

CFLAGS += -I$(PWD)

PLATFORM_BAUDRATE ?= 500000UL
BASE_LOG_LEVEL ?= 0xFFFF

CFLAGS += -I../../tos/powersupply

include ../../thinnect.tos-groundlib/tos/groundlib.mk

# Avoid strange TinyOS issues
CFLAGS += -DTASKLET_IS_TASK

include $(MAKERULES)
