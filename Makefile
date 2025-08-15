# list of subdirectories containing a Dockerfile
SUBDIRS := $(shell find . -type f -name Dockerfile -exec dirname {} \;)

all: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@

clean:
	for dir in $(SUBDIRS); do \
			$(MAKE) -C $$dir clean; \
	done
	rm -rf debian/refplat-images-docker
	cd BUILD && dh_clean

.PHONY: all build clean $(SUBDIRS)

deb:
	cd BUILD && dpkg-buildpackage --build=binary --no-sign --no-check-builddeps

definitions:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir definitions; \
	done
