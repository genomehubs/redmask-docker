#!/bin/bash

cp /in/$ASSEMBLY ./

if [[ $ASSEMBLY =~ \.gz$ ]]; then
  gunzip $ASSEMBLY
  ASSEMBLY=${ASSEMBLY%.gz}
fi

redmask.py -i $ASSEMBLY -o $ASSEMBLY

rm $ASSEMBLY
gzip *
mv * /out/


