install:
	mysql -uroot -proot -e 'CREATE DATABASE IF NOT EXISTS `{PACKAGE_NAME}`'
	npm set progress=false && npm install
	if [ ! -f dist/index.php ]; then make wordpress; fi;
	make build

watch:
	npm run craffft

build:
	npm run craffft:build

compile:
	npm run craffft:compile

debug:
	npm run craffft:compile:log

wordpress:
	cd dist && rm -rf wp-{a*,b*,comun*,cont*,cr*,config-s*,i*,l*,m*,s*,t*} xmlrpc.php in* lic* lie* rea* wor*
	curl -k https://de.wordpress.org/latest-de_DE.zip -o dist/wordpress.zip
	cd dist && unzip wordpress.zip
	cd dist && rm ./wordpress/wp-config-sample.php
	cd dist && mv -n ./wordpress/* .
	if [ ! -f dist/local-config.php ]; then php dist/local-config-generator.php; fi;
	cd dist && rm -rf wordpress readme.html liesmich.html license.txt wordpress.zip wp-content/themes/twenty*
	make wordpress_plugins_install
	find ./dist -name '__MACOSX' -exec rm -rv {} \; || true
	find ./dist -name '.DS_Store' -exec rm -v {} \; || true

wordpress_plugins_dump:
	find ./dist -name '__MACOSX' -exec rm -rv {} \; || true
	find ./dist -name '.DS_Store' -exec rm -v {} \; || true
	rm -rf ./resources/plugins/*.zip
	cd ./dist/wp-content/plugins && for d in ./*; do zip -rq ./../../../resources/plugins/$$d.zip $$d; done

wordpress_plugins_install:
	rm -rf ./dist/wp-content/plugins/*
	for f in ./resources/plugins/*.zip; do unzip -q $$f -d ./dist/wp-content/plugins; done || true

db_dump:
	wp db export /vagrant/sql/initial.sql

db_import:
	wp db reset --yes
	wp db import /vagrant/sql/initial.sql
