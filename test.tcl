# Test firmware for RFSoC 4x2

source ./util.tcl

## Device setting (RFSoC 4x2)
set p_device "xczu48dr-ffvg1517-2-e"
set p_board "realdigital.org:rfsoc4x2:part0:1.0"

set project_name "rfsoc42_test"

create_project -force $project_name ./${project_name} -part $p_device
set_property board_part $p_board [current_project]


add_files -fileset constrs_1 -norecurse {\
    "./constraints/base.xdc" \
}

## IP repository
set_property  ip_repo_paths  {\
    ../axi_ddc_oct \
    ../RFSoC-PYNQ/boards/ip \
} [current_project]

#set_property ip_repo_paths $lib_dirs [current_fileset]
update_ip_catalog

## create board design
create_bd_design "system"


## port definitions
#### Interfaces
set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

set adc0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc0_clk ]
set_property -dict [ list \
  CONFIG.FREQ_HZ {491520000.0} \
] $adc0_clk

#set adc2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 adc2_clk ]
#set_property -dict [ list \
#CONFIG.FREQ_HZ {491520000.0} \
#] $adc2_clk

set dac0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac0_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {491520000.0} \
] $dac0_clk

set dac2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 dac2_clk ]
set_property -dict [ list \
CONFIG.FREQ_HZ {491520000.0} \
] $dac2_clk

set ddr4_pl [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_pl ]

#set diff_clock_rtl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 diff_clock_rtl ]
#set_property -dict [ list \
#CONFIG.FREQ_HZ {156250000} \
#] $diff_clock_rtl

set sys_clk_ddr4 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk_ddr4 ]
set_property -dict [ list \
    CONFIG.FREQ_HZ {200000000} \
] $sys_clk_ddr4

set sysref_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:display_usp_rf_data_converter:diff_pins_rtl:1.0 sysref_in ]
set syzygy_std0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 syzygy_std0 ]
set vin0_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_01 ]
set vin0_23 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin0_23 ]
#set vin2_01 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_01 ]
#set vin2_23 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vin2_23 ]
set vout00 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout00 ]
set vout20 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 vout20 ]

set sysref_fpga [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sysref_fpga ]
set fpga_refclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 fpga_refclk ]
set_property -dict [ list \
    CONFIG.FREQ_HZ {122880000} \
] $fpga_refclk

## RF data converter

set rfdc [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter:2.6 rfdc ]
set_property -dict [list \
    CONFIG.ADC0_Outclk_Freq {307.200} \
    CONFIG.ADC0_PLL_Enable {true} \
    CONFIG.ADC0_Refclk_Freq {491.520} \
    CONFIG.ADC0_Sampling_Rate {4.9152} \
    CONFIG.ADC0_Multi_Tile_Sync {true} \
    CONFIG.ADC_Coarse_Mixer_Freq00 {3} \
    CONFIG.ADC_Coarse_Mixer_Freq02 {3} \
    CONFIG.ADC_Data_Type00 {0} \
    CONFIG.ADC_Data_Type02 {0} \
    CONFIG.ADC_Data_Width00 {12} \
    CONFIG.ADC_Data_Width02 {12} \
    CONFIG.ADC_Decimation_Mode00 {1} \
    CONFIG.ADC_Decimation_Mode02 {1} \
    CONFIG.ADC_Mixer_Mode00 {2} \
    CONFIG.ADC_Mixer_Mode02 {2} \
    CONFIG.ADC_Mixer_Type00 {1} \
    CONFIG.ADC_Mixer_Type02 {1} \
    CONFIG.ADC_OBS02 {false} \
    CONFIG.ADC_Slice02_Enable {true} \
    CONFIG.ADC_Slice20_Enable {false} \
    CONFIG.ADC_Slice22_Enable {false} \
    CONFIG.DAC0_Multi_Tile_Sync {true} \
    CONFIG.DAC0_Outclk_Freq {307.200} \
    CONFIG.DAC0_PLL_Enable {true} \
    CONFIG.DAC0_Refclk_Freq {491.520} \
    CONFIG.DAC0_Sampling_Rate {4.9152} \
    CONFIG.DAC2_Multi_Tile_Sync {true} \
    CONFIG.DAC2_Outclk_Freq {307.200} \
    CONFIG.DAC2_PLL_Enable {true} \
    CONFIG.DAC2_Refclk_Freq {491.520} \
    CONFIG.DAC2_Sampling_Rate {4.9152} \
    CONFIG.DAC_Coarse_Mixer_Freq00 {3} \
    CONFIG.DAC_Coarse_Mixer_Freq20 {3} \
    CONFIG.DAC_Data_Type00 {0} \
    CONFIG.DAC_Interpolation_Mode00 {1} \
    CONFIG.DAC_Interpolation_Mode20 {1} \
    CONFIG.DAC_Mixer_Mode00 {2} \
    CONFIG.DAC_Mixer_Mode20 {2} \
    CONFIG.DAC_Mixer_Type00 {1} \
    CONFIG.DAC_Mixer_Type20 {1} \
    CONFIG.DAC_Mode00 {3} \
    CONFIG.DAC_Mode20 {3} \
    CONFIG.DAC_Slice00_Enable {true} \
    CONFIG.DAC_Slice02_Enable {false} \
    CONFIG.DAC_Slice20_Enable {true} \
] $rfdc
## DDC 
#set ddc_oct [ create_bd_cell -type ip -vlnv [latest_ip axi_ddc_oct] ddc_oct ]
#set stream_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] stream_rstgen]


## DDR4
set ddr4_0 [ create_bd_cell -type ip -vlnv [latest_ip ip:ddr4] ddr4_0 ]
set_property -dict [ list \
    CONFIG.C0.BANK_GROUP_WIDTH {1} \
    CONFIG.C0.DDR4_AxiAddressWidth {33} \
    CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_CLKFBOUT_MULT {15} \
    CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
    CONFIG.C0.DDR4_CasLatency {17} \
    CONFIG.C0.DDR4_CasWriteLatency {12} \
    CONFIG.C0.DDR4_DIVCLK_DIVIDE {2} \
    CONFIG.C0.DDR4_DataWidth {64} \
    CONFIG.C0.DDR4_InputClockPeriod {4998} \
    CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
    CONFIG.C0.DDR4_MemoryType {Components} \
    CONFIG.C0.DDR4_TimePeriod {833} \
    CONFIG.System_Clock {No_Buffer} \
] $ddr4_0

set ddr4_0_sys_reset [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] ddr4_0_sys_reset]
set mem_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] mem_rstgen]
set ddr4_ui_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] ddr4_ui_rstgen]

set interconnect_ddr4 [ create_bd_cell -type ip -vlnv [latest_ip axi_interconnect] interconnect_ddr4 ]
set_property -dict [ list \
    CONFIG.NUM_SI {1} \
    CONFIG.NUM_MI {1} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
    CONFIG.S01_HAS_DATA_FIFO {2} \
] $interconnect_ddr4

### AXI stream clock preparation
set clk_wiz_str [ create_bd_cell -type ip -vlnv [latest_ip clk_wiz] clk_wiz_str]
set_property -dict [list CONFIG.PRIM_IN_FREQ.VALUE_SRC USER] $clk_wiz_str
set_property -dict [list \
  CONFIG.CLKIN1_JITTER_PS {81.38} \
  CONFIG.CLKOUT1_JITTER {97.093} \
  CONFIG.CLKOUT1_PHASE_ERROR {100.322} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {409.6} \
  CONFIG.CLKOUT2_JITTER {102.480} \
  CONFIG.CLKOUT2_PHASE_ERROR {100.322} \
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {307.2} \
  CONFIG.CLKOUT2_USED {true} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {7.500} \
  CONFIG.MMCM_CLKIN1_PERIOD {8.138} \
  CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.250} \
  CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
  CONFIG.MMCM_DIVCLK_DIVIDE {1} \
  CONFIG.NUM_OUT_CLKS {2} \
  CONFIG.PRIM_IN_FREQ {122.88} \
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
] $clk_wiz_str
set adc_stream_reset [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] adc_stream_reset]
set dac_stream_reset [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] dac_stream_reset]

### PL sysref 
set util_ds_buf_sysref [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_sysref]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {IBUFDS} \
] $util_ds_buf_sysref
set sysref_cdc [create_bd_cell -type ip -vlnv [latest_ip xpm_cdc_gen] sysref_cdc]

# constant for clock pin
set xlconstant_0 [create_bd_cell -type ip -vlnv [latest_ip xlconstant] xlconstant_0]
set_property CONFIG.CONST_VAL {0} $xlconstant_0

### DDR4 clock preparation
set util_ds_buf_0 [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_0 ]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {IBUFDS} \
] $util_ds_buf_0

set util_ds_buf_1 [create_bd_cell -type ip -vlnv [latest_ip util_ds_buf] util_ds_buf_1 ]
set_property -dict [ list \
    CONFIG.C_BUF_TYPE {BUFG} \
] $util_ds_buf_1

### DDR4 sys_rst generation
set c_clk_mmcm_200 [ create_bd_cell -type ip -vlnv [latest_ip clk_wiz] c_clk_mmcm_200 ]
set_property -dict [ list \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKOUT1_JITTER {92.799} \
    CONFIG.CLKOUT1_PHASE_ERROR {82.655} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {6.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {6.000} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {No_buffer} \
] $c_clk_mmcm_200

set c_clk_mmcm_200_locked [create_bd_cell -type ip -vlnv [latest_ip util_vector_logic] c_clk_mmcm_200_locked]
set_property -dict [ list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
] $c_clk_mmcm_200_locked

set clk_mmcm_reset [create_bd_cell -type ip -vlnv [latest_ip util_vector_logic] clk_mmcm_reset ]
set_property -dict [ list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
] $clk_mmcm_reset

set binary_latch_counter_0 [ create_bd_cell -type ip -vlnv [latest_ip user:binary_latch_counter] binary_latch_counter_0]

## Zynq
source ./zynq_inst.tcl
set sys_rstgen [create_bd_cell -type ip -vlnv [latest_ip proc_sys_reset] sys_rstgen]

set interconnect_cpu [ create_bd_cell -type ip -vlnv [latest_ip axi_interconnect] interconnect_cpu ]
set_property -dict [ list \
    CONFIG.NUM_MI {2} \
    CONFIG.S00_HAS_DATA_FIFO {2} \
] $interconnect_cpu

## DMA
#set axi_dma [create_bd_cell -type ip -vlnv [latest_ip axi_dma] axi_dma]
#set_property -dict [list \
#    CONFIG.c_include_sg {0} \
#    CONFIG.c_sg_length_width {20} \
#    CONFIG.c_sg_include_stscntrl_strm {0} \
#    CONFIG.c_include_mm2s {0} \
#    CONFIG.c_addr_width {40} \
#] $axi_dma

## System management wizard
set system_management_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_management_wiz:1.3 system_management_wiz ]
set_property -dict [ list \
   CONFIG.ENABLE_RESET {false} \
   CONFIG.INTERFACE_SELECTION {Enable_AXI} \
 ] $system_management_wiz


############## Connection
## Clock definition
# FPGA refclk (122.88 MHz)
connect_bd_intf_net [get_bd_intf_ports fpga_refclk] [get_bd_intf_pins clk_wiz_str/CLK_IN1_D]

# ADC stream clk (409.6 MHz)
set adc_stream_clk [create_bd_net adc_stream_clk]
connect_bd_net -net $adc_stream_clk [get_bd_pins clk_wiz_str/clk_out1]

# DAC stream clk (307.2 MHz)
set dac_stream_clk [create_bd_net dac_stream_clk]
connect_bd_net -net $dac_stream_clk [get_bd_pins clk_wiz_str/clk_out2]

# DDR4
set ddr4_clk [create_bd_net ddr4_clk]
connect_bd_intf_net [get_bd_intf_ports sys_clk_ddr4] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]
connect_bd_net -net $ddr4_clk [get_bd_pins util_ds_buf_1/BUFG_O]

connect_bd_net -net $ddr4_clk [get_bd_pins c_clk_mmcm_200/clk_in1]

set ddr4_ui_clk [create_bd_net ddr4_ui_clk]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_0/c0_ddr4_ui_clk]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins interconnect_ddr4/M00_ACLK]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_0_sys_reset/slowest_sync_clk]

# Clock from Zynq
set mem_clk [create_bd_net mem_clk]
connect_bd_net -net $mem_clk [get_bd_pins zynq_ultra_ps_e_0/pl_clk1]

set sys_cpu_clk [create_bd_net sys_cpu_clk]
connect_bd_net -net $sys_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

## Reset
# Reset from ZYNQ
set pl_resetn [create_bd_net pl_resetn]
connect_bd_net -net $pl_resetn [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

# Reset for ADC stream clk (409.6 MHz)
set adc_stream_resetn [create_bd_net adc_stream_resetn]
connect_bd_net -net $pl_resetn [get_bd_pins adc_stream_reset/ext_reset_in]
connect_bd_net -net $adc_stream_clk [get_bd_pins adc_stream_reset/slowest_sync_clk]
connect_bd_net -net $adc_stream_resetn [get_bd_pins adc_stream_reset/peripheral_aresetn]

# Reset for DAC stream clk (307.2 MHz)
set dac_stream_resetn [create_bd_net dac_stream_resetn]
connect_bd_net -net $pl_resetn [get_bd_pins dac_stream_reset/ext_reset_in]
connect_bd_net -net $dac_stream_clk [get_bd_pins dac_stream_reset/slowest_sync_clk]
connect_bd_net -net $dac_stream_resetn [get_bd_pins dac_stream_reset/peripheral_aresetn]

# Peripheral reset
set sys_cpu_reset [create_bd_net sys_cpu_reset]
connect_bd_net -net $sys_cpu_reset [get_bd_pins sys_rstgen/peripheral_reset]
set sys_cpu_resetn [create_bd_net sys_cpu_resetn]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins sys_rstgen/peripheral_aresetn]
connect_bd_net -net $sys_cpu_clk [get_bd_pins sys_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn [get_bd_pins sys_rstgen/ext_reset_in]

# DDR4 reset
set ddr4_rst [create_bd_net ddr4_rst]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_0_sys_reset/ext_reset_in]

set ddr4_peripheral_aresetn [create_bd_net ddr4_peripheral_aresetn]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins ddr4_0_sys_reset/peripheral_aresetn]

set ddr4_ui_resetn [create_bd_net ddr4_ui_resetn]
connect_bd_net -net $ddr4_ui_resetn [get_bd_pins ddr4_ui_rstgen/peripheral_aresetn]
connect_bd_net -net $ddr4_ui_clk [get_bd_pins ddr4_ui_rstgen/slowest_sync_clk]
connect_bd_net -net $ddr4_rst [get_bd_pins ddr4_ui_rstgen/ext_reset_in]

# Reset synchronized to mem_clk
set mem_resetn [create_bd_net mem_resetn]
connect_bd_net -net $mem_resetn [get_bd_pins mem_rstgen/peripheral_aresetn]
connect_bd_net -net $mem_clk [get_bd_pins mem_rstgen/slowest_sync_clk]
connect_bd_net -net $pl_resetn [get_bd_pins mem_rstgen/ext_reset_in]

## IPs
# RFDC
connect_bd_intf_net [get_bd_intf_ports vout00] [get_bd_intf_pins rfdc/vout00]
connect_bd_intf_net [get_bd_intf_ports vout20] [get_bd_intf_pins rfdc/vout20]
connect_bd_intf_net [get_bd_intf_ports vin0_01] [get_bd_intf_pins rfdc/vin0_01]
connect_bd_intf_net [get_bd_intf_ports vin0_23] [get_bd_intf_pins rfdc/vin0_23]
#connect_bd_intf_net [get_bd_intf_ports vin2_01] [get_bd_intf_pins rfdc/vin2_01]
#connect_bd_intf_net [get_bd_intf_ports vin2_23] [get_bd_intf_pins rfdc/vin2_23]

connect_bd_intf_net [get_bd_intf_ports sysref_in] [get_bd_intf_pins rfdc/sysref_in]
connect_bd_intf_net [get_bd_intf_pins adc0_clk] [get_bd_intf_pins rfdc/adc0_clk]
#connect_bd_intf_net [get_bd_intf_pins adc2_clk] [get_bd_intf_pins rfdc/adc2_clk]
connect_bd_intf_net [get_bd_intf_pins dac0_clk] [get_bd_intf_pins rfdc/dac0_clk]
connect_bd_intf_net [get_bd_intf_pins dac2_clk] [get_bd_intf_pins rfdc/dac2_clk]

connect_bd_net -net $adc_stream_clk [get_bd_pins rfdc/m0_axis_aclk]
#connect_bd_net -net $adc_stream_clk [get_bd_pins rfdc/m2_axis_aclk]
connect_bd_net -net $dac_stream_clk [get_bd_pins rfdc/s0_axis_aclk]
connect_bd_net -net $dac_stream_clk [get_bd_pins rfdc/s2_axis_aclk]

connect_bd_net -net $adc_stream_resetn [get_bd_pins rfdc/m0_axis_aresetn]
#connect_bd_net -net $adc_stream_resetn [get_bd_pins rfdc/m2_axis_aresetn]
connect_bd_net -net $dac_stream_resetn [get_bd_pins rfdc/s0_axis_aresetn]
connect_bd_net -net $dac_stream_resetn [get_bd_pins rfdc/s2_axis_aresetn]

connect_bd_net -net $sys_cpu_clk [get_bd_pins rfdc/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins rfdc/s_axi_aresetn]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M01_AXI] [get_bd_intf_pins rfdc/s_axi]


# Interconnect for AXI peripheral control
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/S00_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M00_ACLK]
connect_bd_net -net $sys_cpu_clk [get_bd_pins interconnect_cpu/M01_ACLK]

connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/S00_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M00_ARESETN]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins interconnect_cpu/M01_ARESETN]

connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD] [get_bd_intf_pins interconnect_cpu/S00_AXI]

connect_bd_net -net $sys_cpu_clk [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk]


# DDR4
connect_bd_net -net $ddr4_clk [get_bd_pins ddr4_0/c0_sys_clk_i]
connect_bd_intf_net [get_bd_intf_ports ddr4_pl] [get_bd_intf_pins ddr4_0/C0_DDR4]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn]


# DDR4 interconnect
connect_bd_intf_net [get_bd_intf_pins interconnect_ddr4/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
connect_bd_intf_net [get_bd_intf_pins interconnect_ddr4/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]
connect_bd_net -net $ddr4_peripheral_aresetn [get_bd_pins interconnect_ddr4/M00_ARESETN]

connect_bd_net -net $mem_resetn [get_bd_pins interconnect_ddr4/ARESETN]
connect_bd_net -net $mem_resetn [get_bd_pins interconnect_ddr4/S00_ARESETN]
connect_bd_net -net $mem_clk [get_bd_pins interconnect_ddr4/ACLK]
connect_bd_net -net $mem_clk [get_bd_pins interconnect_ddr4/S00_ACLK]

connect_bd_net -net $mem_clk [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]



# DDR4 sys_rst preparation
connect_bd_net [get_bd_pins c_clk_mmcm_200/locked] [get_bd_pins c_clk_mmcm_200_locked/Op1]
connect_bd_net [get_bd_pins c_clk_mmcm_200_locked/Res] [get_bd_pins ddr4_0/sys_rst]

# mmcm reset preparation
connect_bd_net -net $sys_cpu_resetn [get_bd_pins binary_latch_counter_0/resetn]
connect_bd_net -net $sys_cpu_clk [get_bd_pins binary_latch_counter_0/clk]

connect_bd_net [get_bd_pins c_clk_mmcm_200/reset] [get_bd_pins clk_mmcm_reset/Res]
connect_bd_net [get_bd_pins clk_wiz_str/reset] [get_bd_pins clk_mmcm_reset/Res]
connect_bd_net [get_bd_pins binary_latch_counter_0/latched] [get_bd_pins clk_mmcm_reset/Op1]

# pl sysref
connect_bd_net -net $dac_stream_clk [get_bd_pins sysref_cdc/dest_clk]
connect_bd_intf_net [get_bd_intf_ports sysref_fpga] [get_bd_intf_pins util_ds_buf_sysref/CLK_IN_D]
connect_bd_net [get_bd_pins util_ds_buf_sysref/IBUF_OUT] [get_bd_pins sysref_cdc/src_in]
connect_bd_net [get_bd_pins sysref_cdc/dest_out] [get_bd_pins rfdc/user_sysref_adc]
connect_bd_net [get_bd_pins sysref_cdc/dest_out] [get_bd_pins rfdc/user_sysref_dac]


connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins sysref_cdc/src_clk]

# System management wiz
connect_bd_intf_net [get_bd_intf_ports Vp_Vn] [get_bd_intf_pins system_management_wiz/Vp_Vn]
connect_bd_intf_net [get_bd_intf_pins interconnect_cpu/M00_AXI] [get_bd_intf_pins system_management_wiz/S_AXI_LITE]
connect_bd_net -net $sys_cpu_clk [get_bd_pins system_management_wiz/s_axi_aclk]
connect_bd_net -net $sys_cpu_resetn [get_bd_pins system_management_wiz/s_axi_aresetn]


## Addresses
assign_bd_address -offset 0x001000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
#assign_bd_address -offset 0x001000000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces axi_dma/Data_S2MM] [get_bd_addr_segs ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force

assign_bd_address -offset 0x80000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs system_management_wiz/S_AXI_LITE/Reg] -force
assign_bd_address -offset 0x80080000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs rfdc/s_axi/Reg] -force

### Project
save_bd_design
validate_bd_design

set project_system_dir "./${project_name}/${project_name}.srcs/sources_1/bd/system"

set_property synth_checkpoint_mode None [get_files  $project_system_dir/system.bd]
generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]
make_wrapper -files [get_files $project_system_dir/system.bd] -top

import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v
set_property top system_wrapper [current_fileset]

