% eseguire prima ['primoesempio.pl'].
% in seguito si può interrogare l'interprete
% le costanti sono scritte con la lettera minuscola
% le variabili sono scritte con la lettera maiuscola

% se non si usa il trace. quando premiamo invio otteniamo subito l'esito del ragionamentomiagola(fred9.)
% trace. serve ad avere un debug: l'interprete mostra passo per passo cosa cerca di dimostrare
% per disattivare il trace. si usa nodebug.

% Fatti
gatto(tom).
gatto(fred).
tigre(mike).
vivo(tom).
graffia(mike).
mangia(fred).

% Regole
felino(X):-gatto(X).    % ogni gatto è un felino: per ogni X, gatto X implica felino X
felino(X):-tigre(X).    % ogni tigre è un felino: per ogni X, tigre X implica felino X
miagola(X):-gatto(X),vivo(X).   %X miagola se X è un gatto e X è vivo (i fatti a destra sono in AND)
% chiedendo miagola(tom). l'interprete cerca di dimostrare prima gatto(tom) e se questo è vero, allora prova a dimostrare vivo(tom)

% per scrivere una disgiunzione scriviamo diverse clausole separate
vivo(X):-graffia(X).    % se qualcuno mi ha graffiato è vivo: per ogni X, graffia X implica vivo X
vivo(X):-mangia(X).