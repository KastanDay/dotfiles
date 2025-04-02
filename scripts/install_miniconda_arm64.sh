install_miniconda_arm64 () {
    mkdir -p ~/utils/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/utils/miniconda3/miniconda.sh
    bash ~/utils/miniconda3/miniconda.sh -b -u -p ~/utils/miniconda3
    rm -rf ~/utils/miniconda3/miniconda.sh
    source ~/utils/miniconda3/bin/activate
    ~/utils/miniconda3/bin/conda init --all
    source ~/.zshrc
}

# run it
install_miniconda_arm64
