#!/bin/bash
#find your key in fumagician or check known_keys.txt
#look for base64 or use this oneliner: strings fumagician | grep -E '^[A-Za-z0-9+/]{42}[AEIMQUYcgkosw048]=$' | base64 -d | xxd -p -c 32
key=8c7ef2b7836d88ca0abd8f2c91d4eeba4f4d71762df745ee341d2bacbc0f86c0 #key for 2B2QEXM7
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
