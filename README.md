# cmangos-image


### 1. starter
#### build classic
```
## image without maps
sh build.sh 20230204 classic simple
## image with maps
sh build.sh 20230204 classic full
## image with db sql
sh build.sh 20230204 classic db
```

#### build tbc
```
## image without maps
sh build.sh 20230204 tbc simple
## image with maps
sh build.sh 20230204 tbc full
## image with db sql
sh build.sh 20230204 classic db
```

#### build wotlk
```
## image without maps
sh build.sh 20230204 wotlk simple
## image with maps
sh build.sh 20230204 wotlk full
## image with db sql
sh build.sh 20230204 wotlk db
```

### 2. tips

1. use apt mirror in China default. Please change the mirror if not in China.
  - pass ATP_MIRROR in build.sh
  - change APT_MIRROR in Dockerfile

2. uncomment the docker push command in the build.sh when you need to push image to rep.

3. you can change the image_name_prefix in build.sh

