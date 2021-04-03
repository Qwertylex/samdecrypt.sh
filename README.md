# samdecrypt.sh

This script decrypts, checks the file header to see if it properly decrypted, then decodes the file size, then chops off the header at the start and padding at the end to result in a clean file.
The file header is 32 bytes long, the first 16 bytes is the magic, the next 16 bytes contains a 32 bit Little Endian file size padded with zeros.

example usage:
extracting the iso, initrd and finding the 256 bit key:
```
~/sam $ 7z x Samsung_SSD_970_EVO_Plus_2B2QEXM7.iso
~/sam $ mkdir x; cd x
~/sam/x $ 7z x ../initrd; 7z x initrd\~
~/sam/x $ cd root/fumagician
~/sam/x/root/fumagician $ strings fumagician | grep -E '^[A-Za-z0-9+/]{42}[AEIMQUYcgkosw048]=$' | base64 -d | xxd -p -c 32

8c7ef2b7836d88ca0abd8f2c91d4eeba4f4d71762df745ee341d2bacbc0f86c0
```
change key= in ./samdecrypt.sh to 8c7ef2b7836d88ca0abd8f2c91d4eeba4f4d71762df745ee341d2bacbc0f86c0

decrypting:
```
~/sam/x/root/fumagician $ ./samdecrypt.sh DSRD.enc
~/sam/x/root/fumagician $ cat DSRD.bin
<SSD>
<SN>ALL</SN>
<MOD>ALL</MOD>
<CURFW>1B2QEXM7</CURFW>
<NEWFW>2B2QEXM7</NEWFW>
<MFW>2B2QEXM7_00190411.bin</MFW>
<MFW>2B2QEXM7_10190411.bin</MFW>
<MFW>2B2QEXM7_20190411.bin</MFW>
</SSD>
~/sam/x/root/fumagician $ ./samdecrypt.sh 2B2QEXM7.enc
~/sam/x/root/fumagician $ 7z x 2B2QEXM7.bin
```
2B2QEXM7.bin is actually a normal .zip and unzipped, extracts to the following:
```
2B2QEXM7_00190411.enc
2B2QEXM7_10190411.enc
2B2QEXM7_20190411.enc
```
which can be decrypted in the same manner as above.

