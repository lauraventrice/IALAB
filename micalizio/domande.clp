;;*******************
;;* DOMANDE APPARTAMENTI *
;;*******************

(defmodule APARTMENTS-QUESTIONS (import QUESTIONS ?ALL) (export ?ALL))

(deffacts APARTMENTS-QUESTIONS::question-attributes
    (question (attribute prezzo-massimo)
        (the-question "Qual è il prezzo massimo che preferirebbe spendere per l'appartamento? (possibili risposte 200000 300000 400000 500000 600000 700000 800000 unknown): ")
        (valid-answers 200000 300000 400000 500000 600000 700000 800000 unknown)) ;; una soglia ragionevole può essere + o - 50000 euro

    ; (question (attribute zona)
    ;     (the-question "Preferirebbe trovare la casa in centro, nella primacintura o in periferia? ")
    ;     (valid-answers centro primacintura periferia unknown))

    ; (question (attribute metri-quadri)
    ;     (the-question "Di quanti metri quadri preferirebbe l'appartamento? possibili valori (50 70 90 110 130 150 170 190 210 230 250 270 290 310 unknown): ")
    ;     (valid-answers 50 70 90 110 130 150 170 190 210 230 250 270 290 310 unknown))

    ; (question (attribute numero-vani)
    ;     (the-question "Preferirebbe avere 1, 2, 3, 4, 5 o 6 vani nell'appartamento? ")
    ;     (valid-answers 1 2 3 4 5 6 unknown))

    ; (question (attribute numero-servizi)
    ;     (the-question "Preferirebbe avere 1, 2 o 3 servizi nell'appartamento? ")
    ;     (valid-answers 1 2 3 unknown))

    ; (question (attribute numero-piano)
    ;     (the-question "Preferirebbe trovare la casa al primo, secondo, terzo, quarto o quinto piano?  ")
    ;     (valid-answers terra primo secondo terzo quarto quinto unknown))

    ; (question (attribute citta)
    ;     (the-question "Preferirebbe trovare l'appartamento a torino, roma, milano o firenze? ")
    ;     (valid-answers torino roma milano firenze unknown)) 

    ; ; ; domande sul quartiere in base alla città inserita
    ; ; ; ----------------------------------------------------------------------------------------
    
    ; ; (question (attribute quartiere)
    ; ;     (precursors citta is torino)
    ; ;     (the-question "Preferirebbe trovare l'appartamento in zona lingotto o moncalieri? ")
    ; ;     (valid-answers lingotto moncalieri unknown))

    ; ; (question (attribute quartiere)
    ; ;     (precursors citta is roma)
    ; ;     (the-question "Preferirebbe trovare l'appartamento in zona trastevere o campitelli? ")
    ; ;     (valid-answers trastevere campitelli unknown))

    ; ; (question (attribute quartiere)
    ; ;     (precursors citta is milano)
    ; ;     (the-question "Preferirebbe trovare l'appartamento in zona sansiro o navigli? ")
    ; ;     (valid-answers sansiro navigli unknown))

    ; ; (question (attribute quartiere)
    ; ;     (precursors citta is firenze)
    ; ;     (the-question "Preferirebbe trovare l'appartamento in zona santacroce o rovezzano? ")
    ; ;     (valid-answers santacroce rovezzano unknown))


    ; ; ; Caratteristiche aggiuntive dell'appartamento
    ; ; ; ----------------------------------------------------------------------------------------

    (question (attribute ascensore)
        (the-question "Deve essere presente l'ascensore? ")
        (valid-answers si no unknown))

    ; (question (attribute boxauto)
    ;     (the-question "Deve essere presente il box auto? ")
    ;     (valid-answers si no unknown))

    ; ; (question (attribute metri-quadri-boxauto)
    ; ;     (precursors boxauto is si)  ; questa domanda deve essere fatta solo se la persona è interessata al box-auto
    ; ;     (the-question "Di quanti metri quadri deve essere il box auto? ")
    ; ;     (valid-answers unknown)) ;; TODO: sistemare -> capire che valori mettere di metri quadri 

    ; (question (attribute terrazzino)
    ;     (the-question "Deve essere presente il terrazzino? ")
    ;     (valid-answers si no unknown))

    ; ; ; Domande più generiche sulla persona che cerca l'appartamento
    ; ; ; ----------------------------------------------------------------------------------------

    ; ; ; TODO: capire che fare -> PER ME LA RISPSOTA UNKNOWN NON HA SENSO PER QUESTE DOMANDE!

    ; (question (attribute ha-figli-piccoli)
    ;     (the-question "Ha dei figli piccoli? ")
    ;     (valid-answers si no unknown))  

    ; (question (attribute ha-animali)
    ;     (the-question "Ha degli animali domestici? ")
    ;     (valid-answers si no unknown))

    ; (question (attribute ha-piudi60anni)
    ;     (the-question "Ha più di 60 anni? ")
    ;     (valid-answers si no unknown))

    ; (question (attribute e-sportivo)
    ;     (the-question "E' uno sportivo? ")
    ;     (valid-answers si no unknown))

)