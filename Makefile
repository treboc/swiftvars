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