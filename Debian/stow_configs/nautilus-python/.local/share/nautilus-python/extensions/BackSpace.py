# Nautilus Backspace Back Extension
#
# Place me in ~/.local/share/nautilus-python/extensions/,
# ensure you have python-nautilus package, restrart Nautilus, and enjoy :)
#
# This script was written by molaeiali and is released to the public domain

import os, gi
gi.require_version('Nautilus', '4.0')
from gi.repository import GObject, Nautilus, Gtk, Gio, GLib

def back():
                app = Gtk.Application.get_default()
                if not app.get_actions_for_accel("BackSpace"):
                        app.set_accels_for_action( "win.up", ["BackSpace"] )


class BackspaceBack(GObject.GObject, Nautilus.InfoProvider):
                def __init__(self):
                        pass

                def update_file_info(self, file):
                        back()
                        return None
