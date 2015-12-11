#!/usr/bin/env bash
#!/bin/bash
###############################################################################
# This script is inspired by
# http://www.devco.net/archives/2006/02/13/public_-_private_key_encryption_using_openssl.php
# and http://www.simplehelp.net/2009/02/19/adding-encryption-to-protect-your-backups-on-linux/
# Public/private key scheme works great if it can encrypt large files but unfortunately only
# file upto 1024 bytes can be encrypted using a public key. secret key scheme can deal with
# big files but the same key is used for encrypting and decrypting. Therefore the best practice
# to do is to combine these two methods together: encrypt data with the secret key (not to be
# confused with private key) then encrypt the secret key with public key. problem solved.
# file upto 1024 bytes can be encrypted using a public key. secret key scheme can deal with
# big files but the same key is used for encrypting and decrypting. Therefore the best practice
# to do is to combine these two methods together: encrypt data with the secret key (not to be
# confused with private key) then encrypt the secret key with public key. problem solved.
#### encrypt procedures
# [ 1 ] create a 200-byte random key
# [ 2 ] encrypt the destination (either a file or folder) then remove the original secret key
# [ 3 ] encrypt the scret key generated at step 1 with the public key
# [ 4 ] now the secret key and the data file are both encrypted


#### decrypt procedures
# [ 1 ] decrypt secret key with the private key
# [ 2 ] decrypt the data file with the decrypted secret key
# [ 3 ] delete secret key

#in order to use this script, a pair of public/private keys need to be created first:
# for example:
# $ mkdir ~/.ssl
# $ cd ~/.ssl
# $ openssl genrsa -out private.pem 4096
# $ chmod 600 private.pem
# $ openssl rsa -in private.pem -out public.pem -outform PEM -pubout
#
# the private key privated.pem should be stored in a secure location as once it's compromised,
# all the efforts to protect sensitive data will be useless.
# $Id: encdec.sh,v 1.1 2009/04/27 05:05:03 rico Exp $

declare -rx SCRIPT=${0##*/}
TMP=`mktemp -u -p . XXX`
TMP=${TMP##*/}
KEY=secret.$TMP.key
DEBUG=1

usage() {
    printf "usages:\n"
    printf "\t%s enc datafile public_key [ output_path ]\n" $SCRIPT
    printf "\t%s enc datadir/ public_key [ output_path ]\n" $SCRIPT
    printf "\t%s dec datafile.bf private_key [ output_path ]\n" $SCRIPT
}

if [ $# -lt 3 ]; then
    usage
    exit
fi

case $1 in
    enc)
        TIME_START=$(date "+%s")
        TARGET=$2
        TARGET=${TARGET%/}    #remove trailing / if any
        PUB_KEY=$3
        [ $# -gt 3 ] && OUT_DIR=$4 || OUT_DIR=.
        OUT_DIR=${OUT_DIR%/}    #remove trailing / if any
        ID=`mktemp -u -p . XXXX`
        ID=${ID##*/}
        OUTPUT=$OUT_DIR/${TARGET##*/}.bf.$ID
        [ ! -f $PUB_KEY -o ! -d $OUT_DIR ] && \
		printf "Check if $PUB_KEY or $OUT_DIR/ exists\n" && exit 151
        #make sure the key is only readable by the script owner
        touch $KEY && chmod 600 $KEY
        KEY=$OUT_DIR/secret.key.$ID
        ENC_KEY=$OUT_DIR/secret.key.rsa.$ID
        dd if=/dev/random of=$KEY bs=100 count=1
        #/usr/local/bin/genpass 40 > $KEY
        #encrypt the key
        G1="openssl rsautl -encrypt -inkey $PUB_KEY -pubin -in $KEY -out $ENC_KEY"
        [ $DEBUG -eq 1 ] && echo $G1
        eval $G1
        G="tar -zcf - $TARGET|openssl enc -blowfish -pass file:$KEY|dd of=$OUTPUT"
        [ $DEBUG -eq 1 ] && echo $G || echo "Encrypting ..."
        eval $G && rm -f $KEY
        TIME_END=$(date "+%s")
        SECONDS_SPENT=$(expr $TIME_END - $TIME_START)
        printf "Encryption Summary:\n"
        printf "\tData: %s\n" $OUTPUT
        printf "\tEncrypted Key: %s\n" $ENC_KEY
        printf "\tTotal Time Elapsed: $SECONDS_SPENT seconds.\n"
        exit 0
        ;;
    dec)
        TIME_START=$(date "+%s")
        TARGET=$2
        ID=${TARGET##*.}
        PRIV_KEY=$3
        [ $# -gt 3 ] && OUT_DIR=$4 || OUT_DIR=.
        #remove trailing / if any
        OUT_DIR=${OUT_DIR%/}
        [ ! -f $PRIV_KEY ] && printf "Missing valid private key.\n" && exit 152
        if [ ! -d $OUT_DIR ]; then
            if [ -f $OUT_DIR ]; then
                printf "$OUT_DIR exists and it's a file!\n"
                exit 155
            else
                printf "Creating non-existing directory $OUT_DIR\n" && mkdir $OUT_DIR
            fi
        fi
        [ ! -f $TARGET ] && printf "$TARGET does not exist or is not a file" && exit 153
        ORIG_DIR=$(dirname $TARGET)
        ENC_KEY=$ORIG_DIR/secret.key.rsa.$ID
        KEY=$OUT_DIR/secret.key.$ID
        [ ! -f $ENC_KEY ] && printf "Encrypted secret key $ENC_KEY is missing, \
		it should be in the same path as $TARGET" && exit 154
        G="openssl rsautl -decrypt -inkey $PRIV_KEY -in $ENC_KEY -out $KEY"
        [ $DEBUG -eq 1 ] && echo $G
        eval $G
        chmod 600 $KEY
        G1="dd if=$TARGET|openssl enc -d -blowfish -pass file:$KEY|tar xzf - -C $OUT_DIR"
        [ $DEBUG -eq 1 ] && echo $G1 || echo "Decrypting ..."
        eval $G1 && rm -f $KEY
        TIME_END=$(date "+%s")
        SECONDS_SPENT=$(expr $TIME_END - $TIME_START)
        printf "Decryption Summary:\n"
        printf "\tData Location: %s\n" $OUT_DIR
        printf "\tEncrypted Key: %s\n" $ENC_KEY
        printf "\tTotal Time Elapsed: $SECONDS_SPENT seconds.\n"
        exit 0
        ;;
    *)
        usage
        exit 152
esac