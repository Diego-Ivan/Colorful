/* Application.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Colorful {
	public class Application : Adw.Application {
		private ActionEntry[] APP_ACTIONS = {
			{ "about", on_about_action },
			{ "quit", quit }
		};


		public Application () {
			Object (
			    application_id: "io.github.diegoivanme.colorful",
			    flags: ApplicationFlags.FLAGS_NONE
			);

			add_action_entries(APP_ACTIONS, this);
			set_accels_for_action("app.quit", {"<primary>q"});
		}

		public override void activate () {
			var win = active_window;
			if (win == null) {
				win = new Window (this);
			}
			win.present ();
		}

		private void on_about_action () {
	        const string COPYRIGHT = "Copyright \xc2\xa9 2022 Diego Iván";
			const string?[] AUTHORS = {
			    "Diego Iván",
			    null
			};
            Gtk.show_about_dialog (
                active_window, // transient for
                "program_name", Config.PRETTY_NAME,
                "logo-icon-name", Config.APP_ID,
                "version", Config.VERSION,
                "copyright", COPYRIGHT,
                "authors", AUTHORS,
                "license-type", Gtk.License.GPL_3_0,
                "wrap-license", true,
                // Translators: Write your Name<email> here :p
                "translator-credits", _("translator-credits"),
                null
            );
		}
	}
}
