#!/usr/bin/env bash
echo ' i will NOT delete entire groups , and i will delete only octet-stream existing files now executing on : --> '$1

FILETODELETE=$1
export STORAGE_GROUP=bkstorage
export FILE_TRIMMED="$(echo -e "${FILETODELETE}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
COMMAND="swift --os-auth-token ${OSTK}  --os-storage-url ${OSURL}"


[  $(echo -ne "${FILE_TRIMMED}" | wc -m) -gt 0 ] || {
echo 'invalid filename length for  : '${FILE_TRIMMED}
exit 1
}

CONTENTTYPE=$($COMMAND stat $STORAGE_GROUP ${FILE_TRIMMED} | grep 'Content Type' )
echo 'content type = '$CONTENTTYPE

export CONTENTTYPE_TRIMMED="$(echo -e "${CONTENTTYPE}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

[  $(echo -ne "${CONTENTTYPE_TRIMMED}" | wc -m)  -gt 0 ] && [[ "${CONTENTTYPE_TRIMMED}" =~ ^.*octet-stream.*$ ]] || {
echo 'invalid length / content for  : '${CONTENTTYPE_TRIMMED}
exit 1
}
# execute deletion
$COMMAND delete "$STORAGE_GROUP" "${FILE_TRIMMED}"
exit 0

