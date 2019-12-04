/* Runs DC analysis for a netlist and selects the results */
procedure(extractOP(lib, cellview, cv, path_stm_file, path_rslt_file)
	/* Setup simulator for running OP point analysis */
	checkAndSave(cv)
	simulator('spectre)
	design( lib, cellview, "schematic")
	resultsDir( path_rslt_file)
	/* Setting analysis type and options */
	stimulusFile( ?xlate nil path_stm_file)
	analysis('dc ?saveOppoint t )
	save('all)
	envOption(
		'analysisOrder  list("dc")
	)

	/* Setting temperature variable to 27C */
	temp( 27 )
	run()

	/* Selecting results */
	selectResults('dcOp)
0
)
