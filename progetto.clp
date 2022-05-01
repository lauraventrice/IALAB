
;;;======================================================
;;;   Wine Expert Sample Problem
;;;
;;;     WINEX: The WINe EXpert system.
;;;     This example selects an appropriate wine
;;;     to drink with a meal.
;;;
;;;     CLIPS Version 6.0 Example
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================

(defmodule MAIN (export ?ALL))

;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction MAIN::ask-question (?question ?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)

;;*****************
;;* INITIAL STATE *
;;*****************

(deftemplate MAIN::attribute
   (slot name)
   (slot value)
   (slot certainty (default 100.0)))

(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-QUALITIES APPARTAMENTI PRINT-RESULTS))

(defrule MAIN::combine-certainties ""
  (declare (salience 100)
           (auto-focus TRUE))
  ?rem1 <- (attribute (name ?rel) (value ?val) (certainty ?per1))
  ?rem2 <- (attribute (name ?rel) (value ?val) (certainty ?per2))
  (test (neq ?rem1 ?rem2))
  =>
  (retract ?rem1)
  (modify ?rem2 (certainty (/ (- (* 100 (+ ?per1 ?per2)) (* ?per1 ?per2)) 100))))
  
;;******************
;;* QUESTION RULES *
;;******************

(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))

(deftemplate QUESTIONS::question
   (slot attribute (default ?NONE))
   (slot the-question (default ?NONE))
   (multislot valid-answers (default ?NONE))
   (slot already-asked (default FALSE))
   (multislot precursors (default ?DERIVE)))
   
(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))

(defrule QUESTIONS::precursor-is-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is ?value $?rest))
         (attribute (name ?name) (value ?value))
   =>
   (if (eq (nth 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))

(defrule QUESTIONS::precursor-is-not-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is-not ?value $?rest))
         (attribute (name ?name) (value ~?value))
   =>
   (if (eq (nth 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))









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

    ; domande sul quartiere in base alla città inserita
    ; ----------------------------------------------------------------------------------------
    
    (question (attribute quartiere)
                (precursors citta is torino)
                (the-question "In quale quartiere cerca l'appartamento? ")
                (valid-answers lingotto moncalieri unknown))

    (question (attribute quartiere)
                (precursors citta is roma)
                (the-question "In quale quartiere cerca l'appartamento? ")
                (valid-answers trastevere campitelli unknown))

    (question (attribute quartiere)
                (precursors citta is milano)
                (the-question "In quale quartiere cerca l'appartamento? ")
                (valid-answers sansiro navigli unknown))

    (question (attribute quartiere)
                (precursors citta is firenze)
                (the-question "In quale quartiere cerca l'appartamento? ")
                (valid-answers santacroce rovezzano unknown))

    ; ----------------------------------------------------------------------------------------

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
 










;;******************
;; The RULES module
;;******************

(defmodule RULES (import MAIN ?ALL) (export ?ALL))

(deftemplate RULES::rule
  (slot certainty (default 100.0))
  (multislot if)
  (multislot then))

(defrule RULES::throw-away-ands-in-antecedent
  ?f <- (rule (if and $?rest))
  =>
  (modify ?f (if ?rest)))

(defrule RULES::throw-away-ands-in-consequent
  ?f <- (rule (then and $?rest))
  =>
  (modify ?f (then ?rest)))

(defrule RULES::remove-is-condition-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (if ?attribute is ?value $?rest))
  (attribute (name ?attribute) 
             (value ?value) 
             (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::remove-is-not-condition-when-satisfied
  ?f <- (rule (certainty ?c1) 
              (if ?attribute is-not ?value $?rest))
  (attribute (name ?attribute) (value ~?value) (certainty ?c2))
  =>
  (modify ?f (certainty (min ?c1 ?c2)) (if ?rest)))

(defrule RULES::perform-rule-consequent-with-certainty
  ?f <- (rule (certainty ?c1) 
              (if) 
              (then ?attribute is ?value with certainty ?c2 $?rest))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) 
                     (value ?value)
                     (certainty (/ (* ?c1 ?c2) 100)))))

(defrule RULES::perform-rule-consequent-without-certainty
  ?f <- (rule (certainty ?c1)
              (if)
              (then ?attribute is ?value $?rest))
  (test (or (eq (length$ ?rest) 0)
            (neq (nth 1 ?rest) with)))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) (value ?value) (certainty ?c1))))

;;*******************************
;;* CHOOSE WINE QUALITIES RULES *
;;*******************************

(defmodule CHOOSE-QUALITIES (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-QUALITIES::startit => (focus RULES))

(deffacts the-wine-rules

  ; Rules for picking the best body

  (rule (if has-sauce is yes and 
            sauce is spicy)
        (then best-body is full))

  (rule (if tastiness is delicate)
        (then best-body is light))

  (rule (if tastiness is average)
        (then best-body is light with certainty 30 and
              best-body is medium with certainty 60 and
              best-body is full with certainty 30))

  (rule (if tastiness is strong)
        (then best-body is medium with certainty 40 and
              best-body is full with certainty 80))

  (rule (if has-sauce is yes and
            sauce is cream)
        (then best-body is medium with certainty 40 and
              best-body is full with certainty 60))

  (rule (if preferred-body is full)
        (then best-body is full with certainty 40))

  (rule (if preferred-body is medium)
        (then best-body is medium with certainty 40))

  (rule (if preferred-body is light) 
        (then best-body is light with certainty 40))

  (rule (if preferred-body is light and
            best-body is full)
        (then best-body is medium))

  (rule (if preferred-body is full and
            best-body is light)
        (then best-body is medium))

  (rule (if preferred-body is unknown) 
        (then best-body is light with certainty 20 and
              best-body is medium with certainty 20 and
              best-body is full with certainty 20))

  ; Rules for picking the best color

  (rule (if main-component is meat)
        (then best-color is red with certainty 90))

  (rule (if main-component is poultry and
            has-turkey is no)
        (then best-color is white with certainty 90 and
              best-color is red with certainty 30))

  (rule (if main-component is poultry and
            has-turkey is yes)
        (then best-color is red with certainty 80 and
              best-color is white with certainty 50))

  (rule (if main-component is fish)
        (then best-color is white))

  (rule (if main-component is-not fish and
            has-sauce is yes and
            sauce is tomato)
        (then best-color is red))

  (rule (if has-sauce is yes and
            sauce is cream)
        (then best-color is white with certainty 40))
                   
  (rule (if preferred-color is red)
        (then best-color is red with certainty 40))

  (rule (if preferred-color is white)
        (then best-color is white with certainty 40))

  (rule (if preferred-color is unknown)
        (then best-color is red with certainty 20 and
              best-color is white with certainty 20))
  
  ; Rules for picking the best sweetness

  (rule (if has-sauce is yes and
            sauce is sweet)
        (then best-sweetness is sweet with certainty 90 and
              best-sweetness is medium with certainty 40))

  (rule (if preferred-sweetness is dry)
        (then best-sweetness is dry with certainty 40))

  (rule (if preferred-sweetness is medium)
        (then best-sweetness is medium with certainty 40))

  (rule (if preferred-sweetness is sweet)
        (then best-sweetness is sweet with certainty 40))

  (rule (if best-sweetness is sweet and
            preferred-sweetness is dry)
        (then best-sweetness is medium))

  (rule (if best-sweetness is dry and
            preferred-sweetness is sweet) 
        (then best-sweetness is medium))

  (rule (if preferred-sweetness is unknown)
        (then best-sweetness is dry with certainty 20 and
              best-sweetness is medium with certainty 20 and
              best-sweetness is sweet with certainty 20))

)

;;************************
;;* APARTMENT SELECTION RULES *
;;************************

(defmodule APPARTAMENTI (import MAIN ?ALL))

;;TODO: capire come adattare qualcosa del genere al nostro dominio degli appartamenti
(deffacts any-attributes
  (attribute (name best-color) (value any))
  (attribute (name best-body) (value any))
  (attribute (name best-sweetness) (value any)))

(deftemplate APPARTAMENTI::apartment
    (slot name (default ?NONE))
    (slot metriquadri (default ?NONE))
    (slot numerovani (default ?NONE))
    (slot numeroservizi (default ?NONE))
    (slot piano (default ?NONE))
    (slot citta (default ?NONE))
    (slot zona (default ?NONE))
    (slot quartiere (default ?NONE))
    (slot ascensore (default ?NONE))
    (slot boxauto (default ?NONE))
    (slot metriqudriboxauto (default ?NONE))
    (slot terrazzino (default ?NONE))
    (slot prezzorichiesto (default ?NONE)) ; capire se possa avere senso usare un multislot per il prezzo richiesto: secondo me no!
  )

(deffacts APPARTAMENTI::the-apartment-list 
    ; lista appartamenti a moncalieri (torino)
    (apartment  (name "Appartamento su due piani in vendita in strada dei Cunioli Alti, 137")
                (metriquadri 137) (numerovani 4) (numeroservizi 3) (piano secondo) (citta torino) (zona primacintura) (quartiere moncalieri)
                (ascensore no) (boxauto si) (metriqudriboxauto 3) (terrazzino si) (prezzorichiesto 375000)
    )

    (apartment  (name "Quadrilocale in vendita in strada Genova, 255 /4")
                (metriquadri 110) (numerovani 4) (numeroservizi 2) (piano primo) (citta torino) (zona primacintura) (quartiere moncalieri)
                (ascensore si) (boxauto si) (metriqudriboxauto 5) (terrazzino si) (prezzorichiesto 240000)
    )

    (apartment  (name "Trilocale in vendita in strada Genova, 208")
                (metriquadri 83) (numerovani 3) (numeroservizi 1) (piano primo) (citta torino) (zona periferia) (quartiere moncalieri)
                (ascensore no) (boxauto si) (metriqudriboxauto 3) (terrazzino si) (prezzorichiesto 157000)
    )

    ; lista appartamenti a lingotto (torino)
    (apartment  (name "Attico in vendita in via Onorato Vigliani, 24")
                (metriquadri 170) (numerovani 7) (numeroservizi 2) (piano quinto) (citta torino) (zona centro) (quartiere lingotto)
                (ascensore si) (boxauto si) (metriqudriboxauto 7) (terrazzino si) (prezzorichiesto 465000)
    )

    (apartment  (name "Trilocale in vendita in via Fratel Teodoreto, 3")
                (metriquadri 75) (numerovani 3) (numeroservizi 1) (piano primo) (citta torino) (zona primacintura) (quartiere lingotto)
                (ascensore si) (boxauto no) (terrazzino si) (prezzorichiesto 114000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Appartamento in vendita in via Filadelfia, 50")
                (metriquadri 130) (numerovani 5) (numeroservizi 2) (piano primo) (citta torino) (zona centro) (quartiere lingotto)
                (ascensore si) (boxauto si) (metriqudriboxauto 4) (terrazzino si) (prezzorichiesto 260000)
    )

    ; lista appartamenti a trastevere (roma)
    (apartment  (name "Appartamento in vendita in via di San Crisogono")
                (metriquadri 140) (numerovani 5) (numeroservizi 2) (piano secondo) (citta roma) (zona centro) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 895000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )
  
    (apartment  (name "Trilocale in vendita in vicolo del Bologna s.n.c")
                (metriquadri 68) (numerovani 3) (numeroservizi 2) (piano terra) (citta roma) (zona centro) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 315000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita in via del Politeama")
                (metriquadri 84) (numerovani 2) (numeroservizi 2) (piano terra) (citta roma) (zona centro) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 500000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a campitelli (roma)
    (apartment  (name "Bilocale in vendita in piazza Margana, 20")
                (metriquadri 60) (numerovani 2) (numeroservizi 1) (piano terra) (citta roma) (zona centro) (quartiere campitelli)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 460000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Quadrilocale in vendita in via fori imperiali")
                (metriquadri 120) (numerovani 4) (numeroservizi 2) (piano terzo) (citta roma) (zona centro) (quartiere campitelli)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 747000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita a Aventino - San Saba")
                (metriquadri 120) (numerovani 2) (numeroservizi 2) (piano quarto) (citta roma) (zona centro) (quartiere campitelli)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 950000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a san siro (milano)
    (apartment  (name "Bilocale in vendita in piazza Margana, 20")
                (metriquadri 63) (numerovani 2) (numeroservizi 1) (piano primo) (citta milano) (zona primacintura) (quartiere sansiro)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 200000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Appartamento su due piani in vendita in via Matteo Civitali, 41")
                (metriquadri 66) (numerovani 2) (numeroservizi 1) (piano terzo) (citta milano) (zona primacintura) (quartiere sansiro)
                (ascensore no) (boxauto si) (metriqudriboxauto 4) (terrazzino no) (prezzorichiesto 450000)
    )

    (apartment  (name "Appartamento in vendita in piazza Santa Maria Nascente s.n.c")
                (metriquadri 200) (numerovani 5) (numeroservizi 1) (piano primo) (citta milano) (zona centro) (quartiere sansiro)
                (ascensore no) (boxauto si) (metriqudriboxauto 6) (terrazzino no) (prezzorichiesto 890000)
    )

    ; lista appartamenti a navigli (milano)
    (apartment  (name "Trilocale in vendita in via San Calocero, 9")
                (metriquadri 102) (numerovani 3) (numeroservizi 3) (piano terzo) (citta milano) (zona centro) (quartiere navigli)
                (ascensore si) (boxauto si) (metriqudriboxauto 6) (terrazzino no) (prezzorichiesto 950000)
    )

    (apartment  (name "Bilocale in vendita in piazza Ventiquattro Maggio s.n.c")
                (metriquadri 50) (numerovani 2) (numeroservizi 2) (piano primo) (citta milano) (zona periferia) (quartiere navigli)
                (ascensore no) (boxauto si) (metriqudriboxauto 4) (terrazzino si) (prezzorichiesto 235000)
    )

    (apartment  (name "Monolocale in vendita in piazza Serafino Belfanti, 1")
                (metriquadri 36) (numerovani 1) (numeroservizi 1) (piano primo) (citta milano) (zona primacintura) (quartiere navigli)
                (ascensore si) (boxauto no) (terrazzino si) (prezzorichiesto 165000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a santa croce (firenze)
    (apartment  (name "Trilocale in vendita in Campo San Giacomo da l'Orio s.n.c")
                (metriquadri 85) (numerovani 3) (numeroservizi 2) (piano primo) (citta firenze) (zona centro) (quartiere santacroce)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 330000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Quadrilocale in vendita in Santa Croce")
                (metriquadri 110) (numerovani 4) (numeroservizi 1) (piano primo) (citta firenze) (zona centro) (quartiere santacroce)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 590000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita a Santa Croce")
                (metriquadri 39) (numerovani 2) (numeroservizi 1) (piano primo) (citta firenze) (zona primacintura) (quartiere santacroce)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 220000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a rovezzano (firenze)
    (apartment  (name "Quadrilocale in vendita in via SANT'ANDREA A ROVEZZANO s.n.c")
                (metriquadri 110) (numerovani 4) (numeroservizi 2) (piano primo) (citta firenze) (zona centro) (quartiere rovezzano)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 280000) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita in piazza Ventiquattro Maggio s.n.c")
                (metriquadri 250) (numerovani 1) (numeroservizi 2) (piano primo) (citta firenze) (zona primacintura) (quartiere rovezzano)
                (ascensore no) (boxauto si) (metriqudriboxauto 6) (terrazzino si) (prezzorichiesto 500000)
    )

    (apartment  (name "Monolocale in vendita in via di Rocca Tedalda s.n.c")
                (metriquadri 30) (numerovani 1) (numeroservizi 1) (piano terra) (citta firenze) (zona periferia) (quartiere rovezzano)
                (ascensore no) (boxauto si) (metriqudriboxauto 6) (terrazzino si) (prezzorichiesto 168000)
    )

)
  
(defrule APPARTAMENTI::generate-wines
  (wine (name ?name)
        (color $? ?c $?)
        (body $? ?b $?)
        (sweetness $? ?s $?))
  (attribute (name best-color) (value ?c) (certainty ?certainty-1))
  (attribute (name best-body) (value ?b) (certainty ?certainty-2))
  (attribute (name best-sweetness) (value ?s) (certainty ?certainty-3))
  =>
  (assert (attribute (name wine) (value ?name)
                     (certainty (min ?certainty-1 ?certainty-2 ?certainty-3)))))

;;*****************************
;;* PRINT SELECTED WINE RULES *
;;*****************************

(defmodule PRINT-RESULTS (import MAIN ?ALL))

(defrule PRINT-RESULTS::header ""
   (declare (salience 10))
   =>
   (printout t t)
   (printout t "        SELECTED WINES" t t)
   (printout t " WINE                  CERTAINTY" t)
   (printout t " -------------------------------" t)
   (assert (phase print-wines)))

(defrule PRINT-RESULTS::print-wine ""
  ?rem <- (attribute (name wine) (value ?name) (certainty ?per))		  
  (not (attribute (name wine) (certainty ?per1&:(> ?per1 ?per))))
  =>
  (retract ?rem)
  (format t " %-24s %2d%%%n" ?name ?per))

(defrule PRINT-RESULTS::remove-poor-wine-choices ""
  ?rem <- (attribute (name wine) (certainty ?per&:(< ?per 20)))
  =>
  (retract ?rem))

(defrule PRINT-RESULTS::end-spaces ""
   (not (attribute (name wine)))
   =>
   (printout t t))



