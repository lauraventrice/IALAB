;;*******************
;;* DOMANDE APPARTAMENTI *
;;*******************

(defmodule APARTMENTS-QUESTIONS (import QUESTIONS ?ALL) (export ?ALL))

(deffacts APARTMENTS-QUESTIONS::question-attributes
    (question (attribute prezzo-massimo)
        (the-question "Qual è il prezzo massimo che preferirebbe spendere per l'appartamento? (possibili risposte 200000 300000 400000 500000 600000 700000 800000 unknown): ")
        (valid-answers 200000 300000 400000 500000 600000 700000 800000 unknown)) ;; una soglia ragionevole può essere + o - 50000 euro

    (question (attribute zona)
        (the-question "Preferirebbe trovare la casa in centro, nella primacintura o in periferia? ")
        (valid-answers centro primacintura periferia unknown))

    (question (attribute metri-quadri)
        (the-question "Di quanti metri quadri preferirebbe l'appartamento? possibili valori (50 70 90 110 130 150 170 190 210 230 250 270 290 310 unknown): ")
        (valid-answers 50 70 90 110 130 150 170 190 210 230 250 270 290 310 unknown))

    (question (attribute numero-vani)
        (the-question "Preferirebbe avere 1, 2 o 3 vani nell'appartamento? ")
        (valid-answers 1 2 3 unknown))

    (question (attribute numero-servizi)
        (the-question "Preferirebbe avere 1, 2 o 3 servizi nell'appartamento? ")
        (valid-answers 1 2 3 unknown))

    (question (attribute numero-piano)
        (the-question "Preferirebbe trovare la casa al piano 0, 1, 2 o 3 piano?  ")
        (valid-answers 0 1 2 3 unknown))

    (question (attribute citta)
        (the-question "Preferirebbe trovare l'appartamento a torino, roma, milano o firenze? ")
        (valid-answers torino roma milano firenze unknown)) 

    ; ; ; Caratteristiche aggiuntive dell'appartamento
    ; ; ; ----------------------------------------------------------------------------------------

    (question (attribute ascensore)
        (the-question "Preferirebbe che fosse presente l'ascensore? ")
        (valid-answers si no unknown))

    (question (attribute boxauto)
        (the-question "Preferirebbe che fosse presente il box auto? ")
        (valid-answers si no unknown))

    (question (attribute terrazzino)
        (the-question "Preferirebbe che fosse presente il terrazzino? ")
        (valid-answers si no unknown))

    ; ; ; Domande più generiche sulla persona che cerca l'appartamento
    ; ; ; ----------------------------------------------------------------------------------------

    (question (attribute ha-figli-piccoli)
        (the-question "Ha dei figli piccoli? ")
        (valid-answers si no))  

    (question (attribute ha-animali)
        (the-question "Ha degli animali domestici? ")
        (valid-answers si no))

    (question (attribute ha-piudi60anni)
        (the-question "Ha più di 60 anni? ")
        (valid-answers si no))

    (question (attribute e-sportivo)
        (the-question "E' uno sportiv*? ")
        (valid-answers si no))

    (question (attribute e-automunito)
        (the-question "E' automunit*? ")
        (valid-answers si no))

    (question (attribute preferisce)
        (precursors citta is unknown)   ; se l'utente non ha fornito la risposta per la citta allora chiediamo se preferisce mare o montagna
        (the-question "Preferisce il mare o la montagna? ")
        (valid-answers mare montagna unknown))

)