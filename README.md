Spooler for an RStudio Container Instance
=========================================

The script included here, `rstudio.sh`, works to pull a version-stable R Docker
image (3.5.0) that includes some useful, portable utilities pre-compiled:

- The entire "tidyverse" of R packages (as well as the data.table package)
- RStudio Server (which will run & broadcast as a result of running the script)

System Requirements
-------------------

- [Docker](https://www.docker.com/community-edition)
- A Bourne-shell language interpreter (i.e. something that can interpret Bourne
shell scripts; Linux & macOS should have this functionality by default, but
Windows users will need something like [Git Bash](https://gitforwindows.org/))
- A web browser that you're comfortable with running the RStudio IDE in.

Why Isn't This a Dockerfile?
----------------------------

This is a shell script, and not a Dockerfile, because the actual local
deployment of the container is modified using some `docker run` options:

- Your local home directory is mounted as a [bind
mount](https://docs.docker.com/storage/bind-mounts/). This means that your
RStudio Server instance will have access to your SSH keys, Git repositories,
local credentials, etc., and any work done inside the container instance will
persist outside of it in a familiar location.

- A separate [Docker volume](https://docs.docker.com/storage/volumes/) is
mounted to the container at run ("rocker_lib_[ver]"). This volume serves as a
persistent library for R packages installed within the container. This takes a
bit more time during the very first container deployment, but after the first
run, the same packages need not be installed again. This is handled this way,
versus making another bind mount to the local R libraries, for several reasons:
  - Fighting with using a good, readable set of mount calls for each local R
library is gross, honestly
  - The container can have its own R library, which is version-stable with the R
version of the image. This library is isolated from the local machine as well as
other Docker volumes. Another benefit of this is that it allows *anyone* use
this script to set up a container and use R, and not just regular R users,
thereby removing the dependency of having local R libraries in advance.
