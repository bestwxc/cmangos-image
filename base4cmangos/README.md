# base4cmangos


### 1. Usage
``` bash 
sudo sh build.sh 1.0.0
sudo sh build.sh 1.0.0 classic
sudo sh build.sh 1.0.0 tbc
# Didn't build the image of wotlk because of without the maps data files.
sudo sh build.sh 1.0.0 wotlk
```

### 2. project ignore the maps files
the size of the maps files was large, so i didn't commit to the project.
If you want to build the image yourself, please prepare the maps files(tar with gzip) and put in the folder.

### 3. project structure
```
-- project folder
 |-- build.sh
 |-- README.md
 |-- Dockerfile
 |-- classic-maps.tgz(ignore)
 |-- tbc-maps.tgz(ignore)
 |-- tbc-maps.tgz(without)
```  


