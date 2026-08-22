#!/usr/bin/env python3
"""
Kitty Session Manager
A simple script to manage kitty sessions and layouts
"""

import json
import os
import subprocess
import sys
from pathlib import Path

SESSIONS_DIR = Path.home() / ".config" / "kitty" / "sessions"
SESSIONS_DIR.mkdir(exist_ok=True)

def run_kitty_command(args):
    """Run a kitty remote control command"""
    try:
        result = subprocess.run(
            ["kitty", "@"] + args,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error: {e}")
        return None

def list_sessions():
    """List all available sessions"""
    sessions = list(SESSIONS_DIR.glob("*.json"))
    if not sessions:
        print("No sessions found.")
        return
    
    print("Available sessions:")
    for session in sessions:
        print(f"  - {session.stem}")

def save_session(name):
    """Save current kitty layout as a session"""
    layout_data = {
        "tabs": []
    }
    
    # Get current tabs
    tabs_output = run_kitty_command(["ls"])
    if not tabs_output:
        print("Failed to get current layout")
        return
    
    try:
        tabs_data = json.loads(tabs_output)
        for tab in tabs_data:
            tab_info = {
                "title": tab.get("title", ""),
                "layout": tab.get("layout", ""),
                "windows": []
            }
            
            for window in tab.get("windows", []):
                window_info = {
                    "title": window.get("title", ""),
                    "cwd": window.get("cwd", ""),
                    "cmdline": window.get("cmdline", [])
                }
                tab_info["windows"].append(window_info)
            
            layout_data["tabs"].append(tab_info)
    
        session_file = SESSIONS_DIR / f"{name}.json"
        with open(session_file, 'w') as f:
            json.dump(layout_data, f, indent=2)
        
        print(f"Session '{name}' saved to {session_file}")
    except json.JSONDecodeError:
        print("Failed to parse kitty layout data")

def load_session(name):
    """Load a saved session"""
    session_file = SESSIONS_DIR / f"{name}.json"
    if not session_file.exists():
        print(f"Session '{name}' not found")
        return
    
    with open(session_file) as f:
        layout_data = json.load(f)
    
    # Create new kitty instance with the session
    cmd = ["kitty", "--session", "-"]
    
    # Generate session commands
    session_commands = []
    
    for i, tab in enumerate(layout_data["tabs"]):
        if i == 0:
            # First tab
            session_commands.append("new_tab")
        else:
            session_commands.append("new_tab")
        
        if tab.get("title"):
            session_commands.append(f"set_tab_title {tab['title']}")
        
        # Add windows to tab
        for j, window in enumerate(tab.get("windows", [])):
            if j > 0:  # First window is created with the tab
                session_commands.append("new_window")
            
            if window.get("cwd"):
                session_commands.append(f"cd {window['cwd']}")
    
    # Write session commands to stdin
    session_content = "\n".join(session_commands)
    
    try:
        subprocess.run(cmd, input=session_content, text=True, check=True)
        print(f"Session '{name}' loaded")
    except subprocess.CalledProcessError:
        print(f"Failed to load session '{name}'")

def create_dev_session():
    """Create a development session with common panes"""
    commands = [
        "new_tab",
        "set_tab_title Development",
        "launch --location=hsplit --cwd=~ fish",
        "launch --location=vsplit --cwd=~ fish",
        "new_tab",
        "set_tab_title Monitoring", 
        "launch --location=hsplit htop",
        "launch --location=vsplit --cwd=~ fish"
    ]
    
    session_content = "\n".join(commands)
    try:
        subprocess.run(["kitty", "--session", "-"], input=session_content, text=True, check=True)
        print("Development session created")
    except subprocess.CalledProcessError:
        print("Failed to create development session")

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python session_manager.py list")
        print("  python session_manager.py save <name>")
        print("  python session_manager.py load <name>")
        print("  python session_manager.py dev")
        return
    
    command = sys.argv[1]
    
    if command == "list":
        list_sessions()
    elif command == "save" and len(sys.argv) > 2:
        save_session(sys.argv[2])
    elif command == "load" and len(sys.argv) > 2:
        load_session(sys.argv[2])
    elif command == "dev":
        create_dev_session()
    else:
        print("Invalid command or missing arguments")

if __name__ == "__main__":
    main()