procedure(CCFbuildMatrix(N)
  let((matrix column)
    matrix=makeVector(N)
    for(x 0 N-1
      matrix[x]=column=makeVector(N)
      for(y 0 N-1
        column[y]=1
      )
    )
  matrix
  )
)

matrix[1][1]=(a1**2+b1**2+c1**2)
matrix[2][1]=(a2**2+b2**2+c2**2)
matrix[3][1]=(a3**2+b3**2+c3**2)

matrix[1][2]=(a1**3+b1**3+c1**3)
matrix[2][2]=(a2**3+b2**3+c2**3)
matrix[3][2]=(a3**3+b3**3+c3**3)

matrix[1][3]=(a1**2+b1**2+c1**2)**2
matrix[2][3]=(a2**2+b2**2+c2**2)**2
matrix[3][3]=(a3**2+b3**2+c3**2)**2

h = outfile("new_file.txt", "w")

for(x 0 N-1
      for(y 0 N-1
        fprintf(h,"%f",matrix[x][y])
      )
    )

shell("bash callPython.sh")


h = infile("existing_file.txt")

str = lineread(h)





