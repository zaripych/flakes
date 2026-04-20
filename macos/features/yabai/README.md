# NAME

yabai - window manager

NOTE: This README.md is generated from manual pages. The yabai
installation and configuration is managed by `macos/features/yabai/module.nix`.

# SYNOPSIS

**yabai**
\[**\--load-sa**\|**\--uninstall-sa**\|**\--install-service**\|**\--uninstall-service**\|**\--start-service**\|**\--restart-service**\|**\--stop-service**\|**\--message**,**-m**
_msg_\|**\--config**,**-c**
_config_file_\|**\--verbose**,**-V**\|**\--version**,**-v**\|**\--help**,**-h**\]

# DESCRIPTION

**yabai** is a tiling window manager for macOS based on binary space
partitioning.

# OPTIONS

**\--load-sa**

> Load the scripting-addition into Dock.app.\
> Installs and updates the scripting-addition when necessary.\
> Path is /Library/ScriptingAdditions/yabai.osax.\
> System Integrity Protection must be partially disabled.

**\--uninstall-sa**

> Uninstall the scripting-addition. Must be run as root.\
> Path is /Library/ScriptingAdditions/yabai.osax.\
> System Integrity Protection must be partially disabled.

**\--install-service**

> Writes a launchd service file to disk.\
> Path is \~/Library/LaunchAgents/com.koekeishiya.yabai.plist.

**\--uninstall-service**

> Removes a launchd service file from disk.\
> Path is \~/Library/LaunchAgents/com.koekeishiya.yabai.plist.

**\--start-service**

> Enables, loads, and starts the launchd service.\
> Will install service file if it does not exist.

**\--restart-service**

> Attempts to restart the service instance.

**\--stop-service**

> Stops a running instance of the service and unloads it.

**\--message**, **-m** _\<msg\>_

> Send message to a running instance of yabai.

**\--config**, **-c** _\<config_file\>_

> Use the specified configuration file.\
> Executes using `/usr/bin/env sh -c <config_file>` if the exec-bit is
> set.\
> Interpreted using `/usr/bin/env sh <config_file>` if the exec-bit is
> unset.

**\--verbose**, **-V**

> Output debug information to stdout.

**\--version**, **-v**

> Print version to stdout and exit.

**\--help**, **-h**

> Print options to stdout and exit.

# DEFINITIONS

> REGEX :=
> POSIX extended regular expression syntax <https://www.gnu.org/software/findutils/manual/html_node/find_html/posix_002dextended-regular-expression-syntax.html>
>
>     LABEL       := arbitrary string/text used as an identifier
>
>     LAYER       := below | normal | above | auto
>
>     BOOL_SEL    := on | off
>
>     FLOAT_SEL   := 0 < <value> <= 1.0
>
>     RULE_SEL    := <index> | LABEL
>
>     SIGNAL_SEL  := <index> | LABEL
>
>     DIR_SEL     := north | east | south | west
>
>     STACK_SEL   := stack.prev | stack.next | stack.first | stack.last | stack.recent | stack.<index (1-based)>
>
>     WINDOW_SEL  := prev | next | first | last | recent | mouse | largest | smallest | sibling | first_nephew | second_nephew | uncle | first_cousin | second_cousin | STACK_SEL | DIR_SEL | <window id>
>
>     DISPLAY_SEL := prev | next | first | last | recent | mouse | DIR_SEL | <arrangement index (1-based)> | LABEL
>
>     SPACE_SEL   := prev | next | first | last | recent | mouse | <mission-control index (1-based)> | LABEL
>
>     EASING      := ease_in_sine  | ease_out_sine  | ease_in_out_sine  |
>                    ease_in_quad  | ease_out_quad  | ease_in_out_quad  |
>                    ease_in_cubic | ease_out_cubic | ease_in_out_cubic |
>                    ease_in_quart | ease_out_quart | ease_in_out_quart |
>                    ease_in_quint | ease_out_quint | ease_in_out_quint |
>                    ease_in_expo  | ease_out_expo  | ease_in_out_expo  |
>                    ease_in_circ  | ease_out_circ  | ease_in_out_circ

# DOMAINS

## Config

## General Syntax

yabai -m config \<global setting\>

> Get or set the value of \<global setting\>.

yabai -m config \[\--space _\<SPACE_SEL\>_\] \<space setting\>

> Get or set the value of \<space setting\>.

## Global Settings

**debug_output** \[_\<BOOL_SEL\>_\]

> Enable output of debug information to stdout.

**external_bar**
\[_\<main\|all\|off\>:\<top_padding\>:\<bottom_padding\>_\]

> Specify top and bottom padding for a potential custom bar that you may
> be running.\
> _main_: Apply the given padding only to spaces located on the main
> display.\
> _all_: Apply the given padding to all spaces regardless of their
> display.\
> _off_: Do not apply any special padding.

**menubar_opacity** \[_\<FLOAT_SEL\>_\]

> Changes the transparency of the macOS menubar.\
> If the value is 0.0, the menubar will no longer respond to
> mouse-events, effectively hiding the menubar permanently.\
> The menubar will automatically become fully opaque upon entering a
> native-fullscreen space, and adjusted down afterwards.

**mouse_follows_focus** \[_\<BOOL_SEL\>_\]

> When focusing a window, put the mouse at its center.

**focus_follows_mouse** \[_autofocus\|autoraise\|off_\]

> Automatically focus the window under the mouse.

**display_arrangement_order** \[_default\|vertical\|horizontal_\]

> Specify how displays are ordered (determined by center point).\
> _default_: Native macOS ordering.\
> _vertical_: Order by y-coordinate (followed by x-coordinate when
> equal).\
> _horizontal_: Order by x-coordinate (followed by y-coordinate when
> equal).

**window_origin_display** \[_default\|focused\|cursor_\]

> Specify which display a newly created window should be managed in.\
> _default_: The display in which the window is created (standard macOS
> behaviour).\
> _focused_: The display that has focus when the window is created.\
> _cursor_: The display that currently holds the mouse cursor.

**window_placement** \[_first_child\|second_child_\]

> Specify whether managed windows should become the first or second
> leaf-node.

**window_insertion_point** \[_focused\|first\|last_\]

> Specify where new managed windows will be inserted.

**window_zoom_persist** \[_\<BOOL_SEL\>_\]

> Windows will keep their zoom-state through layout changes.

**window_shadow** \[_\<BOOL_SEL\>\|float_\]

> Draw shadow for windows.\
> System Integrity Protection must be partially disabled.

**window_opacity** \[_\<BOOL_SEL\>_\]

> Enable opacity for windows.\
> System Integrity Protection must be partially disabled.

**window_opacity_duration** \[_\<FLOAT_SEL\>_\]

> Duration of transition between active / normal opacity.\
> System Integrity Protection must be partially disabled.

**active_window_opacity** \[_\<FLOAT_SEL\>_\]

> Opacity of the focused window.\
> System Integrity Protection must be partially disabled.

**normal_window_opacity** \[_\<FLOAT_SEL\>_\]

> Opacity of an unfocused window.\
> System Integrity Protection must be partially disabled.

**window_animation_duration** \[_\<FLOAT_SEL\>_\]

> Duration of window frame animation.\
> If 0.0, the change in dimension is not animated.\
> Requires Screen Recording permissions.\
> System Integrity Protection must be partially disabled.

**window_animation_easing** \[_\<EASING\>_\]

> Easing function to use for window animations.\
> See \<https://easings.net\> for details.

**insert_feedback_color** \[_0xAARRGGBB_\]

> Color of the **window \--insert** message and mouse_drag selection.\
> The purpose is to provide a visual preview of the new window frame.

**split_ratio** \[_\<FLOAT_SEL\>_\]

> Specify the size distribution when a window is split.

**mouse_modifier** \[_cmd\|alt\|shift\|ctrl\|fn_\]

> Keyboard modifier used for moving and resizing windows.

**mouse_action1** \[_move\|resize_\]

> Action performed when pressing _mouse_modifier_ + _button1_.

**mouse_action2** \[_move\|resize_\]

> Action performed when pressing _mouse_modifier_ + _button2_.

**mouse_drop_action** \[_swap\|stack_\]

> Action performed when a bsp-managed window is dropped in the center of
> some other bsp-managed window.

## Space Settings

**layout** \[_bsp\|stack\|float_\]

> Set the layout of the selected space.

**split_type** \[_vertical\|horizontal\|auto_\]

> Specify how a window should be split.\
> _vertical_: The window is split along the y-axis.\
> _horizontal_: The window is split along the x-axis.\
> _auto_: The axis is determined based on width/height ratio.

**top_padding** \[_\<integer number\>_\]

> Padding added at the upper side of the selected space.

**bottom_padding** \[_\<integer number\>_\]

> Padding added at the lower side of the selected space.

**left_padding** \[_\<integer number\>_\]

> Padding added at the left side of the selected space.

**right_padding** \[_\<integer number\>_\]

> Padding added at the right side of the selected space.

**window_gap** \[_\<integer number\>_\]

> Size of the gap that separates windows for the selected space.

**auto_balance** \[_\<BOOL_SEL\>\|x-axis\|y-axis_\]

> Balance the window tree upon change, so that all windows occupy an
> equally sized area.

## Display

## General Syntax

yabai -m display \[_\<DISPLAY_SEL_\>\] _\<COMMAND\>_

## COMMAND

**\--focus** _\<DISPLAY_SEL\>_

> Focus the given display.

**\--space** _\<SPACE_SEL\>_

> The given space will become visible on the selected display, without
> changing focus.\
> The given space must belong to the selected display.\
> System Integrity Protection must be partially disabled.

**\--label** \[_\<LABEL\>_\]

> Label the selected display, allowing that label to be used as an alias
> in commands that take a `DISPLAY_SEL` parameter.\
> If the command is called without an argument it will try to remove a
> previously assigned label.

## Space

## General Syntax

yabai -m space \[_\<SPACE_SEL\>_\] _\<COMMAND\>_

## COMMAND

**\--focus** _\<SPACE_SEL\>_

> Focus the given space.\
> System Integrity Protection must be partially disabled.

**\--switch** _\<SPACE_SEL\>_

> The selected space will always be the currently focused space.\
> The given space substitutes the selected space, gaining focus.\
> If the selected space and the given space belong to different
> displays, this behaves like _\--swap_.\
> If the selected space and the given space belong to the same display,
> this behaves like _\--focus_.\
> System Integrity Protection must be partially disabled.

**\--create** \[_\<DISPLAY_SEL\>_\]

> Create a new space on the given display.\
> If none specified, use the display of the active space instead.\
> System Integrity Protection must be partially disabled.

**\--destroy** \[_\<SPACE_SEL\>_\]

> Remove the given space.\
> If none specified, use the selected space instead.\
> System Integrity Protection must be partially disabled.

**\--move** _\<SPACE_SEL\>_

> Move position of the selected space to the position of the given
> space.\
> The selected space and given space must both belong to the same
> display.\
> System Integrity Protection must be partially disabled.

**\--swap** _\<SPACE_SEL\>_

> Swap the selected space with the given space.\
> If the selected space and given space belong to different displays,
> all the windows will swap.\
> If the selected space and given space belong to the same display, the
> actual spaces will swap.\
> System Integrity Protection must be partially disabled.

**\--display** _\<DISPLAY_SEL\>_

> Send the selected space to the given display.\
> System Integrity Protection must be partially disabled.

**\--equalize** \[_x-axis\|y-axis_\]

> Reset the split ratios on the selected space to the default value
> along the given axis.\
> If no axis is specified, use both.

**\--balance** \[_x-axis\|y-axis_\]

> Adjust the split ratios on the selected space so that all windows
> along the given axis occupy the same area.\
> If no axis is specified, use both.

**\--mirror** _x-axis\|y-axis_

> Flip the tree of the selected space along the given axis.

**\--rotate** _90\|180\|270_

> Rotate the tree of the selected space.

**\--padding** _abs\|rel:\<top\>:\<bottom\>:\<left\>:\<right\>_

> Padding added at the sides of the selected space.

**\--gap** _abs\|rel:\<gap\>_

> Size of the gap that separates windows on the selected space.

**\--toggle** _padding\|gap\|mission-control\|show-desktop_

> Toggle space setting on or off for the selected space.

**\--layout** _bsp\|stack\|float_

> Set the layout of the selected space.

**\--label** \[_\<LABEL\>_\]

> Label the selected space, allowing that label to be used as an alias
> in commands that take a `SPACE_SEL` parameter.\
> If the command is called without an argument it will try to remove a
> previously assigned label.

## Window

## General Syntax

yabai -m window \[_\<WINDOW_SEL\>_\] _\<COMMAND\>_

## COMMAND

**\--focus** \[_\<WINDOW_SEL\>_\]

> Focus the given window.\
> If none specified, focus the selected window instead.

**\--close** \[_\<WINDOW_SEL\>_\]

> Close the given window.\
> If none specified, close the selected window instead.\
> Only works on windows that provide a close button in its titlebar.

**\--minimize** \[_\<WINDOW_SEL\>_\]

> Minimize the given window.\
> If none specified, minimize the selected window instead.\
> Only works on windows that provide a minimize button in its titlebar.

**\--deminimize** _\<WINDOW_SEL\>_

> Restore the given window if it is minimized.\
> The window will only get focus if the owning application has focus.\
> Note that you can also _\--focus_ a minimized window to restore it as
> the focused window.

**\--display** _\<DISPLAY_SEL\>_

> Send the selected window to the given display.

**\--space** _\<SPACE_SEL\>_

> Send the selected window to the given space. System Integrity
> Protection must be partially disabled on macOS Monterey 12.7+, Ventura
> 13.6+, Sonoma 14.5+, and macOS Sequoia.

**\--swap** _\<WINDOW_SEL\>_

> Swap position of the selected window and the given window.

**\--warp** _\<WINDOW_SEL\>_

> Re-insert the selected window, splitting the given window.

**\--stack** _\<WINDOW_SEL\>_

> Stack the given window on top of the selected window.\
> Any kind of warp operation performed on a stacked window will unstack
> it.

**\--insert** _\<DIR_SEL\>\|stack_

> Set the splitting mode of the selected window.\
> If the current splitting mode matches the selected mode, the action
> will be undone.

**\--grid**
_\<rows\>:\<cols\>:\<start-x\>:\<start-y\>:\<width\>:\<height\>_

> Set the frame of the selected window based on a self-defined grid.

**\--move** _abs\|rel:\<dx\>:\<dy\>_

> If type is _rel_ the selected window is moved by _dx_ pixels
> horizontally and _dy_ pixels vertically.\
> If type is _abs_ _dx_ and _dy_ will become the new position.

**\--resize**
_top\|left\|bottom\|right\|top_left\|top_right\|bottom_right\|bottom_left\|abs:\<dx\>:\<dy\>_

> Resize the selected window by moving the given handle _dx_ pixels
> horizontally and _dy_ pixels vertically.\
> If handle is _abs_ the new size will be _dx_ width and _dy_ height and
> cannot be used on managed windows.

**\--ratio** _rel\|abs:\<dr\>_

> If type is _rel_ the split ratio of the selected window is changed by
> _dr_, otherwise _dr_ will become the new split ratio.\
> A positive/negative delta will increase/decrease the size of the
> left-child.

**\--toggle**
_float\|sticky\|pip\|shadow\|split\|zoom-parent\|zoom-fullscreen\|windowed-fullscreen\|native-fullscreen\|expose\|\<LABEL\>_

> Toggle the given property of the selected window.\
> The following properties require System Integrity Protection to be
> partially disabled: sticky, pip, shadow, LABEL (scratchpad identifier)
> .

**\--sub-layer** _\<LAYER\>_

> Set the stacking sub-layer of the selected window.\
> The window will no longer be eligible for automatic change in
> sub-layer when managed/unmanaged.\
> Specify the value _auto_ to reset back to normal and make it become
> automatically managed.\
> System Integrity Protection must be partially disabled.

**\--opacity** _\<FLOAT_SEL\>_

> Set the opacity of the selected window.\
> The window will no longer be eligible for automatic change in opacity
> upon focus change.\
> Specify the value _0.0_ to reset back to full opacity and make it
> become automatically managed.\
> System Integrity Protection must be partially disabled.

**\--raise** \[_\<WINDOW_SEL\>_\]

> Orders the selected window above the given window, or to the front
> within its layer.\
> System Integrity Protection must be partially disabled.

**\--lower** \[_\<WINDOW_SEL\>_\]

> Orders the selected window below the given window, or to the back
> within its layer.\
> System Integrity Protection must be partially disabled.

**\--scratchpad** \[_\<LABEL\>\|recover_\]

> Unique identifier used to identify a window scratchpad.\
> An identifier may only be assigned to a single window at any given
> time.\
> A scratchpad window will automatically be treated as a (manage=off)
> floating window.\
> If the scratchpad is already taken by another window, this assignment
> will fail.\
> If the scratchpad is re-assigned, the previous identifier will become
> available.\
> If no value is given, the window will seize to be a scratchpad
> window.\
> The special value _recover_ can be used to forcefully bring all
> scratchpad windows to the front.\
> This can be useful if windows become inaccessible due to a restart or
> crash.\
> System Integrity Protection must be partially disabled.

## Query

## General Syntax

yabai -m query _\<COMMAND\>_ \[_\<PROPERTIES\>_\] \[_\<ARGUMENT\>_\]

## COMMAND

**\--displays**

> Retrieve information about displays.

**\--spaces**

> Retrieve information about spaces.

**\--windows**

> Retrieve information about windows.

## ARGUMENT

**\--display** \[_\<DISPLAY_SEL\>_\]

> Constrain matches to the selected display.

**\--space** \[_\<SPACE_SEL\>_\]

> Constrain matches to the selected space.

**\--window** \[_\<WINDOW_SEL\>_\]

> Constrain matches to the selected window.

## PROPERTIES

A comma-separated string containing the name of fields to include in the
output.\
The name of the provided fields must be present in the dataformat of the
corresponding entity.

## DATAFORMAT

DISPLAY

> {
> "id": number,
> "uuid": string,
> "index": number,
> "label": string,
> "frame": object {
> "x": number,
> "y": number,
> "w": number,
> "h": number
> },
> "spaces": array of number,
> "has-focus": bool
> }

SPACE

> {
> "id": number,
> "uuid": string,
> "index": number,
> "label": string,
> "type": string,
> "display": number,
> "windows": array of number,
> "first-window": number,
> "last-window": number,
> "has-focus": bool,
> "is-visible": bool,
> "is-native-fullscreen": bool
> }

WINDOW

> {
> "id": number,
> "pid": number,
> "app": string,
> "title": string,
> "scratchpad": string,
> "frame": object {
> "x": number,
> "y": number,
> "w": number,
> "h": number,
> },
> "role": string,
> "subrole": string,
> "root-window": bool,
> "display": number,
> "space": number,
> "level": number,
> "sub-level": number,
> "layer": string,
> "sub-layer": string,
> "opacity": number,
> "split-type": string,
> "split-child": string,
> "stack-index": number,
> "can-move": bool,
> "can-resize": bool,
> "has-focus": bool,
> "has-shadow": bool,
> "has-parent-zoom": bool,
> "has-fullscreen-zoom": bool,
> "has-ax-reference": bool,
> "is-native-fullscreen": bool,
> "is-visible": bool,
> "is-minimized": bool,
> "is-hidden": bool,
> "is-floating": bool,
> "is-sticky": bool,
> "is-grabbed": bool
> }

Some window properties are only accessible when yabai has a valid
AX-reference for that window.\
This AX-reference can only be retrieved when the space that the window
is visible on, is active.\
If windows are already opened on inactive spaces when yabai is launched,
yabai will attempt to detect\
these using a workaround, and for most applications and windows this
will work. Some windows are not\
detected using this method, and for those windows yabai will retrieve a
limited amount of information,\
until the window that space belongs to becomes active --- yabai window
commands will NOT WORK for these windows.\
These windows can be identified by looking at the `has-ax-reference`
property. Once the space that the window\
belongs to becomes active, yabai will automatically create an
AX-reference. The queries will from that point\
forwards contain complete information, and the window can be used with
yabai window commands.

The properties that contain incorrect information for windows with
`has-ax-reference: false` are as follows:

> {
> "role": string,
> "subrole": string,
> "can-move": bool,
> "can-resize": bool
> }

## Rule

All rules that match the given filter will be applied in the order they
were registered.\
If multiple rules specify a value for the same property, the latter rule
will end up overriding that value.\
If the display and space properties are both set, the space property
will take precedence.\
The following properties require System Integrity Protection to be
partially disabled: sticky, sub-layer, opacity, scratchpad.

## General Syntax

yabai -m rule _\<COMMAND\>_

## COMMAND

**\--add \[\--one-shot\] \[\***\<ARGUMENT\>**\*\]**

> Add a new rule. Rules apply to windows that spawn after said rule has
> been added.\
> If _\--one-shot is present it will apply once and automatically remove
> itself._

**\--apply \[\***\<RULE*SEL\>* **\|** \_\<ARGUMENT\>**\*\]**

> Apply a rule to currently known windows.\
> If no argument is given, all existing rules will apply.\
> If an index or label is given, that particular rule will apply.\
> Arguments can also be provided directly, just like in the **\--add** > _command._\
> Existing `--one-shot` _rules that have yet to apply will be ignored by
> this command._

**\--remove** _\<RULE_SEL\>_

> Remove an existing rule with the given index or label.

**\--list**

> Output list of registered rules.

## ARGUMENT

**label=\***\<LABEL\>\*

> Label used to identify the rule with a unique name

**app\[!\]=\***\<REGEX\>\*

> Name of application. If _! is present, invert the match._

**title\[!\]=\***\<REGEX\>\*

> Title of window. If _! is present, invert the match._

**role\[!\]=\***\<REGEX\>\*

> _Accessibility role of window_ > \<https://developer.apple.com/documentation/applicationservices/carbon_accessibility/roles?language=objc\>.
> If _! is present, invert the match._

**subrole\[!\]=\***\<REGEX\>\*

> _Accessibility subrole of window_ > \<https://developer.apple.com/documentation/applicationservices/carbon_accessibility/subroles?language=objc\>.
> If _! is present, invert the match._

**display=\***\[\^\]\<DISPLAY_SEL\>\*

> Send window to display. If _\^ is present, follow focus._

**space=\***\[\^\]\<SPACE_SEL\>\*

> Send window to space. If _\^ is present, follow focus._

**manage=\***\<BOOL_SEL\>\*

> Window should be managed (tile vs float).\
> Most windows will be managed automatically, so this should mainly be
> used to make a window float.

**sticky=\***\<BOOL_SEL\>\*

> Window appears on all spaces.\
> System Integrity Protection must be partially disabled.

**mouse_follows_focus=\***\<BOOL_SEL\>\*

> When focusing the window, put the mouse at its center. Overrides the
> global **mouse_follows_focus** _setting._

**sub-layer=\***\<LAYER\>\*

> Window is ordered within the given stacking sub-layer.\
> The window will no longer be eligible for automatic change in
> sub-layer when managed/unmanaged.\
> Specify the value _auto to reset back to normal and make it become
> automatically managed._\
> System Integrity Protection must be partially disabled.

**opacity=\***\<FLOAT_SEL\>\*

> Set window opacity.\
> The window will no longer be eligible for automatic change in opacity
> upon focus change.\
> Specify the value _0.0 to reset back to full opacity and make it
> become automatically managed._\
> System Integrity Protection must be partially disabled.

**native-fullscreen=\***\<BOOL_SEL\>\*

> Window should enter native macOS fullscreen mode.

**grid=\***\<rows\>:\<cols\>:\<start-x\>:\<start-y\>:\<width\>:\<height\>\*

> Set window frame based on a self-defined grid.

**scratchpad=\***\<LABEL\>\*

> Unique identifier used to identify a window scratchpad.\
> An identifier may only be assigned to a single window at any given
> time.\
> A scratchpad window will automatically be treated as a (manage=off)
> floating window.\
> If this rule matches multiple windows, only the first window that
> matched will be assigned this scratchpad identifier.\
> System Integrity Protection must be partially disabled.

## DATAFORMAT

> {
> "index": number,
> "label": string,
> "app": string,
> "title": string,
> "role": string,
> "subrole": string,
> "display": number,
> "space": number,
> "follow_space": bool,
> "opacity": number,
> "manage": bool (optional),
> "sticky": bool (optional),
> "mouse_follows_focus": bool (optional),
> "sub-layer": string,
> "native-fullscreen": bool (optional),
> "grid": string,
> "scratchpad": string,
> "one-shot": bool,
> "flags": string
> }

## Signal

A signal is a simple way for the user to react to some event that has
been processed.\
Arguments are passed through environment variables.

## General Syntax

yabai -m signal _\<COMMAND\>_

## COMMAND

**\--add event=\***\<EVENT\>\* **action=\***\<ACTION\>\*
**\[label=\***\<LABEL\>**_\] \[app\[!\]=_**\<REGEX\>**_\]
\[title\[!\]=_**\<REGEX\>**_\] \[active=_**yes\|no**\*\]**

> Add an optionally labelled signal to execute an action after
> processing an event of the given type.\
> Some signals can be specified to trigger based on the application name
> and/or window title, and its active/focused state.

**\--remove** _\<SIGNAL_SEL\>_

> Remove an existing signal with the given index or label.

**\--list**

> Output list of registered signals.

## EVENT

**application_launched**

> Triggered when a new application is launched.\
> Eligible for **app** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**application_terminated**

> Triggered when an application is terminated.\
> Eligible for **app** _and_ **active** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**application_front_switched**

> Triggered when the front-most application changes.\
> Passes two arguments: \$YABAI_PROCESS_ID, \$YABAI_RECENT_PROCESS_ID

**application_activated**

> Triggered when an application is activated.\
> Eligible for **app** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**application_deactivated**

> Triggered when an application is deactivated.\
> Eligible for **app** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**application_visible**

> Triggered when an application is unhidden.\
> Eligible for **app** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**application_hidden**

> Triggered when an application is hidden.\
> Eligible for **app** _and_ **active** _filter._\
> Passes one argument: \$YABAI_PROCESS_ID

**window_created**

> Triggered when a window is created.\
> Also applies to windows that are implicitly created at application
> launch.\
> Eligible for **app** _and_ **title** _filter._\
> Passes one argument: \$YABAI_WINDOW_ID

**window_destroyed**

> Triggered when a window is destroyed.\
> Also applies to windows that are implicitly destroyed at application
> exit.\
> Eligible for **app** _and_ **active** _filter._\
> Passes one argument: \$YABAI_WINDOW_ID

**window_focused**

> Triggered when a window becomes the key-window.\
> Eligible for **app** _and_ **title** _filter._\
> Passes one argument: \$YABAI_WINDOW_ID

**window_moved**

> Triggered when a window changes position.\
> Eligible for **app\***,* **title** *and* **active** *filter.\*\
> Passes one argument: \$YABAI_WINDOW_ID

**window_resized**

> Triggered when a window changes dimensions.\
> Eligible for **app\***,* **title** *and* **active** *filter.\*\
> Passes one argument: \$YABAI_WINDOW_ID

**window_minimized**

> Triggered when a window has been minimized.\
> Eligible for **app\***,* **title** *and* **active** *filter.\*\
> Passes one argument: \$YABAI_WINDOW_ID

**window_deminimized**

> Triggered when a window has been deminimized.\
> Eligible for **app** _and_ **title** _filter._\
> Passes one argument: \$YABAI_WINDOW_ID

**window_title_changed**

> Triggered when a window changes its title.\
> Eligible for **app\***,* **title** *and* **active** *filter.\*\
> Passes one argument: \$YABAI_WINDOW_ID

**space_created**

> Triggered when a space is created.\
> Passes two arguments: \$YABAI_SPACE_ID, \$YABAI_SPACE_INDEX

**space_destroyed**

> Triggered when a space is destroyed.\
> Passes one argument: \$YABAI_SPACE_ID

**space_changed**

> Triggered when the active space has changed.\
> Passes four arguments: \$YABAI_SPACE_ID, \$YABAI_SPACE_INDEX,
> \$YABAI_RECENT_SPACE_ID, \$YABAI_RECENT_SPACE_INDEX

**display_added**

> Triggered when a new display has been added.\
> Passes two arguments: \$YABAI_DISPLAY_ID, \$YABAI_DISPLAY_INDEX

**display_removed**

> Triggered when a display has been removed.\
> Passes one argument: \$YABAI_DISPLAY_ID

**display_moved**

> Triggered when a change has been made to display arrangement.\
> Passes two arguments: \$YABAI_DISPLAY_ID, \$YABAI_DISPLAY_INDEX

**display_resized**

> Triggered when a display has changed resolution.\
> Passes two arguments: \$YABAI_DISPLAY_ID, \$YABAI_DISPLAY_INDEX

**display_changed**

> Triggered when the active display has changed.\
> Passes four arguments: \$YABAI_DISPLAY_ID, \$YABAI_DISPLAY_INDEX,
> \$YABAI_RECENT_DISPLAY_ID, \$YABAI_RECENT_DISPLAY_INDEX

**mission_control_enter**

> Triggered when mission-control activates.\
> Passes one argument: \$YABAI_MISSION_CONTROL_MODE

**mission_control_exit**

> Triggered when mission-control deactivates.\
> Passes one argument: \$YABAI_MISSION_CONTROL_MODE

**dock_did_change_pref**

> Triggered when the macOS Dock preferences changes.

**dock_did_restart**

> Triggered when Dock.app restarts.

**menu_bar_hidden_changed**

> Triggered when the macOS menubar _autohide setting changes._

**system_woke**

> Triggered when macOS wakes from sleep.

## ACTION

Arbitrary command executed through **/usr/bin/env sh -c**

## DATAFORMAT

> {
> "index": number,
> "label": string,
> "app": string,
> "title": string,
> "active": bool (optional),
> "event": string,
> "action": string
> }

# EXIT CODES

If **yabai** _can't handle a message, it will return a non-zero exit
code._

# AUTHOR

Åsmund Vikane \<aasvi93 at gmail.com\>
