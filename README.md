# Rate by Filename (Lightroom Classic plugin)

Paste the filenames your client picked and this plugin star-rates the matching photos in your catalogue, with an optional Pick flag. It also reports any names it couldn't find.

## Install
1. Download the `RateByFilename.lrdevplugin` folder and keep it somewhere permanent.
2. Lightroom Classic > File > Plug-in Manager > Add, then select the folder.

## Use
Library > Plug-in Extras > Rate Photos from Filename List...

## Matching
- `IMG_1234`, `img_1234` and `IMG_1234.jpg` all match `IMG_1234.*` (RAW + JPG pairs both get rated).
- A bare number like `1234` matches any file ending in that number.
- Separate names with new lines, commas, semicolons or spaces.

Tested on Lightroom Classic on macOS.
