#!/bin/bash -x

if [[ $# -lt 2 ]] ; then
    echo 'Please pass the path to the pdf to convert and the name of the output file.'
    echo 'Run something like cd images/pubpic; ../../_scripts/pdftogif.sh ../../assets/presentations/B_Kundu-PyHEP23_Cppyy_CppInterOp.pdf BKPyHEPDev2023'
    exit 1
fi


SLIDES_PDF=$1
PRES_ID=$2
WORK_DIR=$(mktemp -d)

gs -dSAFER -dQUIET -dNOPLATFONTS -dNOPAUSE -dBATCH \
   -sOutputFile="$WORK_DIR/%d.png" \
   -sDEVICE=pngalpha \
   -r72 \
   -dTextAlphaBits=4 \
   -dGraphicsAlphaBits=4 \
   -dUseCIEColor \
   -dUseTrimBox \
   $SLIDES_PDF

convert -delay 100 $(ls $WORK_DIR/*.png | sort -V) $PRES_ID.gif
mv $WORK_DIR/1.png $PRES_ID.png

# deletes the temp directory
function cleanup {      
  rm -rf "$WORK_DIR"
  echo "Deleted temp working directory $WORK_DIR"
}

# register the cleanup function to be called on the EXIT signal
trap cleanup EXIT
