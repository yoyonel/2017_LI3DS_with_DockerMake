Etape 1:
-------
On lance un container sur l'image `li3ds-prototype` pour y installer/configurer les workspaces: overlay & catkin. Le container contiendra les sources d'un projet (ROS/LI3DS) et une résolution des dépendances de packets pour compiler/runner ce projet (via rosdep/apt).
On souhaite une persistance sur les workspaces (overlay & catkin).

IN:
- l'image de dev `li3ds-prototype`
- Les adresses des dépots pour construire le workspace overlay (via wstool)

OUT:
- un container `li3ds-prototype_step1` mise à jour avec les dépendances
- volumes de persistances de données sur les workspaces: overlay & catkin
  - overlay: `li3ds-prototype_overlay`
  - catkin: `li3ds-prototype_catkin`

=> scripts: /root/step1.sh dans l'image
  - /root/configure.sh
    - construction d'overlay_ws: dans le volume `li3ds-prototype_overlay`
      - construction d'un wst via wstool -> fetch des sources
    - résolution des dépendances via rosdep -> install de nouveaux apts (potentiellement)
    - construction d'un catkin_ws: dans le volume `li3ds-prototype_catkin`

Le but au final est de commit le container en une image, 
on peut utiliser une option de la commande commit de docker qui permet d'envoyer des commandes (au sens Dockerfile) avec de commit.
Commit a container with new CMD and EXPOSE instructions
https://docs.docker.com/engine/reference/commandline/commit/

On tenter une sorte de DinD minimaliste
http://tdeheurles.github.io/acting-on-docker-from-inside-docker/
host $ docker run -v /var/run/docker.sock:/var/run/docker.sock -ti ubuntu bash
container $ # update apt-get and install curl
container $ apt-get update && apt-get install curl
container $ # [... lots of log ...]
container $ # install docker
container $ curl -sSL https://get.docker.com/ | sh

Idée:
- Utiliser un DinD.
- On génère le projet avec dépendances.
- On génère un identifiant SH256 par rapport au workspace overlay (à réflêchir)
- On commit le container (généré) dans une nouvelle image avec le tag SHA256: `li3ds-prototype:<sha256>`


Problèmes avec les volumes:
Pas réussi à créer des volumes via docker volume create "propres".
On utilise la création de volume avec host mount point directement dans la commande docker run ... -> -v $(realpath ../.volumes/pipeline/li3ds-prototype_overlay):/root/overlay_ws \ par exemple.
Ca monte un point de montage sur les workspaces (catkin, overlay) du container dans un moint point local de l'host.

Il y a un problème de changement de droit sur certains fichiers dans catkin workspace:
root@f363f65746e5:~/catkin_ws# ls /root/catkin_ws/devel/share/ros_arduino/arduino.elf -la
lrwxrwxrwx 1 latty latty 72 Mar  2 11:11 /root/catkin_ws/devel/share/ros_arduino/arduino.elf -> /root/catkin_ws/devel/.private/ros_a
rduino/share/ros_arduino/arduino.elf
-> à vérifier ...

---

2017-04-03

Deploiement
-----------

Problème avec le docker daemon pour setter correctement un private registry.
Pas réussi à configurer le daemon via les fichiers /etc/default/docker et/ou /etc/docker/daemon.json.
Guillaume a proposé de lancer à la main le daemon docker via le script launch_docker_daemon.sh à la racine du projet:
more docker_launch_daemon.sh     
#!/usr/bin/sh

sudo service docker stop

sudo docker daemon \
    --dns 172.21.2.14 --dns 172.16.2.91 \
    --insecure-registry=172.20.250.99:5000

Faudra cleaner ce script, car ça expose des addresses IP de l'IGN ... c'est pas top top.

Le laser VLP-16 est configuré sur le laptop toughbook. Faudrait mettre en place un script qui récupère l'IP du launcher du docker pour le placer en setting pour le VLP-16 (et utiliser les serveurs de paramtres pour setter le laser).