function max(a,b,c,d,e) {
m = a
col = 0
if(b>m) { m = b; col = 1; }
if(c>m) { m = c; col = 2; }
if(d>m) { m = d; col = 3; }
if(e>m) { m = e; col = 4; }

return col
}

BEGIN { FS = "," } ;

{
m1 = max($1,$2,$3,$4,$5)
m2 = max($6,$7,$8,$9,$10)
m3 = max($11,$12,$13,$14,$15)
m4 = max($16,$17,$18,$19,$20)
m5 = max($21,$22,$23,$24,$25)
m6 = max($26,$27,$28,$29,$30)
m7 = max($31,$32,$33,$34,$35)
m8 = max($36,$37,$38,$39,$40)
m9 = max($41,$42,$43,$44,$45)
m10 = max($46,$47,$48,$49,$50)
m11 = max($51,$52,$53,$54,$55)
m12 = max($56,$57,$58,$59,$60)

ma[0] = 0
ma[1] = 0
ma[2] = 0
ma[3] = 0
ma[4] = 0

ma[m1]++
ma[m2]++
ma[m3]++
ma[m4]++
ma[m5]++
ma[m6]++
ma[m7]++
ma[m8]++
ma[m9]++
ma[m10]++
ma[m11]++
ma[m12]++

maximum = max(ma[0],ma[1],ma[2],ma[3],ma[4])
print maximum
}
