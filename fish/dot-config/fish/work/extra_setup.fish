# TODO add naws setup
echo "Work setup"
echo "Setting up global JS toolchain"
if ! type "fnm" &> /dev/null;
    echo "installing fnm"
    curl -fsSL https://fnm.vercel.app/install | bash
else;
    echo "fnm found, skipping installation..."
end

fnm i 24.14.0
fnm default 24.14.0
fnm use default
npm config set @ffa:registry https://artifactory.flexport.io/artifactory/api/npm/ffa-infra-npm-dev-local
npm install -g @ffa/naws-cli
echo 
git lfs install