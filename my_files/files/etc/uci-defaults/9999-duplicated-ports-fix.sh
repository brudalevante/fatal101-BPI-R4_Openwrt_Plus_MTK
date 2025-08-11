#!/bin/sh

FILE_PATH="/etc/board.json"

if [ ! -f "$FILE_PATH" ]; then
    exit 1
fi

if awk 'NR==55 { if ($0 ~ /"eth2"|"wan"/) exit 0; else exit 1 }' "$FILE_PATH"; then

    sed -i -e '39d' -e '40d' -e '41d' -e '42d' -e '52d' -e '53d' "$FILE_PATH"

    exit 0
else

    exit 0
fi

exit 0
