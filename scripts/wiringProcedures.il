/* Wiring procedures */
/* Creates a wire between two terminals */
procedure(createWireBwTerms(inst1, term1, inst2, term2, cv)
	w1=centerBox(dbTransformBBox(car(term1~>term~>pins~>fig~>bBox) inst1~>transform))
	w2=centerBox(dbTransformBBox(car(term2~>term~>pins~>fig~>bBox) inst2~>transform))
	schCreateWire(cv "draw" "full" list(w1 w2) 0.625 0.625 0.0)
)
/* Creates a wire between a terminal and a pin */
procedure(createWireBwTermAndPin(inst1, term1, inst2, cv)
	w1=centerBox(dbTransformBBox(car(term1~>term~>pins~>fig~>bBox) inst1~>transform))
	w2=centerBox(car(list(inst2~>bBox)))
	w2 = list(nth(0, w2)+0.1, nth(1, w2)+0.05)
	schCreateWire(cv "draw" "full" list(w1 w2) 0.625 0.625 0.0)
)

/* Creates a wire from a terminal to a location 
procedure(createWireBwTermAndLocation(inst1, term1, location2, cv)
	w1=centerBox(dbTransformBBox(car(term1~>term~>pins~>fig~>bBox) inst1~>transform))
	w2 = location2
	schCreateWire(cv "draw" "full" list(w1 w2) 0.625 0.625 0.0)
)*/
/* Creates a wire from a terminal to a location */
procedure(createWireBwTerms_symbol(inst1, term1, inst2, term2, cv)
	w1=centerBox(dbTransformBBox(car(term1~>term~>pins~>fig~>bBox) inst1~>transform))
	w2=centerBox(caar(term2~>term~>pins~>figs~>bBox))
	print(w2)
	w2 = list(nth(0, w2)+5, nth(1, w2)+5)
	/* w2 = list(nth(0, w2)+0.1, nth(1, w2)+0.05) */
	schCreateWire(cv "draw" "full" list(w1 w2) 0.625 0.625 0.0)
)
