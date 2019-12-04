
/*  Finds the list of the terminals by which the circuit in the selected
	figure interfaces with the rest of the circuit in the original schematic */
/*
procedure(findPeripheralTerminalsOfSelSet(cv, window)

	let( ((netList nil))
		hiSetCurrentWindow(window)
		netList = nil
		netCountList = nil
		terminals_list = nil
		counter = 0
		foreach(fig geGetSelSet()

			foreach(term fig~>terminals

				terminals_list = tconc(terminals_list, term)
				)
		)
		terminals_list = car(terminals_list)
		foreach(term terminals_list

			netList = tconc(netList, term~>net)
		)
		netList = car(netList)
		foreach(net netList
			countNet = 0
			foreach(net_1 netList
				if(net_1 == net
					countNet = countNet + 1
				)
			)
			netCountList = tconc(netCountList, countNet)
		)
		netCountList = car(netCountList)
		terminals_list_1 = nil
		foreach(val netCountList

			if(val == 1
				terminals_list_1 = tconc(terminals_list_1, nth(counter, terminals_list))
			)
			counter = counter + 1
		)
		car(terminals_list_1)
	)
)
*/
procedure(deleteSelElementsInWindow(window)
	hiSetCurrentWindow(original_Window)
	schHiDelete()
)

procedure(createSymbolAndSave(libName, symbolCreationSch, @optional (method "Replace"))
	let(((pinListFromSchematic nil))
		pinListFromSchematic=schSchemToPinList(libName symbolCreationSch "schematic")
	  pinListFromSchematic->prop->schCvCreationMethod=method
	  schPinListToView(libName symbolCreationSch "symbol" pinListFromSchematic "schPinListToSymbolGen")
	)
)

/* Finds list of terminals in the selected set inside the window by checking if a terminal's net is connected to an instace outside the selected set*/
procedure(findTerminalsOfSelSet(cv, window)
	let(((tlist_3 nil) (tlist_4 nil))
		hiSetCurrentWindow(window)
		foreach(fig geGetSelSet()
			foreach(term fig~>terminals
					tlist_3 = tconc(tlist_3, term)
			)
		)
		tlist_3 = car(tlist_3)
		foreach(term tlist_3
			i = 0
			while(cadr(tlist_4) != term && i < length(term~>net~>instances)
				instance = nth(i, term~>net~>instances)
					if(not(member(instance geGetSelSet()))
						tlist_4 = tconc(tlist_4, term)
					)
				i += 1
			)
		)
		tlist_4 = car(tlist_4)
		tlist_4
	)
)

/* Finds list of terminals in the selected set inside the window by removing terminals with nets shared between elements of the selected set */
procedure(findTerminalsOfSelSet_2(cv, window)
	let( ((tlist_3 nil) (flag nil) (check_i nil) (check_j nil))
		hiSetCurrentWindow(window)
		foreach(fig geGetSelSet()
			foreach(term fig~>terminals
					tlist_3 = tconc(tlist_3 term)
			)
		)
		tlist_3 = car(tlist_3)
		i = 0
		while(i<length(tlist_3)
			flag = nil
			check_i = nth(i, tlist_3)
			j = i+1
			while(j<length(tlist_3)
				check_j = nth(j, tlist_3)
					if(check_j~>net == check_i~>net
						then
						tlist_3 = remove(check_j tlist_3)
						flag = t
					)
				j+=1
				)
			if(flag == t
				tlist_3 = remove(check_i, tlist_3)
			)
			i+=1
		)
		tlist_3
	)
)

/* Finds a list of voltages corresponding to the terminal list tlist */
procedure(makePinNumberVsVdcListForCv(tlist, cv1, window_cv1, cv)
	let( ((tlist_1 findTerminals(cv1, window_cv1)) (pinVdcMap nil) (volt nil))
		foreach(term tlist_1
			foreach(instTerminal (dbFindAnyInstByName(cv, term~>inst~>name)~>terminals)
				if(instTerminal~>name == term~>name
					then
					volt = v(instTerminal~>net~>name)
					if(instTerminal~>net~>name == "gnd!"
						then
						volt = 0
						)
					if(instTerminal~>net~>name == "vdd"
						then
						volt = 1.8
						)
					pinVdcMap = tconc(pinVdcMap, volt)
				)
			)
		)
		car(pinVdcMap)
	)
)

/* Finds the difference between two lists */
procedure(findNewTerminals(tlist_old, tlist_full)
	let( ((tlist_new_1 nil))
		foreach(element tlist_full

			if(not(member(element tlist_old))
			then
			tlist_new_1 = tconc(tlist_new_1 element)
			)
		)
		car(tlist_new_1)
	)
)
/* Find terminals of all the figures inside the cv schematic */
procedure(findTerminals(cv, window)
	let( ((tlist_2 nil))
		hiSetCurrentWindow(window)
		geSelectAllFig()
		foreach(fig geGetSelSet()
			foreach(term fig~>terminals
				if(length(term~>net~>terminals)==1
					then
						tlist_2 = tconc(tlist_2 term)
				)
			)
		)
	car(tlist_2)
	)
)

/* Copies selected items in window over to the cv schematic */
procedure(copyFigSelectedInWindow(cv, window, save, @optional (offset 1))

	hiSetCurrentWindow(window)
	foreach(fig geGetSelSet()
		dbCopyFig(fig cv list((offset+0):0 "R0" 1.0))
	)
	if(save == t
		then
			checkAndSave(cv)
		)
)

/* Does check and save on the specified scematic cv */
procedure(checkAndSave(cv)

	schCheck(cv)
	dbSave(cv)
)
