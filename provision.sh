cd /home/vagrant

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

apt update
apt install -y \
    build-essential \
    python-dev \
    git \
    mongodb-org \
    ngircd \
    irssi \
    emacs-nox \
    wget \
    silversearcher-ag


# sed -i -s 's/bindIp: 127.0.0.1/#bindIp: 127.0.0.1/' /etc/mongod.conf
systemctl restart mongod

echo "Downloading miniconda..."
su - vagrant -c 'wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda.sh  > /dev/null 2>&1'
echo "Instaling miniconda..."
su - vagrant -c 'bash Miniconda.sh -b'

IFS='' read -r -d '' conda_suffix <<"EOF"
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vagrant/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vagrant/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vagrant/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vagrant/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
EOF
sudo -u vagrant echo "${conda_suffix}" >> .bashrc
su - vagrant -c '/home/vagrant/miniconda3/bin/conda update -n base -c defaults conda -y'
su - vagrant -c '/home/vagrant/miniconda3/bin/conda create -n helga python=2 pip=9.0.3 -y'
su - vagrant -c 'echo "conda activate helga" >> .bashrc'
sudo -u vagrant echo "alias start_helga='(cd ~; helga --settings=/home/vagrant/helga/my_settings.py)'" >> .bashrc
sudo -u vagrant echo "alias screen_helga='(cd ~; screen -a helga --settings=/home/vagrant/helga/my_settings.py)'" >> .bashrc

su - vagrant -c 'git clone https://github.com/shaunduncan/helga.git'
su - vagrant -c 'git clone https://github.com/nixjdm/helga-mimic.git'
(cd helga-mimic; sudo -u vagrant git checkout trim_responses)

su - vagrant -c 'cp /vagrant/my_settings.py helga/my_settings.py'
su - vagrant -c 'cp /vagrant/my_requirements.txt helga/requirements.txt'

su - vagrant -c 'miniconda3/envs/helga/bin/pip install -e helga'
su - vagrant -c 'miniconda3/envs/helga/bin/pip install -e helga-mimic'

cd /vagrant
