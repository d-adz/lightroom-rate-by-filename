Rate by Filename (Lightroom Classic plugin)
===========================================

What it does
- You paste the filenames your client picked.
- It finds those photos in your catalogue and gives them a star rating
  (1-5, default 5), and can also flag them as Pick.
- It tells you which pasted names it could not find.

Install (once)
1. Keep the folder "RateByFilename.lrdevplugin" somewhere permanent
   (e.g. Documents). Do not delete it after installing.
2. Lightroom Classic > File > Plug-in Manager...
3. Click "Add", choose the RateByFilename.lrdevplugin folder, click Done.

Use
1. In the Library module, open the folder/collection for the shoot.
2. Library > Plug-in Extras > Rate Photos from Filename List...
3. Paste the list, pick the rating, choose where to search, click Apply.

How names are matched
- IMG_1234, img_1234, IMG_1234.jpg and IMG_1234.CR3 all match IMG_1234.*
  (RAW + JPG pairs both get rated).
- A bare number like 1234 matches any file whose name ENDS in that number
  (IMG_1234, DSC_01234 and so on).
- Separate names with new lines, commas, semicolons or spaces.

Tips
- "Current folder / collection" searches the photos in the grid. If you
  have one photo selected it still searches the whole grid.
- Use "Entire catalog" if a name is reported as not found.
- Undo with Edit > Undo (Cmd/Ctrl+Z) straight after applying.
