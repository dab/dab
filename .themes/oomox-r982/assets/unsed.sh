#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#21211f/g' \
         -e 's/rgb(100%,100%,100%)/#b8b9b4/g' \
    -e 's/rgb(50%,0%,0%)/#21211f/g' \
     -e 's/rgb(0%,50%,0%)/#939490/g' \
 -e 's/rgb(0%,50.196078%,0%)/#939490/g' \
     -e 's/rgb(50%,0%,50%)/#4c4c4c/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#4c4c4c/g' \
     -e 's/rgb(0%,0%,50%)/#d4d4d4/g' \
	*.svg
