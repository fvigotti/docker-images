#!/bin/bash

set -x

# PROVIDED VARS

JDK_LOCAL_DESTINATION=${JDK_LOCAL_DESTINATION-"/usr/java/src/"}
TGZ_SOURCES_path=${TGZ_SOURCES_path-"http://download.oracle.com/otn-pub/java/jdk/8u45-b14/"}
TGZ_SOURCES_filename=${TGZ_SOURCES_filename-"jdk-8u45-linux-x64.tar.gz"}
JDK_EXPECTED_MD5="1ad9a5be748fb75b31cd3bd3aa339cac"

# derived values
JDK_VERSION=$(echo $TGZ_SOURCES_filename | sed 's/\(jdk-\)\([^\-]*\)-\(.*\)/\2/')
echo 'extracted jdk version : '$JDK_VERSION
VERSION_DESTINATION=${JDK_LOCAL_DESTINATION}/$JDK_VERSION
JDK_TGZ_FULL_LOCAL_PATH="${JDK_LOCAL_DESTINATION}/${TGZ_SOURCES_filename}"
JDK_TGZ_FULL_REMOTE_PATH="${TGZ_SOURCES_path}/${TGZ_SOURCES_filename}"
JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH="${JDK_LOCAL_DESTINATION}/${JDK_VERSION}"
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
    [ -f "${JDK_TGZ_FULL_LOCAL_PATH}" ] || download_sources
}

download_sources() {
    export DOWNLOAD_ATTEMPT_COUNT=$((DOWNLOAD_ATTEMPT_COUNT+1))
    /usr/bin/wget -O ${JDK_TGZ_FULL_LOCAL_PATH} --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "${JDK_TGZ_FULL_REMOTE_PATH}"
}

exitONFatalError() {
msg=$1
exitVal=$2
echo $msg
echo $msg >&2
exit $exitVal
}

validate_sources() {
    [ -z "$JDK_EXPECTED_MD5" ] && {
         echo "md5 value not provided , skipping check "
         return 0
    }

if ! check_md5 $JDK_TGZ_FULL_LOCAL_PATH $JDK_EXPECTED_MD5; then
  echo '[WARNING] checksum validation failed for the downloaded archive, retrying download...!'

  [ "$DOWNLOAD_ATTEMPT_COUNT" -lt "2" ] || exitONFatalError '[FATAL] too many download attempts, exiting!' 3
  download_sources

  if ! check_md5 $JDK_TGZ_FULL_LOCAL_PATH $JDK_EXPECTED_MD5; then
    exitONFatalError '[FATAL] checksum validation failed for the downloaded archive, exiting!' 2
  fi
fi

}

extract_sources() {
    mkdir -p $JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH
    echo 'extracting archive to : '$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH
    tar -xzvf $JDK_TGZ_FULL_LOCAL_PATH -C $JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH  --strip-components=1
}

# file copyed from webupd8-oracle-ppa-installer created files
update_profiled_envs(){
dst_csh="/etc/profile.d/jdk.csh"
dst_sh="/etc/profile.d/jdk.sh"
echo 'setenv J2SDKDIR '$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH > $dst_csh
echo 'setenv J2REDIR '$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/jre' >> $dst_csh
echo 'setenv PATH ${PATH}:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/bin:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/db/bin:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/jre/bin' >> $dst_csh
echo 'setenv JAVA_HOME '$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'' >> $dst_csh
echo 'setenv DERBY_HOME '$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/db' >> $dst_csh

echo 'export J2SDKDIR='$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH > $dst_sh
echo 'export J2SDKDIR='$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH >> $dst_sh
echo 'export J2REDIR='$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/jre' >> $dst_sh
echo 'export PATH=$PATH:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/bin:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/db/bin:'$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/jre/bin' >> $dst_sh
echo 'export JAVA_HOME='$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'' >> $dst_sh
echo 'export DERBY_HOME='$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH'/db' >> $dst_sh

}

update_alternatives(){


for f in $(find "$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH/bin" -type f -maxdepth 1 -regex "[^.]*")
do
 filenameOnly=$(basename $f)
 echo "Processing $f -- $filenameOnly"
 update-alternatives --install "/usr/bin/$filenameOnly" "$filenameOnly" "$f" "1"
done


}

[ -d "$JDK_LOCAL_DESTINATION" ] || mkdir -p $JDK_LOCAL_DESTINATION
[ -d "$JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH" ] || mkdir -p $JDK_EXTRACTEDSOURCES_FULL_LOCAL_PATH

download_sources_if_necessary
validate_sources

extract_sources
update_profiled_envs
update_alternatives

