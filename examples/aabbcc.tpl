// a's durch v tauschen
// b's eliminieren
1 case a jump 3
2 halt
3 write v
4 right
5 case a jump 4
6 case b jump 4
7 case c jump 4
8 case * jump 11
9 case # jump 11
10 halt
11 left
12 case c jump 14
13 halt
14 write *
15 left
16 case b jump 28
17 case c jump 19
18 halt
19 left
20 case c jump 19
21 case b jump 19
22 case a jump 19
23 case v jump 25
24 halt
25 right
26 case a jump 3
27 halt  //abbruch, zu viele c's

// überüfen ob noch a's vorkommen
28 left
29 case b jump 28
30 case v jump 28
31 case # jump 33
32 halt  //abbruch, zu viele a's

// v und b überprüfen
33 right
34 case v jump 36
35 halt // zu viele b's
36 write *
37 right
38 case v jump 37
39 case b jump 37
40 case * jump 42
41 halt
42 left
43 case b jump 49
44 case v jump 47
45 case * jump 48
46 halt
47 halt // zu wenig b's
48 halt // zu wenig b's
49 write *

50 left
51 case b jump 54
52 case * jump 58
53 halt // zu wenig b's

54 left
55 case b jump 54
56 case v jump 54
57 case * jump 33

58 halt