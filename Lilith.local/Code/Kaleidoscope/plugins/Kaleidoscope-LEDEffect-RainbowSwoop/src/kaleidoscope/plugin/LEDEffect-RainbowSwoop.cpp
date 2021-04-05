#include "Kaleidoscope-LEDEffect-RainbowSwoop.h"

namespace kaleidoscope {
namespace plugin {
void LEDRainbowSwoopEffect::TransientLEDMode::onActivate(void) {
  if (!Runtime.has_leds)
    return;

  for (uint8_t i = 0; i < 64; i++) {
    uint8_t col =
      i > 26 && i < 31 ? i - 23 : // assign left curve as 4, 5, 6, (and the only button in) 7
      i > 32 && i < 37 ? i - 25 : // assign right curve as (only button in) 8, 9, 10, 11
      /*0 - 26,37 - 63*/ i / 4;   // divide into the 4 button column - 0-6,9-15

    uint16_t led_hue =
    (( // we assign each column a base hue
      (15 - col) * // working across columns right to left
            27)/2  // in increments of approx 13.5 = (305º / 16 = 19.0625º) * 255/360º
    ) +
    ( // then skew hues on individual LEDs as
      (abs((2*((i + 4) % 8)) - 7)/2) * // none on bottom row, some in middle rows, most on top row
      ( // always towards red
        i < 27 ?  1 : //    meaning   up (+) from 180º towards 360º (aka 0º) on the left
        i > 32 ? -1 : //but meaning down (-) towards 0º on the right
        0 // and leaving the curves alone cause they're pretty how they are.
      ) *
      ( // & more on the outside columns than the middle
        ( (i < 32 ? max(5 - col, 0) : // which is to say lower numbers on the left half
                   max(col - 10, 0) ) * // but higher numbers on the right
        7)/5 // weighted at approx 7 = 10º for the most weighted column
      ) // meaning theres is a 30º (about 1 rainbow color) hue swing in the upper-left and upper right
    );

    ::LEDControl.setCrgbAt(i, hsvToRgb(led_hue, rainbow_saturation, parent_->rainbow_value));
  }
  ::LEDControl.setCrgbAt(31, hsvToRgb(128, rainbow_saturation, 255));
  ::LEDControl.setCrgbAt(32, hsvToRgb(0, rainbow_saturation, 255));
}

void LEDRainbowSwoopEffect::brightness(byte brightness) {
  rainbow_value = brightness;
}

}
}

kaleidoscope::plugin::LEDRainbowSwoopEffect LEDRainbowSwoopEffect;
