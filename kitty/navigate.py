from kittens.tui.handler import result_handler

def main(args):
    pass

@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    exec = window.child.foreground_cmdline[0]
    if args[1] != "user" or exec[-4:] != "nvim":
        boss.active_tab.neighboring_window(args[2])
    elif args[2] == "top":
        window.write_to_child("\x1b[119;8uju")
    elif args[2] == "bottom":
        window.write_to_child("\x1b[119;8uje")
    elif args[2] == "left":
        window.write_to_child("\x1b[119;8ujn")
    elif args[2] == "right":
        window.write_to_child("\x1b[119;8uji")

