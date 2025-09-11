if status is-interactive
    switch (uname)
        case Darwin
            fish_add_path /opt/homebrew/bin
    end
end

if status --is-login
    # login shell stuff here
end

if test -d $HOME/flexport
    echo "Configuring for work"
    set dir (dirname (status -f))
    source $dir/work_config.fish
end