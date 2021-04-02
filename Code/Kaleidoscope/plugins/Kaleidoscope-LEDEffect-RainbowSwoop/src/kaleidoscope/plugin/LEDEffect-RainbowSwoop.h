#pragma once

#include "Kaleidoscope-LEDControl.h"

namespace kaleidoscope {
namespace plugin {

class LEDRainbowSwoopEffect : public Plugin, public LEDModeInterface {
 public:
  LEDRainbowSwoopEffect(void) {}

  void brightness(byte);
  byte brightness(void) {
    return rainbow_value;
  }

  // This class' instance has dynamic lifetime
  //
  class TransientLEDMode : public LEDMode {
   public:

    // Please note that storing the parent ptr is only required
    // for those LED modes that require access to
    // members of their parent class. Most LED modes can do without.
    //
    explicit TransientLEDMode(const LEDRainbowSwoopEffect *parent)
      : parent_(parent) {}

    void onActivate(void) final;
    //void update() final;

   private:

    const LEDRainbowSwoopEffect *parent_;

    uint8_t rainbow_wave_steps = 1;  //  number of hues we skip in a 360 range per update
    uint8_t rainbow_last_update = 0;

    byte rainbow_saturation = 255;
  };


  byte rainbow_value = 192;
};
}
}

extern kaleidoscope::plugin::LEDRainbowSwoopEffect LEDRainbowSwoopEffect;
