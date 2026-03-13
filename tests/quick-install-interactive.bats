#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../quick-install-interactive.sh"
}

@test "quick-install-interactive --self-test returns OK" {
  run "$SCRIPT" --self-test
  [ "$status" -eq 0 ]
  [[ "$output" == *"Self-test OK"* ]]
}

@test "quick-install-interactive selections dry-run exits cleanly" {
  run "$SCRIPT" --dry-run --selections "1,3,5"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Dry-run mode: skipping installs and downloads."* ]]
}
