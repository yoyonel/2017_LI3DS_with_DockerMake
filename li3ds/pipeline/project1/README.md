2017-04-05

# Outils pour ROSBAG

## bagedit

url: https://bitbucket.org/daniel_dube/bagedit/wiki/Home

### Installation

Il faut passer par Mercurial:
```
hg clone https://daniel_dube@bitbucket.org/daniel_dube/bagedit
cd bagedit
export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH
make
```

### Utilisation

```
rosrun bagedit badmerge.py --help
```
