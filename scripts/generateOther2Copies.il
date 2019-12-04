procedure(generateOther2Copies(cv, window_cv, cv1, window_cv1, pinList, vdcVsPinMap, offset, param_var)

	hiSetCurrentWindow(window_cv)
	geGetSelSet()

	tlist_old = findTerminals(cv1, window_cv1)
	print(strcat("tlist_old:", artMakeString(tlist_old)))
	copyFigSelectedInWindow(cv1, window_cv, t, offset)
	tlist_full = findTerminals(cv1, window_cv1)
	print(strcat("tlist_full:", artMakeString(tlist_full)))
	tlist_new = findNewTerminals(tlist_old, tlist_full)
	print(strcat("tlist_new:", artMakeString(tlist_new)))
	print(tlist_new~>inst~>name)
	location = 0
	pin_counter = 0
	foreach(term tlist_new
		masterId=dbOpenCellViewByType("analogLib" "gnd" "symbol")
		gnd = dbCreateInst(cv1 masterId nil (2+offset):(-2+location) "R0" 1)

		masterId=dbOpenCellViewByType("analogLib" "vcvs" "symbol")
		vcvs0 = dbCreateInst(cv1 masterId nil (-3+offset):(-1+location) "R0" 1)

		/* Setting scaling parameter variable as voltage gain for vcvs0 */
		param = strcat("pPar(\"", param_var, "\")")
		vcvs0~>egain = param


		masterId=dbOpenCellViewByType("analogLib" "vsource" "symbol")
		vs1 = dbCreateInst(cv1 masterId nil (-4+offset):(-1+location) "R0" 1)
		vs2 = dbCreateInst(cv1 masterId nil (-2+offset):(-1+location) "R0" 1)
		vs1~>srcType = "dc"
		vs2~>srcType = "dc"

		checkAndSave(cv1)

		/* Connections */
		createWireBwTerms(vcvs0, nth(3, vcvs0~>terminals), gnd, car(gnd~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(0, vcvs0~>terminals), vs1, nth(1, vs1~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(1, vcvs0~>terminals), vcvs0, nth(3, vcvs0~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(2, vcvs0~>terminals), vs2, nth(1, vs2~>terminals), cv1)
		createWireBwTerms(term~>inst, term, vs2, nth(0, vs2~>terminals), cv1)

		createWireBwTermAndPin(vs1, nth(0, vs1~>terminals), nth(pin_counter, pinList), cv1)

		/* Current Sources */
		masterId=dbOpenCellViewByType("analogLib" "cccs" "symbol")
		cccs = dbCreateInst(cv1 masterId nil (5+offset):(-1+location) "R0" 1)
		cccs~>fgain = -1
		cccs~>vref = vcvs0~>name

		checkAndSave(cv1)

		/* Connections */
		createWireBwTerms(cccs, nth(0, cccs~>terminals), gnd, car(gnd~>terminals), cv1)
		createWireBwTermAndPin(cccs, nth(1, cccs~>terminals), nth(pin_counter, pinList), cv1)

		/* Set extracted OP Values */
		vOP = nth(atoi(nth(pin_counter, pinList)~>net~>name), vdcVsPinMap)
		vs1~>vdc = vOP
		vs2~>vdc = vOP

		location = location+7
		pin_counter = pin_counter + 1

		checkAndSave(cv1)
	)
)
