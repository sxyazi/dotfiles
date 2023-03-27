from ranger.api.commands import Command


class chname(Command):
    """
    :chname <dirname>

    Rename files, decide whether to bulk automatically.
    """

    def execute(self):
        if self.fm.thisdir.marked_items:
            self.fm.execute_console("bulkrename")
            return

        action = self.rest(1)
        if action == "k":
            self.fm.execute_console("rename_append -r")
        elif action == "K":
            self.fm.open_console(
                "rename " + self.fm.thisfile.relative_path.replace("%", "%%"),
                position=7,
            )
        elif action == "a":
            self.fm.execute_console("rename_append")
        elif action == "A":
            self.fm.open_console(
                "rename " + self.fm.thisfile.relative_path.replace("%", "%%")
            )
        else:
            self.fm.notify("invalid action!", bad=True)


class mkcd(Command):
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        from os.path import join, expanduser, lexists
        from os import makedirs
        import re

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search("^/|^~[^/]*/", dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0) :]

            for m in re.finditer("[^/]+", dirname):
                s = m.group(0)
                if s == ".." or (
                    s.startswith(".") and not self.fm.settings["show_hidden"]
                ):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console("scout -ae ^{}$".format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)


class trash_mac(Command):
    """:trash
    Tries to move the selection or the files passed in arguments (if any) to
    the trash, using rifle rules with label "trash".
    The arguments use a shell-like escaping.
    "Selection" is defined as all the "marked files" (by default, you
    can mark files with space or v). If there are no marked files,
    use the "current file" (where the cursor is)
    When attempting to trash non-empty directories or multiple
    marked files, it will require a confirmation.
    """

    allow_abbrev = False
    escape_macros_for_shell = True

    def execute(self):
        import os
        import shlex
        from functools import partial

        def is_directory_with_files(path):
            return (
                os.path.isdir(path)
                and not os.path.islink(path)
                and len(os.listdir(path)) > 0
            )

        if self.rest(1):
            file_names = shlex.split(self.rest(1))
            files = self.fm.get_filesystem_objects(file_names)
            if files is None:
                return
            many_files = len(files) > 1 or is_directory_with_files(files[0].path)
        else:
            cwd = self.fm.thisdir
            tfile = self.fm.thisfile
            if not cwd or not tfile:
                self.fm.notify("Error: no file selected for deletion!", bad=True)
                return

            files = self.fm.thistab.get_selection()
            # relative_path used for a user-friendly output in the confirmation.
            file_names = [f.relative_path for f in files]
            many_files = cwd.marked_items or is_directory_with_files(tfile.path)

        confirm = self.fm.settings.confirm_on_delete
        if confirm != "never" and (confirm != "multiple" or many_files):
            self.fm.ui.console.ask(
                "Confirm deletion of: %s (y/N)" % ", ".join(file_names),
                partial(self._question_callback, files),
                ("n", "N", "y", "Y"),
            )
        else:
            # no need for a confirmation, just delete
            self._trash_files_catch_arg_list_error(files)

    def tab(self, tabnum):
        return self._tab_directory_content()

    def _question_callback(self, files, answer):
        if answer.lower() == "y":
            self._trash_files_catch_arg_list_error(files)

    # https://www.anthonysmith.me.uk/2008/01/08/moving-files-to-trash-from-the-mac-command-line/
    def _trash_files_catch_arg_list_error(self, files):
        import os
        import subprocess

        args = []
        for file in files:
            a = file.path.replace("\\", "\\\\").replace('"', '\\"')
            args.append('the POSIX file "' + a + '"')

        cmd = [
            "osascript",
            "-e",
            'tell app "Finder" to move {' + ", ".join(args) + "} to trash",
        ]
        subprocess.call(cmd, stdout=open(os.devnull, "w"))


class fzf_select(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import os
        import subprocess

        env = os.environ.copy()
        env["__FD_COMMAND"] = " --color=always"
        env["__FD_COMMAND"] += "" if self.fm.settings.show_hidden else " --no-hidden"
        env["__FD_COMMAND"] += " --type directory" if self.quantifier else ""

        env["__FZF_PREVIEW"] = "1"

        fzf = self.fm.execute_command(
            "fzf", env=env, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


class compress(Command):
    """
    :compress
    Compress marked files to current directory
    """

    @staticmethod
    def archive_ext(name):
        from re import search

        match = search(r"\.(zip|7z|rar|tar|tgz|tar\.gz|tar\.bz2)$", name)
        if match:
            return match.group()
        return ""

    def execute(self):
        from os.path import basename, relpath
        from ranger.core.loader import CommandLoader

        cwd = self.fm.thisdir
        src = [relpath(f.path, cwd.path) for f in cwd.get_selection()]
        if not src:
            return

        parts = self.line.split()
        if len(parts) < 2:
            self.fm.notify("archive filename is required!", bad=True)
            return

        ext = self.archive_ext(parts[1])
        if not ext:
            self.fm.notify("invalid archive filename!", bad=True)
            return

        commands = {
            ".zip": ["7zz", "a", "-tzip", parts[1], *src],
            ".7z": ["7zz", "a", "-t7z", parts[1], *src],
            ".rar": ["rar", "a", parts[1], *src],
            # tar
            ".tar": ["tar", "fc", parts[1], *src],
            ".tgz": ["tar", "fcz", parts[1], *src],
            ".tar.gz": ["tar", "fcz", parts[1], *src],
            ".tar.bz2": ["tar", "fcj", parts[1], *src],
        }

        obj = CommandLoader(
            args=commands[ext],
            descr="Compressing: " + basename(parts[1]),
            read=True,
        )
        obj.signal_bind(
            "after", lambda _: self.fm.get_directory(cwd.path).load_content()
        )
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        next = {
            "": ".zip",
            ".zip": ".7z",
            ".7z": ".tar.gz",
            ".tar.gz": ".rar",
            ".rar": ".zip",
        }

        name = self.rest(1)
        ext = self.archive_ext(name)
        if ext:
            name = name[: -len(ext)]
        if ext in next:
            return "compress " + name + next[ext]
        return ""


class extract(Command):
    """
    :extract
    Extract selected files to current directory.
    """

    def execute(self):
        from os.path import basename
        from ranger.core.loader import CommandLoader

        cwd = self.fm.thisdir
        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False

        for file in cwd.get_selection():
            ext = compress.archive_ext(file.basename)
            if not ext:
                continue

            obj = CommandLoader(
                args=["unar", file.path],
                descr="Extracting: " + basename(file.path),
                read=True,
            )
            obj.signal_bind(
                "after", lambda _: self.fm.get_directory(cwd.path).load_content()
            )
            self.fm.loader.add(obj)


class reveal_in_finder(Command):
    """
    :reveal_in_finder

    Present selected files in finder
    """

    def execute(self):
        import subprocess

        files = ",".join(
            [
                '"{0}" as POSIX file'.format(file.path)
                for file in self.fm.thistab.get_selection()
            ]
        )
        subprocess.check_output(
            [
                "osascript",
                "-e",
                'tell application "Finder" to reveal {{{0}}}'.format(files),
                "-e",
                'tell application "Finder" to set frontmost to true',
            ]
        )
