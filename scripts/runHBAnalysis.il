/* Runs transient analysis for a netlist and selects the results */
procedure(runHBAnalysis(lib, cellName, cv, symbol, outPin, a, b, c, path_stm_file, path_rslt_file)
	
	/* Setup symbol for simulation */
        symbol~>a = a
        symbol~>b = b
        symbol~>c = c
	checkAndSave(cv)

	simulator( 'spectre )
	design(	lib, cellName, "schematic")
	stimulusFile( ?xlate nil path_stm_file)
	resultsDir( path_rslt_file)
	analysis('hb ?autoharms "" ?autotstab "yes" 
		?oversample list("1") 
		?fundfreqs list("(1000)") 
		?maxharms list("31") 
		?harmonicsCyc "View All")
	envOption('analysisOrder  list("hb") )

	save( 'v "/Vo" )
	temp( 27 )
	run()
	selectResults('hb_td)
	vh('hb, outPin)
)

/* Runs transient analysis on schematics without replacement */
procedure(runHBAnalysis_ori(lib, cellName, cv, outPin, path_stm_file, path_rslt_file)
simulator( 'spectre )
design(	lib, cellName, "schematic")
stimulusFile( ?xlate nil path_stm_file)
resultsDir( path_rslt_file)
analysis('hb ?autoharms "" ?autotstab "yes" 
	?oversample list("1") 
	?fundfreqs list("(1000)") 
	?maxharms list("31") 
	?harmonicsCyc "View All")
envOption('analysisOrder  list("hb") )

save( 'v "/Vo" )
temp( 27 )
run()
selectResults('hb_td)
vh('hb, outPin)
)
