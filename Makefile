all:
	@jbuilder build @install @DEFAULT

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

.PHONY: clean all dev bench test check install uninstall

clean:
	jbuilder clean
