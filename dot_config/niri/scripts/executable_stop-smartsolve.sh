#!/bin/sh
# Terminate any running smartSolve run spawned by the niri hotkeys.
# The venv entry point is the python child of "uv run"; killing it also
# ends the uv parent. Match only this precise path so unrelated processes
# (e.g. a terminal or editor mentioning smartSolve) are never hit.
pkill -f "/home/varun/web/smartSolve/.venv/bin/smartsolve"
