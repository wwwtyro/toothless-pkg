
VERSION:=$(shell cat VERSION)

deb: stage-deb
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
	cp deb/*.deb .
	make clean

stage-deb: clean toothless node
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

node: 
	mkdir node
	tar -xf node-v0.12.0-linux-x64.tar.gz -C node --strip-components=1

clean:
	echo $(VERSION)
	rm -rf deb
	rm -rf toothless
	rm -rf node
	rm *.deb
