cd ~
git clone https://github.com/perinm/Encyclopedia-Galactica.git

DIRECTORY=Arduino
if [[ -d "$DIRECTORY" ]]; then
    echo "$DIRECTORY exists on your filesystem."
else
    mkdir "$DIRECTORY"
fi
cd Arduino
git clone https://github.com/perinm/esp-codes.git
cd ~

DIRECTORY=dev
if [[ -d "$DIRECTORY" ]]; then
    echo "$DIRECTORY exists on your filesystem."
else
    mkdir "$DIRECTORY"
fi
cd dev
git clone https://github.com/perinm/ArtIntelli-s-Vault

DIRECTORY=freelas
if [[ -d "$DIRECTORY" ]]; then
    echo "$DIRECTORY exists on your filesystem."
else
    mkdir "$DIRECTORY"
fi
cd freelas
git clone https://github.com/perinm/guido-lenzi
