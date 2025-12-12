sudo apt update
sudo apt install openjdk-11-jdk -y
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
V
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo apt install jenkins -y
sudo apt update
sudo apt install -y wget gnupg
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt install -y jenkins
sudo apt update
sudo apt install -y jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo apt install openjdk-11-jdk -y
sudo apt install openjdk-17-jdk -y
sudo systemctl stop jenkins
sudo apt remove --purge jenkins -y
sudo rm -rf /var/lib/jenkins /etc/default/jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee   /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]"   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
