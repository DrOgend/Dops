yum-utils:
  pkg.installed

device-mapper-persistent-data:
  pkg.installed

lvm2:
  pkg.installed

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

install_selinux4docker-ce:
  pkg.installed:
    - skip_verify: True
    - sources:
      - container-selinux: http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.68-1.el7.noarch.rpm

python:
  pkg.latest

python2-pip_pkg:
  pkg.installed:
    - name: python2-pip

install_pip-docker:
  pip.installed:
    - name: docker
    - upgrade: True
    - force_reinstall: True
    - reload_modules: True

docker-ce:
  pkg.installed

salt-minion:
  service.running:
    - enable: True

docker:
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
