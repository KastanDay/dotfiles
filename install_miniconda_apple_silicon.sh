install_miniconda_apple_silicon () {
mkdir -p ~/utils/miniconda3
wget https://github.com/conda-forge/miniforge/releases/download/23.3.1-1/Mambaforge-23.3.1-1-MacOSX-arm64.sh -O ~/utils/miniconda3/miniconda.sh
sudo bash ~/utils/miniconda3/miniconda.sh -b -u -p ~/utils/miniconda3
rm -rf ~/utils/miniconda3/miniconda.sh
~/utils/miniconda3/bin/mamba init zsh
source ~/.zshrc
}

# run it
install_miniconda_apple_silicon