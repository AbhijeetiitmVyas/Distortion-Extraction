procedure(extractDistortion(a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4, s0, s1, s2, s3)
	inv_A = invertMat_4x4(a1, b1, c1, d1, a2, b2**2+c2**2+d2**2, b2**3+c2**3+d2**3, (b2**2+c2**2+d2**2)**2, a3, b3**2+c3**2+d3**2, b3**3+c3**3+d3**3, (b3**2+c3**2+d3**2)**2, a4, b4**2+c4**2+d4**2, b4**3+c4**3+d4**3, (b4**2+c4**2+d4**2)**2)
	distWaves = nil
	foreach(row inv_A
		distWaves = tconc(distWaves, s0*nth(0, row)+s1*nth(1, row)+s2*nth(2, row)+s3*nth(3, row))
	)
	car(distWaves)
)
/* Inverts a 4x4 matrix */
procedure(invertMat_4x4(a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, a4, b4, c4, d4)
	adj_A_11 = detOfMat_3x3(b2, c2, d2, b3, c3, d3, b4, c4, d4)
	adj_A_12 = -1*detOfMat_3x3(a2, c2, d2, a3, c3, d3, a4, c4, d4)
	adj_A_13 = detOfMat_3x3(a2, b2, d2, a3, b3, d3, a4, b4, d4)
	adj_A_14 = -1*detOfMat_3x3(a2, b2, c2, a3, b3, c3, a4, b4, c4)

	adj_A_21 = -1*detOfMat_3x3(b1, c1, d1, b3, c3, d3, b4, c4, d4)
	adj_A_22 = detOfMat_3x3(a1, c1, d1, a3, c3, d3, a4, c4, d4)
	adj_A_23 = -1*detOfMat_3x3(a1, b1, d1, a3, b3, d3, a4, b4, d4)
	adj_A_24 = detOfMat_3x3(a1, b1, c1, a3, b3, c3, a4, b4, c4)

	adj_A_31 = detOfMat_3x3(b1, c1, d1, b2, c2, d2, b4, c4, d4)
	adj_A_32 = -1*detOfMat_3x3(a1, c1, d1, a2, c2, d2, a4, c4, d4)
	adj_A_33 = detOfMat_3x3(a1, b1, d1, a2, b2, d2, a4, b4, d4)
	adj_A_34 = -1*detOfMat_3x3(a1, b1, c1, a2, b2, c2, a4, b4, c4)

	adj_A_41 = -1*detOfMat_3x3(b1, c1, d1, b2, c2, d2, b3, c3, d3)
	adj_A_42 = detOfMat_3x3(a1, c1, d1, a2, c2, d2, a3, c3, d3)
	adj_A_43 = -1*detOfMat_3x3(a1, b1, d1, a2, b2, d2, a3, b3, d3)
	adj_A_44 = detOfMat_3x3(a1, b1, c1, a2, b2, c2, a3, b3, c3)
	
	detOfA = float(a1*adj_A_11 + b1*adj_A_12 + c1*adj_A_13 + d1*adj_A_14)
	/* detOfA = 1 */

	returnArr = nil
	tempArr = nil
	tempArr = tconc(tempArr, adj_A_11/detOfA)
	tempArr = tconc(tempArr, adj_A_21/detOfA)
	tempArr = tconc(tempArr, adj_A_31/detOfA)
	tempArr = tconc(tempArr, adj_A_41/detOfA)
	returnArr = tconc(returnArr, car(tempArr))

	tempArr = nil
        tempArr = tconc(tempArr, adj_A_12/detOfA)
        tempArr = tconc(tempArr, adj_A_22/detOfA)
        tempArr = tconc(tempArr, adj_A_32/detOfA)
        tempArr = tconc(tempArr, adj_A_42/detOfA)
        returnArr = tconc(returnArr, car(tempArr))

	tempArr = nil
        tempArr = tconc(tempArr, adj_A_13/detOfA)
        tempArr = tconc(tempArr, adj_A_23/detOfA)
        tempArr = tconc(tempArr, adj_A_33/detOfA)
        tempArr = tconc(tempArr, adj_A_43/detOfA)
        returnArr = tconc(returnArr, car(tempArr))

	tempArr = nil
        tempArr = tconc(tempArr, adj_A_14/detOfA)
        tempArr = tconc(tempArr, adj_A_24/detOfA)
        tempArr = tconc(tempArr, adj_A_34/detOfA)
        tempArr = tconc(tempArr, adj_A_44/detOfA)
        returnArr = tconc(returnArr, car(tempArr))
	
	car(returnArr)
)
/* Finds determinant of a 3x3 matrix, expands along first row */
procedure(detOfMat_3x3(a1, b1, c1, a2, b2, c2, a3, b3, c3)
	float(a1*(b2*c3-c2*b3)-b1*(a2*c3-c2*a3)+c1*(a2*b3-b2*a3))
)
