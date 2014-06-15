# vim: set ts=8 tw=0 noet :
#
# Makefile for building the Gem
#

all:
	git add lib
	vim lib/scaffold_plus/version.rb
	git commit -a
	rake release

