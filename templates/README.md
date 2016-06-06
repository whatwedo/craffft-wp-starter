# {PROJECT_NAME}

{DESCRIPTION}

## Vagrant
Die Entwicklungsumgebung nutzt Vagrant. Vagrant erstellt eine virtuelle Umgebung mit allen Tools, welche zur Entwicklung benötigt werden

*Download:* https://www.vagrantup.com/downloads.html

### Vagrant Plugins

Zum einfacheren Einstieg nutzen wir einige Vagrant Plguins. Diese können wie nachfolgend installiert werden:

```
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-auto_network
vagrant plugin install vagrant-reload
vagrant plugin install vagrant-vbguest
```

## {LOCAL_ADDRESS}

Die Entwicklungsumgebung kann wie folgt gestartet werden:

```
vagrant up
vagrant ssh
sh ./vm-init.sh
´´´

Danach ist die Seite über [{LOCAL_ADDRESS}](http://{LOCAL_ADDRESS}) erreichbar.

# Entwicklung

Alle Befehle müssen in der Vagrant VM ausgeführt werden. Die Dateien liegen im Ordner `/vagrant`. In diese kann mit `vagrant ssh` gelangt werden.

## Deployment

Deployment wird mittels Docker automatisch beim Commit durchgeführt.


## Craffft

This projects uses [craffft](https://github.com/whatwedo/craffft) as build system. See corresponding repository for
further information and configuration options. At time of writing it's still in development. So please contribute any
fixes and feature ideas back to the origin.

### Requirements

* npm
* An editor or IDE supporting jsconfig, jshint, editorconfig, TypeScript and es2015 (es6) syntax.

### Install developer tools

* Run installation via terminal. This may take a while (around 300mb).

  ```
  $ make install
  ```

### Compile

* Run following command to start the watcher

  ```
  $ make compile
  ```

### Build

* Run following command to start a one time build with minified output

  ```
  $ make build
  ```
