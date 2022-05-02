# IALAB
Development of Pozzato's project. 

## Come eseguire?

Per eseguire questo progetto è necessario eseguire i seguenti passi:
- eseguire l'interprete di CLINGO con il comando _clingo progettoNOME.cl_


## Quali versioni sono presenti in questo progetto?

Il file _'progettoBase.cl'_ include i seguenti vincoli:

- sono presenti ***20 squadre***;
- il campionato prevede ***38 giornate, 19 di andata e 19 di ritorno NON simmetriche***, ossia la giornata 1 di ritorno non coincide necessariamente con la giornata 1 di andata a campi invertiti;
- ogni squadra fa riferimento ad una ***citta'***, che offre la struttura in cui la squadra gioca gli incontri in casa;
- ogni squadra ***affronta due volte tutte le altre squadre***, una volta in casa e una volta fuori casa, ossia una volta nella propria città di riferimento e una volta in quella dell’altra squadra;
- due squadre della stessa città condividono la stessa struttura di gioco, quindi
***non possono giocare entrambe in casa nella stessa giornata***;
- ci sono ***3 derby***, ossia 3 coppie di squadre che fanno riferimento alla medesima città.

Il file _'progettoPiccoloBase.cl'_ include i seguenti vincoli:

- sono presenti ***6 squadre***;
- il campionato prevede ***10 giornate, 5 di andata e 5 di ritorno NON simmetriche***, ossia la giornata 1 di ritorno non coincide necessariamente con la giornata 1 di andata a campi invertiti;
- tutti quelli presenti per _'progettoBase.cl_ .

Il file _'progettoPiccoloBase.cl'_ include i seguenti vincoli:

- ciascuna squadra non deve giocare mai più di ***due partite consecutive in casa o fuori casa***;
- ci sono ***4 derby***;
- ***la distanza tra una coppia di gare*** di andata e ritorno è di almeno 10 giornate, ossia se SquadraA vs SquadraB è programmata per la giornata 12, il ritorno SquadraB vs SquadraA verrà schedulato non prima dalla giornata 22.
- tutti quelli presenti per _'progettoBase.cl_ ;

### Cosa si ottiene dalla esecuzione da ognuno dei progetti?

L'esecuzione genera più modelli che rispettano i vincoli, in particolare un calendario con l'associazione della giornata ad una 
partita. 

*NB!*  ogni predicato _assegnaAGiornata_ è da interpretare nel seguente modo: (#giornata, squadra in casa, squadra ospite)


