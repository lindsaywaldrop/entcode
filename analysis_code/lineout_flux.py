##### Using Lineout ####
#
# Instructions: Make the following edits:
# 
# Lines 16,21,92,117: Make sure your name is in the file path. 
# 
# Open terminal window in Bosque and paste: 
#
# /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout_flux.py 1 2 3 4
# Where the following numbers must be provided:
#  - 1: the number of the simulation
#  - 2: hair center x 
#  - 3: hair center y 
#  - 4: distance away from hair center to run lineout
#
# Replace [script.py] with the name of this file
#

import sys

num=sys.argv[1]
hairx=sys.argv[2]
hairy=sys.argv[3]
dist=sys.argv[4]

OpenDatabase("localhost:/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/lag_data.visit", 0)
AddPlot("Mesh", "hairs"+str(num)+"_vertices", 1, 1)
DrawPlots()
OpenDatabase("localhost:/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/dumps.visit", 0)
AddPlot("Pseudocolor", "U_magnitude", 1, 1)
DrawPlots()
SetActivePlots(2)
SetTimeSliderState(5)
Query("Lineout", end_point=(float(float(hairx)+float(dist)), float(float(hairy)-float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)+float(dist)), float(float(hairy)+float(dist)), 0), use_sampling=0, vars=("U_x"))
Query("Lineout", end_point=(float(float(hairx)+float(dist)), float(float(hairy)-float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)+float(dist)), float(float(hairy)+float(dist)), 0), use_sampling=0, vars=("U_y"))
SetActiveWindow(2)
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 0
SaveWindowAtts.outputDirectory = "/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/hairline_flux"
SaveWindowAtts.fileName = "hairline_flux"
SaveWindowAtts.family = 1
SaveWindowAtts.format = SaveWindowAtts.CURVE  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.width = 1024
SaveWindowAtts.height = 1024
SaveWindowAtts.screenCapture = 0
SaveWindowAtts.saveTiled = 0
SaveWindowAtts.quality = 80
SaveWindowAtts.progressive = 0
SaveWindowAtts.binary = 0
SaveWindowAtts.stereo = 0
SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
SaveWindowAtts.forceMerge = 0
SaveWindowAtts.resConstraint = SaveWindowAtts.ScreenProportions  # NoConstraint, EqualWidthHeight, ScreenProportions
SaveWindowAtts.advancedMultiWindowSave = 0
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()
DeleteAllPlots()
SetActiveWindow(1)
SetActivePlots(2)
Query("Lineout", end_point=(float(float(hairx)-float(dist)), float(float(hairy)-float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)+float(dist)), float(float(hairy)-float(dist)), 0), use_sampling=0, vars=("U_x"))
Query("Lineout", end_point=(float(float(hairx)-float(dist)), float(float(hairy)-float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)+float(dist)), float(float(hairy)-float(dist)), 0), use_sampling=0, vars=("U_y"))
SetActiveWindow(2)
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 0
SaveWindowAtts.outputDirectory = "/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/hairline_flux"
SaveWindowAtts.fileName = "hairline_flux"
SaveWindowAtts.family = 1
SaveWindowAtts.format = SaveWindowAtts.CURVE  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.width = 1024
SaveWindowAtts.height = 1024
SaveWindowAtts.screenCapture = 0
SaveWindowAtts.saveTiled = 0
SaveWindowAtts.quality = 80
SaveWindowAtts.progressive = 0
SaveWindowAtts.binary = 0
SaveWindowAtts.stereo = 0
SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
SaveWindowAtts.forceMerge = 0
SaveWindowAtts.resConstraint = SaveWindowAtts.ScreenProportions  # NoConstraint, EqualWidthHeight, ScreenProportions
SaveWindowAtts.advancedMultiWindowSave = 0
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()
DeleteAllPlots()
SetActiveWindow(1)
SetActivePlots(2)
Query("Lineout", end_point=(float(float(hairx)-float(dist)), float(float(hairy)+float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)-float(dist)), float(float(hairy)-float(dist)), 0), use_sampling=0, vars=("U_x"))
Query("Lineout", end_point=(float(float(hairx)-float(dist)), float(float(hairy)+float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)-float(dist)), float(float(hairy)-float(dist)), 0), use_sampling=0, vars=("U_y"))
SetActiveWindow(2)
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 0
SaveWindowAtts.outputDirectory = "/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/hairline_flux"
SaveWindowAtts.fileName = "hairline_flux"
SaveWindowAtts.family = 1
SaveWindowAtts.format = SaveWindowAtts.CURVE  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.width = 1024
SaveWindowAtts.height = 1024
SaveWindowAtts.screenCapture = 0
SaveWindowAtts.saveTiled = 0
SaveWindowAtts.quality = 80
SaveWindowAtts.progressive = 0
SaveWindowAtts.binary = 0
SaveWindowAtts.stereo = 0
SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
SaveWindowAtts.forceMerge = 0
SaveWindowAtts.resConstraint = SaveWindowAtts.ScreenProportions  # NoConstraint, EqualWidthHeight, ScreenProportions
SaveWindowAtts.advancedMultiWindowSave = 0
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()
DeleteAllPlots()
SetActiveWindow(1)
SetActivePlots(2)
Query("Lineout", end_point=(float(float(hairx)+float(dist)), float(float(hairy)+float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)-float(dist)), float(float(hairy)+float(dist)), 0), use_sampling=0, vars=("U_x"))
Query("Lineout", end_point=(float(float(hairx)+float(dist)), float(float(hairy)+float(dist)), 0), num_samples=1000, start_point=(float(float(hairx)-float(dist)), float(float(hairy)+float(dist)), 0), use_sampling=0, vars=("U_y"))
SetActiveWindow(2)
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 0
SaveWindowAtts.outputDirectory = "/Volumes/HelmsDeep/IBAMR/entcode/usedruns/viz_IB2d"+str(num)+"/hairline_flux"
SaveWindowAtts.fileName = "hairline_flux"
SaveWindowAtts.family = 1
SaveWindowAtts.format = SaveWindowAtts.CURVE  # BMP, CURVE, JPEG, OBJ, PNG, POSTSCRIPT, POVRAY, PPM, RGB, STL, TIFF, ULTRA, VTK, PLY
SaveWindowAtts.width = 1024
SaveWindowAtts.height = 1024
SaveWindowAtts.screenCapture = 0
SaveWindowAtts.saveTiled = 0
SaveWindowAtts.quality = 80
SaveWindowAtts.progressive = 0
SaveWindowAtts.binary = 0
SaveWindowAtts.stereo = 0
SaveWindowAtts.compression = SaveWindowAtts.PackBits  # None, PackBits, Jpeg, Deflate
SaveWindowAtts.forceMerge = 0
SaveWindowAtts.resConstraint = SaveWindowAtts.ScreenProportions  # NoConstraint, EqualWidthHeight, ScreenProportions
SaveWindowAtts.advancedMultiWindowSave = 0
SetSaveWindowAttributes(SaveWindowAtts)
SaveWindow()




DeleteAllPlots()

sys.exit()



