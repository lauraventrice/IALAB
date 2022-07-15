% gli uccelli volano
% i pinguini sono uccelli che non volano

uccello(X) :- pinguino(X).  % tutti i pinguini sono uccelli. Se X è un pinguino allora X è un uccello.
vola(X) :- uccello(X), \+pinguino(X).   % se X è un uccello e non è un pinguino allora X vola.

% possiamo sfruttare la negazione per fallimento: l'interprete prova a dimostrare pinguino(X), se ci riesce la negazione per fallimento è falsa e quindi non conclude che vola. Se non riesce allora avrà successo e quindi vola.

pinguino(tweety).

/*
?- uccello(tweety).
true.

?- vola(tweety).
false.
*/

/*
LA PROPRIETA' DI MONOTONICITA' DICHE CE:

se KB |= F allora KB U {C} |= F

seda KB posso inferire F, allora aggiungendo una nuova informazione alla base di conooscenza posso sempre inferire F.

Questa propriuetà non vale per la nostra base di conoscenza dei pinguini!
*/