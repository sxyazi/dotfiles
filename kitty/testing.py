from kittens.tui.handler import result_handler
from kitty.launch import launch, parse_launch_args
import os
import time
import signal
import shlex


def process_exists(pid):
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    else:
        return True


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = None
    for w in boss.active_tab.windows:
        if w.title == "TEST_RUNNER":
            window = w
            break

    if window:
        if window.has_running_program:
            pid = window.child.pid_for_cwd

            os.kill(pid, signal.SIGTERM)
            time.sleep(0.2)

            i = 0
            while i < 5 and process_exists(pid):
                i += 1
                os.kill(pid, signal.SIGKILL)
                time.sleep(0.1)
            if process_exists(pid):
                raise Exception("Failed to terminate the process")

        window.send_text("normal", "\x03cd " + shlex.quote(args[1]) + "\n\x03")
        time.sleep(0.1)
        window.clear_screen(reset=True, scrollback=True)
    else:
        window = launch(
            boss,
            *parse_launch_args(
                [
                    "--cwd=" + args[1],
                    "--title=TEST_RUNNER",
                    "--location=hsplit",
                    "--dont-take-focus",
                ]
            )
        )

        boss.active_tab.resize_window_by(window.id, -999, False)
        boss.active_tab.resize_window_by(window.id, +8, False)

    window.send_text("normal", args[2] + "\n")
