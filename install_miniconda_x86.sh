install_miniconda_x86 () {
mkdir -p ~/utils/miniconda3
wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O ~/utils/miniconda3/miniconda.sh
bash ~/utils/miniconda3/miniconda.sh -b -u -p ~/utils/miniconda3
rm -rf ~/utils/miniconda3/miniconda.sh
~/utils/miniconda3/bin/mamba init zsh
source ~/.zshrc
}

# run it
install_miniconda_x86