;;*******************
;;* DOMANDE APPARTAMENTI *
;;*******************

(defmodule APARTMENTS-QUESTIONS (import QUESTIONS ?ALL))

(deffacts APARTMENTS-QUESTIONS::question-attributes
    (question (attribute prezzo-massimo)
                (the-question "Qual è il prezzo massimo che è interessat* spendere per l'appartamento? ")
                (valid-answers 200000 300000 400000 500000 600000 700000 800000 unknown)) ;; una soglia ragionevole può essere + o - 50000 euro

    (question (attribute zona)
                (the-question "In che zona vorrebbe acquistare casa? ")
                (valid-answers centro primacintura periferia unknown)) ; qua possiamo mettere 'unknown' come risposta valida?

    (question (attribute metri-quadri)
                (the-question "Di quanti metri quadri vorrebbe l'appartamento? ")
                (valid-answers 50 70 90 110 130 150 170 190 210 230 250 270 290 310 unknown))

    (question (attribute numero-vani)
                (the-question "Quanti vani devono esserci nell'appartamento? ")
                (valid-answers 1 2 3 4 5 6 unknown))

    (question (attribute numero-servizi)
                (the-question "Quanti servizi devono esserci nell'appartamento? ")
                (valid-answers 1 2 3 unknown))

    (question (attribute piano)
                (the-question "A quale piano cerca l'appartamento? ")
                (valid-answers terra primo secondo terzo quarto quinto unknown))

    (question (attribute citta)
                (the-question "In quale città cerca l'appartamento? ")
                (valid-answers torino roma milano firenze unknown))

    (question (attribute quartiere)
                ;(precursors boxauto is si) ;TODO: capire cosa fare in questo caso! bisogna prima chiedere la città per poter chiedere il quartiere?
                (the-question "In quale quartiere cerca l'appartamento? ")
                (valid-answers lingotto moncalieri trastevere campitelli sansiro navigli santacroce rovezzano unknown))

    ;NB: se è necessario chiedere la città prima del quartiere allora bisogna creare tante domande per il quartiere quante sono le città
    ;in questo modo se la risposta alla domanda sulla città è 'torino' allora verrà fatta la domanda sul quartiere che accetta come risposte solo lingotto e moncalieri
    ;stesso discorso in caso di scelta di una delle altre città

    (question (attribute ascensore)
                (the-question "Deve essere presente l'ascensore?? ")
                (valid-answers si no unknown))

    (question (attribute boxauto)
                (the-question "Deve essere presente il box auto? ")
                (valid-answers si no unknown))

    (question (attribute metri-quadri-boxauto)
                (precursors boxauto is si)  ; questa domanda deve essere fatta solo se la persona è interessata al box-auto
                (the-question "Di quanti metri quadri deve essere il box auto? ")
                (valid-answers unknown)) ;; TODO: sistemare -> capire che valori mettere di metri quadri 

    (question (attribute terrazino)
                (the-question "Deve essere presente il terrazzione? ")
                (valid-answers si no unknown))