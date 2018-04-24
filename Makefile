all: pack
	@jbuilder build @install @DEFAULT

pack:
	cd src && python pack_data.py > data.ml

lib: all
	cp _build/default/src/main.bc.js lib/elpi-worker.js \
	&& cp src/js/elpi-api.js lib/elpi-api.js \
	&& sed -i bak 's/require/req2uire/' lib/elpi-worker.js
# We need to rename require by something else in elpi-worker.js
# because it doesn't play well with Parcel.

#	&& cp _build/default/src/elpiAPI.bc.js lib/elpi-api.js

dev:
	rm lib/* && @jbuilder build @install @DEFAULT --dev

test:
	@jbuilder runtest

check: test

install:
	@jbuilder install

uninstall:
	@jbuilder uninstall

bench:
	@jbuilder build bench/bench.exe

doc:
	documentation build -f md src/js/elpi-api.js > doc.md

.PHONY: clean pack doc all dev bench test check install uninstall

clean:
	jbuilder clean
