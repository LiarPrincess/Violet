# What is this?

This script is used when updating [SwiftLint](https://github.com/realm/SwiftLint) version for the whole project.

It will:
1. Get all of the possible rules (`swiftlint rules` command).
2. Read `.swiftlint.yml` in root directory to check the rules mentioned there.
3. List all of the rules not mentioned in `.swiftlint.yml`.

With that information go to [SwiftLint/rule-directory](https://realm.github.io/SwiftLint/rule-directory.html) and read about every new rule deciding whether we want to enable it or not (the general rule is: enable everything that does not produce a lot of errors in already written code).
If the rule should not be enabled then it should be *commented* in config.

# How to run?

Run following in root directory:
> python3 ./Scripts/swiftlint_version_migration
