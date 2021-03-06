/* ColorImage.vala
 *
 * Copyright 2022 Diego Iván <diegoivan.mae@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace Colorful {
    public class ColorImage : Adw.Bin {
        private Gtk.CssProvider css_provider;
        private const int HEIGHT = 100;
        private const int WIDTH = 100;
        private Gdk.RGBA _color;
        private Gtk.Stack stack;
        public Gdk.RGBA color {
            get {
                return _color;
            }
            set {
                _color = value;
                css_provider.load_from_data ((uint8[])
                    "* { background-color: %s; }".printf (value.to_string ())
                );
                update_light_settings ();
            }
        }
        
        public ColorImage () {
        }
        
        construct {
            width_request = WIDTH;
            height_request = HEIGHT;
            halign = CENTER;
            tooltip_text = "Copy Image with Color";
            
            css_provider = new Gtk.CssProvider ();
            get_style_context ().add_provider (
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_USER
            );
            
            stack = new Gtk.Stack () {
                transition_type = SLIDE_UP_DOWN
            };
            stack.add_named (new Adw.Bin (), "clear");
            
            stack.add_named (
                new Gtk.Image.from_icon_name ("edit-copy-symbolic"),
                "clipboard_icon"
            );
            
            stack.add_named (
                new Gtk.Image.from_icon_name ("emblem-ok-symbolic"),
                "copied_icon"
            );
            
            child = stack;
            
            var motion_controller = new Gtk.EventControllerMotion ();
            add_controller (motion_controller);
            
            motion_controller.enter.connect (() => {
                stack.set_visible_child_full ("clipboard_icon", SLIDE_UP);
            });
            
            motion_controller.leave.connect (() => {
                stack.set_visible_child_full ("clear", SLIDE_DOWN);
            });
            
            var click_controller = new Gtk.GestureClick ();
            click_controller.pressed.connect (() => {
                stack.set_visible_child_full ("copied_icon", CROSSFADE);
                copy ();
            });
            
            add_controller (click_controller);
        }
        
        private void update_light_settings () {
            double sr = color_operation (color.red) *  0.2126;
            double sg = color_operation (color.green) * 0.7152;
            double sb = color_operation (color.blue) * 0.0722;

            var final = sr + sg + sb;
            if (final < 0.5) {
                stack.add_css_class ("dark");
                stack.remove_css_class ("light");
            }
            else {
                stack.add_css_class ("light");
                stack.remove_css_class ("dark");
            }
        }

        private double color_operation (double c) {
            if (c <= 0.03928)
                return c / 12.92;
            else
                return Math.pow ((c + 0.055) / 1.055, 2.4);
        }

        private void copy () {
            var surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, WIDTH, HEIGHT);
            var context = new Cairo.Context (surface);
            
            context.set_source_rgb (
                color.red,
                color.green,
                color.blue
            );
            context.rectangle (0, 0, WIDTH, HEIGHT);
            context.fill ();
            
            var pixbuf = Gdk.pixbuf_get_from_surface (
                surface,
                0,
                0,
                WIDTH,
                HEIGHT
            );
            
            var texture = Gdk.Texture.for_pixbuf (pixbuf);
            get_clipboard ().set_texture (texture);
        }
    }
} 
