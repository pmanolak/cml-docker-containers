BASE := ../BUILD/refplat-images-docker_all/var/lib/libvirt/images
DEST := $(BASE)/virl-base-images
NDEF := $(BASE)/node-definitions
TAG  := $(shell echo $(VERSION) | tr '[:upper:]~' '[:lower:]-')
NTAG := $(NAME)-$(TAG)
DNT  := $(DEST)/$(NTAG)

.PHONY: definitions
definitions: $(DNT)
	sha256=`docker image inspect -f '{{ index .Id }}' $(NAME):$(TAG) | cut -d':' -f2)` && \
  date=`date +"%Y%m%d"` && \
	cat ../templates/image-definition | sed \
		-e 's/{{DESCR}}/$(DESCR)/g' \
		-e 's/{{NAME}}/$(NAME)/g' \
		-e 's/{{VERSION}}/$(VERSION)/g' \
		-e 's/{{TAG}}/$(TAG)/g' \
		-e 's/{{NTAG}}/$(NTAG)/g' \
		-e "s/{{SHA256}}/$$sha256/g" \
	  -e "s/{{DATE}}/$$date/" \
	>$(DNT)/$(NTAG).yaml
	cp node-definition $(NDEF)/$(NAME).yaml

$(DNT):
	mkdir -p $@
