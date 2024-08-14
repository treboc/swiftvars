build:
	swift build

update: 
	swift package update

release:
	swift build -c release
		
test:
	swift test --parallel

clean:
	rm -rf .build

install: release
	sudo install ./.build/release/swiftvars /usr/local/bin/swiftvars

uninstall:
	rm /usr/local/bin/swiftvars
