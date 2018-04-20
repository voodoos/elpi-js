all: pack
	@jbuilder build @install @DEFAULT

pack:
	cd src && python pack_data.py > data.ml

lib: all
	cp _build/default/src/elpiJs.bc.js lib/elpi.js && cp src/js/* lib/

dev:
	@jbuilder build @install @DEFAULT --dev

test:
	@jbuilder runtest

check: test

install:
	@jbuilder install

uninstall:
	@jbuilder uninstall

bench:
	@jbuilder build bench/bench.exe

.PHONY: clean pack all dev bench test check install uninstall

clean:
	jbuilder clean
