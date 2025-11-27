if status is-interactive
    # https://fishshell.com/docs/current/cmds/set.html
    set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home
    set -gx GITHUB_USERNAME sjones
    set -gx SOURCE_SCRIPT_DIR /Users/sjones/IdeaProjects/infra-deployer
    set -gx SNOWFLAKE_USERNAME "SJONES@FLEXPORT.COM"
    set -gx KMO_HOME /Users/sjones/Documents/code/kimono/
    set -gx KMO_SNOWFLAKE_USERNAME "SJONES@FLEXPORT.COM"
    set -gx AWS_REGION us-east-1
    set -gx SNOWFLAKE_WAREHOUSE_XS "DBT_DEV_XS"
    set -gx SNOWFLAKE_WAREHOUSE_S "DBT_DEV_S"
    set -gx SNOWFLAKE_WAREHOUSE_M "DBT_DEV_M"
    set -gx SNOWFLAKE_WAREHOUSE_L "DBT_DEV_L"
    set -gx SNOWFLAKE_WAREHOUSE_XL "DBT_DEV_XL"
    set -gx SNOWFLAKE_WAREHOUSE_DYNAMIC_M "DBT_DEV_M"
    set -gx DBT_PROJECT_DIR "/Users/sjones/Documents/code/kimono/transform/dbt_transforms"
    set -gx DBT_PROFILES_DIR "/Users/sjones/Documents/code/kimono/transform/dbt_transforms"
    set -gx PYENV_ROOT $HOME/.pyenv
    source (dirname (status -f))/.env.fish
  
    alias k="kubectl"
    alias mpr="/Users/sjones/flexport/mpr"
    alias bastion_ssh='~/flexport/env-improvement/bin/bastion ssh'
    alias dbt-defer="$DBT_PROJECT_DIR/scripts/dbt-defer.sh"
    alias my_kimono='echo /Users/sjones/Documents/code/kimono/transform'

    fish_add_path /opt/homebrew/Cellar/llvm@14/14.0.6/bin
    fish_add_path $(go env GOPATH)/bin
    if test -d $PYENV_ROOT/bin 
        fish_add_path "$PYENV_ROOT/bin"
    end
    fish_add_path "/Users/sjones/.local/bin"
    if command -q pyenv
    else 
        echo "Couldn't find pyenv command, adding pyenv to path"
        fish_add_path "$PYENV_ROOT/bin"
    end
    pyenv init - fish | source
    # Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
    # fish_add_path "$HOME/.rvm/bin"
    # TODO conditionally load nvm and rvm instead of putting them in global functions folder to always be loaded
    rvm ruby-2.7.7
    nvm use 18.17.1
end

if status --is-login
    # login stuff here
end
