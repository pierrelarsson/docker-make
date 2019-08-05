docker-make
===========
Simple Makefile to simplify the development of Docker(files).
The Makefile should be kept as clean and generic as possible.
Extra functionality should instead be added to a Dockerfile.mk within the docker project working directory.


Usage
-----
Create an alias eg. in your *.bashrc*, which runs make with this *Makefile* as argument.
```
alias dmake='make --makefile=~/src/docker-make/Makefile'
```

Targets
-------
### build
Builds the *Dockerfile* from the current working directory.

### run
Runs the image in foreground with default parameters.

### debug
Runs the image in foreground with a bash shell and root privileges.

### tag
Tags the image with the final tag.

### clean
Removes all previous versions of this image built by **you** from the system.

### push
Pushes the image to a remote repository (see the *REGISTRY* variable).


Environment variables
---------------------
Override these variables in a *Dockerfile.mk* file within your docker project working directory.

### DOCKER
The command used to run docker. Defaults to "sudo docker"

### RELEASE
Variable which can be used to build different releases/versions using the same *Dockerfile*.
This variable is passed into the Dockerfile at buildtime, as well as used when tagging the image.

### REGISTRY
Used to push image to a remote repository/hub-user. Defaults to *unset* which disables push:ing.

### NAME
Name of the image to build. Defaults to the current/working directory name.

### TAG
Possibility to override the image tag when pushing the image.
Defaults to the RELEASE variable suffixed with the git commit number (if applicable).

### BUILDTAG
Tag used when building the image. Defaults to the RELEASE variable suffixed with your username.


Notes
-----
If you have uncommited changes in your git working directory, the default TAG will be replaced by BUILDTAG instead.
This is to avoid you from pushing images upstream, which cannot be rebuilt later on.
