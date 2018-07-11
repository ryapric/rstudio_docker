#! /usr/bin/env sh
set -e

# Specify rocker/tidyverse image
R_version="3.5.0"
rocker_image="rocker/tidyverse:${R_version}"

# Specify docker_run script to iteratively build
docker_run="/tmp/docker_run.sh"

# Specify image homedir to mount to
rstudio_home="/home/rstudio"

# RStudio Server port binding
rstudio_port="8787"

# Specify Docker volume for R libraries
rocker_lib="rocker_lib_${R_version}"

# Specify what the RStudio image uses as its R library
rstudio_lib="/usr/local/lib/R/site-library"



# Pull docker image
docker pull $rocker_image

# Stop & Remove container, if running
docker stop rstudio || true && docker rm rstudio || true >/dev/null

# Add first block to docker_run script, and mount homedir
printf "Mounting local homedir...\n"
echo -n "
docker run \\
    -ti \\
    -d \\
    -p ${rstudio_port}:${rstudio_port} \\
    --name=rstudio \\
    --mount \\
        type=bind,source=\"${HOME}\",target=\"${rstudio_home}\" \\" > "$docker_run"

# Mount a volume for the R libraries (will be created if not existing)
echo -n "
-v ${rocker_lib}:${rstudio_lib} \\" >> "$docker_run"

# Run prepared container
echo "$rocker_image" >> "$docker_run"
sh "$docker_run"

printf "\nRStudio server running on localhost:${rstudio_port}\n"
printf "Username and password are both 'rstudio'\n"

exit 0
