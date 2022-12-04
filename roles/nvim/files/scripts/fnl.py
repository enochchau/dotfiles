#!/usr/bin/env python

import subprocess, os, argparse


def nvim_cmd(*commands: str):
    return ["nvim", "--headless"] + list(commands) + ["+q"]


def run_nvim(*commands: str):
    cmd = nvim_cmd(*commands)
    env = os.environ.copy()
    env["FENNEL_COMPILE"] = "true"

    with subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, env=env, text=True
    ) as p:
        if p.stdout:
            while True:
                l = p.stdout.readline()
                if not l:
                    break
                print(l)


parser = argparse.ArgumentParser(
    description="Fennel compiler under Neovim", prog="fnl-nvim"
)
parser.add_argument("file", help="Input source file")
parser.add_argument(
    "-c",
    "--compile",
    required=False,
    dest="compile",
    help="Compile files writing Lua to stdout",
    action="store_true",
)
parser.add_argument(
    "-e",
    "--eval",
    required=False,
    dest="eval",
    help="Evaluate source code and print the result",
    action="store_true",
)

args = parser.parse_args()
file_name = args.file

if args.compile:
    run_nvim("-c", f"FnlCompile {file_name}")
elif args.eval:
    run_nvim("-c", f"FnlRun {file_name}")
