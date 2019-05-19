################################################################################
#
#  == CREATE OR ATTACH TMUX SESSION ==
#
################################################################################

function ftmux
    
    # Check if tmux exists
    if not which tmux > /dev/null 2>&1
        return 1
    end

    # Prevent nesting of tmux sessions
    if test -n "$TMUX"
        return 1
    end

    # Attach to tmux session (if running); else create new session
    if tmux ls > /dev/null 2>&1
        tmux attach -t default-session
    else
        tmux new-session -s default-session
    end

end
