SWIFT_BUILD_FLAGS=--configuration debug

.PHONY: all
all: build

# ------------------
# -- Usual things --
# ------------------

.PHONY: build test clean

build:
	swift build $(SWIFT_BUILD_FLAGS)

test:
	swift test

clean:
	swift package clean

# ---------------------
# -- Code generation --
# ---------------------

.PHONY: elsa gen

elsa:
	swift run Elsa

gen:
	./Sources/Objects/Generated/run.sh
	./Scripts/unimplemented_builtins/main.sh

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
	cspell --config "./.cspell.json" "./Sources/Lexer/**"

# -----------
# -- Xcode --
# -----------

.PHONY: xcode

xcode:
	swift package generate-xcodeproj
	@echo ''
	@echo 'Remember to add SwiftLint build phase!'
	@echo 'See: https://github.com/realm/SwiftLint#xcode'
