PYTHON_MAJOR_VERSION=3.12
PYTHON_MINOR_VERSION=1
PYTHON_VERSION=${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}
nproc=6

sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
       libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
       libncurses5-dev libncursesw5-dev xz-utils tk-dev \
       libgdbm-dev libnss3-dev libffi-dev

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

# apt-get --purge remove build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev -y
# apt-get autoremove -y
# apt-get clean

python$PYTHON_MAJOR_VERSION -m pip install -U pip setuptools wheel setuptools-rust
# python3.7 -m pip install -U pip
# echo '$alias pip3="python3.7 -m pip"' >> ~/.bashrc