from kittens.tui.handler import result_handler
from kitty.keys import keyboard_mode_name


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    cmd = window.child.foreground_cmdline
    if args[1] == "C-i":
        # Move cursor to the end of line, specific to zsh
        if cmd[0][-3:] == "zsh":
            window.write_to_child("\x1b[105;5u")

        # A workaround only for tmux to fix its bug of Ctrl+i recognition, sending a Ctrl-; instead
        elif cmd[0][-4:] == "tmux":
            window.write_to_child("\x1b[59;5u")
            return

        # A CSI u workaround only for ranger, send a Alt-g instead of Ctrl-i
        elif len(cmd) > 1 and cmd[1][-6:] == "ranger":
            window.write_to_child("\x1bg")
            return

        # Other programs that support CSI u
        elif keyboard_mode_name(window.screen) == "kitty":
            window.write_to_child("\x1b[105;5u")

        # Otherwise send a ^I
        else:
            window.write_to_child("\x09")

    elif args[1] == "S-s":
        if cmd[0][-4:] == "nvim":
            window.write_to_child("\x1b[115;8u")
