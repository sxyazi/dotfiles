from kittens.tui.handler import result_handler

mappings = {
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

    exec = window.child.foreground_cmdline[0]
    act = args[1]  # e.g. -jump
    if act[0] == "-" and exec[-4:] == "nvim":
        secound = mappings[args[2]] if len(args) > 2 else ""
        window.write_to_child(f"\x1b[119;8u{act[1]}{secound}")
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
                boss.active_tab.resize_window("shorter", 5)
            elif top:
                boss.active_tab.resize_window("taller", 5)
            elif bottom:
                boss.active_tab.resize_window("shorter", 5)
        elif direction == "bottom":
            if top and bottom:
                boss.active_tab.resize_window("taller", 5)
            elif top:
                boss.active_tab.resize_window("shorter", 5)
            elif bottom:
                boss.active_tab.resize_window("taller", 5)
        elif direction == "left":
            if left and right:
                boss.active_tab.resize_window("narrower", 5)
            elif left:
                boss.active_tab.resize_window("wider", 5)
            elif right:
                boss.active_tab.resize_window("narrower", 5)
        elif direction == "right":
            if left and right:
                boss.active_tab.resize_window("wider", 5)
            elif left:
                boss.active_tab.resize_window("narrower", 5)
            elif right:
                boss.active_tab.resize_window("wider", 5)

    def move(direction):
        boss.active_tab.move_window(direction)

    act = act[1:]
    if act == "split":
        split(args[2])
    elif act == "close":
        close()
    elif act == "jump":
        jump(args[2])
    elif act == "resize":
        resize(args[2])
    elif act == "move":
        move(args[2])