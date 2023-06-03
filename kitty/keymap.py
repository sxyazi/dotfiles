from kittens.tui.handler import result_handler
from kitty.keys import keyboard_mode_name


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    if args[1] == "C-i":
        # Move cursor to the end of line, specific to zsh
        if cmd[-3:] == "zsh":
            window.write_to_child("\x1b[105;5u")

        # A workaround for tmux to fix its bug of Ctrl+i recognition, sending a Ctrl-; instead
        elif cmd[-4:] == "tmux":
            window.write_to_child("\x1b[59;5u")
            return

        # Other programs that support CSI u
        elif keyboard_mode_name(window.screen) == "kitty":
            window.write_to_child("\x1b[105;5u")

        # Otherwise send a ^I
        else:
            window.write_to_child("\x09")

    elif args[1] == "S-s":
        if cmd[-4:] == "nvim":
            window.write_to_child("\x1b[115;8u")
