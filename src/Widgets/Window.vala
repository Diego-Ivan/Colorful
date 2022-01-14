/* Window.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Colorful {
	[GtkTemplate (ui = "/io/github/diegoivanme/colorful/window.ui")]
	public class Window : Adw.ApplicationWindow {
	    [GtkChild] unowned ColorEntry rgb_entry;
	    [GtkChild] unowned ColorEntry hex_entry;
	    [GtkChild] unowned ColorImage color_image;
	    [GtkChild] unowned Gtk.Box color_box;
	    [GtkChild] unowned HueSlider hue_slider;

	    public Chooser chooser;
		
		public Window (Gtk.Application app) {
			Object (
			    application: app
			);
		}

		construct {
		    color_image.color = {
			    1,
			    0,
			    0,
			    1
			};

    		chooser = new Chooser (color_image.color);
			chooser.on_sv_move.connect (update_image_color);

			hue_slider.hue_changed.connect (update_hue);
			color_box.prepend (chooser);

			update_hue ();
		}

		private void update_hue () {
		    float r, g, b;
		    Gtk.hsv_to_rgb (
		        hue_slider.current_hue,
		        (float) chooser.s,
		        (float) chooser.v,
		        out r,
		        out g,
		        out b
		    );

		    chooser.active_color = {
		        r,
		        g,
		        b,
		        1
		    };

		    chooser.h = hue_slider.current_hue;
		    update_image_color ((float) chooser.s, (float) chooser.v);
		}

		private void update_image_color (double s, double v) {
	        float r, g, b;
	        Gtk.hsv_to_rgb (hue_slider.current_hue, (float) s, (float) v, out r, out g, out b);
	        color_image.color = {
	            r,
	            g,
	            b,
	            1
	        };

	        rgb_entry.text = color_image.color.to_string ();
		}
	}
}
