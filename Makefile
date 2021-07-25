dist: release-build
	dune install --prefix=dist

release-build:
	dune build -p elpi-js

dev:
	dune build

clean:
	dune clean

fmt:
	dune build @fmt --auto-promote

.PHONY: dist clean release-build fmt dev
