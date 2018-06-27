#!/bin/bash

JPEG_DIR="JPEG"
PDF_DIR="PDF"
ALL_PDF="calendar.pdf"
CURRENT=$(pwd)
EXTENSION=".jpg"

# Functions to manage dates
month_max[1]=31
month_max[2]=29
month_max[3]=31
month_max[4]=30
month_max[5]=31
month_max[6]=30
month_max[7]=31
month_max[8]=31
month_max[9]=30
month_max[10]=31
month_max[11]=30
month_max[12]=31

# Always display 2 digits. in: one number, out: one number of 2 digits
function number_format {
  if [ $1 -lt 10 ]; then
    echo -n 0$1
  else
    echo -n $1
  fi
}

# in: MM_DD, out: MM_DD + 1
function next {
  month=$(echo $1 | cut -d '_' -f1)
  day=$(echo $1 | cut -d '_' -f2)
  # Remove leading 0
  month=${month#0}
  day=${day#0}
  if [ $day -eq ${month_max[$month]} ]; then
    day=1
    month=$(( $month + 1))
  else
    day=$(( $day + 1 ))
  fi
  echo "$(number_format $month)_$(number_format $day)"
}

# in: MM_DD, out: MM_DD - 1
function prev {
  month=$(echo $1 | cut -d '_' -f1)
  day=$(echo $1 | cut -d '_' -f2)
  # Remove leading 0
  month=${month#0}
  day=${day#0}
  if [ $day -eq 1 ]; then
    month=$(( $month - 1))
    day=${month_max[$month]}
  else
    day=$(( $day - 1 ))
  fi
  echo "$(number_format $month)_$(number_format $day)"
}

# Convert JPEG to PDF
cd $JPEG_DIR
for pic in $(ls); do
#for pic in $(ls | head -n 2); do
  name=$(basename $pic $EXTENSION)
  pdf_name=$CURRENT/$PDF_DIR/$name.pdf
  if [ -e $pdf_name ]; then
    echo "PDF $name.pdf already exists..."
  else
    echo ">> Convert $name"
    convert $pic $CURRENT/$PDF_DIR/$name.pdf
  fi
done

# Merge PDF
cd $CURRENT/$PDF_DIR
if [ ! -e ../$ALL_PDF ]; then
  nb_pdf=$(ls | wc -l)
  if [ $nb_pdf -lt 2 ]; then
    echo "The script requires at least 2 PDF files (Nb. of detected files: $nb_pdf)."
    exit
  fi
  echo "Merging all PDF to ../$ALL_PDF"
  if [ -z "$1" ]; then
    ## Create a PDF to display (chronological order)
    pdftk $(ls) cat output ../$ALL_PDF
  else
    ## Create a PDF to print the calendar (two-sided document)
    # Get the name of the first file
    recto=$(ls ../$PDF_DIR | head -n 1)
    # Remove the extension
    recto="${recto%.*}"
    # Get the name of the last file
    verso=$(ls ../$PDF_DIR | tail -n 1)
    # Remove the extension
    verso="${verso%.*}"
    # Merge PDF files to the final PDF
    dates=""
    nb_pdf=$(( $nb_pdf / 2 ))
    echo $recto $verso
    for i in $(seq 1 $nb_pdf); do
      dates="$dates $recto.pdf $verso.pdf"
      recto=$(next $recto)
      verso=$(prev $verso)
    done
    echo $dates
    pdftk $dates cat output ../$ALL_PDF
  fi
else
  echo "File ../$ALL_PDF already exists!"
fi

