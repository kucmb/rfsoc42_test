# RFSoC4x2 test firmware

## Overview
This repository contains codes to make a test firmware for RFSoC4x2.
The test firmware has:
- AXI configurable DDS (inherited from dds_hls https://github.com/kucmb/dds_hls) to feed DAC, and
- ILA (Integrated Logic Analyzer) for ADC input inspection.

## Requirement
TCL file included in this software assumes the following repositories are placed at the same level as this repository.
1. RFSoC-PYNQ (https://github.com/Xilinx/RFSoC-PYNQ)
2. dds_hls (https://github.com/kucmb/dds_hls)
Test is done with Vivado 2023.2 on Ubuntu 20.04.

## Usage
Run `vivado -mode batch -source test.tcl` at the top level of this repository to produce firmware.
Rename `rfsoc42_test/rfsoc42_test.runs/impl_1/system_wrapper.bit` to `system.bit` and copy it to PYNQ on RFSoC4x2.
Copy `rfsoc42_test/rfsoc42_test.gen/sources_1/bd/system/hw_handoff/system.hwh` to PYNQ on RFSoC4x2.
Copy files and mtspy submodule to PYNQ and then run ipython notebook.
For ILA, you also need `system_wrappter.ltx` for debug probe information.

## Feature
- Multi-tile synchronization with pure python codes (mtspy: https://github.com/kucmb/mtspy)
    - No modification needed on library


--- 

Copyright (C) 2024 Junya SUZUKI, Kyoto CMB group

SPDX-License-Identifier: BSD-3-Clause
