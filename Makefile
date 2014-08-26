# vim: set ts=8 tw=0 noet :
#
# Makefile for building the Gem
#

all: build
	git status

rel: build
	vim lib/scaffold_plus/version.rb
	git commit -a
	rake release
	sudo gem uninstall scaffold_plus --all
	sudo rake install


install: build
	git commit -a
	sudo gem uninstall scaffold_plus --all
	sudo rake install

build:
	git add lib

