# TODO add naws setup
echo "Work setup"
echo "Setting up global JS toolchain"
nvm use
npm config set @ffa:registry https://artifactory.flexport.io/artifactory/api/npm/ffa-infra-npm-dev-local
npm install -g @ffa/naws-cli
echo 
git lfs install