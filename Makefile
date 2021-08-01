dist: release-build
	dune install --prefix=demo

release-build:
	dune build -p elpi-js

dev:
	dune build

clean:
	dune clean

fmt:
	dune build @fmt --auto-promote

.PHONY: dist clean release-build fmt dev watch

watch:
	while true; do \
		make dist; \
		fswatch -1 src; \
	done
