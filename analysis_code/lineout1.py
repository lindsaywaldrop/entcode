##### Using Lineout ####
#
# Instructions: Make the following edits:
# 
# Lines 16,21,92,117: Make sure your name is in the file path. 
# 
# Open terminal window in Bosque and paste: 
#
# /Applications/VisIt.app/Contents/Resources/bin/visit -nowin -cli -s lineout1.py 1 2 3 4 5 
# Where the following numbers must be provided:
#  - 1: the number of the simulation
#  - 2: the x value of the startpoint for the lineout
#  - 3: the y value of the startpoint for the lineout
#  - 4: the x value of the endpoint for the lineout
#  - 5: the y value of the endpoint for the lineout
#
# Replace [script.py] with the name of this file
#

import sys

num=sys.argv[1]
startpointx=sys.argv[2]
startpointy=sys.argv[3]
endpointx=sys.argv[4]
endpointy=sys.argv[5]

OpenDatabase("localhost:/Users/Bosque/IBAMR/entcode/code/runs/viz_IB2d"+str(num)+"/lag_data.visit", 0)
AddPlot("Mesh", "hairs"+str(num)+"_vertices", 1, 1)
DrawPlots()
OpenDatabase("localhost:/Users/Bosque/IBAMR/entcode/code/runs/viz_IB2d"+str(num)+"/dumps.visit", 0)
AddPlot("Pseudocolor", "U_magnitude", 1, 1)
DrawPlots()
Query("Lineout", end_point=(float(endpointx), float(endpointy), 0), num_samples=5000, start_point=(float(startpointx), float(startpointy), 0), use_sampling=1, vars=("U_magnitude"))
SetActiveWindow(2)
for i in range(TimeSliderGetNStates()):
	SetTimeSliderState(i)
	SaveWindowAtts = SaveWindowAttributes()
	SaveWindowAtts.outputToCurrentDirectory = 0
	SaveWindowAtts.outputDirectory = "/Users/Bosque/IBAMR/entcode/code/runs/viz_IB2d"+str(num)+"/hairline"
	SaveWindowAtts.fileName = "hairline"
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
DeleteAllPlots()

sys.exit()



