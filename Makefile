-include Dockerfile.mk

.DELETE_ON_ERROR:

.PHONY: build run debug tag push clean

.DEFAULT_GOAL := build

DOCKER ?= sudo docker
RELEASE ?= latest
REGISTRY ?= 
NAME ?= $(basename $(notdir $(PWD)))
BUILDTAG ?= $(addprefix $(addsuffix -,$(RELEASE)),$(USER))

ifeq ($(shell git ls-files --error-unmatch Dockerfile >/dev/null 2>&1 ; echo $$?), 0)
 build := $(shell git log --pretty=%h | wc -l)
 localchanges := $(shell git status --untracked-files --short --porcelain . | wc -l)
 ifneq ($(localchanges), 0)
  TAG ?= $(BUILDTAG)
 endif
endif

TAG ?= $(addsuffix $(addprefix -,$(build)),$(RELEASE))
image := $(NAME)$(addprefix :,$(TAG))
buildimage := $(NAME)$(addprefix :,$(BUILDTAG))
target := $(addprefix $(addsuffix /,$(REGISTRY)),$(image))

build : Dockerfile
	$(DOCKER) build --pull --rm \
		--build-arg RELEASE=$(RELEASE) \
		--tag=$(buildimage) \
		--label build.user=$(USER) \
		--label build.name=$(NAME) .

run :
	$(DOCKER) run --interactive --tty --rm $(buildimage)

debug :
	$(DOCKER) run --interactive --tty --rm --entrypoint=/bin/bash --user=0:0 $(buildimage)

tag : build
	-$(DOCKER) rmi --no-prune $(target)
	$(DOCKER) tag $(buildimage) $(target)

clean :
	-$(DOCKER) rmi --force $(buildimage)
	-$(DOCKER) rmi --force $(target)
	-$(DOCKER) images --quiet \
		--filter "label=build.user=$(USER)" \
		--filter "label=build.name=$(NAME)" \
		| xargs --no-run-if-empty $(DOCKER) rmi --force

ifdef REGISTRY
push : tag
	$(DOCKER) push $(target)
endif

