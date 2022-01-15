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
	    [GtkChild] unowned ColorEntry hsv_entry;
	    [GtkChild] unowned ColorImage color_image;
	    [GtkChild] unowned Gtk.Box color_box;
	    [GtkChild] unowned HueSlider hue_slider;

	    private Chooser chooser;
	    private Xdp.Portal portal;
		
		public Window (Gtk.Application app) {
			Object (
			    application: app
			);
		}

		construct {
		    portal = new Xdp.Portal ();
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
		        1,
		        1,
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
	        hsv_entry.text = "hsv(%i,%i,%i)".printf (
	            (int) (hue_slider.current_hue * 360),
	            (int) (s * 360),
	            (int) (v * 360)
	        );

	        double red = r * 255;
            double green = g * 255;
            double blue = b * 255;

            hex_entry.text = "#%02x%02x%02x".printf ((uint)red, (uint)green, (uint)blue);
		}

		[GtkCallback]
		private void on_pick_color_button_clicked () {
		    var parent = Xdp.parent_new_gtk (this);
		    portal.pick_color.begin (
		        parent,
		        null,
		        color_callback
		    );
		}

		private void color_callback (Object? obj, AsyncResult res) {
		    GLib.Variant colors;
		    try {
		        colors = portal.pick_color.end (res);
		        double red = 0;
                double green = 0;
                double blue = 0;

                GLib.VariantIter iter = colors.iterator ();
                iter.next ("d", &red);
                iter.next ("d", &green);
                iter.next ("d", &blue);

                double h, s, v;
                Gtk.rgb_to_hsv ((float) red,(float) green, (float) blue, out h, out s, out v);

                chooser.sv_to_pos ((float) s, (float) v);
                hue_slider.adjustment.value = h * 360;
		    }
		    catch (Error e) {
		        critical (e.message);
		    }
		}
	}
}
