#!/usr/bin/python

import random
from random import randint
import fileinput

def ncopies(hazard):
    if hazard < 3:
      return 1
    elif hazard < 6:
      return 2
    elif hazard < 9:
      return 5
    elif hazard < 12:
      return 11
    else:
      return 12


idx1 = [2,3,4,11,14,15,19,20,22,24,25,26,27,28,32,33]
idx2 = [5,6,7,8,9,10,12,13,16,17,18,21,23,29,30,31]

mean = [9.722093,12.84759,3.186004,7.020451,13.99625,1.578521,57.58005,12.41962,
        10.2595,1.948215,33.48775,1.032236,12.49303,4.49652,2.451126,3.48448]

sigma = [5.167943,6.255743,1.739369,3.595279,4.647499,0.8628816,23.49982,
       4.783411,4.852008,0.8001166,5.834038,0.1958932,7.314788,1.896717,
       1.260074,3.076745]
      
classes = [
["B", "C", "E", "G", "H", "N", "S", "W"],
["A", "B", "C", "D", "E", "H", "I", "J", "K", "L"],
["N", "Y"],
["A", "B", "C", "D"],
["A", "B", "C", "D"],
["B", "C", "D", "E", "F", "G"],
["A", "B", "D", "E", "F", "H", "I", "J", "K", "L", "M", "N"],
["A", "B", "C", "D"],
["A", "C", "D", "F", "H", "N", "S", "W"],
["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R"],
["N", "Y"],
["N", "Y"],
["A", "B", "C", "D", "E", "F"],
["N", "Y"],
["N", "Y"],
["A", "B", "C", "D", "E"],
]

randomels = 5
features = 32
for line in fileinput.input():
    line = line.rstrip('\n')
    valors = line.split(',')
    haz = int(valors[1])
    for j in range(ncopies(haz)):
	valors = line.split(',')
	v = random.sample(range(32), randomels)        
	for l in v:
            index = l%16
            typ = l/16
            if typ == 0:
                val = random.normalvariate(mean[index], sigma[index])
		if val < 0:
			val = 0
                valors[idx1[index]] = str(val)
            else:
                l = randint(0,len(classes[index])-1)
                valors[idx2[index]] = classes[index][l]
        print ','.join(valors)

