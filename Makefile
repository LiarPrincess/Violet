# cSpell:ignore workdir xcodeproj xcodebuild Xfrontend

SWIFT_BUILD_FLAGS_RELEASE=--configuration release

.PHONY: all
all: build

# ==================
# == Usual things ==
# ==================

.PHONY: build build-r
.PHONY: run run-r
.PHONY: test linuxmain
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

# For Swift 5.3. Use on macOS!
linuxmain:
	swift test --generate-linuxmain

pytest:
	swift run PyTests

# Hmm…
# '--configuration=release' does not work on macOS 10.15.6 (Swift 5.3 from Xcode),
# somehow it will still use 'debug'. But you can create a new scheme in Xcode.
#
# There are no such problems on Ubuntu 21.4 (Swift 5.4.2),
pytest-r:
	swift run PyTests $(SWIFT_BUILD_FLAGS_RELEASE)

clean:
	swift package clean

# ============
# == Docker ==
# ============

.PHONY: docker-test docker-pytest
.PHONY: docker-test-old docker-pytest-old

DOCKER_OPTIONS=--rm \
		--volume "$(PWD):$(PWD)" \
		--workdir "$(PWD)"

# https://hub.docker.com/_/swift/
DOCKER_LATEST=swift:latest
DOCKER_OLD=swift:5.3.2

docker-test:
	docker run $(DOCKER_OPTIONS) $(DOCKER_LATEST) bash -c 'make test'

docker-pytest:
	docker run $(DOCKER_OPTIONS) $(DOCKER_LATEST) bash -c 'make pytest-r'

docker-test-old:
	docker run $(DOCKER_OPTIONS) $(DOCKER_OLD) bash -c 'make test'

docker-pytest-old:
	docker run $(DOCKER_OPTIONS) $(DOCKER_OLD) bash -c 'make pytest-r'

# =====================
# == Code generation ==
# =====================

.PHONY: elsa ariel gen unicode

# Use 'Elsa' module to generate AST and bytecode data.
# It will use '.letitgo' files from 'Definitions' directory.
elsa:
	swift run Elsa

# Dump module interface (all of the open/public declarations).
ariel:
	./Documentation/Module exports/create_files.sh

# Generate code inside 'Objects' module.
# It will print detailed steps, which makes it a great way to learn how Violet
# works internally.
gen:
	./Sources/Objects/Generated/run.sh
	@echo
	./Tests/ObjectsTests/Generated/run.sh
	@echo
	./Scripts/unimplemented_builtins/refresh.sh
	@echo
	./PyTests/generate_tests.sh

# Generate Unicode database.
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
		"./Documentation/**" \
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

.PHONY: xcode xcode-compilation-time

xcode:
	swift package generate-xcodeproj
	@echo ''
	@echo 'Remember to add SwiftLint build phase!'
	@echo 'See: https://github.com/realm/SwiftLint#xcode'

# We don't care about compilation times.
# But it is fun to see how bad we are at this.
# https://github.com/fastred/Optimizing-Swift-Build-Times#slowly-compiling-files
xcode-compilation-time:
	xcodebuild \
		-project "Violet.xcodeproj" \
		-scheme "Violet" \
		-configuration Debug \
		OTHER_SWIFT_FLAGS="-driver-time-compilation -Xfrontend -debug-time-function-bodies -Xfrontend -debug-time-compilation" \
		clean build > \
		compilation_times_raw.txt

	grep -E ^[1-9]{1}[0-9]*.[0-9]+ms compilation_times_raw.txt | \
		sort --numeric-sort --reverse > \
		compilation_times.txt
