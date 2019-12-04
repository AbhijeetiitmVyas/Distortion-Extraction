procedure(generate1stCopy(cv1, tlist, tlist_ori, window, param_var)
	hiSetCurrentWindow(window)
	location = 0
	pinList = nil
	pin_counter = 0
	counter = 0
	foreach(term tlist

		/* Voltage Sources */
		masterId=dbOpenCellViewByType("analogLib" "gnd" "symbol")
		gnd = dbCreateInst(cv1 masterId nil 2:(-2+location) "R0" 1)

		masterId=dbOpenCellViewByType("analogLib" "vcvs" "symbol")
		vcvs0 = dbCreateInst(cv1 masterId nil -3:(-1+location) "R0" 1)

		/* Setting scaling parameter variable as voltage gain for vcvs0 */
		param = strcat("pPar(\"", param_var, "\")")
		vcvs0~>egain = param

		masterId=dbOpenCellViewByType("analogLib" "vsource" "symbol")
		vs1 = dbCreateInst(cv1 masterId nil -4:(-1+location) "R0" 1)
		vs2 = dbCreateInst(cv1 masterId nil -2:(-1+location) "R0" 1)
		vs1~>srcType = "dc"
		vs2~>srcType = "dc"

		pinName = artMakeString(pin_counter)
		inputCVid = dbOpenCellViewByType("basic" "ipin" "symbol" "" 'r)
		pin = schCreatePin(cv1 inputCVid pinName "input" nil 10:(2+location) "R0")

		pinList = tconc(pinList pin)

		schCheck(cv1)
		dbSave(cv1)

		/* Connections */
		createWireBwTerms(vcvs0, nth(3, vcvs0~>terminals), gnd, car(gnd~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(0, vcvs0~>terminals), vs1, nth(1, vs1~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(1, vcvs0~>terminals), vcvs0, nth(3, vcvs0~>terminals), cv1)
		createWireBwTerms(vcvs0, nth(2, vcvs0~>terminals), vs2, nth(1, vs2~>terminals), cv1)
		createWireBwTerms(term~>inst, term, vs2, nth(0, vs2~>terminals), cv1)

		/* Pin connection */
		createWireBwTermAndPin(vs1, nth(0, vs1~>terminals), pin, cv1)

		/* Current Sources */
		masterId=dbOpenCellViewByType("analogLib" "cccs" "symbol")
		cccs = dbCreateInst(cv1 masterId nil 5:(-1+location) "R0" 1)
		cccs~>fgain = -1

		schCheck(cv1)
		dbSave(cv1)

		/* Connections */
		createWireBwTerms(cccs, nth(0, cccs~>terminals), gnd, car(gnd~>terminals), cv1)
		createWireBwTermAndPin(cccs, nth(1, cccs~>terminals), pin, cv1)
		location = location + 1

		/* Putting final current source */
		masterId=dbOpenCellViewByType("analogLib" "gnd" "symbol")
		gnd = dbCreateInst(cv1 masterId nil 5:(1+location) "R0" 1)

		masterId=dbOpenCellViewByType("analogLib" "isource" "symbol")
		i0 = dbCreateInst(cv1 masterId nil 5:(1.5+location) "R90" 1)

		schCheck(cv1)
		dbSave(cv1)

		/* Connections */
		createWireBwTerms(i0, nth(0, i0~>terminals), gnd, car(gnd~>terminals), cv1)
		createWireBwTermAndPin(i0, nth(1, i0~>terminals), pin, cv1)
		location = location + 1
		i0~>srcType = "dc"

		/* Set extracted OP values */
		cccs~>vref = vcvs0~>name
		i_val = i(strcat("/" artMakeString(term~>inst~>name) "/" artMakeString(term~>name)))
		if(not(i_val) then
			term_ori = nth(counter, tlist_ori)
			if(term_ori != car(term_ori~>net~>terminals) then
				red_resist_t = car(term_ori~>net~>terminals)
			else
				red_resist_t = nth(1, term_ori~>net~>terminals)
			)
			i0~>idc = -2*i(strcat("/" artMakeString(red_resist_t~>inst~>name) "/" artMakeString(red_resist_t~>name)))
		else
			i0~>idc = 2*i_val
		)

		vOP = nth(atoi(pinName), vdcVsPinMap)
		vs1~>vdc = vOP
		vs2~>vdc = vOP

		pin_counter = pin_counter + 1

		schCheck(cv1)
		dbSave(cv1)
		counter = counter + 1
	)

	car(pinList)
)
