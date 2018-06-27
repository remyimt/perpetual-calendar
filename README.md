## Perpetual Calendar Tool
This is how I build my own perpetual calendar from my pictures. It took time for me so I just want to share my workflow and some tools.

### External Tools
* gimp (2.8.22): create the template of a day (XCF files), manipulate pictures (resize, rotate...)
* gimp plugin (dpb): generate JPEG files from XCF files
* convert command: convert JPEG files to PDF files
* pdftk: merge PDF of every day to the final PDF of 366 days (recent versions of Ubuntu do not include pdftk in official repositories)

### Folder and Files
* [Accessories](accessories): gimp plugin and pdftk packages for manual install
* [JPEG](JPEG): output of the gimp plugin dpb
* [jpeg2pdf.sh](jpeg2pdf.sh): convert JPEG files to PDF files and create the final PDF (the perpetual calendar)
* [PDF](PDF): output of jpeg2pdf.sh (the final PDF is generated in the current folder)
* [Horizontal](horizontal): Template of one day for a horizontal calendar
* [Vertical](vertical): Template of one day for a vertical calendar

### Workflow
* NOTE: Include the date in the name of pictures helps me a lot. Moreover, the name of XCF files must include the month number (MM) and the day number (DD) in the filename. So, the pattern of [XCF filenames](horizontal/xcf) is MM\_DD.xcf (e.g., the file for January 31st is 01\_31.xcf).
* In the [horizontal/jpeg](horizontal/jpeg) folder, I put my pictures. I add the date of the day (MM\_DD) in front of the filename to keep pictures organized.
* In the [horizontal/xcf](horizontal/xcf) folder, I create one XCF file for every day of the year with the right picture. I start by duplicating the horizontal template and I change the picture and the date. The XCF filename is related to the date of the day (MM\_DD.xcf).
* I create 366 XCF files from my pictures with the right dates (very long process).
* I use the gimp plugin (dpb) to export XCF files to JPEG files in the [JPEG/](JPEG) folder.
* I run the jpeg2pdf.sh script to create the final PDF with all pictures.

### Notes
* You can export XCF files to JPEG files manually but it requires lot of time. The gimp plugin automates the export of the 366 XCF files:
  * In the gimp menu, run Filters > Batch process...
  * Input Tab > Add files
  * Select all the files you want to export then click Add and Close
  * Rename Tab > Select Dir (select the output folder, i.e., JPEG/)
  * Output Tab > Format JPG
  * Click Start
* To print the calendar as a two-sided document, you have to reorganized the pages. To do it, run the script jpeg2pdf.sh with one argument: ./jpeg2pdf.sh reorder
* To generate again PDF files, you must delete previous generated files!

### Acknowledgement
Thanks to the Open Source community to create great tools!

