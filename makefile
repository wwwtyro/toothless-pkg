
VERSION:=$(shell cat VERSION)
EDGE:=$(shell cat EDGE)

deb:
	make clean
	make toothless
	make node
	make stage-deb
	cd deb && \
	fpm \
		-s dir \
		-t deb \
		-n toothless \
		-v $(VERSION) \
		-d paprefs \
		-d lxc-docker-1.5.0 \
		--before-install pre-install.sh \
		--after-install post-install.sh \
		--before-upgrade pre-upgrade.sh \
		--after-upgrade post-upgrade.sh \
		--description "A service for launching native applications seamlessly from the browser." \
		opt etc
	mv deb/*.deb .
	make clean

edge:
	make clean
	make toothless-edge
	make node
	make stage-deb
	cd deb && \
	fpm \
		-s dir \
		-t deb \
		-n toothless-edge \
		-v $(EDGE) \
		-d paprefs \
		-d lxc-docker-1.5.0 \
		--before-install pre-install.sh \
		--after-install post-install.sh \
		--before-upgrade pre-upgrade.sh \
		--after-upgrade post-upgrade.sh \
		--description "A service for launching native applications seamlessly from the browser." \
		opt etc
	mv deb/*.deb .
	make clean

stage-deb:
	mkdir -p deb/opt/toothless
	mkdir -p deb/etc/init
	cp -r toothless/src/* deb/opt/toothless
	cp -r node deb/opt/toothless
	cp toothless.conf deb/etc/init
	cp deb-pre-install.sh deb/pre-install.sh
	cp deb-post-install.sh deb/post-install.sh
	cp deb-pre-upgrade.sh deb/pre-upgrade.sh
	cp deb-post-upgrade.sh deb/post-upgrade.sh
	cd deb/opt/toothless && node/bin/npm install

toothless:
	git clone git@github.com:wwwtyro/toothless.git

toothless-edge:
	git clone git@github.com:wwwtyro/toothless.git && cd toothless && git checkout develop

node: 
	mkdir node
	tar -xf node-v0.12.0-linux-x64.tar.gz -C node --strip-components=1

clean:
	rm -rf deb
	rm -rf toothless
	rm -rf node
