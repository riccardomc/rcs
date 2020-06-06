#!/usr/bin/env python3
from Xlib import X, display


class MyRandr(object):
    """
    MyRandr is an abstraction of XRandR that extract the information and
    performs the actions required to configure displays the way I want.
    """

    def __init__(self):
        self.get_resources()

    def get_resources(self):
        """
        Initialize the object by extracting resources from X Display :0.
        """
        self.display = display.Display()
        self.screen = self.display.screen()
        self.window = self.screen.root.create_window(
            0, 0, 1, 1, 1, self.screen.root_depth
        )

        self.resources = self.window.xrandr_get_screen_resources()

        self.crtcs = {
            crtc_id: self.display.xrandr_get_crtc_info(crtc_id, 0)
            for crtc_id in self.resources.crtcs
        }

        self.modes = self._build_modes_dict(
            self.resources.mode_names, self.resources.modes
        )
        self.outputs = {
            o: self.display.xrandr_get_output_info(o, 0) for o in self.resources.outputs
        }
        self.connected_outputs = {
            i: o for i, o in list(self.outputs.items()) if o._data["connection"] == 0
        }

    def next_free_crtc(self, output_id):
        """
        Returns the first free CRTC available for output_id.

        @return a CRTC ID
        """
        min_id = -1
        min_outputs = 2048
        for crtc_id, crtc in list(r.crtcs.items()):
            if len(crtc.outputs) < min_outputs and output_id in crtc.possible_outputs:
                min_id = crtc_id
                min_outputs = len(crtc.outputs)
        return min_id

    def _build_modes_dict(self, mode_names, modes):
        """
        Builds a dictionary of display modes indexed on modes id.

        @param mode_names a string of node_names as returned by X resources
        @param modes a list of modes object as returned by Xlib
        @return a dict of display mode data indexed on mode id
        """
        last_index = 0
        mode_datas = dict()
        for mode in modes:
            mode_data = dict(mode._data)
            mode_data["name"] = mode_names[
                last_index : last_index + mode_data["name_length"]
            ]
            mode_datas[mode_data["id"]] = mode_data
            last_index += mode_data["name_length"]
        return mode_datas

    def output_name_to_id(self, name):
        """
        Returns the Output id returned by XRandR corresponding to the name
        passed as parameter (i.e. HDMI1 -> 70). None if name is not found.

        @param name the name of an Output (i.e. HDMI1)
        @return the corresponding Output Id or None
        """
        for i, o in list(r.outputs.items()):
            if o.name == name:
                return i

    def set(self, output_id, width):
        """
        Set the output_id to its maximum resolution at width offset width.
        Returns the width of the configured Output.

        @param output_id the id of the Output to be set
        @param width offset for Output placement
        @returns the width of the configured Output
        """
        crtc_id = self.next_free_crtc(output_id)
        mode_id = self.outputs[output_id].modes[0]
        print(
            (
                "%5s +%4d %s crtc %d"
                % (
                    self.outputs[output_id].name,
                    width,
                    self.modes[mode_id]["name"],
                    crtc_id,
                )
            )
        )
        self.display.xrandr_set_crtc_config(
            crtc_id, 0, width, 0, mode_id, 1, [output_id], X.CurrentTime
        )
        return self.modes[mode_id]["width"], self.modes[mode_id]["height"]

    def set_screen_size(self, width, height, width_mm, height_mm):
        """
        Set framebuffer size.

        @param width
        @param height
        @param width_mm
        @param height_mm
        """
        # FIXME: setting framebuffer size doesn't work for some reason
        # self.window.xrandr_set_screen_size(width, height, 310+550, 310)
        # so I am going to use this dirty hack for the time being
        import subprocess

        subprocess.call(["xrandr", "--fb", "%dx%d" % (width, height)])

    def set_from_left_to_right(self, leftmost_output_name):
        """
        Set all Outputs next to eachother.

        @param the leftmost output name
        """
        leftmost_output_id = r.output_name_to_id(leftmost_output_name)
        width, height = self.set(leftmost_output_id, 0)
        screen_width, screen_height = width, height
        for output_id in list(self.connected_outputs.keys()):
            if output_id == leftmost_output_id:
                continue
            r.get_resources()
            width, height = r.set(output_id, screen_width)
            screen_width += width
            screen_height = max(screen_height, height)
        self.set_screen_size(screen_width, screen_height, 0, 0)


if __name__ == "__main__":
    r = MyRandr()
    r.set_from_left_to_right("eDP1")
