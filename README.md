# Тестовое задание

## Дано

- Этот репозиторий с исходниками [приложения](#Приложение).
- Две Linux (дистрибутив на выбор) машины: salt master и salt minion.


## Задача

1. Контейнеризировать приложение.
1. Развернуть docker host на minion машине с помощью salt states.
1. Развернуть и запустить приложение на docker host с помощью salt states.

Результатом тестового задания должен быть PR с кодом (salt states, Dockerfile ...) и документацией для развертывания.
При проверке будем пробовать всё развернуть и запустить.

# Приложение

Web chat на _Erlang_ и _WebSockets_.

Build:

```shell
$ make compile
```

Run:

```shell
$ make start
```


#                                   Task solution
Used AMAZON AWS EC2
created 2 HOST's used  Red Hat Enterprise Linux Server 7.5 (Maipo)
!!! in security policies had to OPEN PORTS SSH 21, APP 8080 and SALT 4505 - 4506 !!!

-------------------------------------------------------------------------------------------------
This file is documentation with list sh commands 
which used to prepare infrastructure
and task solution.

In parts (## install INFRA soft on MINION) 
and (##install INFRA soft on MASTER)
commands which had used to install infrastructure sofware

In part (##SOLUTION - BUILD & Containerize application)
there is Task solution - commands to containerize and run application on minion with salt states

 HOST_MASTER and HOST_MINION are private IP addreses
 if run on other hosts you have to change them

Servers are:
*) salt_master 
Public DNS (IPv4)
ec2-34-211-230-199.us-west-2.compute.amazonaws.com
Private IP
172.31.28.23

*) salt_minion
Public DNS (IPv4)
ec2-34-212-27-63.us-west-2.compute.amazonaws.com
Private IP
172.31.22.146

In infra dir you can find cert's to connect servers 
```shell
sh -i ${HOST_MASTER}
```

In part (##Check app running) you can check app by wget
 
-------------------------------------------------------------------------------------------------

##install INFRA soft on MINION
```shell
export HOST_MASTER=172.31.28.23
export HOST_MINION=172.31.22.146

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm 

sudo yum install -y salt-minion

echo ${HOST_MASTER}"   "salt |sudo tee -a /etc/hosts

sudo systemctl enable salt-minion
sudo systemctl restart salt-minion
sudo systemctl status salt-minion
```


##install INFRA soft on MASTER

```shell
export HOST_MASTER=172.31.28.23
export HOST_MINION=172.31.22.146

git clone https://github.com/rbkmoney/test-devops-DrOgend.git

cp test-devops-DrOgend

sudo yum install -y git

sudo yum install -y wget

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm 

sudo yum install -y salt-master salt-ssh salt-syndic salt-cloud salt-api

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm

sudo yum install -y docker-ce

echo ${HOST_MASTER}"   "salt |sudo tee -a /etc/hosts


echo "file_roots:"|sudo tee -a /etc/salt/master
echo "  base:"|sudo tee -a /etc/salt/master
echo "    - /home/ec2-user/test-devops-DrOgend/salt/"|sudo tee -a /etc/salt/master

sudo systemctl enable salt-master
sudo systemctl restart salt-master
sudo systemctl status salt-master

sudo systemctl enable docker
sudo systemctl restart docker
sudo systemctl status docker


sudo salt-key -L
sudo salt-key -A -y
sudo salt-key -L

```

##SOLUTION - BUILD & Containerize application
```shell
sudo docker build -t websocket_chat:1.5 .

sudo docker save -o /home/ec2-user/test-devops-DrOgend/salt/websocket_chat_1_5.tar websocket_chat:1.5


sudo salt '*' state.highstate
```

##Check app running
```shell
wget ${HOST_MINION}:8080
cat index.html
```

