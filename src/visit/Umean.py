# #### Using Lineout ####
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

WDin=sys.argv[1]
WDout=sys.argv[2]
num=sys.argv[3]
hairx=sys.argv[4]
hairy=sys.argv[5]
dist=sys.argv[6]

#OpenDatabase(str(WDin)+"/lag_data.visit", 0)
#AddPlot("Mesh", "hairs"+str(num)+"_vertices", 1, 1)
#DrawPlots()
OpenDatabase(str(WDin)+"/dumps.visit", 0)
AddPlot("Pseudocolor", "U_magnitude", 1, 1)
DrawPlots()
AddOperator("Clip", 1)
SetActivePlots(2)
SetActivePlots(2)
ClipAtts = ClipAttributes()
ClipAtts.quality = ClipAtts.Fast  # Fast, Accurate
ClipAtts.funcType = ClipAtts.Sphere  # Plane, Sphere
ClipAtts.plane1Status = 1
ClipAtts.plane2Status = 0
ClipAtts.plane3Status = 0
ClipAtts.plane1Origin = (0, 0, 0)
ClipAtts.plane2Origin = (0, 0, 0)
ClipAtts.plane3Origin = (0, 0, 0)
ClipAtts.plane1Normal = (1, 0, 0)
ClipAtts.plane2Normal = (0, 1, 0)
ClipAtts.plane3Normal = (0, 0, 1)
ClipAtts.planeInverse = 0
ClipAtts.planeToolControlledClipPlane = ClipAtts.Plane1  # None, Plane1, Plane2, Plane3
ClipAtts.center = (float(hairx), float(hairy), 0)
ClipAtts.radius = float(dist)
ClipAtts.sphereInverse = 1
SetOperatorOptions(ClipAtts, 1)
DrawPlots()
QueryOverTimeAtts = GetQueryOverTimeAttributes()
QueryOverTimeAtts.timeType = QueryOverTimeAtts.DTime  # Cycle, DTime, Timestep
QueryOverTimeAtts.startTimeFlag = 0
QueryOverTimeAtts.startTime = 0
QueryOverTimeAtts.endTimeFlag = 0
QueryOverTimeAtts.endTime = 1
QueryOverTimeAtts.strideFlag = 0
QueryOverTimeAtts.stride = 1
QueryOverTimeAtts.createWindow = 1
QueryOverTimeAtts.windowId = 2
SetQueryOverTimeAttributes(QueryOverTimeAtts)
SetQueryFloatFormat("%g")
QueryOverTime("Average Value", end_time=3, start_time=0, stride=1)
SetActiveWindow(2)
SaveWindowAtts = SaveWindowAttributes()
SaveWindowAtts.outputToCurrentDirectory = 0
SaveWindowAtts.outputDirectory = str(WDout)
SaveWindowAtts.fileName = "Umag_hair"+str(num)
SaveWindowAtts.family = 0
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
exit()
