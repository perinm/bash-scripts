PYTHON_VERSION=3.11.1
nproc=12

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

sudo apt install -y make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
       libncurses5-dev libncursesw5-dev xz-utils tk-dev

mkdir python_installation && cd python_installation

wget "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz"
tar xzvf Python-$PYTHON_VERSION.tgz
rm -f Python-$PYTHON_VERSION.tgz

cd Python-$PYTHON_VERSION
./configure --enable-optimizations --with-ensurepip=install
make -j $(nproc)
sudo make altinstall

# cd ../..
# rm -rf python_installation

# apt --purge remove build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev -y
# apt autoremove -y
# apt clean

python$PYTHON_VERSION -m pip install -U pip
# python3.7 -m pip install -U pip
# echo '$alias pip3="python3.7 -m pip"' >> ~/.bashrc