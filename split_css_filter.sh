#!/bin/bash

is_css_filter() {
  local rule="$1"

  if [[ -z "$rule" || "$rule" =~ ^[[:space:]]*$ ]]; then
    return 1 # false
  fi

  if [[ "$rule" == *'##'* ]]; then
    return 0 # true
  fi

  if [[ "$rule" == *'###'* ]]; then
    return 0 # true
  fi

  if [[ "$rule" == *'#?#'* || "$rule" == *'#@#'* ]]; then
    return 0 # true
  fi

  return 1
}

INPUT_FILE="$1"
CSS_FILTER_OUTPUT="css.filter"
URL_FILTER_OUTPUT="url.filter"

> "$CSS_FILTER_OUTPUT"
> "$URL_FILTER_OUTPUT"

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "'$INPUT_FILE' is not exist"
  exit 1
fi

while IFS= read -r line; do
  # skip comment of filter
  if [[ "$line" =~ ^! ]] || \
     [[ -z "$line" ]] || \
     [[ "$line" =~ ^[[:space:]]*# ]]; then
    continue
  fi

  if is_css_filter "$line"; then
    echo "$line" >> "$CSS_FILTER_OUTPUT"
  else
    echo "$line" >> "$URL_FILTER_OUTPUT"
  fi
done < "$INPUT_FILE"
echo "DONE"