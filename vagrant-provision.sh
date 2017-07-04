# This has been tested on a new Ubuntu-14.04 vagrant box.
# If using anything else, YMMV.

# PS: You might need to ensure that there is enough memory
# given to the VM. I would suggest 2048MB or more.

# Install all requirements
echo "# LLVM 5.0" | sudo tee -a /etc/apt/sources.list
echo "deb http://apt.llvm.org/zesty/ llvm-toolchain-zesty main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/zesty/ llvm-toolchain-zesty main" | sudo tee -a /etc/apt/sources.list
echo "# 3.9" | sudo tee -a /etc/apt/sources.list
echo "deb http://apt.llvm.org/zesty/ llvm-toolchain-zesty-3.9 main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/zesty/ llvm-toolchain-zesty-3.9 main" | sudo tee -a /etc/apt/sources.list
echo "# 4.0" | sudo tee -a /etc/apt/sources.list
echo "deb http://apt.llvm.org/zesty/ llvm-toolchain-zesty-4.0 main" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://apt.llvm.org/zesty/ llvm-toolchain-zesty-4.0 main" | sudo tee -a /etc/apt/sources.list

# Add apt.llvm.org key
wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

sudo apt-get update
sudo apt-get install -y git make realpath screen zlib1g-dev libssl-dev
sudo apt-get build-dep -y python3

# Install clang 4.0
sudo apt-get -y install clang-4.0 lldb-4.0 lld-4.0 libfuzzer-4.0-dev

# Ensure that the clang and clang++ executables point correctly
sudo update-alternatives --install /usr/bin/clang clang $(which clang-4.0) 100
sudo update-alternatives --install /usr/bin/clang++ clang++ $(which clang++-4.0) 100

# To prevent git from complaining
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set up the fuzzing-numpy repository
git clone /vagrant ~/fuzzing-numpy
cd ~/fuzzing-numpy
./first_run.sh
cd ..

# Set up symlink for crashes directory
cd ~/fuzzing-numpy
mkdir -p /vagrant/crashes
mkdir -p /vagrant/cov
ln -s /vagrant/crashes ./crashes
ln -s /vagrant/cov ./cov
cd ..
