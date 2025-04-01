DEST:=../cml-definitions/virl-base-images
TAG := $(shell echo $(VERSION) | tr '[:upper:]~' '[:lower:]-')
NTAG:=$(NAME)-$(TAG)
DNT:=$(DEST)/$(NTAG)

.PHONY: definitions
definitions: $(DNT)
	sha256=`docker image inspect -f '{{ index .Id }}' $(NTAG) | cut -d':' -f2)` && \
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

$(DNT):
	mkdir -p $@
