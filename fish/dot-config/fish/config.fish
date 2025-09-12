if status is-interactive

end

if status --is-login
    switch (uname)
        case Darwin
            eval "$(/opt/homebrew/bin/brew shellenv)"
    end
end

# TODO figure out if there's a better way for me to do this
if test -d $HOME/flexport
    echo "Configuring for work"
    set dir (dirname (status -f))
    source $dir/work_config.fish
end
