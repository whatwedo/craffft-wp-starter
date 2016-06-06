#!/bin/bash
######################################
#                                    #
# starts a Craffft WordPress project #
#                                    #
######################################

# Configuration
REPO_URL="https://raw.githubusercontent.com/whatwedo/craffft-wp-starter/master/templates/"


echo "Geben Sie einen Projektnamen, z.B. \"whatwedo Webseite\""
read PROJECT_NAME
echo " "

echo "Geben Sie einen Paketnamen für das Projekt ein, z.B. \"whatwedo-website\""
read PACKAGE_NAME
echo " "

echo "Geben Sie die öffentliche Adresse (mit Protokoll) für das Projekt ein, z.B. \"https://whatwedo.ch\""
read PUBLIC_ADDRESS
echo " "

echo "Geben Sie die lokale Adresse für das Projekt ein, z.B. \"whatwedo.dev\""
read LOCAL_ADDRESS
echo " "

echo "Geben Sie eine Beschreibung für das Projekt ein, z.B. \"WordPress Template und Logik der Webseite von whatwedo GmbH\""
read DESCRIPTION
echo " "

echo "WordPress Seitenname, z.B. \"whatwedo.ch\""
read WP_NAME
echo " "

echo "WordPress Admin-Benutzername"
read WP_USERNAME
echo " "

echo "WordPress Admin-Passwort"
read WP_PASSWORD
echo " "

echo "WordPress Admin E-Mail"
read WP_EMAIL
echo " "


echo " "
echo "-----------------------------"
echo " Das Projekt wird generiert. "
echo "-----------------------------"
echo " "

# Project structure
echo "- Erstelle Projektstruktur"
mkdir -p dist
mkdir -p resources/plugins
mkdir -p resources/themes
mkdir -p sql
mkdir -p src/wp-content/themes/$PACKAGE_NAME
touch resources/plugins/.gitkeep
touch resources/themes/.gitkeep
touch sql/.gitkeep

# config files
echo "- Erstelle Vagrantfile"
curl -s https://raw.githubusercontent.com/whatwedo/Vaprobash/develop/Vagrantfile -o Vagrantfile
sed -i.bak s/vaprobash\.dev/${LOCAL_ADDRESS}/ Vagrantfile # replace vaprobash.dev with LOCAL_ADDRESS
sed -i.bak s/^public_folder.*$/public_folder\ =\ \"\\/vagrant\\/dist\"/ Vagrantfile # replace public_folder with /vagrant/dist
sed -i.bak 's/\(\s*\)#\(.*\)php\.sh/\1\2php\.sh/' Vagrantfile # provision php
sed -i.bak 's/\(\s*\)#\(.*\)apache\.sh/\1\2apache\.sh/' Vagrantfile # provision apache
sed -i.bak 's/\(\s*\)#\(.*\)mysql\.sh/\1\2mysql\.sh/' Vagrantfile # provision mysql
sed -i.bak 's/\(\s*\)#\(.*\)nodejs\.sh/\1\2nodejs\.sh/' Vagrantfile # provision nodejs
sed -i.bak 's/\(\s*\)#\(.*\)wp-cli\.sh/\1\2wp-cli\.sh/' Vagrantfile # provision wp-cli
rm Vagrantfile.bak

echo "- Weitere Daten"
declare -a FILES
FILES=(
    ".gitignore"
    ".jshintrc"
    ".editorconfig"
    "CHANGELOG.md"
    "Dockerfile"
    "Makefile"
    "README.md"
    "craffft-config.json"
    "jsconfig.json"
    "package.json"
    "tsconfig.json"
    "tsd.json"
    "vm-init.sh"
    "dist/local-config-generator.php"
    "dist/wp-config.php"
)


declare -A REPLACES
REPLACES=(
    [{PROJECT_NAME}]=${PROJECT_NAME}
    [{PACKAGE_NAME}]=${PACKAGE_NAME}
    [{LOCAL_ADDRESS}]=${LOCAL_ADDRESS}
    [{DESCRIPTION}]=${DESCRIPTION}
)

for f in ${FILES[@]}
do
    echo "-- ${f}"
    curl -s "$REPO_URL$f" -o "$f"
    # Loop the config array
    for i in "${!REPLACES[@]}"
    do
        search=$i
        replace=${REPLACES[$i]}
        # Note the "" after -i, needed in OS X
        sed -i.bak "s/${search}/${replace}/g" $f
        
    done
    rm $f.bak
done

# add template files
cat << THEMECSS > src/wp-content/themes/$PACKAGE_NAME/style.css
/*!
Theme Name: ${PROJECT_NAME}
Theme URI: ${PUBLIC_ADDRESS}
Author: whatwedo GmbH
Author URI: https://whatwedo.ch
Version: 1.0
Text Domain: ${PACKAGE_NAME}
*/

THEMECSS

echo "- starte Vagrant"

vagrant up 

echo "- installiere WordPress und Abhängigkeiten"

vagrant ssh -c 'cd /vagrant && npm install craffft --save-dev && make install'

echo "- konfiguriere WordPress"

vagrant ssh -c "cd /vagrant/dist && wp core install --url='http://${LOCAL_ADDRESS}/' --title='${PROJECT_NAME}' --admin_user='${WP_USERNAME}' --admin_password='${WP_PASSWORD}' --admin_email='${WP_EMAIL}' --skip-email"

echo " "
echo "----------------------------"
echo " Erfolgreich abgeschlossen. "
echo "----------------------------"
echo " "

rm -- "$0"
