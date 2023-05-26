sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y

sudo apt install git

FILE=~/.ssh/id_ed25519
if [ -f $FILE ]; then
    echo "$FILE exists."
else
    ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "cloud_gpu" -q -N ""
fi

# COMMAND=docker
# if ! command -v $COMMAND &> /dev/null; then
#     sudo apt-get remove docker docker-engine docker.io containerd runc
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
#     echo \
#         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#         $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#     sudo apt-get update
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# else
#     echo "$COMMAND found"
# fi