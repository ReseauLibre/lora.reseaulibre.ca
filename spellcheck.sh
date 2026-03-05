#!/bin/sh

lang="$1"

if ! dpkg-query --show aspell aspell-"$lang" >/dev/null; then
    apt-get update && apt-get install -y aspell aspell-"$lang"
fi

aspell="aspell --mode=markdown --lang=$lang --home-dir=. --personal=aspell.$lang.pws --encoding=utf-8"

find -name "*.md" | while read path; do
    echo "spellchecking $path..."
    if $aspell list < "$path" | grep .; then
        echo "found above misspelled in $path"
        echo "run aspell with: $aspell check $path"
        exit 1
    fi
done

echo "all checked language $lang"
