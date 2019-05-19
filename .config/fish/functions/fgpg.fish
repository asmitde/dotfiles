################################################################################
#
#  == ENABLE GPG KEY SIGNING ==
#
################################################################################

function fgpg
    
    set -xg GPG_TTY (tty)

    if not test -e ~/.gnupg/S.gpg-agent
        gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf
    end

    set -xg GPG_AGENT_INFO $HOME/.gnupg/S.gpg-agent:0:1

end
