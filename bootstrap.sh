apt-get update
apt-get upgrade

apt-get install -y git zsh unzip
apt-get install -y wget stow make cmake
apt-get install -y python3.4-venv
apt-get install -y silversearcher-ag tig
apt-get install -y openjdk-8-jdk
apt-get install -y vim
apt-get install -y python2.7-dev
apt-get install -y g++

# TinyOS
echo "deb http://tinyprod.net/repos/debian squeeze main" >> /etc/apt/sources.list.d/tinyprod-debian.list
echo "deb http://tinyprod.net/repos/debian msp430-46 main" >> /etc/apt/sources.list.d/tinyprod-debian.list

gpg --keyserver keyserver.ubuntu.com --recv‐keys 34EC655A
gpg ‐a --export 34EC655A | sudo apt-key add -

sudo apt-get update
sudo apt-get install nesc tinyos-tools msp430-46 avr-tinyos

# Oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git /home/vagrant/.oh-my-zsh
cp /home/vagrant/.oh-my-zsh/templates/zshrc.zsh-template /home/vagrant/.zshrc
chsh -s /usr/bin/zsh ubuntu
chsh -s /usr/bin/zsh vagrant
