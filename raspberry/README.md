# Cross-compilation Raspberry Pi3 + Docker + Ros Indigo => LI3DS project

## env.sh
```bash
#!/usr/bin/env bash

source scripts/env.sh

export RESIN_IMAGE_NAME="spmaniato/resin-raspbian-ros-indigo-qemu"
export QEMU_ARM_STATIC_HOST=/usr/bin/qemu-arm-static

# step 0
export STEP0_CONTAINER_NAME="0_resin-raspbian-ros-indigo-qemu"

# step 1
export STEP1_COMMIT_IMAGE_NAME="atty/qemu_for_li3ds"

# step 2
export STEP2_COMMIT_IMAGE_NAME="atty/li3ds:rpi"
export STEP2_CONTAINER_NAME="2_qemu_for_li3ds"

# step 4
export STEP4_REGISTRY_IP="192.168.0.13:5000"

# step 5

# step 6
export STEP6_RPI_IP=pi@192.168.0.28
export STEP6_RPI_DEPLOY_PATH=/home/pi/Prog/2017_LI3DS_with_DockerMake/li3ds/pipeline/project1/build_crosscompile
```

### QEmu

- https://wiki.debian.org/QemuUserEmulation
- https://wiki.debian.org/Arm64Qemu

Le but est d'avoir un binaire `/usr/bin/qemu-arm-static`sur l'host qui puisse émuler les instructions armhf sur x86-64.

A priori, il suffit d'installer les packages:
```bash
# apt-get install qemu binfmt-support qemu-user-static

# update-binfmts --display | grep arm
qemu-arm (enabled):
 interpreter = /usr/bin/qemu-arm-static
qemu-armeb (enabled):
 interpreter = /usr/bin/qemu-armeb-static
```

TODO: A refaire sous un docker pour bien maitriser l'installation/configuration de l'émulateur.

### Image Docker de départ

`spmaniato/resin-raspbian-ros-indigo-qemu` => https://hub.docker.com/r/spmaniato/resin-raspbian-ros-indigo-qemu/
Malheureusement, on n'a pas accès à un dépôt github (valide) pour cette image docker.
L'image buildée permet d'utiliser qemu avec un Raspbian 8.0:
```bash
# docker run -it --rm \
	-v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static \
	spmaniato/resin-raspbian-ros-indigo-qemu \
	bash
root@aa3f91ebc663:/home/pi# uname -a
Linux aa3f91ebc663 4.9.0-2-amd64 #1 SMP Debian 4.9.18-1 (2017-03-30) armv7l GNU/Linux
root@aa3f91ebc663:/home/pi# lsb_release -a
No LSB modules are available.
Distributor ID: Raspbian
Description:    Raspbian GNU/Linux 8.0 (jessie)
Release:        8.0
Codename:       jessie

Il y a plusieurs outils installés par défaut: git, gcc, vim, ... :
```bash
# 
root@89735af82ce7:/home/pi# gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/arm-linux-gnueabihf/4.9/lto-wrapper
Target: arm-linux-gnueabihf
Configured with: ../src/configure -v --with-pkgversion='Raspbian 4.9.2-10' --with-bugurl=file:///usr/share/doc/gcc-4.9/README.Bugs --enable-languages=c,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.9 --enable-shared --enable-linker-build-id 
--libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.9 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object
 --disable-libitm --disable-libquadmath --enable-plugin --with-system-zlib --disable-browser-plugin --enable-java-awt=gtk --enable-gtk-cairo --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-4.9-armhf/jre --enable-java-home --with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-g
cj-4.9-armhf --with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-4.9-armhf --with-arch-directory=arm --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-multiarch --disable-sjlj-exceptions --with-arch=armv6 --with-fpu=vfp --with-float=hard 
--enable-checking=release --build=arm-linux-gnueabihf --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf
Thread model: posix
gcc version 4.9.2 (Raspbian 4.9.2-10) 

root@89735af82ce7:/home/pi# git --version
git version 2.1.4

root@89735af82ce7:/home/pi# vim --version              
VIM - Vi IMproved 7.4 (2013 Aug 10, compiled Apr 12 2015 23:01:44)
Included patches: 1-488, 576
...
```

Cette image ou étape est assez importante, faudrait essayer de la maitriser controler.

## 0_install_li3ds_packages.sh

```bash
#!/usr/bin/env bash

source env.sh

docker run \
	-it --rm \
	--name $STEP0_CONTAINER_NAME \
	-v $QEMU_ARM_STATIC_HOST:/usr/bin/qemu-arm-static \
	-v $(realpath ./scripts):$WORKDIR/scripts \
	$RESIN_IMAGE_NAME \
	bash -c '$WORKDIR/scripts/install_packages_for_li3ds.sh && \
			echo "Hit ctrl+p ctrl+q to suspend docker container" && \
			echo "and commit the new image: ./1_commit_new_image.sh" && \
			bash'
```

Dans le container, 
on utilise le script `scripts/install_packages_for_li3ds.sh` pour l'installation:
```bash
┏ ✓    atty@debian   ~/Prog/__IGN__/2017…Make/raspberry     pi3                         0.20   0.16G    11:14:14  
┗ more scripts/install_packages_for_li3ds.sh 
#!/usr/bin/env bash

LI3DS_ROS_PACKAGES="ros-indigo-rosserial-python ros-indigo-pcl-ros \
        ros-indigo-diagnostic-updater ros-indigo-nmea-msgs \
        ros-indigo-angles ros-indigo-dynamic-reconfigure \
        ros-indigo-rosserial-arduino ros-indigo-rqt \
        ros-indigo-rqt-common-plugins"

LI3DS_PACKAGES="$LI3DS_ROS_PACKAGES libpcap-dev libyaml-cpp-dev"
#LI3DS_PACKAGES="libpcap-dev libyaml-cpp-dev"

apt-get update
apt-get install -y $LI3DS_PACKAGES
rm -rf /var/lib/apt/lists/*
```

Ce script installe manuellement les packages/dépendances pour les packages ROS du projet LI3DS,
car l'installation automatique via rosdep ne semble pas fonctionner avec ce système:
```bash
ERROR: the following packages/stacks could not have their rosdep keys resolved
to system dependencies:                             
ros_arduino: No definition of [rosserial_python] for OS [debian]
velodyne_pointcloud: No definition of [tf] for OS [debian]
velodyne_driver: No definition of [tf] for OS [debian]
velodyne_gps_imu: No definition of [nmea_msgs] for OS [debian]
rqt_li3ds: No definition of [rqt_gui_py] for OS [debian]
...
Failed     << velodyne_gps_imu:cmake                [ Exited with code 1 ]                                                         
Failed    <<< velodyne_gps_imu                      [ 16.2 seconds ]                                                               
Abandoned <<< velodyne_msgs                         [ Unrelated job failed ]                                                       
Abandoned <<< ros_arduino                           [ Unrelated job failed ]                                                       
Abandoned <<< rqt_li3ds                             [ Unrelated job failed ]                                                       
Abandoned <<< velodyne_driver                       [ Unrelated job failed ]                                                       
Abandoned <<< velodyne_pointcloud                   [ Unrelated job failed ]          
```
TODO: Ce problème me rappelle quelque chose ... 
il y a une peut être une astuce/feinte à effectuer pour faire croire à rosdep qu'on est sous un autre système (compatible).
A investiguer.


A la fin de l'installation des packages (apt), on invite l'utilisation à detached le container pour effectuer une sauvegarde/commit de container dans une nouvelle image. 
TODO: Le DinD (Docker in Docker) pourrait être une alternative, 
mais ça semble compliqué d'installer et faire tourner un docker sous un environnement émulé (raspbian + qemu). 
Je n'ai pas cherché à aller plus loin de ce coté (l'alternative manuelle est/était acceptable).

## 1_commit_new_image.sh

A la fin de l'étape 0, on utilise le script `./1_commit_new_image.sh` pour commit le container dans une image pour le projet:
```bash
#!/usr/bin/env bash

source env.sh

docker commit \
	$(docker ps -aqf name=$STEP0_CONTAINER_NAME)	\
	$STEP1_COMMIT_IMAGE_NAME
```

A la fin de step_0 et 1, on a une image résultant `$STEP1_COMMIT_IMAGE_NAME` (dans env.sh: `export STEP1_COMMIT_IMAGE_NAME="atty/qemu_for_li3ds"`).

Cette image est exploitable pour la compilation projet LI3DS.

## 2_install_li3ds_project.sh

Etape de mise en place dans un container du projet LI3DS:
```bash
#!/usr/bin/env bash

source env.sh

# urls:
# - http://stackoverflow.com/questions/37281533/how-do-i-append-to-path-environment-variable-when-running-a-docker-container
docker run \
	-it --rm \
	--name $STEP2_CONTAINER_NAME \
	-v $QEMU_ARM_STATIC_HOST:/usr/bin/qemu-arm-static \
	-v $(realpath ./scripts):$WORKDIR/scripts \
	$STEP1_COMMIT_IMAGE_NAME \
	bash -c 'export PATH=$PATH:$WORKDIR/scripts && \
			install_li3ds_project.sh && \
			echo "Hit ctrl+p ctrl+q to suspend docker container" && \
			echo "and commit the new image: ./3_commit_new_image_li3ds.sh" && \
			bash'
```

Cette fois, on met à jour le PATH avec l'accès au répertoire des scripts `~/scriptts` pour éviter de spécifier à chaque le path complet.

Dans le container, 
on utilise le script `install_li3ds_project.sh` pour l'installation:
```bash
#!/usr/bin/env bash

source bash_tools.sh
source env.sh

# workspace
echo_i "Create directory: $ROS_WORKSPACE"
mkdir -p $ROS_WORKSPACE

## overlay_ws
echo_i "Create directory: $ROS_OVERLAY_WS/src"
mkdir -p $ROS_OVERLAY_WS/src
#
cd $ROS_OVERLAY_WS/src

# .rosinstall
echo_i "Download .rosinstall: $LI3DS_ROSINSTALL_URL"
wget $LI3DS_ROSINSTALL_URL -O .rosinstall

# get sources
echo_i "wstool update ..."
wstool update

## catkin_ws
echo_i "Create directory: $ROS_CATKIN_WS"
mkdir -p $ROS_CATKIN_WS

cd $ROS_CATKIN_WS

if [ ! -d .catkin_tools ]; then
	catkin init --workspace $ROS_OVERLAY_WS
fi

mkdir -p src

echo_i "Create symlink $ROS_OVERLAY_WS/src into $(realpath src/.)"
ln -fs $ROS_OVERLAY_WS/src src/.

catkin config --init

# rosdep for li3ds project
apt-get update

# installation des dépendances restantes 
# (dans notre cas: 'python-pyaudio')
rosdep install \
		--default-yes \
		--from-paths $ROS_OVERLAY_WS \
		--ignore-src \
		--rosdistro indigo

# build
catkin build --cmake-args -Wno-dev
```

Ce script représente (à peu près) la concaténation des scripts d'installation/build du projet LI3DS.
Il y a:
- construction des workspaces
	- overlay_ws: qui contient les sources/dépôts du projet (les différents packages ROS de LI3DS)
	- catkin_ws: répertoire de compilation/déploiement des binaires
- téléchargement des sources avec 
	- Téléchargement du .rosinstall du projet: `wget $LI3DS_ROSINSTALL_URL -O .rosinstall`
	- Téléchargement des sources des dépôts des packages: `wstool update`
- résolution de dépendances (restantes) avec `rosdep install ...`
- compilation du projet avec `catkin build ...`

TODO: On pourrait (peut être) essayer de ré-utiliser les scripts de la version PC/docker de l'installation compilation du projet.


A la fin de cette étape, l'utilisateur est invité à détacher le container et effectuer une sauvegarde/commit du container dans une image:
```bash
Hit ctrl+p ctrl+q to suspend docker container
and commit the new image: ./3_commit_new_image_li3ds.sh
```

## 3_commit_new_image_li3ds.sh

A la fin de l'étape 2,
on utilise le script `./3_commit_new_image_li3ds.sh` pour commit le container dans une image pour le projet:
```bash
#!/usr/bin/env bash

source env.sh

docker commit \
	$(docker ps -aqf name=$STEP2_CONTAINER_NAME)	\
	$STEP2_COMMIT_IMAGE_NAME
```

A la fin de step_2 et 3,
on a une image résultant `$STEP2_COMMIT_IMAGE_NAME` (dans env.sh: `export STEP2_COMMIT_IMAGE_NAME="atty/li3ds:rpi"`).

Cette image est exploitable pour l'exécution/déploiement du projet LI3DS.

## 4_push_image_to_registry.sh

Script pour push l'image sur un private registry.
(ps: étape pas forcément nécessaire, dans le sens que l'image n'est pas vraiment utilisable directement par le raspberry, car env. emulé ... après ça peut être utile pour utiliser cette image pour d'autres hosts de compilation/exploitation (build farm)).

```bash
#!/usr/bin/env bash

source env.sh

docker tag $STEP2_COMMIT_IMAGE_NAME $STEP4_REGISTRY_IP/$STEP2_COMMIT_IMAGE_NAME

docker push "$STEP4_REGISTRY_IP/$STEP2_COMMIT_IMAGE_NAME"
```

On tag l'image et la push sur le registry. Rien de foufou :-) (voir `env.sh` pour les noms utilisés).

## 5_copy_ros_workspaces.sh

Transfert des workspaces contenus dans l'image LI3DS vers l'host:
```bash
#!/usr/bin/env bash

source env.sh
source scripts/bash_tools.sh

echo_i "Copy directories:"
echo_i "- ROS_CATKIN_WS: $ROS_CATKIN_WS"
echo_i "- ROS_OVERLAY_WS: $ROS_OVERLAY_WS"
echo_i "from container: $STEP2_CONTAINER_NAME to host ..."
docker cp $STEP2_CONTAINER_NAME:$ROS_CATKIN_WS .
docker cp $STEP2_CONTAINER_NAME:$ROS_OVERLAY_WS .

echo_i "Tar.gz of directories ..."
tar -zcvf catkin_ws.tar.gz catkin_ws
tar -zcvf overlay_ws.tar.gz overlay_ws
#
rm -rf catkin_ws overlay_ws
```

On construit des archives des workspaces, 
car ils peuvent contenir (potentiellement) beaucoup de (petits) fichiers qui sont (assez) longs à transférer via un scp sur le réseau.

A la fin de cette étape, on récupère deux archives tar.gz: `catkin_ws.tar.gz` et `overlay_ws.tar.gz`.
`catkin_ws` est le résultat de build spécifique à l'architecture: armhf.
`overlay_ws` contient les sources (updatées) du projet (ayant servies à la construction de ce `catkin_ws`).

## 6_transfert_to_rpi.sh

Script permettant de transférer sur le/mon raspberry le résultat de compilation:
```bash
#!/usr/bin/env bash

source env.sh
source scripts/bash_tools.sh

echo_i "Transfert to raspberry LI3DS project:"
echo_i "- Raspberry IP: $STEP6_RPI_IP"
echo_i "- Path to deploy archives: $STEP6_RPI_DEPLOY_PATH/."
# catkin
scp catkin_ws.tar.gz \
    $STEP6_RPI_IP:$STEP6_RPI_DEPLOY_PATH/.
# overlay
scp overlay_ws.tar.gz \
    $STEP6_RPI_IP:$STEP6_RPI_DEPLOY_PATH/.
```

Ce script est assez/trop spécifique à mon installation sur l'host/raspberry.
En particulier le répertoire target pour la copie/transfert des archives (dans env.sh):
```bash
# step 6
export STEP6_RPI_IP=pi@192.168.0.28
export STEP6_RPI_DEPLOY_PATH=/home/pi/Prog/2017_LI3DS_with_DockerMake/li3ds/pipeline/project1/build_crosscompile
```