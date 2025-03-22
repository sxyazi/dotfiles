from kittens.tui.handler import result_handler

directions = {
    "top": "u",
    "bottom": "e",
    "left": "n",
    "right": "i",
}


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    act = args[1]  # e.g. -jump
    if act[0] == "-" and cmd[-4:] == "nvim":
        second = directions[args[2]] if len(args) > 2 else ""
        window.write_to_child(f"\x1b[119;8u{act[1]}{second}")
        return

    if (act == "-close" or act == "-quit") and cmd[-4:] == "yazi":
        window.write_to_child(f"\x1b[99;5u")
        return

    def split(direction):
        if direction == "top" or direction == "bottom":
            boss.launch("--cwd=current", "--location=hsplit")
        else:
            boss.launch("--cwd=current", "--location=vsplit")

        if direction == "top" or direction == "left":
            boss.active_tab.move_window(direction)

    def close():
        boss.close_window()

    def quit():
        boss.quit()

    def jump(direction):
        boss.active_tab.neighboring_window(direction)

    # https://github.com/chancez/dotfiles/blob/master/kitty/.config/kitty/relative_resize.py
    def resize(direction):
        neighbors = boss.active_tab.current_layout.neighbors_for_window(
            window, boss.active_tab.windows
        )
        top, bottom = neighbors.get("top"), neighbors.get("bottom")
        left, right = neighbors.get("left"), neighbors.get("right")

        if direction == "top":
            if top and bottom:
                boss.active_tab.resize_window("shorter", 10)
            elif top:
                boss.active_tab.resize_window("taller", 10)
            elif bottom:
                boss.active_tab.resize_window("shorter", 10)
        elif direction == "bottom":
            if top and bottom:
                boss.active_tab.resize_window("taller", 10)
            elif top:
                boss.active_tab.resize_window("shorter", 10)
            elif bottom:
                boss.active_tab.resize_window("taller", 10)
        elif direction == "left":
            if left and right:
                boss.active_tab.resize_window("narrower", 10)
            elif left:
                boss.active_tab.resize_window("wider", 10)
            elif right:
                boss.active_tab.resize_window("narrower", 10)
        elif direction == "right":
            if left and right:
                boss.active_tab.resize_window("wider", 10)
            elif left:
                boss.active_tab.resize_window("narrower", 10)
            elif right:
                boss.active_tab.resize_window("wider", 10)

    def move(direction):
        boss.active_tab.move_window(direction)

    act = act[1:]
    if act == "split":
        split(args[2])
    elif act == "close":
        close()
    elif act == "quit":
        quit()
    elif act == "jump":
        jump(args[2])
    elif act == "resize":
        resize(args[2])
    elif act == "move":
        move(args[2])
