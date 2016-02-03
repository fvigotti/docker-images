# docker image with ubuntu and swift
  
## test with :
```
docker build -t fvigotti/app-swift ./src
```

## tips:
- set --os-auth-token  as environment variable : -e OSTK="token"
- set --os-storage-url as environment variable : -e OSURL="url"

# execute directly command using command shortcuts
`
docker run --rm -ti -e "OSTK=${OSTK}" -e "OSURL=${OSURL}"  fvigotti/app-swift s_ list
`
`
docker run --rm -ti -e "OSTK=${OSTK}" -e "OSURL=${OSURL}"  fvigotti/app-swift safeDelete_ testfileNotExist
`

# s_ command helper
execute swift command (it will only append the env variables to swift cli to avoid verbosity )

# safeDelete_ command helper
execute swift delete of the given file, avoiding the deletion of directories, inexistent files, files different from octet-stream type

  