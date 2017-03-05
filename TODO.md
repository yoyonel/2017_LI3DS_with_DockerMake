# TODO

#2017-03-06#

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