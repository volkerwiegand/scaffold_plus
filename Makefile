# vim: set ts=8 tw=0 noet :
#
# Makefile for building the Gem
#

all: build
	git status

rel: build
	vim lib/scaffold_plus/version.rb
	git commit -a
	sudo gem uninstall scaffold_plus --all
	rake release


install: build
	git commit -a
	sudo gem uninstall scaffold_plus --all
	sudo rake install
	sudo rm -rf pkg

build:
	git add lib

