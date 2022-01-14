/* ColorEntry.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Colorful {
    public class ColorEntry : Gtk.Box {
        public Gtk.Entry entry { get; private set; }
        public Gtk.Button copy_button { get; private set; }
        public string text { get; private set; }

        construct {
            orientation = HORIZONTAL;
            halign = CENTER;
            add_css_class ("linked");

            entry = new Gtk.Entry () {
                width_request = 390,
                height_request = 40,
                editable = false,
                xalign = (float) 0.50
            };
            entry.add_css_class ("monospace");
            entry.add_css_class ("title-4");

            entry.bind_property ("text",
                this, "text",
                SYNC_CREATE | BIDIRECTIONAL
            );

            copy_button = new Gtk.Button () {
                icon_name = "edit-copy-symbolic"
            };

            append (entry);
            append (copy_button);
        }
    }
}
