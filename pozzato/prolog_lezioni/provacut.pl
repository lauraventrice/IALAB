gatto(pippo).
gatto(tom).
gatto(fred).
grigio(fred).

p(X) :- gatto(X), !, grigio(X).

/*
?- p(X).
false.

[trace]  ?- p(X).
   Call: (10) p(_1230) ? creep
   Call: (11) gatto(_1230) ? creep
   Exit: (11) gatto(pippo) ? creep
   Call: (11) grigio(pippo) ? creep
   Fail: (11) grigio(pippo) ? creep
   Fail: (10) p(_1230) ? creep
false.

Il cut ha tagliato i punti di backtracking e quindi non ariverà mai ad esplorare la strada con gatto(fred)!

?- p(fred).
true.

Se istanzo già dall'inizio la variabile X non ho problemi.

p(fred) unifica subito con la testa e quindi va a verificare gatto(fred), il cut e grigio(fred).

In questo caso non si hanno alternative con il backtracking quindi il cut non ha effetto!

*/

pNuovo(X) :- gatto(X), grigio(X).

/*
?- pNuovo(X).
X = fred.

[trace]  ?- pNuovo(X).
   Call: (10) pNuovo(_1232) ? creep
   Call: (11) gatto(_1232) ? creep
   Exit: (11) gatto(pippo) ? creep
   Call: (11) grigio(pippo) ? creep
   Fail: (11) grigio(pippo) ? creep
   Redo: (11) gatto(_1232) ? creep
   Exit: (11) gatto(tom) ? creep
   Call: (11) grigio(tom) ? creep
   Fail: (11) grigio(tom) ? creep
   Redo: (11) gatto(_1232) ? creep
   Exit: (11) gatto(fred) ? creep
   Call: (11) grigio(fred) ? creep
   Exit: (11) grigio(fred) ? creep
   Exit: (10) pNuovo(fred) ? creep
X = fred.

in questo caso ha i punto di backgracking!
*/