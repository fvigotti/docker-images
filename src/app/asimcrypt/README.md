# ASIMMETRIC crypter
encrypt big files using asymmetric public key and a random generated simmetric key,
need as input the file to crypt (xx.zz) and a public key
and produce: ( xx.zz.enc , xx.zz.secret.enc )
the xx.zz.secret.enc can be decrypted with the private key generating xx.zz.secret , and then the file
 xx.zz.enc can be decripted with xx.zz.secret generating xx.zz.enc 


 
 
# howto
- generate private key: 
```sh
openssl genpkey -algorithm RSA -des3 -out private_key.pem -pkeyopt rsa_keygen_bits:4096
```  

- export public key from private key: 
```sh
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

## sample usage :
```sh
PRIVKEY=private_key.pem
PUBKEY=public_key.pem
KEYFILE=secretkeyfile
KEYFILE_CRYPTED=${KEYFILE}.pubcrypted
KEYFILE_CRYPTED_DECRYPTED=${KEYFILE}.pubcrypted.decrypted

dd if=/dev/random of=$KEYFILE bs=1 count=400
openssl rsautl -encrypt -pubin -inkey $PUBKEY -in $KEYFILE  -out $KEYFILE_CRYPTED
#  or : openssl rsautl -encrypt -pubin -inkey $PUBKEY < $KEYFILE  > $KEYFILE_CRYPTED

# now decrypt using: (nb: will prompt password if private key have one )   
openssl rsautl -decrypt -inkey $PRIVKEY -in $KEYFILE_CRYPTED -out $KEYFILE_CRYPTED_DECRYPTED
## input password....

## test decrypted key match:
diff $KEYFILE $KEYFILE_CRYPTED_DECRYPTED || echo "original and decrypted key are identical"
  
# encrypt file with secretkey:
openssl enc -aes-256-cbc -salt -in 200M.dat -out 200M.dat.enc -kfile $KEYFILE

# decrypt file with secretkey:
openssl enc -aes-256-cbc -d -in 200M.dat.enc -out 200M.dat.enc.dec  -kfile  $KEYFILE 
  
```
                                                                              
                                                                            



PUBKEY=wcbackupsPublic.pem  
-- openssl will then ask password to secure the private key
FILE_TO_CRYPT=test.dat
FILE_TO_CRYPT_CRYPTED=${FILE_TO_CRYPT}.crypted

create pass:
KEYFILE=${FILE_TO_CRYPT}.key
touch $KEYFILE && chmod 600 $KEYFILE       
KEYFILE_CRYPTED=${KEYFILE}.crypted

dd if=/dev/random of=$KEYFILE bs=200 count=1
## encrypt archive file:
openssl enc -aes-256-cbc -pass file:$KEYFILE < $FILE_TO_CRYPT > $FILE_TO_CRYPT_CRYPTED
## asymmetric encrypt password using public key:
openssl rsautl -encrypt -pubin -inkey $PUBKEY < $KEYFILE  > $KEYFILE_CRYPTED

 
to view private key : 
openssl rsa -text -in private_key.pem
 
 
 
 
# resources :
- http://christopher.su/2012/encrypt-archives-gpg-openssl/
- https://en.wikibooks.org/wiki/Cryptography/Generate_a_keypair_using_OpenSSL
- https://rietta.com/blog/2012/01/27/openssl-generating-rsa-key-from-command/



 
 
## to investigate: gpg instead of openssl? 
 gpg --gen-key
 1
 4096
 0
 y
  
  
  
  
## encdec file taken from : 
 https://ricochen.wordpress.com/page/23/
  
  
  
  
  
# encrypt using smime
## http://stackoverflow.com/questions/18924715/encrypt-a-big-file-using-openssl-smime
- Create a new key and a certificate request (you will be prompted for additional information to complete the request): 
```
openssl req -newkey rsa:2048 -keyout privkey.pem -out req.pem
```

- Self-sign the certificate request to create a certificate 
```
openssl x509 -req -in req.pem -signkey privkey.pem -out cert.pem
```
   (You can delete req.pem at this point if you wish)

--- Encrypt the file using the newly generated certificate: 
```
openssl smime -encrypt -aes256 -in ABC.xml -binary -outform DER -out DEF.xml cert.pe
```
 
- smime encrypt: 
```
openssl smime -encrypt -aes256 -in 100M.dat -binary -outform DER -out 100M.dat.smime cert.pem
```
  
- smime decrypt: 
```
openssl smime -decrypt -in DEF.xml -inform DER -inkey privkey.pem -out GHI.xml
```

