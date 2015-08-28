#!/usr/bin/python

with open('output.txt') as f:
    lines = f.readlines()
    for line in lines:
        vals = line.split(',')
	unos = 0
        doses = 0
        treses = 0
        cuatros = 0
        ceros = 0
        for val in vals:
            if val == '1':
                unos = unos + 1
            elif val == '2':
                doses = doses + 1
            elif val == '3':
                treses = treses + 1
            elif val == '4':
                cuatros = cuatros + 1
            elif val == '0':
                ceros = ceros + 1
        m = max(unos, doses, max(treses, cuatros, ceros))
        if ceros == unos and unos == doses and doses == treses and treses == cuatros:
            print '0'
        elif ceros == m:
            print '0'
        elif unos == m:
            print '1'
        elif doses == m:
            print '2'
        elif treses == m:
            print '3'
        elif cuatros == m:
            print '4'


