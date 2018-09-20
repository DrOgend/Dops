yum-utils:
  pkg.installed

device-mapper-persistent-data:
  pkg.installed

lvm2:
  pkg.installed

container-selinux:
  pkg.latest

docker_repo:
  pkgrepo.managed:
    - humanname: docker-ce
    - baseurl: https://download.docker.com/linux/centos/7/$basearch/stable
    - gpgcheck: 1
    - gpgkey: https://download.docker.com/linux/centos/gpg
    - enabled: 1

salt_repo:
  pkgrepo.managed:
    - humanname: Salt state repo
    - baseurl: https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/SALTSTACK-GPG-KEY.pub
              https://repo.saltstack.com/yum/redhat/$releasever/$basearch/latest/base/RPM-GPG-KEY-CentOS-7
    - enabled: 1

mypkgs:
  pkg.installed:
    - sources:
      - container-selinux: http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm

docker-ce:
  pkg.installed

docker:
  service.running:
    - enable: True

python:
  pkg.latest

python2-pip_pkg:
  pkg.installed:
    - name: python2-pip

install_pip-docker:
  pip.installed:
    - name: docker
    - upgrade: True

salt-minion:
  service.running:
    - enable: True

websocket_chat:
  docker_image.present:
    - load: salt://websocket_chat_1_5.tar
    - tag: websocket_chat

run_websocket_chat:
  docker_container.running:
    - image: websocket_chat:1.5
    - replace: True
    - port_bindings:
      - 8080:8080
