# Runs the tests on both targets.
test-all:
    gleam test
    gleam test --target javascript

# Review `birdie` snapshots.
review-snapshots:
    gleam run -m birdie
