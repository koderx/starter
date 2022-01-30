#!/bin/bash
set -e
echo "checking root..."

if [ $EUID -ne 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi

declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install -y"
osInfo[/etc/alpine-release]="apk --update add"
osInfo[/etc/centos-release]="yum install -y"
osInfo[/etc/fedora-release]="dnf install -y"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        install_cmd=${osInfo[$f]}
    fi
done

if [ -f /etc/debian_version ]; then
	apt update
elif [ -f /etc/alpine-release ]; then
  apk update
elif [ -f /etc/centos-release ]; then
	yum update
elif [ -f /etc/fedora-release ]; then
	dnf update
fi

${install_cmd} git tmux zsh wget

echo "install oh-my-zsh..."

sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh \
    | sed 's|^REPO=.*|REPO=${REPO:-mirrors/oh-my-zsh}|g' \
    | sed 's|^REMOTE=.*|REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}|g')"

echo "init done"
