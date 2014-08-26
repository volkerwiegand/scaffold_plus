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
	sudo rake install


install: build
	git commit -a

build:
	git add lib

