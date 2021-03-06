/* Controls.vala
 *
 * Copyright (C) 2009 - 2016 Jerry Casiano
 *
 * This file is part of Font Manager.
 *
 * Font Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Font Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Font Manager.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author:
 *        Jerry Casiano <JerryCasiano@gmail.com>
*/

public class LabeledSwitch : Gtk.Box {

    public Gtk.Label label { get; private set; }
    public Gtk.Label dim_label { get; private set; }
    public Gtk.Switch toggle { get; private set; }

    construct {
        label = new Gtk.Label(null);
        label.hexpand = false;
        label.halign = Gtk.Align.START;
        dim_label = new Gtk.Label(null);
        dim_label.hexpand = true;
        dim_label.halign = Gtk.Align.CENTER;
        dim_label.get_style_context().add_class(Gtk.STYLE_CLASS_DIM_LABEL);
        toggle = new Gtk.Switch();
        toggle.expand = false;
        pack_start(label, false, false, 0);
        set_center_widget(dim_label);
        pack_end(toggle, false, false, 0);
    }

    public LabeledSwitch (string label = "") {
        Object(name: "LabeledSwitch", margin: 24);
        this.label.set_text(label);
    }

    public override void show () {
        label.show();
        dim_label.show();
        toggle.show();
        base.show();
        return;
    }
}

public class LabeledSpinButton : Gtk.Grid {

    public double @value { get; set; default = 0.0; }

    Gtk.Label label;
    Gtk.SpinButton spin;

    public LabeledSpinButton (string label = "", double min, double max, double step) {
        Object(name: "LabeledspinButton", margin: 24);
        this.label = new Gtk.Label(label);
        this.label.hexpand = true;
        this.label.halign = Gtk.Align.START;
        spin = new Gtk.SpinButton.with_range(min, max, step);
        attach(this.label, 0, 0, 1, 1);
        attach(spin, 1, 0, 1, 1);
        bind_property("value", spin, "value", BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE);
    }

    public override void show () {
        label.show();
        spin.show();
        base.show();
        return;
    }

}

public class OptionScale : Gtk.Grid {

    public Gtk.Label label { get; private set; }
    public Gtk.Scale scale { get; private set; }
    public string [] options { get; private set; }

    public OptionScale (string? heading = null, string [] options) {
        Object(name: "OptionScale", margin: 24);
        hexpand = true;
        this.options = options;
        scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, 0, options.length, 1);
        scale.hexpand = true;
        scale.draw_value = false;
        scale.round_digits = 1;
        scale.adjustment.lower = 0;
        scale.adjustment.page_increment = 1;
        scale.adjustment.step_increment = 1;
        scale.adjustment.upper = options.length - 1;
        scale.show_fill_level = false;
        for (int i = 0; i < options.length; i++)
            scale.add_mark(i, Gtk.PositionType.BOTTOM, options[i]);
        scale.value_changed.connect(() => {
            scale.set_value(Math.round(scale.adjustment.get_value()));
        });
        label = new Gtk.Label(null);
        label.hexpand = true;
        if (heading != null)
            label.set_text(heading);
        attach(label, 0, 0, options.length, 1);
        attach(scale, 0, 1, options.length, 1);
    }

    public override void show () {
        label.show();
        scale.show();
        base.show();
        return;
    }

}

public class FontScale : Gtk.EventBox {

    public Gtk.Adjustment adjustment {
        get {
            return scale.get_adjustment();
        }
        set {
            scale.set_adjustment(value);
            spin.set_adjustment(value);
        }
    }

    Gtk.Box container;
    Gtk.SpinButton spin;
    Gtk.Scale scale;
    ReactiveLabel min;
    ReactiveLabel max;

    construct {
        scale = new Gtk.Scale.with_range(Gtk.Orientation.HORIZONTAL, MIN_FONT_SIZE, MAX_FONT_SIZE, 0.5);
        scale.draw_value = false;
        scale.set_range(MIN_FONT_SIZE, MAX_FONT_SIZE);
        scale.set_increments(0.5, 1.0);
        spin = new Gtk.SpinButton.with_range(MIN_FONT_SIZE, MAX_FONT_SIZE, 0.5);
        spin.set_adjustment(adjustment);
        min = new ReactiveLabel(null);
        max = new ReactiveLabel(null);
        min.label.set_markup("<span font=\"Serif Italic Bold\" size=\"small\"> A </span>");
        max.label.set_markup("<span font=\"Serif Italic Bold\" size=\"large\"> A </span>");
        container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);
        container.pack_start(min, false, true, 2);
        container.pack_start(scale, true, true, 0);
        container.pack_start(max, false, true, 2);
        container.pack_end(spin, false, true, 8);
        container.border_width = 5;
        add(container);
        connect_signals();
    }

    public FontScale () {
        Object(name: "FontScale");
    }

    public override void show () {
        container.show();
        min.show();
        max.show();
        spin.show();
        scale.show();
        container.show();
        base.show();
        return;
    }

    void connect_signals () {
        min.clicked.connect(() => { scale.set_value(MIN_FONT_SIZE); });
        max.clicked.connect(() => { scale.set_value(MAX_FONT_SIZE); });
    }

    public void add_style_class (string gtk_style_class) {
        container.forall((w) => {
            if ((w is Gtk.SpinButton) || (w is Gtk.Scale))
                return;
            w.get_style_context().add_class(gtk_style_class);
        });
        get_style_context().add_class(gtk_style_class);
        return;
    }

}
