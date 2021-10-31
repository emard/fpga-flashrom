###################################################################
# Project Configuration: 
# 
# Specify the name of the design (project) and the Quartus II
# Settings File (.qsf)
###################################################################

PROJECT ?= project
TOP_LEVEL_ENTITY ?= glue
ASSIGNMENT_FILES ?= $(PROJECT).qpf $(PROJECT).qsf

###################################################################
# Part, Family, Boardfile
FAMILY ?= "Cyclone IV E"
PART ?= EP4CE6E22C8
SPIOVERJTAG_BRIDGE ?= 5CE423
BOARDFILE ?= tb276.board
CONFIG_DEVICE ?= EPCS4
SERIAL_FLASH_LOADER_DEVICE ?= EP4CE6
OPENOCD_INTERFACE ?= =interface/altera-usb-blaster.cfg
OPENOCD_BOARD ?= tb276.ocd
OPENOCD_SVF_CLOCK ?= 1MHz
OPENFPGALOADER ?= /usr/local/bin/openFPGALoader
FLASHROM ?= /usr/sbin/flashrom
###################################################################

###################################################################
# Setup your sources here
SRCS ?= glue.vhd

###################################################################
#
# Quartus shell environment vars
#
###################################################################

quartus_env ?= . ./quartus_env.sh

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and database
# program: program your device with the compiled design
###################################################################

all: $(PROJECT).sof $(PROJECT).svf

clean:
	rm -rf *~ $(PROJECT).jdi $(PROJECT).jic $(PROJECT).pin $(PROJECT).qws $(PROJECT).sld \
	       *.rpt *.chg smart.log *.htm *.eqn *.sof *.svf *.pof *.rbf *.jic *.smsg *.summary \
	       f32c_dual_boot.map f32c_dual_boot*.rpd cfm.bin  \
	       PLL*INFO.txt c5_pin_model_dump.txt \
	       db incremental_db output_files greybox_tmp cr_ie_info.json \
	       $(ASSIGNMENT_FILES)

map: smart.log $(PROJECT).map.rpt
fit: smart.log $(PROJECT).fit.rpt
asm: smart.log $(PROJECT).asm.rpt
sta: smart.log $(PROJECT).sta.rpt
smart: smart.log

###################################################################
# Executable Configuration
###################################################################

MAP_ARGS = --read_settings_files=on --enable_register_retiming=on $(addprefix --source=,$(SRCS))
FIT_ARGS = --part=$(PART) --read_settings_files=on --effort=standard --optimize_io_register_for_timing=on --one_fit_attempt=off --pack_register=auto
ASM_ARGS = 
STA_ARGS = 

###################################################################
# Target implementations
###################################################################

STAMP = echo done >

$(PROJECT).map.rpt: map.chg $(SOURCE_FILES) 
	$(quartus_env); quartus_map $(MAP_ARGS) $(PROJECT)
	$(STAMP) fit.chg

$(PROJECT).fit.rpt: fit.chg $(PROJECT).map.rpt
	$(quartus_env); quartus_fit $(FIT_ARGS) $(PROJECT)
	$(STAMP) asm.chg
	$(STAMP) sta.chg

$(PROJECT).asm.rpt: asm.chg $(PROJECT).fit.rpt
	$(quartus_env); quartus_asm $(ASM_ARGS) $(PROJECT)

$(PROJECT).sta.rpt: sta.chg $(PROJECT).fit.rpt
	$(quartus_env); quartus_sta $(STA_ARGS) $(PROJECT) 

smart.log: $(ASSIGNMENT_FILES)
	$(quartus_env); quartus_sh --determine_smart_action $(PROJECT) > smart.log
	
$(PROJECT).sof: map fit asm sta smart

$(PROJECT).jic: $(PROJECT).sof
	$(quartus_env); quartus_cpf -c \
	-d $(CONFIG_DEVICE) \
	-s $(SERIAL_FLASH_LOADER_DEVICE) \
	$(PROJECT).sof $(PROJECT).jic

$(PROJECT).pof: $(PROJECT).sof
	$(quartus_env); quartus_cpf -c -d $(CONFIG_DEVICE) $(PROJECT).sof $(PROJECT).pof

$(PROJECT).rbf: $(PROJECT).sof
	$(quartus_env); quartus_cpf -c \
	$(PROJECT).sof $(PROJECT).rbf

#	-o bitstream_compression=on \
#	--start_address 0 \
#	--sfl_device $(CONFIG_DEVICE) \

$(PROJECT).svf: $(PROJECT).sof
	$(quartus_env); quartus_cpf -c \
	-q $(OPENOCD_SVF_CLOCK) -g 3.3 -n p \
	$(PROJECT).sof $(PROJECT).svf

# http://dangerousprototypes.com/docs/JTAG_SVF_to_XSVF_file_converter
# executable svf2xsvf502 is in zip file under old subdirectory:
# http://www.xilinx.com/support/documentation/application_notes/xapp058.zip
$(PROJECT).xsvf: $(PROJECT).svf
	svf2xsvf502 -i $(PROJECT).svf -o $(PROJECT).xsvf

# suitable for python script flasher on pulserain M10
cfm.bin: post_flow.tcl dual_image.cof project.sof
	$(quartus_env); quartus_sh -t post_flow.tcl

# MAX10 full image
full_image.pof: post_flow.tcl dual_image.cof project.sof
	$(quartus_env); quartus_sh -t post_flow.tcl

# MAX10 full image converted to SVF
full_image.svf: full_image.pof
	$(quartus_env); quartus_cpf -c -q 8MHz -g 3.3 -n p $< $@

###################################################################
# Project initialization
###################################################################

$(ASSIGNMENT_FILES):
	$(quartus_env); quartus_sh --prepare -f $(FAMILY) -t $(TOP_LEVEL_ENTITY) $(PROJECT)
	echo >> $(PROJECT).qsf
	cat $(BOARDFILE) >> $(PROJECT).qsf
map.chg:
	$(STAMP) map.chg
fit.chg:
	$(STAMP) fit.chg
sta.chg:
	$(STAMP) sta.chg
asm.chg:
	$(STAMP) asm.chg

###################################################################
# Programming the device
###################################################################

upload: prog

prog: $(PROJECT).sof
	$(quartus_env); quartus_pgm --no_banner --mode=jtag -o "P;$(PROJECT).sof"

prog_ocd: $(PROJECT).svf
	openocd --file=$(OPENOCD_INTERFACE) --file=$(OPENOCD_BOARD)

flash_ocd: $(PROJECT)_flash.svf
	openocd --file=$(OPENOCD_INTERFACE) --file=$(OPENOCD_BOARD_FLASH)

prog_ofl: $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 $(PROJECT).svf

# MODULE DIP SWITCH POSITIONS for "make flash"
# 1      1      1        1
# | o|   |o |   | o|     |oo|
# |o |   | o|   |o |     |  |
#    M0 M1  M2 M3  M4    SW4

flash: $(PROJECT).jic
	$(quartus_env); quartus_pgm --no_banner --mode=jtag -o "IP;$(PROJECT).jic"
	echo "Power cycle or Reset device to run"

# bitstream normally works but verify dumps some error (CRC)
#	$(quartus_env); quartus_pgm --no_banner --mode=jtag -o "IPV;$(PROJECT).jic"

flash_svf: $(PROJECT)_flash.svf

# this doesn't work
$(PROJECT)_flash.svf: $(PROJECT).jic
	$(quartus_env); quartus_cpf \
	-c -q 8MHz -g 3.3 -n p \
	$(PROJECT).jic $(PROJECT)_flash.svf

# hack convert ".jic" to ".rbf" file
# from start of .jic file, skip some ASCII and NULL bytes until first
# occurence of 0xFF is found. Copy from first 0xFF until last 0xFF.
# Last 0xFF comes in a series of many 0xFF, indicating of end of flash.
# after last 0xFF some ASCII and NULL bytes are expected.
$(PROJECT)_flash.rbf: $(PROJECT).jic
	./jic2rbf.py $(PROJECT).jic $(PROJECT)_flash.rbf

$(PROJECT)_flash.bit: $(PROJECT).jic
	./jic2bit.py $(PROJECT).jic $(PROJECT)_flash.bit

# this is crude replacement of above that skips start
# with hardcoded number of bytes
# dd if=$(PROJECT).jic of=$(PROJECT)_flash.rbf bs=1 count=8M skip=154

# any working .svf bitstream must be uploaded to SRAM
# before before spioverjtag is uploaded to SRAM
# rbf file type is "reverse bits file" MSB-LSB bits in each byte are reversed and flashed to chip
# bin file type is direct, unchanged content is flashed to chip
flash_ofl: $(PROJECT)_flash.rbf $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 --fpga-part $(SPIOVERJTAG_BRIDGE) \
	--file-type rbf -f $(PROJECT)_flash.rbf

flash_rom: $(PROJECT)_flash.bit $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 $(PROJECT).svf
	$(FLASHROM) -p ft2232_spi:type=4232H,port=B,divisor=8 -w $(PROJECT)_flash.bit

# .rbf generated by quartus should work for SRAM
# this check shows that it actually works
prog_rbf_ofl: $(PROJECT).rbf
	$(OPENFPGALOADER) -c ft4232 $(PROJECT).rbf

# .rbf generated by quartus should work for FLASH
# this doesn't work
flash_rbf_ofl: $(PROJECT).rbf $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 $(PROJECT).svf
	$(OPENFPGALOADER) -c ft4232 --fpga-part $(SPIOVERJTAG_BRIDGE) \
	--file-type rbf -f $(PROJECT).rbf

bridge.svf: /opt/altera/intelFPGA_lite/20.1/quartus/common/devinfo/programmer/sfl_enhanced_01_02b050dd.sof
	$(quartus_env); quartus_cpf \
	-c -q 8MHz -g 3.3 -n p \
	$< $@
