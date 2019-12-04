/* Runs transient analysis for a netlist and selects the results */
procedure(runTransAnalysis(lib, cellName, cv, symbol, outPin, a, b, c, path_stm_file, path_rslt_file)
	
	/* Setup symbol for simulation */
        symbol~>a = a
        symbol~>b = b
        symbol~>c = c
	checkAndSave(cv)

	/* Setup simulator for running transient analysis */
	simulator('spectre)
	design( lib, cellName, "schematic")
	stimulusFile( ?xlate nil path_stm_file)
	resultsDir( path_rslt_file )
	/* Setting analysis type and options */
	analysis('tran ?stop "100000u"  )
	save('all)
	envOption(
		'analysisOrder  list("tran")
	)

	/* Setting temperature variable to 27C */
	temp( 27 )
	
	/* Run simulation with the above settings */
	run()

	/* Selecting results */
	selectResults('tran)

	/* Return the wave at the output pin outPin */
	getData(outPin)
)

/* Runs transient analysis on schematics without replacement */
procedure(runTransAnalysis_ori(lib, cellName, cv, outPin, path_stm_file, path_rslt_file)
	/* Setup simulator for running transient analysis */
        simulator('spectre)
        design( lib, cellName, "schematic")
        stimulusFile( ?xlate nil path_stm_file)
        resultsDir( path_rslt_file )
        /* Setting analysis type and options */
        analysis('tran ?stop "100000u"  )
        save('all)
        envOption(
                'analysisOrder  list("tran")
        )

	temp( 27 )
	/* Run simulation */
	run()

	/* Selecting results */
	selectResults('tran)
	
	/* Return the wave at the output in outPin */
	getData(outPin)
)
