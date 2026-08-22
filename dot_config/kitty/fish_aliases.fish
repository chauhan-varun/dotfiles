# Add this to your ~/.config/fish/config.fish file

# Kitty session management aliases
alias ks='~/.config/kitty/kitty-session'
alias kslist='~/.config/kitty/kitty-session list'
alias ksdev='~/.config/kitty/kitty-session dev'
alias kssimple='~/.config/kitty/kitty-session simple'

# Kitty pane shortcuts (alternative to key bindings)
alias ksplit='kitty @ launch --location=hsplit'
alias vsplit='kitty @ launch --location=vsplit'
alias newt='kitty @ new-tab'

# Kitty window management functions
function kw
    if test (count $argv) -eq 0
        echo "Usage: kw <command>"
        echo "Commands:"
        echo "  ls       - List windows"
        echo "  focus N  - Focus window N"
        echo "  close    - Close current window"
        echo "  title X  - Set window title to X"
        return
    end
    
    switch $argv[1]
        case ls
            kitty @ ls
        case focus
            if test (count $argv) -ge 2
                kitty @ focus-window --match id:$argv[2]
            end
        case close
            kitty @ close-window
        case title
            if test (count $argv) -ge 2
                kitty @ set-window-title $argv[2..-1]
            end
        case '*'
            echo "Unknown command: $argv[1]"
    end
end