dist: _build/default/src/main.bc.js
	dune install --prefix=dist

_build/default/src/main.bc.js:
	dune build -p elpi-js

clean:
	dune clean

.PHONY: dist clean
