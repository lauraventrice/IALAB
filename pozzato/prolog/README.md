# IALAB
Development of Artificial Intelligence and Laboratory's project. 

## Come eseguire?

Per eseguire questo progetto è necessario eseguire i seguenti passi:
- avviare l'interprete di prolog;
- caricare il file progetto.pl con il seguente comando: _['progetto.pl']._ ;
- eseguire uno dei predicati disponibili nel file.

>  *NB!*  ogni predicato si occupa di eseguire l'algoritmo di ricerca corrispondente fornendo in output sullo schermo sia la lista delle azioni da eseguire (tessere da spostare) per raggiungere lo stato finale, sia il tempo totale di esecuzione.

## Quali algoritmi di ricerca nello spazio degli stati sono presenti in questo progetto?

Il file _'progetto.pl'_ include i seguenti predicati:
- ***startIDAstarHeuristic1***: esso si occupa di eseguire l'algoritmo di ricerca IDA* nella versione che utilizza come euristica il numero di tessere fuori posto;
- ***startIDAstarHeuristic2***: esso si occupa di eseguire l'algoritmo di ricerca IDA* nella versione che utilizza come euristica il numero di inversioni presenti nella lista rappresentante lo stato;
- ***startRicercaProfonditaBasic***: esso si occupa di eseguire l'algoritmo di ricerca in profondità basilare;
- ***startRicercaProfonditaLimitata***: esso si occupa di eseguire l'algoritmo di ricerca in profondità limitata;
- ***startRicercaIterativeDeepening***: esso si occupa di eseguire l'algoritmo di ricerca Iterative deepening restituendo la prima soluzione disponibile e fornendo in output a schermo anche il livello di profondità a cui la trova.

## Quali euristiche sono state implementate e usate con l'algoritmo IDA*?
Le euristiche implementate e contenute rispettivamente nei file _'heuristic1.pl'_ e _'heuristic2.pl'_ sono le seguenti:
- ***Heuristic1***: numero di tessere fuori posto;
- ***Heuristic2***: numero di inversioni presenti nella lista rappresentante lo stato.