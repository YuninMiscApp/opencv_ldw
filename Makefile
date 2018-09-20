

# configure
CONFIG_BSP_MPSOC=n

#
CROSS_COMPILE ?= arm-xilinx-linux-gnueabi-

ifeq (${CONFIG_BSP_MPSOC},y)
	CROSS_COMPILE := aarch64-xilinx-linux-
	MPSOC_TOP_PATH =${HOME}/petalinux_disk/prj/xilinx-zcu104-2018.2/images/linux/sdk/sysroots/aarch64-xilinx-linux
	ARCH_FLAGS := --sysroot=${MPSOC_TOP_PATH} -I ${MPSOC_TOP_PATH}/usr/include
else
	CROSS_COMPILE := arm-xilinx-linux-gnueabi-
endif


export CROSS_COMPILE

AS	= $(CROSS_COMPILE)as
LD	= $(CROSS_COMPILE)ld
CC	= $(CROSS_COMPILE)g++
CPP	= $(CC) -E
AR	= $(CROSS_COMPILE)ar
NM	= $(CROSS_COMPILE)nm
STRIP	= $(CROSS_COMPILE)strip
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
RANLIB	= $(CROSS_COMPILE)RANLIB

export AS LD CC CPP AR NM STRIP OBJCOPY OBJDUMP RANLIB 

CFLAGS += ${ARCH_FLAGS}
CFLAGS += -I ./include -I ${HOME}/zynq7_disk/adas_app/opencv2411/include -rdynamic -pipe -O3 -fPIC -Wall 
export CFLAGS

dirs := ldw/

dirs := ${patsubst %/,%,$(filter %/, $(dirs))}
PHONY += $(dirs)
$(dirs): FORCE
	@make -f Makefile.build  obj=$@


all:  $(dirs) FORCE


clean:	FORCE
	@echo '>>> clean target'
	@rm -f *.bak *.so *.a
	@rm -f ${TARGET_NAME}
	@${shell for dir in `find -maxdepth 10 -type d | grep -v git| grep -v include| grep -v 3th | grep -v \.si4project`;\
	do rm -f $${dir}/*.o $${dir}/*.bak $${dir}/*.so $${dir}/*.a $${dir}/*.dep*;done}
	@rm -fr bin/
	@rm -fr libs/

distclean: clean
	@echo  ">>> distclean target"



PHONY += FORCE
FORCE:

