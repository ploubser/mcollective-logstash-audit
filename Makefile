libdir = /usr/libexec/mcollective/mcollective

all: audit restart

audit:
	sudo cp audit/* $(libdir)/audit/

restart:
	sudo service mcollective restart
