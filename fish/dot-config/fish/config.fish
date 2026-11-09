if status is-interactive
    # Let GPG's passphrase prompt use this terminal.
    if isatty stdin
        set -gx GPG_TTY (tty)
    end

end

# Noninteractive scripts also need Homebrew's PATH.
switch (uname)
    case Darwin
        eval "$(/opt/homebrew/bin/brew shellenv)"
end

if status --is-login
    
end

# TODO figure out if there's a better way for me to do this
if test -d $HOME/flexport
    if status is-interactive
        echo "Configuring for work"
    end
    set dir (dirname (status -f))
    source $dir/work/config.fish
else
    direnv hook fish | source
end
