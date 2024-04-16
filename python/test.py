# Copyright (C) 2024 KUCMB
# SPDX-License-Identifier: BSD-3-Clause

import os
os.environ['BOARD'] = 'RFSoC4x2'
import xrfclk
import xrfdc
import pynq
import pynq.lib
from constants import *
from mtspy.mts import multiconverter_init, multiconverter_sync


class TestOverlay(pynq.Overlay):
    """Base overlay for the board.

    The base overlay contains Pmod 0 and 1, LEDs, RGBLEDs, push buttons,
    switches, and pin control gpio.

    After reloading the base overlay, the I2C and display port should become
    available as well.

    """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        if self.is_loaded():
            pass

        self.dds_mmio = self.dds_hls.mmio

    def init_rf_clks(self, lmk_freq=245.76, lmx_freq=491.52):   
        xrfclk.set_ref_clks(lmk_freq=lmk_freq, lmx_freq=lmx_freq)

    def mts(self):
        dac_sync_config = multiconverter_init(0)
        dac_sync_config['Tiles'] = 5 # 0 and 2
        multiconverter_sync(self.rfdc, 1, dac_sync_config)
        
        adc_sync_config = multiconverter_init(0)
        adc_sync_config['Tiles'] = 1
        multiconverter_sync(self.rfdc, 0, adc_sync_config)

    def set_pinc(self, pinc):
        '''Set phase increment value per sample.

        Parameter
        ---------
        pinc : int
            Phase increment per sample.
        '''
        self.dds_mmio.write(0x10, pinc)
