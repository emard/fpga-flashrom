###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT = project
TOP_LEVEL_ENTITY = altera_flashrom
ASSIGNMENT_FILES = $(PROJECT).qpf $(PROJECT).qsf

###################################################################
# Part, Family, Boardfile
FAMILY = "Cyclone V"
PART = 5CEBA4F23C7
#BOARDFILE = ffm-c5a4-sd-v2r0-0.board
BOARDFILE = FFM-C5A4-SD-V3r0_mit_FFC-CA7-V2r0.board
CONFIG_DEVICE = EPCS64 # fixme
SERIAL_FLASH_LOADER_DEVICE = EP4CE22 # fixme
OPENOCD_BOARD=ffm-fpga-c5a4.ocd
# OPENOCD_INTERFACE=altera-usb-blaster.ocd
OPENOCD_INTERFACE=ft4232.ocd
# OPENOCD_INTERFACE=remote.ocd
OPENOCD_SVF_CLOCK=33MHz

###################################################################
#
# Quartus shell environment vars
#
###################################################################

quartus_env ?= . ../include/quartus_env.sh

# include makefile which does it all
include ../include/altera.mk

###################################################################
# Setup your sources here
SRCS = \
top/altera_flashrom.vhd \
