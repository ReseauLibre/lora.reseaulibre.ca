#!/bin/sh

set -e

lang="$1"

if ! dpkg-query --show aspell aspell-"$lang" >/dev/null; then
    apt-get update && apt-get install -y aspell aspell-"$lang"
fi

aspell="aspell --mode=markdown --lang=$lang --home-dir=. --personal=aspell.$lang.pws --encoding=utf-8"

find . -name "*.md" | grep -v \
  -e '/log.md$' \
  -e '/2026-08-26-wismesh-pocket-fire-hazard.md$' \
  -e '/hardware/index.md$' \
    | while read -r path; do
    echo "spellchecking $path..."
    if $aspell list < "$path" | grep .; then
        echo "found above misspelled in $path"
        echo "run aspell with: $aspell check $path"
        exit 1
    fi
done

echo "all checked language $lang"
