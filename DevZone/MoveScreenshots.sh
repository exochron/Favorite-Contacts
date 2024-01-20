#!/bin/bash

cd Images || return

mv "$(ls -dtr1 ../../../../../_ptr_/Screenshots/* | tail -1)" 05_options.jpg
mv "$(ls -dtr1 ../../../../../_ptr_/Screenshots/* | tail -1)" 04_edit-frame.jpg
mv "$(ls -dtr1 ../../../../../_ptr_/Screenshots/* | tail -1)" 03_edit-menu.jpg
mv "$(ls -dtr1 ../../../../../_ptr_/Screenshots/* | tail -1)" 02_new-menu.jpg
mv "$(ls -dtr1 ../../../../../_ptr_/Screenshots/* | tail -1)" 01_inbox.jpg

convert -crop 443x467+09+107 01_inbox.jpg 01_inbox.jpg
convert -crop 467x467+09+107 02_new-menu.jpg 02_new-menu.jpg
convert -crop 443x467+09+107 03_edit-menu.jpg 03_edit-menu.jpg
convert -crop 426x560+447+107 04_edit-frame.jpg 04_edit-frame.jpg
convert -crop 706x725+555+35 05_options.jpg 05_options.jpg