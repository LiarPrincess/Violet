# cSpell:ignore xcodeproj

SWIFT_BUILD_FLAGS_RELEASE=--configuration release

.PHONY: all
all: build

# ==================
# == Usual things ==
# ==================

.PHONY: build build-r
.PHONY: run run-r
.PHONY: test
.PHONY: pytest pytest-r
.PHONY: clean

build:
	swift build

build-r:
	swift build $(SWIFT_BUILD_FLAGS_RELEASE)

run:
	swift run Violet

run-r:
	swift run Violet $(SWIFT_BUILD_FLAGS_RELEASE)

test:
	swift test

pytest:
	swift run PyTests

# Hmm…
# '--configuration=release' does work on Ubuntu 21.4 (Swift 5.4.2),
# but it does not work on macOS 10.15.6 (Swift 5.3 from Xcode) - somehow it will
# still use 'debug'.
# But you can create a new scheme in Xcode and it will work. Whatever…
pytest-r:
	swift run PyTests $(SWIFT_BUILD_FLAGS_RELEASE)

clean:
	swift package clean

# =====================
# == Code generation ==
# =====================

.PHONY: elsa ariel gen unicode

elsa:
	swift run Elsa

ariel:
	./Scripts/ariel_output/create_files.sh

gen:
	./Sources/Objects/Generated/run.sh
	@echo
	./Scripts/unimplemented_builtins/refresh.sh
	@echo
	./PyTests/generate_tests.sh

unicode:
	./Scripts/unicode/main.sh

# =================
# == Lint/format ==
# =================

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

# ===========
# == Xcode ==
# ===========

.PHONY: xcode

xcode:
	swift package generate-xcodeproj
	@echo ''
	@echo 'Remember to add SwiftLint build phase!'
	@echo 'See: https://github.com/realm/SwiftLint#xcode'
