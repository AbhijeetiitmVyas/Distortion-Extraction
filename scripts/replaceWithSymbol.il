procedure(replaceWithSymbol(cv, window, tlist_ori, libName, symbolCreationSch)
	let(( (masterId nil) (counter 0))
		hiSetCurrentWindow(window)
		masterId=dbOpenCellViewByType(libName "Presymbolsch" "symbol")
		symbol = dbCreateInst(cv masterId nil 5:5 "R0" 1)
		symbol~>name = "ReplacementSubcircuit"
		checkAndSave(cv)
		foreach(termi tlist_ori
			termin = nth(counter, symbol~>terminals)
			createWireBwTerms(termi~>inst, termi, symbol, termin, cv)
			counter += 1
		)
		symbol
	)
)
