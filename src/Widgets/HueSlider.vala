/* HueSlider.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Colorful {
    public class HueSlider : Gtk.Scale {
        public float current_hue { get; private set; }
        public signal void hue_changed ();

        construct {
            orientation = HORIZONTAL;
            digits = 0;
            adjustment = new Gtk.Adjustment (1, 0, 360, 1, 10, 0);

            value_changed.connect (() => {
                // gets the value in a range from 0 to 1, just as we need
                current_hue = (float) (adjustment.value / 360);
                hue_changed ();
            });
        }
    }
}
