load("./scripts/extractDistortion.il")
load("./scripts/wiringProcedures.il")
load("./scripts/runTransAnalysis.il")
load("./scripts/runHBAnalysis.il")
load("./scripts/extractDCPoint.il")
load("./scripts/helperFunctionDefinitions.il")
load("./scripts/generate1stCopy.il")
load("./scripts/generateOther2Copies.il")
load("./scripts/replaceWithSymbol.il")
libName = "1st"
cellName ="CSA"
symbolCreationSch = "Presymbolsch"
outPin = "/Vo"
path_stm_file = strcat("/home/ee15b068/simulation/" cellName  "/spectre/schematic/netlist/_graphical_stimuli.scs")
path_rslt_file = strcat("/home/ee15b068/simulation/" cellName "/spectre/schematic") 
/* Clean files created by this file */
when(ddGetObj(libName symbolCreationSch)
    ddDeleteObj(ddGetObj(libName symbolCreationSch))
)

when(ddGetObj(libName strcat(cellName, "_backup"))
    ddDeleteObj(ddGetObj(libName strcat(cellName, "_backup")))
)

/* Save window information of original schematic's window */
original_Window = hiGetCurrentWindow()

/* Open schematics */
cv1 = dbOpenCellViewByType(libName, symbolCreationSch, "schematic" "schematic" "w")
cv = dbOpenCellViewByType(libName, cellName, "schematic")
checkAndSave(cv);
/* Run analysis on original circuit and get wave */
/* s0 = runTransAnalysis_ori(libName, cellName, cv, outPin, path_stm_file, path_rslt_file) */
s0 = runHBAnalysis_ori(libName, cellName, cv, outPin, path_stm_file, path_rslt_file)
/* Save a backup of the original schematic */
geSaveAs(original_Window, libName, strcat(cellName, "_backup"), "schematic")
/* Open pre-symbol-schematic and save its window id */
geOpen(?lib libName ?cell symbolCreationSch ?view "schematic" ?viewType "schematic" ?mode "a")
symbolSchematic_Window = hiGetCurrentWindow()

/* Copy the selected figure to pre-symbol-schematic for replacement creation */
copyFigSelectedInWindow(cv1, original_Window, t, 1)
tlist = findTerminals(cv1, symbolSchematic_Window)
tlist_ori = findTerminalsOfSelSet(cv, original_Window)

/* Extract OP for original circuit and select results */
extractOP(libName, cellName, cv, path_stm_file, path_rslt_file)

/* Find vdc vs pin map */
vdcVsPinMap = makePinNumberVsVdcListForCv(tlist, cv1, symbolSchematic_Window, cv)

/* Create the replacement circuit in the pre-symbol-schematic file */
pinList = generate1stCopy(cv1, tlist, tlist_ori, symbolSchematic_Window, "a")/* Returns a list of pins created (in order) */

/* Create the other 2 copies */
generateOther2Copies(cv, original_Window, cv1, symbolSchematic_Window, pinList, vdcVsPinMap, 10, "b")
generateOther2Copies(cv, original_Window, cv1, symbolSchematic_Window, pinList, vdcVsPinMap, 20, "c")

/* create the symbol for the schematic created above and save it using the method specified as the third argument */
createSymbolAndSave(libName, symbolCreationSch, "Replace")
symbol = replaceWithSymbol(cv, original_Window, tlist_ori, libName, symbolCreationSch)

/* Delete selected instance in original schematic */
deleteSelElementsInWindow(original_Window)
/* Modify a, c and c parameters and run analysis (change input and outputp pins in _graphical_sti.scs file)*/
/*
s1 = runTransAnalysis(libName, cellName, cv, symbol, outPin, 0.2, 0.3, 0.5, path_stm_file, path_rslt_file)
s2 = runTransAnalysis(libName, cellName, cv, symbol, outPin, 0.1, 0.35, 0.55, path_stm_file, path_rslt_file)
s3 = runTransAnalysis(libName, cellName, cv, symbol, outPin, 0.6, 0.15, 0.25, path_stm_file, path_rslt_file)
*/

s1 = runHBAnalysis(libName, cellName, cv, symbol, outPin, 0.2, 0.3, 0.5, path_stm_file, path_rslt_file)
s2 = runHBAnalysis(libName, cellName, cv, symbol, outPin, 0.1, 0.35, 0.55, path_stm_file, path_rslt_file)
s3 = runHBAnalysis(libName, cellName, cv, symbol, outPin, 0.6, 0.15, 0.25, path_stm_file, path_rslt_file)

distWaves = extractDistortion(1, 1, 1, 1, 1, 0.2, 0.3, 0.5, 1, 0.1, 0.35, 0.55, 1, 0.6, 0.15, 0.25, s0, s1, s2, s3)

