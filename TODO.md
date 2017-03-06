# TODO

#2017-03-05#

# SHELL

## TMUX
Mieux paramétriser tmux (voir au niveau des keymaps ce qu'on fait)

## ZSH
Rajouter le plugin 'powerline9k' pour zsh
=> https://github.com/bhilburn/powerlevel9k/wiki/Install-Instructions#option-2-install-for-oh-my-zsh

C'est peut être utile ça => http://unix.stackexchange.com/questions/139082/zsh-set-term-screen-256color-in-tmux-but-xterm-256color-without-tmux
C'est au sujet du terminal et des couleurs

# IDE

## QTCREATOR

### SETTINGS
Il faut faire/trouver un setting initial propre. 
Voir créer un setting/config lié au projet qu'on souhaite éditer.

### CATKIN/CMAKE

Faudrait voir aussi niveau "conflits" de compilation entre QtCreator et catkin tools. 
Faudrait être sur qu'ils ne marchent pas trop dessus.

### Update de CMakeLists.txt

Faut rajouter le script pour mettre à jour CMakeLists.txt pour une édition QtCreator (rajouter tous les fichiers, pas seulement ceux liés directement à la compilation (par exemple ajouter les messages ROS))

# VLP16

## Merge avec le dépôt officiel ROS
Il faudrait regarder pour merger le master de ros_velodyne avec le notre. 
Il y aura surement des conflits par rapport au travail qu'on a effectué pour la récupérer des timestamps du laser et ajustation de la vitesse de capture. Mais rien d'insurmontable j'imagine ^^

# ARDUINO

## Pb avec ROSSERIAL_ARDUINO et l'INS

Il y a un soucy avec rosserial_arduino et les messages qu'on a construit pour l'INS. rosserial n'arrive pas à importer/exporter les messages de notre (custom) package. 
Faudrait débugger, car on va avoir besoin d'un ou plusieurs messages de la centrale vers l'Arduino pour l'interfacer avec le laser (entre autre).

# INS

Faudrait travailler (continuer) sur la fusion des messages (filter) pour construire des messages imu au sens ROS avec ceux qu'on récupère (brutes) de la centrale et notre driver ROS => Il manque une étape de fusion de messages (+ synchronisation) pour avoir des messages vraiment ROS pour une centrale inertielle.

-------------------------------

#2017-03-06#

# Performance

Temps pour compiler une image avec le projet LI3DS

./pipeline.sh project1  0,20s user 0,16s system 0% cpu 10:01,78 total
=> ~ 10 minutes

Ca ne prend pas en compte le temps de build de l'image de base (outils de dev, ROS Indigo (version de base niveau packages)).

# QtCreator
Pas mal de boulot sur la mise en place des settings.
Faudrait poursuivre et finaliser.

Faudrait revoir comment bien configurer le parallèlisme lors de la compilation (pour l'instant c'est un setting manuel 'make -j3' en argument pour le step make dans QrCreator)
Pareil pour catkin tools, faut bien stabiliser cet aspect ! (Argument CMake transmis à catkin, normalement on a documenté cet feature).

# ST3
Il reste pas mal de travail sur ce package !

# ROSSERIAL + ARDUINO

Réussi finalement à gérer l'import d'un custom package.
J'ai modifié le package ros_arduino pour inclure un message (directement copié dans le package ros_arduino) de la centrale 'SbgLogGpsPos'.[msg]
Recompilation du package, et il semblerait qu'il faille supprimer (manuellement) le répertoire 'ros_lib' quelque part dans 'build' (de catkin_ws).
Faudrait revoir cet aspect et le documenter.
Faut faire gaffe de bien utiliser le header générer par rosserial et non pas celui générer par message génération ... A documenter !!!
