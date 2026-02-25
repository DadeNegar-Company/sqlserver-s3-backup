#!/bin/bash
# Mock sqlcmd
ARGS="$@"

# Check for -P flag (password exposure)
if echo "$ARGS" | grep -q -- "-P"; then
  echo "SECURITY FAIL: Password passed via command line arguments!" >&2
  exit 1
fi

# Check if SQLCMDPASSWORD env var is set
if [ -z "$SQLCMDPASSWORD" ]; then
  echo "SECURITY FAIL: SQLCMDPASSWORD environment variable not set!" >&2
  exit 1
fi

# Check for insecure input files
# We scan arguments for -i /tmp/...
# Note: This is a simple check. We iterate through args to find -i and check the next one.
args_array=($ARGS)
for ((i=0; i<${#args_array[@]}; i++)); do
  if [ "${args_array[$i]}" == "-i" ]; then
    input_file="${args_array[$i+1]}"
    if [[ "$input_file" == /tmp/* ]]; then
      echo "SECURITY FAIL: Input file is in /tmp/! Use process substitution to avoid writing secrets to disk." >&2
      exit 1
    fi
  fi
done

echo "MOCK SQLCMD SUCCESS"
exit 0
