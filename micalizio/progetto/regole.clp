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
            (neq (nth$ 1 ?rest) with)))
  =>
  (modify ?f (then ?rest))
  (assert (attribute (name ?attribute) (value ?value) (certainty ?c1))))

;;*******************************
;;* CHOOSE APARTMENT QUALITIES RULES *
;;*******************************

(defmodule CHOOSE-QUALITIES (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import APPARTAMENTI ?ALL)
                            (import MAIN ?ALL))

(defrule CHOOSE-QUALITIES::startit => (focus RULES))

; ------ REGOLE NUMERO VANI --------

(defrule CHOOSE-QUALITIES::tentativo-numero-vani-uguale

   (attribute (name numero-vani) (value ?vaniirisposta &~unknown))
   =>
   (assert (attribute (name best-numero-vani) (value ?vaniirisposta) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-vani-1

   (attribute (name numero-vani) (value 1))
   =>
   (assert (attribute (name best-numero-vani) (value 2) (certainty 70.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 40.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-vani-2

   (attribute (name numero-vani) (value 2))
   =>
   (assert (attribute (name best-numero-vani) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 70.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-vani-3

   (attribute (name numero-vani) (value 3))
   =>
   (assert (attribute (name best-numero-vani) (value 1) (certainty 40.0)))
   (assert (attribute (name best-numero-vani) (value 2) (certainty 70.0)))
)


(defrule CHOOSE-QUALITIES::numero-vani-unk

   (attribute (name numero-vani) (value unknown))
   =>
   (assert (attribute (name best-numero-vani) (value 1) (certainty 20.0)))
   (assert (attribute (name best-numero-vani) (value 2) (certainty 20.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 20.0)))
)


; ------ REGOLE NUMERO SERVIZI --------

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-uguale

   (attribute (name numero-servizi) (value ?servizirisposta &~unknown))
   =>
   (assert (attribute (name best-numero-servizi) (value ?servizirisposta) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-1

   (attribute (name numero-servizi) (value 1))
   =>
   (assert (attribute (name best-numero-servizi) (value 2) (certainty 70.0)))
   (assert (attribute (name best-numero-servizi) (value 3) (certainty 40.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-2

   (attribute (name numero-servizi) (value 2))
   =>
   (assert (attribute (name best-numero-servizi) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-servizi) (value 3) (certainty 70.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-3

   (attribute (name numero-servizi) (value 3))
   =>
   (assert (attribute (name best-numero-servizi) (value 1) (certainty 40.0)))
   (assert (attribute (name best-numero-servizi) (value 2) (certainty 70.0)))
)


(defrule CHOOSE-QUALITIES::numero-servizi-unk

   (attribute (name numero-servizi) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   (apartment (name ?name1) (numeroservizi ?serviziappartamento))
   =>
   ;(printout t "numero-servizi UNKNOWN: " crlf)
   (assert (attribute (name best-numero-servizi) (value ?name1) (certainty 20.0)))
)



; ------ REGOLE NUMERO PIANO --------

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-uguale

   (attribute (name numero-piano) (value ?pianorisposta &~unknown))
   =>
   (assert (attribute (name best-numero-piano) (value ?pianorisposta) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-piano-0

   (attribute (name numero-piano) (value 0))
   =>
   (assert (attribute (name best-numero-piano) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-piano) (value 2) (certainty 50.0)))
   (assert (attribute (name best-numero-piano) (value 3) (certainty 30.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-1

   (attribute (name numero-piano) (value 1))
   =>
   (assert (attribute (name best-numero-piano) (value 0) (certainty 70.0)))
   (assert (attribute (name best-numero-piano) (value 2) (certainty 70.0)))
   (assert (attribute (name best-numero-piano) (value 3) (certainty 50.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-2

   (attribute (name numero-piano) (value 2))
   =>
   (assert (attribute (name best-numero-piano) (value 0) (certainty 50.0)))
   (assert (attribute (name best-numero-piano) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-piano) (value 3) (certainty 50.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-3

   (attribute (name numero-piano) (value 2))
   =>
   (assert (attribute (name best-numero-piano) (value 0) (certainty 30.0)))
   (assert (attribute (name best-numero-piano) (value 1) (certainty 50.0)))
   (assert (attribute (name best-numero-piano) (value 2) (certainty 70.0)))
)


(defrule CHOOSE-QUALITIES::tentativo-numero-piano-pidi60anni      ; se l'appartamento non ha l'ascensore e la persona ha più di 60 anni conviene non proporlo con alta certezza

   (attribute (name ha-piudi60anni) (value si))
   =>
   (assert (attribute (name best-numero-piano) (value 0) (certainty 90.0)))
   (assert (attribute (name best-numero-piano) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-piano) (value 2) (certainty 50.0)))
   (assert (attribute (name best-numero-piano) (value 3) (certainty 30.0)))
)

; ------ REGOLE CITTA --------

; Regole per selezionare il best-citta
(defrule CHOOSE-QUALITIES::citta-valorized

   (attribute (name citta) (value ?val &~unknown))
   =>
   (assert (attribute (name best-citta) (value ?val) (certainty 40.0))))


(defrule CHOOSE-QUALITIES::citta-unkwown-second-iteration-mont

   (attribute (name fine-ciclo))  
   (attribute (name citta) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   (attribute (name preferisce) (value montagna))
   =>
   (printout t "citta SI O NO: " crlf)
   (assert (attribute (name best-citta) (value torino) (certainty 85.0)))
   (assert (attribute (name best-citta) (value milano) (certainty 85.0)))
)

(defrule CHOOSE-QUALITIES::citta-unkwown-second-iteration-mare

   (attribute (name fine-ciclo))  
   (attribute (name citta) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   (attribute (name preferisce) (value mare))
   =>
   (printout t "citta SI O NO: " crlf)
   (assert (attribute (name best-citta) (value roma) (certainty 85.0)))
   (assert (attribute (name best-citta) (value firenze) (certainty 85.0))) 
)


; ------ REGOLE ZONA --------

; Regole per selezionare il best-zona
(defrule CHOOSE-QUALITIES::zona-valorized

   (attribute (name zona) (value ?val &~unknown))
   =>
   (assert (attribute (name best-zona) (value ?val) (certainty 40.0)))
)

; Se l'utente vuole la casa in centro penso sia sensa proporne qualcuna nella prima cintura della città
(defrule CHOOSE-QUALITIES::zona-valorized-centro

   (attribute (name zona) (value centro))
   =>
   (assert (attribute (name best-zona) (value primacintura) (certainty 30.0))))

(defrule CHOOSE-QUALITIES::zona-unk

   (attribute (name zona) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   (assert (attribute (name best-zona) (value centro) (certainty 20.0)))
   (assert (attribute (name best-zona) (value primacintura) (certainty 20.0)))
   (assert (attribute (name best-zona) (value periferia) (certainty 20.0)))
)


(defrule CHOOSE-QUALITIES::zona-unk-torino

   (attribute (name zona) (value unknown))
   (attribute (name citta) (value torino))
   =>
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-milano

   (attribute (name zona) (value unknown))
   (attribute (name citta) (value milano))
   =>
   (assert (attribute (name best-quartiere) (value navigli) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-roma

   (attribute (name zona) (value unknown))
   (attribute (name citta) (value roma))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-firenze

   (attribute (name zona) (value unknown))
   (attribute (name citta) (value firenze))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 20.0)))
)


; ------ REGOLE PER IL BEST QUARTIERE --------

; Regole per selezionare il best-quartiere di Torino
(defrule CHOOSE-QUALITIES::quartiere-valorized-torino-1

   (or (attribute (name citta) (value torino)) (attribute (name best-citta) (value torino)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-torino-2

   (or (attribute (name citta) (value torino)) (attribute (name best-citta) (value torino)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 80.0)))
)

; Regole per selezionare il best-quartiere di Milano
(defrule CHOOSE-QUALITIES::quartiere-valorized-milano-1

   (or (attribute (name citta) (value milano)) (attribute (name best-citta) (value milano)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value navigli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-milano-2

   (or (attribute (name citta) (value milano)) (attribute (name best-citta) (value milano)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value navigli) (certainty 80.0)))
)


; Regole per selezionare il best-quartiere di Firenze
(defrule CHOOSE-QUALITIES::quartiere-valorized-firenze-1

   (or (attribute (name citta) (value firenze)) (attribute (name best-citta) (value firenze)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-firenze-2

   (or (attribute (name citta) (value firenze)) (attribute (name best-citta) (value firenze)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 80.0)))
)


; Regole per selezionare il best-quartiere di Roma
(defrule CHOOSE-QUALITIES::quartiere-valorized-roma-1

   (or (attribute (name citta) (value roma)) (attribute (name best-citta) (value roma)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-roma-2

   (or (attribute (name citta) (value roma)) (attribute (name best-citta) (value roma)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 80.0)))
)

; Regole per selezionare il best-ascensore 

(defrule CHOOSE-QUALITIES::ascensore-si-no

   (attribute (name ascensore) (value ?val &~unknown))
   =>
   (assert (attribute (name best-ascensore) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::ascensore-unk

   (attribute (name ascensore) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   (assert (attribute (name best-ascensore) (value si) (certainty 20.0)))
   (assert (attribute (name best-ascensore) (value no) (certainty 20.0))))


; ------ FINE REGOLE PER IL BEST QUARTIERE --------


; ------ REGOLE BOXAUTO --------

; Regole per selezionare il best-boxauto 
(defrule CHOOSE-QUALITIES::boxauto-si

   (attribute (name boxauto) (value ?val &~unknown))
   =>
   (assert (attribute (name best-boxauto) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::boxauto-unk

   (attribute (name boxauto) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   (assert (attribute (name best-boxauto) (value si) (certainty 20.0)))
   (assert (attribute (name best-boxauto) (value no) (certainty 20.0))))



; ------ REGOLE TERRAZZINO --------

; Regole per selezionare il best-terrazzino 
(defrule CHOOSE-QUALITIES::terrazzino-valorized

   (attribute (name terrazzino) (value ?val &~unknown))
   =>
   (assert (attribute (name best-terrazzino) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::terrazzino-unk

   (attribute (name terrazzino) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   (assert (attribute (name best-terrazzino) (value si) (certainty 20.0)))
   (assert (attribute (name best-terrazzino) (value no) (certainty 20.0))))



;---------------------------------------------------------------------REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-input-20-perc
   (declare (salience 10000))
   (attribute (name prezzo-massimo) (value ?prezzomassimo &~unknown))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty ?perc)))
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "20"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "20"))) (float "100")))))))
   =>
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 50 % e il prezzo della casa più il 50%
(defrule CHOOSE-QUALITIES::checking-input-50-perc
   (declare (salience 1000))
   (attribute (name prezzo-massimo) (value ?prezzomassimo &~unknown))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0)))
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "50"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "50"))) (float "100")))))))
   =>
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 60.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 90 % e il prezzo della casa più il 90%
(defrule CHOOSE-QUALITIES::checking-input-90-perc
   (declare (salience 100))
   (attribute (name prezzo-massimo) (value ?prezzomassimo &~unknown))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (and (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0))) (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 60.0))))
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100")))))))
   =>
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-prezzo-unknown
   (declare (salience 10))
   (attribute (name prezzo-massimo) (value unknown))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   =>
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 20.0))))


;---------------------------------------------------------------------FINE REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------


;---------------------------------------------------------------------REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-mq-20-perc
   (declare (salience 10000))
   (attribute (name metri-quadri) (value ?mq &~unknown))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?perc)))
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "20"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "20"))) (float "100")))))))
   =>
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 50 % e il prezzo della casa più il 50%
(defrule CHOOSE-QUALITIES::checking-mq-50-perc
   (declare (salience 1000))
   (attribute (name metri-quadri) (value ?mq &~unknown))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0)))
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "50"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "50"))) (float "100")))))))
   =>
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 60.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 90 % e il prezzo della casa più il 90%
(defrule CHOOSE-QUALITIES::checking-mq-90-perc
   (declare (salience 100))
   (attribute (name metri-quadri) (value ?mq &~unknown))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (and (not (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0))) (not (attribute (name best-metri-quadri) (value ?name1) (certainty 60.0))))
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100")))))))
   =>
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-mq-unknown
   (declare (salience 10))
   (attribute (name metri-quadri) (value unknown))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?cert)))
   =>
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 20.0))))


;---------------------------------------------------------------------FINE REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------


; TORINO
(defrule CHOOSE-QUALITIES::torino-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::torino-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::torino-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 80.0)))
)

; MILANO
(defrule CHOOSE-QUALITIES::milano-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   (assert (attribute (name best-quartiere) (value navigli) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::milano-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   (assert (attribute (name best-quartiere) (value navigli) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::milano-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value navigli) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 80.0)))
)



; ROMA
(defrule CHOOSE-QUALITIES::roma-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::roma-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::roma-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 80.0)))
)



; FIRENZE
(defrule CHOOSE-QUALITIES::firenze-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::firenze-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::firenze-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 80.0)))
)


(deffacts the-apartment-rules

  ; Regole per selezionare il bast-servizi-vicino

  (rule (if ha-figli-piccoli is si and
            ha-animali is si)
      (then best-servizio-vicino is parco with certainty 90 and
            best-servizio-vicino is scuola with certainty 70))

  (rule (if ha-figli-piccoli is si)
      (then best-servizio-vicino is parco with certainty 70 and
            best-servizio-vicino is scuola with certainty 70))

  (rule (if ha-animali is si)
      (then best-servizio-vicino is parco with certainty 85))

  (rule (if e-sportivo is si)
      (then best-servizio-vicino is parco with certainty 75 and
            best-servizio-vicino is palestra with certainty 90))

  (rule (if e-automunito is no)
      (then best-servizio-vicino is mezzipubblici with certainty 95))

  (rule (if e-automunito is si)
      (then best-boxauto is si with certainty 85))

  (rule (if ha-piudi60anni is si)
      (then best-servizio-vicino is ospedale with certainty 70 and
            best-servizio-vicino is mezzipubblici with certainty 80))

  (rule (if ha-piudi60anni is si)   ; se ha più di 60 anni ha senso dare l'ascensore
      (then best-ascensore is si with certainty 90))

   ;se l'utente ha risposto unknown alla citta e preferisce la montagna mettiamo torino - milano, altrimenti firenze - roma
   (rule (if citta is unknown and
             preferisce is mare)
        (then best-citta is roma with certainty 85 and
              best-citta is firenze with certainty 65))

   (rule (if citta is unknown and
             preferisce is montagna)
        (then best-citta is torino with certainty 85 and
              best-citta is milano with certainty 70))

   ; se l'utente risponde unknown alla preferenza tra mare e montagna mettiamo tutte le città con la stessa certezza
   (rule (if preferisce is unknown)
        (then best-citta is torino with certainty 20 and
              best-citta is milano with certainty 20 and
              best-citta is firenze with certainty 20 and
              best-citta is roma with certainty 20 and
              best-quartiere is lingotto with certainty 20 and
              best-quartiere is moncalieri with certainty 20 and 
              best-quartiere is navigli with certainty 20 and 
              best-quartiere is sansiro with certainty 20 and 
              best-quartiere is trastevere with certainty 20 and 
              best-quartiere is campitelli with certainty 20 and 
              best-quartiere is rovezzano with certainty 20 and 
              best-quartiere is santacroce with certainty 20))

)

