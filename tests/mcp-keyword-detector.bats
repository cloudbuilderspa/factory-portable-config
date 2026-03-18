#!/usr/bin/env bats

setup() {
  SCRIPT="${BATS_TEST_DIRNAME}/../hooks/mcp-keyword-detector.py"
}

@test "detects aws pricing and aws knowledge for pricing prompts" {
  run python3 "$SCRIPT" <<< '{"prompt":"AWS Lambda pricing"}'
  [ "$status" -eq 0 ]
  [[ "$output" == *"AWS-PRICING"* ]]
  [[ "$output" == *"AWS-KNOWLEDGE"* ]]
  [[ "$output" == *"pricing documentation"* ]]
}

@test "detects aws knowledge without pricing for service prompts" {
  run python3 "$SCRIPT" <<< '{"prompt":"Lambda function timeout"}'
  [ "$status" -eq 0 ]
  [[ "$output" == *"AWS-KNOWLEDGE"* ]]
  if [[ "$output" == *"AWS-PRICING"* ]]; then
    false
  fi
}

@test "detects playwright keyword" {
  run python3 "$SCRIPT" <<< '{"prompt":"run playwright screenshot"}'
  [ "$status" -eq 0 ]
  [[ "$output" == *"PLAYWRIGHT"* ]]
}

@test "no output when no keywords are present" {
  run python3 "$SCRIPT" <<< '{"prompt":"hello world"}'
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
