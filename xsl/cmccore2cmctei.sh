#!/bin/bash


D="/vol/work/luengen/kl/trunk/TEI-CMC-SIG/CMCTEI-2025/data/"

for c in  $D/*/*.tei.xml
do
    BASENAME=`basename $c .tei.xml`
    echo "converting $c using saxon... "
    saxon $c cmccore2cmctei.xsl > $BASENAME.cmctei.xml
    ls -l $BASENAME.cmctei.xml
    echo
    echo "validating using saxon-validate..."
    saxon-validate $BASENAME.cmctei.xml
    echo
    echo
done




