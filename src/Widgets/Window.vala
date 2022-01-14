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
		
		public Window (Gtk.Application app) {
			Object (
			    application: app
			);
			
			color_image.color = {
			    0,
			    0,
			    0,
			    1
			};
		}
	}
}
