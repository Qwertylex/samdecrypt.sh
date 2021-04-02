#!/bin/bash
#find your key in fumagician (look for base64)
#key=8337838b2345aa7662cd902a9731ef52f4506275b57ca7cd9c36b565bf993cd1
key=8c7ef2b7836d88ca0abd8f2c91d4eeba4f4d71762df745ee341d2bacbc0f86c0
openssl enc -aes-256-ecb -d -in "$1" -nopad -K "$key" > "${1/.enc/.bintemp}"
magic=5f696369616e4d41475f402a212e3826
check=$(xxd -s 0 -l 16 -p "${1/.enc/.bintemp}")

if [[ "$magic" == "$check" ]];
        then
            size=$(perl -le 'seek STDIN, 16, 0; read STDIN, my $buf, 4; print unpack q/V/, $buf;' < "${1/.enc/.bintemp}")
            tail -c +33 < "${1/.enc/.bintemp}" | head -c "$size" > "${1/.enc/.bin}"
            rm "${1/.enc/.bintemp}"
        else
            rm "${1/.enc/.bintemp}"
            printf 'Signature match fail (wrong key or file).\n'
fi
