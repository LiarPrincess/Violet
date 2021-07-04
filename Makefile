# cSpell:ignore xcodeproj

SWIFT_BUILD_FLAGS=--configuration debug

.PHONY: all
all: build

# ------------------
# -- Usual things --
# ------------------

.PHONY: build run test pytest clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

run:
	swift run Violet

test:
	swift test

pytest:
	swift run PyTests

clean:
	swift package clean

# ---------------------
# -- Code generation --
# ---------------------

.PHONY: elsa gen unicode

elsa:
	swift run Elsa

gen:
	./Sources/Objects/Generated/run.sh
	./Scripts/unimplemented_builtins/main.sh

unicode:
	./Scripts/unicode/main.sh

# -----------------
# -- Lint/format --
# -----------------

.PHONY: lint format spell

# If you are using any other reporter than 'emoji' then you are doing it wrong...
lint:
	SwiftLint lint --reporter emoji

format:
	SwiftFormat --config ./.swiftformat "./Sources" "./Tests"

# cSpell is our spell checker
# See: https://github.com/streetsidesoftware/cspell/tree/master/packages/cspell
spell:
	cspell --no-progress --relative --config "./.cspell.json" \
		"./Sources/**" \
		"./Tests/**" \
		"./Lib/**" \
		"./PyTests/**" \
		"./Scripts/**" \
		"./Code of Conduct.md" \
		"./LICENSE" \
		"./Makefile" \
		"./Package.swift" \
		"./README.md"

# -----------
# -- Xcode --
# -----------

.PHONY: xcode

xcode:
	swift package generate-xcodeproj
	@echo ''
	@echo 'Remember to add SwiftLint build phase!'
	@echo 'See: https://github.com/realm/SwiftLint#xcode'
