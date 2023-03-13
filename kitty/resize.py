# https://github.com/chancez/dotfiles/blob/master/kitty/.config/kitty/relative_resize.py
from kittens.tui.handler import result_handler

def main(args):
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    exec = window.child.foreground_cmdline[0]
    if args[1] == "user" and exec[-4:] == "nvim":
        mappings = {"top": "u", "bottom": "e", "left": "n", "right": "i"}
        return window.write_to_child("\x1b[119;8ur" + mappings[args[2]])

    neighbors = boss.active_tab.current_layout.neighbors_for_window(window, boss.active_tab.windows)
    top, bottom = neighbors.get('top'), neighbors.get('bottom')
    left, right = neighbors.get('left'), neighbors.get('right')

    if args[2] == 'top':
        if top and bottom:
            boss.active_tab.resize_window('shorter', 5)
        elif top:
            boss.active_tab.resize_window('taller', 5)
        elif bottom:
            boss.active_tab.resize_window('shorter', 5)
    elif args[2] == 'bottom':
        if top and bottom:
            boss.active_tab.resize_window('taller', 5)
        elif top:
            boss.active_tab.resize_window('shorter', 5)
        elif bottom:
            boss.active_tab.resize_window('taller', 5)
    elif args[2] == 'left':
        if left and right:
            boss.active_tab.resize_window('narrower', 5)
        elif left:
            boss.active_tab.resize_window('wider', 5)
        elif right:
            boss.active_tab.resize_window('narrower', 5)
    elif args[2] == 'right':
        if left and right:
            boss.active_tab.resize_window('wider', 5)
        elif left:
            boss.active_tab.resize_window('narrower', 5)
        elif right:
            boss.active_tab.resize_window('wider', 5)
