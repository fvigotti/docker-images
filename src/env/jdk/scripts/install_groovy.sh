#!/bin/bash

set -x

# PROVIDED VARS

GROOVY_LOCAL_DESTINATION=${GROOVY_LOCAL_DESTINATION-"/usr/groovy/src"}
GROOVY_TGZ_SOURCES_path=${GROOVY_TGZ_SOURCES_path-"http://bintray.com/artifact/download/groovy/maven/"}
GROOVY_TGZ_SOURCES_filename=${GROOVY_TGZ_SOURCES_filename-"groovy-binary-2.4.3.zip"}
#GROOVYTGZ_EXPECTED_MD5="d41d8cd98f00b204e9800998ecf8427e"

# derived values
GROOVY_VERSION=$(echo $GROOVY_TGZ_SOURCES_filename | sed 's/\(groovy-binary-\)\(.*\)\.zip/\2/')
echo 'extracted jdk version : '$GROOVY_VERSION
VERSION_DESTINATION=${GROOVY_LOCAL_DESTINATION}/$GROOVY_VERSION
GROOVY_TGZ_FULL_LOCAL_PATH="${GROOVY_LOCAL_DESTINATION}/${GROOVY_TGZ_SOURCES_filename}"
GROOVY_TGZ_FULL_REMOTE_PATH="${GROOVY_TGZ_SOURCES_path}/${GROOVY_TGZ_SOURCES_filename}"
GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH="${GROOVY_LOCAL_DESTINATION}/groovy-${GROOVY_VERSION}"
#JDK_EXTRACTEDSOURCES_FULL_LOCAL_TMP_PATH="${JDK_LOCAL_DESTINATION}/${JDK_VERSION}_tmp"

export DOWNLOAD_ATTEMPT_COUNT=0



echo 'VERSION_DESTINATION : '$VERSION_DESTINATION

check_md5() {
    fileToCheck=$1
    expectedMd5=$2

    currentMd5=$(md5sum "$fileToCheck" | awk '{ print $1 }')
    [ "$currentMd5" == "$expectedMd5" ] && {
    return  0
    } || {
    echo '[ERROR] invalid md5 ! expected : '$expectedMd5' , got : '$currentMd5
    return 1
    }
}
#check_md5 'jdk-8u45-linux-x64.tar.gz' '1ad9a5be748fb75b31cd3bd3aa339cac' && echo ok || echo "not"

download_sources_if_necessary() {
    [ -f "${GROOVY_TGZ_FULL_LOCAL_PATH}" ] || download_sources
}

download_sources() {
    export DOWNLOAD_ATTEMPT_COUNT=$((DOWNLOAD_ATTEMPT_COUNT+1))
    /usr/bin/wget -O ${GROOVY_TGZ_FULL_LOCAL_PATH} "${GROOVY_TGZ_FULL_REMOTE_PATH}"
}

exitONFatalError() {
msg=$1
exitVal=$2
echo $msg
echo $msg >&2
exit $exitVal
}

validate_sources() {
    [ -z "$GROOVYTGZ_EXPECTED_MD5" ] && {
         echo "md5 value not provided , skipping check "
         return 0
    }

if ! check_md5 $GROOVY_TGZ_FULL_LOCAL_PATH $GROOVYTGZ_EXPECTED_MD5; then
  echo '[WARNING] checksum validation failed for the downloaded archive, retrying download...!'

  [ "$DOWNLOAD_ATTEMPT_COUNT" -lt "2" ] || exitONFatalError '[FATAL] too many download attempts, exiting!' 3
  download_sources

  if ! check_md5 $GROOVY_TGZ_FULL_LOCAL_PATH $GROOVYTGZ_EXPECTED_MD5; then
    exitONFatalError '[FATAL] checksum validation failed for the downloaded archive, exiting!' 2
  fi
fi

}

extract_sources() {
    echo 'extracting archive to : '$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH
    #unzip $GROOVY_TGZ_FULL_LOCAL_PATH -d $GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH
    unzip $GROOVY_TGZ_FULL_LOCAL_PATH -d "$GROOVY_LOCAL_DESTINATION"
#    [ ! -d $GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH ] || {
#    ls -lar $GROOVY_LOCAL_DESTINATION/*
#    exitONFatalError '[FATAL] groovy destination directory already exists!' 4
#    }
#    mv "$GROOVY_LOCAL_DESTINATION/groovy-${GROOVY_VERSION}" $GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH
    #tar -xzvf $GROOVY_TGZ_FULL_LOCAL_PATH -C $GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH  --strip-components=1
}

# file copyed from webupd8-oracle-ppa-installer created files
update_profiled_envs(){
dst_csh="/etc/profile.d/groovy.csh"
dst_sh="/etc/profile.d/groovy.sh"
echo 'setenv GROOVY_HOME '$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH > $dst_csh
echo 'setenv PATH ${PATH}:'$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/bin' >> $dst_csh

echo 'export GROOVY_HOME='$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH > $dst_sh
echo 'export PATH=$PATH:'$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/bin' >> $dst_sh

}

update_alternatives(){

# for files that doesn't have a dot in the name (because the dirname contain dots , awk is used to parse a regexp only on filename )
for f in $(find "$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH/bin" -maxdepth 1 -type f | awk '$1 ~ "^.*/[a-zA-Z0-9]*$" {print $1} ')
do
 filenameOnly=$(basename $f)
 echo "Processing $f -- $filenameOnly"
 update-alternatives --install "/usr/bin/$filenameOnly" "$filenameOnly" "$f" "1"
done


}

[ -d "$GROOVY_LOCAL_DESTINATION" ] || mkdir -p $GROOVY_LOCAL_DESTINATION
#[ -d "$GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH" ] || mkdir -p $GROOVY_EXTRACTEDSOURCES_FULL_LOCAL_PATH

download_sources_if_necessary
validate_sources

extract_sources
update_profiled_envs
update_alternatives

