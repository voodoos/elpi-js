dist: release-build
	dune install --prefix=dist

release-build:
	dune build -p elpi-js

clean:
	dune clean

.PHONY: dist clean release-build
