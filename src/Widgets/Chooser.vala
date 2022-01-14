/**
 * Widget from Colorway https://github.com/lainsce/colorway/
 * Slightly modified to fit better Colorful's purpose
 *
 * Copyright (c) 2021 Lains
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Co-Authored by: Arvianto Dwi Wicaksono <arvianto.dwi@gmail.com>
 */

namespace Colorful {
    public class Chooser : Gtk.DrawingArea {
        //  Properties
        private const uint16 WIDTH = 222;
        private const uint16 HEIGHT = 222;
        private static double r;
        private static double g;
        private static double b;
        public static double xpos = 222;
        public static double ypos = 0;
        public static unowned Chooser instance;
        private static Cairo.Surface surface;
        private static Gtk.GestureClick gesture;
        private static Gtk.GestureDrag drag;
        private Gdk.RGBA _active_color;
        public Gdk.RGBA active_color {
            get {
                return _active_color;
            }
            set {
                _active_color = value;
                r = value.red;
                g = value.green;
                b = value.blue;
                create_surface ();
                instance.queue_draw ();
            }
        }
        public double h;
        public double s;
        public double v;

        //  Signals
        public signal void on_sv_move (double s, double v);

        public Chooser (Gdk.RGBA active_color) {
            double h, s, v;
            r = active_color.red;
            g = active_color.green;
            b = active_color.blue;
            this.active_color = active_color;
            this.get_style_context ().add_class ("clr-da");

            this.set_halign (Gtk.Align.CENTER);

            Gtk.rgb_to_hsv ((float)r, (float)g, (float)b, out h, out s, out v);
            this.h = h;
            this.s = s;
            this.v = v;

            sv_to_xy (s, v, out xpos, out ypos);
            create_surface ();
        }

        construct {
            instance = this;
            instance.set_size_request (WIDTH, HEIGHT);

            gesture = new Gtk.GestureClick ();
            this.add_controller (gesture);
            gesture.released.connect (gesture_press_release);

            drag = new Gtk.GestureDrag ();
            drag.drag_begin.connect (gesture_drag_begin);
            drag.drag_update.connect (gesture_drag_update);
            drag.drag_end.connect (gesture_drag_end);
            this.add_controller (drag);

            surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, WIDTH, HEIGHT);

            this.set_draw_func (draw_func);
        }

        public void draw_func (Gtk.DrawingArea da, Cairo.Context context, int width, int height) {
            double xc = 7;
            double yc = 7;
            double stroke_width = 5;
            double radius = xc - stroke_width / 2;
            double angle1 = 0;
            double angle2 = 2 * GLib.Math.PI;

            context.set_source_surface (surface, 0, 0);
            context.paint ();
            context.translate (xpos - 7, ypos - 7);
            context.arc (xc, yc, radius, angle1, angle2);
            context.set_line_width (stroke_width);
            context.set_source_rgb (1, 1, 1);
            context.stroke_preserve ();
            context.set_line_width (2);
            context.set_source_rgb (0, 0, 0);
            context.stroke ();

            da.queue_draw ();
        }

        public void update_surface_color (double r_arg, double g_arg, double b_arg) {
            active_color = {
                (float) r_arg,
                (float) g_arg,
                (float) b_arg,
                1
            };
            create_surface ();
            this.queue_draw ();
        }

        public void pos_to_sv (out double s, out double v) {
            xy_to_sv (xpos, ypos, out s, out v);
        }

        public void sv_to_pos (float s, float v) {
            sv_to_xy (s, v, out xpos, out ypos);

            double new_s, new_v;
            xy_to_sv (xpos, ypos, out new_s, out new_v);
            instance.on_sv_move (new_s, new_v);
            instance.queue_draw ();
        }

        private void xy_to_sv (double x, double y, out double s, out double v) {
            if (x < 0) {
                x = 0;
            } else if (x > WIDTH) {
                x = WIDTH;
            }

            if (y < 0) {
                y = 0;
            } else if (y > HEIGHT) {
                y = HEIGHT;
            }

            s = x / WIDTH;
            v = 1 - (y / HEIGHT);

            this.s = s;
            this.v = v;
        }

        public void sv_to_xy (double s, double v, out double x, out double y) {
            x = s * WIDTH;
            y = HEIGHT - (v * HEIGHT);
        }

        private static void create_surface () {
            double x             = 0,
                   y             = 0,
                   width         = WIDTH,
                   height        = HEIGHT,
                   aspect        = 1.0,
                   corner_radius = 8.0;
            double radius        = corner_radius / aspect;
            double degrees       = Math.PI / 180.0;

            Cairo.Context context = new Cairo.Context (surface);
            context.arc (x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
            context.arc (x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
            context.arc (x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
            context.arc (x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
            context.set_source_rgb (r, g, b);
            context.fill_preserve ();

            Cairo.Pattern p1 = new Cairo.Pattern.linear (0, 0, WIDTH, 0);
            p1.add_color_stop_rgba (0, 1, 1, 1, 1);
            p1.add_color_stop_rgba (1, 1, 1, 1, 0);
            context.arc (x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
            context.arc (x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
            context.arc (x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
            context.arc (x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
            context.set_source (p1);
            context.fill_preserve ();

            Cairo.Pattern p2 = new Cairo.Pattern.linear (0, 0, 0, HEIGHT);
            p2.add_color_stop_rgba (0, 0, 0, 0, 0);
            p2.add_color_stop_rgba (1, 0, 0, 0, 1);
            context.arc (x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees);
            context.arc (x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees);
            context.arc (x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees);
            context.arc (x + radius, y + radius, radius, 180 * degrees, 270 * degrees);
            context.set_source (p2);
            context.fill_preserve ();
        }

        private void gesture_press_release (int n_press, double offset_x, double offset_y) {
            double _xpos, _ypos;
            gesture.get_point (null, out _xpos, out _ypos);

            xpos = _xpos;
            ypos = _ypos;

            double new_s, new_v;
            xy_to_sv (xpos, ypos, out new_s, out new_v);
            instance.on_sv_move (new_s, new_v);
            instance.queue_draw ();
        }

        private void gesture_drag_begin (double start_x, double start_y) {
            xpos = start_x;
            ypos = start_y;

            drag.set_state (Gtk.EventSequenceState.CLAIMED);

            double new_s, new_v;
            xy_to_sv (xpos, ypos, out new_s, out new_v);
            instance.on_sv_move (new_s, new_v);
            instance.queue_draw ();
        }

        private void gesture_drag_update (double offset_x, double offset_y) {
            double _xpos, _ypos;
            drag.get_start_point (out _xpos, out _ypos);

            xpos = _xpos + offset_x;
            ypos = _ypos + offset_y;

            double new_s, new_v;
            xy_to_sv (xpos, ypos, out new_s, out new_v);
            instance.on_sv_move (new_s, new_v);
            instance.queue_draw ();
        }

        private static void gesture_drag_end (double offset_x, double offset_y) {
            drag.set_state (Gtk.EventSequenceState.DENIED);
        }
    }
}
