#!/usr/bin/env python

import math
import i3ipc

i3 = i3ipc.Connection()


def get_names(things):
    """
    Returns a filtered list of strings with just the 'name' attribute of the
    dictionaries tings passed as parameter

    @param things: a list of dictionaries with a 'name' attribute
    @returns: a list of strings, the 'name' attributes of the dictionaries
    """
    return [t["name"] for t in things]


def get_focused_workspace(workspaces):
    """
    Returns the workspace with 'focused' True. It can be None in
    some cases.

    @param workspaces: a list of workspace objects
    @returns the focused workspace name
    """
    focused_workspaces = [w for w in workspaces if w["focused"]]
    return focused_workspaces[0] if len(focused_workspaces) else None


def get_non_empty_workspaces():
    """
    Returns a list of workspace names without any node (i.e. a window or client).

    @returns a list of non-empty workspaces
    """
    tree = i3.get_tree()

    outputs = [o for o in tree.nodes if o.name != "__i3"]
    non_empty_workspaces = []
    for output in outputs:
        for con in [c for c in output.nodes if c.type == "con"]:
            for workspace in [w for w in con.nodes if w.type == "workspace"]:
                if len(workspace.nodes) > 0:
                    non_empty_workspaces.append(workspace.name)

    return non_empty_workspaces


def workspaces_sorted_by_number(workspaces):
    """
    Returns the list of workspaces sorted in numerical order.
    """
    return sorted(workspaces, key=lambda workspace: int(workspace["num"]))


def outputs_from_left_to_right(outputs):
    """
    Returns the list of outputs sorted from left to right based on geometry.
    """
    return sorted(outputs, key=lambda output: output["rect"]["x"])


def move_workspace(workspace, output):
    """
    Move a workspace to an output.

    @param workspace: the workspace to move
    @param output: the destination output
    """
    i3.command("workspace %s" % workspace)
    i3.command("move workspace to output %s" % output)


def _reflow(workspaces, outputs):
    """
    Distribute workspaces evenly across outputs.

    @param workspaces: is a list of workspace names i.e. ['1', '2', '3']
    @param outputs: is a list of output names i.e. ['VGA1', 'DP1']
    """
    i = 0
    j = 1
    workspaces_per_output = math.ceil(float(len(workspaces)) / len(outputs))
    while j < len(workspaces) + 1:
        workspace = workspaces[j - 1]
        output = outputs[i]
        print(("%s goes on %s" % (workspace, output)))
        move_workspace(workspace, output)
        if math.fmod(j, workspaces_per_output) == 0 and i < len(outputs) - 1:
            i += 1
        j += 1


def reflow_from_left_to_right():
    """
    Evenly distribute workspaces from left to right outputs.
    """

    # get all the things
    workspaces = i3.get_workspaces()
    outputs = [output for output in i3.get_outputs() if output["active"]]
    focused_workspace = get_focused_workspace(workspaces)
    non_empty_workspace_names = get_non_empty_workspaces()

    # sort and extract the the ids (names)
    workspace_names = get_names(workspaces_sorted_by_number(workspaces))
    output_names = get_names(outputs_from_left_to_right(outputs))
    focused_workspace_name = focused_workspace["name"] if focused_workspace else None
    sorted_non_empty_workspace_names = [
        w for w in workspace_names if w in non_empty_workspace_names
    ]

    print(("workspaces found: %s" % ", ".join(workspace_names)))
    print(("non empty workspaces: %s" % ", ".join(non_empty_workspace_names)))
    print(("outputs found: %s" % ", ".join(output_names)))
    print(("focused workspace: %s" % focused_workspace_name))

    # move all workspaces to first output before reflowing
    for w in workspace_names:
        move_workspace(w, output_names[0])

    # reflow workspaces
    _reflow(sorted_non_empty_workspace_names, output_names)

    # focus back the workspace that was focused before reflowing
    if focused_workspace_name in non_empty_workspace_names:
        i3.command("workspace %s" % focused_workspace_name)


if __name__ == "__main__":
    reflow_from_left_to_right()
