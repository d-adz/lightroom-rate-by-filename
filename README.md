# Rate by Filename (Lightroom Classic plugin)

Paste the filenames your client picked and this plugin star-rates the matching photos in your catalogue, with an optional Pick flag. It also tells you which pasted names it couldn't find.

## Install (once)

1. Download the `RateByFilename.lrdevplugin` folder and keep it somewhere permanent (e.g. Documents). Don't delete it after installing.
2. In Lightroom Classic go to **File > Plug-in Manager > Add**, select the `RateByFilename.lrdevplugin` folder, then click **Done**.

## Use

1. In the Library module, open the folder or collection for the shoot.
2. Go to **Library > Plug-in Extras > Rate Photos from Filename List...**
3. Paste the list, pick the star rating (1-5, default 5), choose where to search, and click **Apply**.

## How names are matched

- `IMG_1234`, `img_1234`, `IMG_1234.jpg` and `IMG_1234.CR3` all match `IMG_1234.*` (RAW + JPG pairs both get rated).
- A bare number like `1234` matches any file whose name ends in that number (`IMG_1234`, `DSC_01234` and so on).
- Separate names with new lines, commas, semicolons or spaces.

## Tips

- **Current folder / collection** searches the photos in the grid. If you have one photo selected it still searches the whole grid.
- Use **Entire catalog** if a name is reported as not found.
- Undo straight after applying with **Cmd/Ctrl+Z** (Edit > Undo).

## Compatibility

Built for Lightroom Classic on macOS. Not yet tested on Windows. It does not work with the cloud-based Lightroom app, which has no plug-in support.

## Licence

MIT
