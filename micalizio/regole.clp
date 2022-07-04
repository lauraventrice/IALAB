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

(defrule RULES::remove-is-condition-when-satisfied ;saranno appartamenti che non andranno bene?
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


;---------------------------------------------------------------------REGOLE DI PROVA---------------------------------------------------------------------

; (defrule CHOOSE-QUALITIES::checking-input
;    (attribute (name prezzo-massimo) (value ?prezzomassimo))
;    (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
;    (test (= (float (str-cat ?prezzomassimo)) (float (str-cat ?prezzorichiesto))))
;    ;?p <- (/ =(* ?prezzomassimo (float "20")) =(float "100")) ; calcolo il 20% di prezzomassimo
;    =>
;    (printout t "APPARTAMENTO CORRISPONDENTE " ?name1 crlf))

;  (defrule CHOOSE-QUALITIES::checking-input-minore
;    (attribute (name prezzo-massimo) (value ?prezzomassimo))
;    (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
;    (test (<= (float (str-cat ?prezzomassimo)) (float (str-cat ?prezzorichiesto))))
;    ;?p <- (/ =(* ?prezzomassimo (float "20")) =(float "100")) ; calcolo il 20% di prezzomassimo
;    =>
;    (printout t "APPARTAMENTO CORRISPONDENTE PREZZO MINORE " ?name1 crlf))

;---------------------------------------------------------------------FINE REGOLE DI PROVA---------------------------------------------------------------------






;---------------------------------------------------------------------REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-input-20-perc
   (declare (salience 10000))
   (attribute (name prezzo-massimo) (value ?prezzomassimo))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty ?perc)))
   (not (test (eq ?prezzomassimo unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ;(test (= (float ?perc) (float 100)))
   ;?s <- (attribute (name best-prezzo-richiesto) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?prezzomassimo) (float "20"))) (float "100")) ; calcolo il 20% di prezzomassimo
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "20"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "20"))) (float "100")))))))
   =>
   ;(printout t "PREZZO 20 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 50 % e il prezzo della casa più il 50%
(defrule CHOOSE-QUALITIES::checking-input-50-perc
   (declare (salience 1000))
   (attribute (name prezzo-massimo) (value ?prezzomassimo))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0)))
   (not (test (eq ?prezzomassimo unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ;?s <- (attribute (name best-prezzo-richiesto) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?prezzomassimo) (float "20"))) (float "100")) ; calcolo il 20% di prezzomassimo
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "50"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "50"))) (float "100")))))))
   =>
   ;(printout t "PREZZO 50 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 60.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 90 % e il prezzo della casa più il 90%
(defrule CHOOSE-QUALITIES::checking-input-90-perc
   (declare (salience 100))
   (attribute (name prezzo-massimo) (value ?prezzomassimo))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (test (eq ?prezzomassimo unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (and (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 85.0))) (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 60.0))))
   ;?s <- (attribute (name best-prezzo-richiesto) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?prezzomassimo) (float "20"))) (float "100")) ; calcolo il 20% di prezzomassimo
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100")))))))
   =>
   ;(printout t "PREZZO 90 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-prezzo-unknown
   (declare (salience 10))
   (attribute (name prezzo-massimo) (value ?prezzomassimo))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (test (eq ?prezzomassimo unknown))    ; se la risposta è unknown bisogna usare questa regola
   ;(not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty ?cert)))
   =>
   ;(printout t "VERSIONE 1 PREZZO UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 20.0))))

; ; ; regola che viene eseguita solo se la risposta è unknown
; (defrule CHOOSE-QUALITIES::checking-prezzo-unknown-2
;    (declare (salience 1000))
;    (attribute (name prezzo-massimo) (value ?prezzomassimo))
;    (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
;    (test (eq ?prezzomassimo unknown))    ; se la risposta è unknown bisogna usare questa regola
;    ?a <- (attribute (name best-prezzo-richiesto) (value ?name1) (certainty ?cert))
;    =>
;    (modify ?a (certainty 20.0))
;    (printout t "VERSIONE 2 PREZZO UNKNOWN APPARTAMENTO: " ?name1 crlf)
;    ;(assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 20.0)))
;    )

;---------------------------------------------------------------------FINE REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------


;---------------------------------------------------------------------REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-mq-20-perc
   (declare (salience 10000))
   (attribute (name metri-quadri) (value ?mq))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?perc)))
   (not (test (eq ?mq unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ;(test (= (float ?perc) (float 100)))
   ;?s <- (attribute (name best-metri-quadri) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?mq) (float "20"))) (float "100")) ; calcolo il 20% di mq
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "20"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "20"))) (float "100")))))))
   =>
   ;(printout t "MQ 20 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 50 % e il prezzo della casa più il 50%
(defrule CHOOSE-QUALITIES::checking-mq-50-perc
   (declare (salience 1000))
   (attribute (name metri-quadri) (value ?mq))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (test (eq ?mq unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0)))
   ;?s <- (attribute (name best-metri-quadri) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?mq) (float "20"))) (float "100")) ; calcolo il 20% di mq
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "50"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "50"))) (float "100")))))))
   =>
   ;(printout t "MQ 50 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 60.0))))

; ; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 90 % e il prezzo della casa più il 90%
(defrule CHOOSE-QUALITIES::checking-mq-90-perc
   (declare (salience 100))
   (attribute (name metri-quadri) (value ?mq))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (test (eq ?mq unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (and (not (attribute (name best-metri-quadri) (value ?name1) (certainty 85.0))) (not (attribute (name best-metri-quadri) (value ?name1) (certainty 60.0))))
   ;?s <- (attribute (name best-metri-quadri) (value any) (certainty 100.0))
   ;?p <- (/ (float (+ (float ?mq) (float "20"))) (float "100")) ; calcolo il 20% di mq
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100")))))))
   =>
   ;(printout t "MQ 90 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-mq-unknown
   (declare (salience 10))
   (attribute (name metri-quadri) (value ?mq))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (test (eq ?mq unknown))    ; se la risposta è unknown bisogna usare questa regola
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?cert)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 20.0))))


;---------------------------------------------------------------------FINE REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------












(deffacts the-apartment-rules

  ; TODO: Regole per selezionare il best-metri-quadri 


  ; Regole per selezionare il best-numero-vani 

  (rule (if numero-vani is 1)
        (then best-numero-vani is 1 with certainty 40))

  (rule (if numero-vani is 2)
        (then best-numero-vani is 2 with certainty 40))

  (rule (if numero-vani is 3)
        (then best-numero-vani is 3 with certainty 40))

  (rule (if numero-vani is 4)
        (then best-numero-vani is 4 with certainty 40))

  (rule (if numero-vani is 5)
        (then best-numero-vani is 5 with certainty 40))

  (rule (if numero-vani is 6)
        (then best-numero-vani is 6 with certainty 40))

  (rule (if numero-vani is unknown)
        (then best-numero-vani is 1 with certainty 20 and
              best-numero-vani is 2 with certainty 20 and
              best-numero-vani is 3 with certainty 20 and
              best-numero-vani is 4 with certainty 20 and
              best-numero-vani is 5 with certainty 20 and
              best-numero-vani is 6 with certainty 20))

  ; Regole per selezionare il best-numero-servizi (1, 2, 3 e unknown sono le possibili valide risposte per la domanda sul numero dei servizi)

  (rule (if numero-servizi is 1)
        (then best-numero-servizi is 1 with certainty 40))

  (rule (if numero-servizi is 2)
        (then best-numero-servizi is 2 with certainty 40))

  (rule (if numero-servizi is 3)
        (then best-numero-servizi is 3 with certainty 40))

  (rule (if numero-servizi is unknown)
        (then best-numero-servizi is 1 with certainty 20 and
              best-numero-servizi is 2 with certainty 20 and
              best-numero-servizi is 3 with certainty 20))

  ; Regole per selezionare il best-piano 

  (rule (if numero-piano is terra)
        (then best-numero-piano is terra with certainty 40))

  (rule (if numero-piano is primo)
        (then best-numero-piano is primo with certainty 40))

  (rule (if numero-piano is secondo)
        (then best-numero-piano is secondo with certainty 40))

  (rule (if numero-piano is terzo)
        (then best-numero-piano is terzo with certainty 40))

  (rule (if numero-piano is quarto)
        (then best-numero-piano is quarto with certainty 40))

  (rule (if numero-piano is quinto)
        (then best-numero-piano is quinto with certainty 40))

  (rule (if numero-piano is sesto)
        (then best-numero-piano is sesto with certainty 40))

  (rule (if numero-piano is unknown)
        (then best-numero-piano is terra with certainty 20 and
              best-numero-piano is primo with certainty 20 and
              best-numero-piano is secondo with certainty 20 and
              best-numero-piano is terzo with certainty 20 and
              best-numero-piano is quarto with certainty 20 and
              best-numero-piano is quinto with certainty 20 and
              best-numero-piano is sesto with certainty 20))


  ; Regole per selezionare il best-citta 

  (rule (if citta is torino)
        (then best-citta is torino with certainty 40))

  (rule (if citta is roma)
        (then best-citta is roma with certainty 40))

  (rule (if citta is milano)
        (then best-citta is milano with certainty 40))

  (rule (if citta is firenze)
        (then best-citta is firenze with certainty 40))

  (rule (if citta is unknown)
        (then best-citta is torino with certainty 20 and
              best-citta is roma with certainty 20 and
              best-citta is milano with certainty 20 and
              best-citta is firenze with certainty 20))


  ; Regole per selezionare il best-zona

  (rule (if zona is centro)
        (then best-zona is centro with certainty 40))

  (rule (if zona is primacintura)
        (then best-zona is primacintura with certainty 40))

  (rule (if zona is periferia)
        (then best-zona is periferia with certainty 40))

  (rule (if zona is unknown)
        (then best-zona is centro with certainty 20 and
              best-zona is primacintura with certainty 20 and
              best-zona is periferia with certainty 20))

  ; TODO: Regole per selezionare il best-quartiere  
  ; TODO: NON SO SE QUESTE REGOLE VADANO BENE COSI'

  (rule (if citta is torino and
            zona is primacintura)
      (then best-quartiere is moncalieri with certainty 70 and
            best-quartiere is mirafiori with certainty 50))

  (rule (if citta is unknown)
      (then best-quartiere is moncalieri with certainty 20 and
            best-quartiere is lingotto with certainty 20 and
            best-quartiere is trastevere with certainty 20 and
            best-quartiere is campitelli with certainty 20 and
            best-quartiere is sansiro with certainty 20 and
            best-quartiere is navigli with certainty 20 and
            best-quartiere is santacroce with certainty 20 and
            best-quartiere is rovezzano with certainty 20))
 
  ; TODO: SE VANNO BENE COSI' BISOGNA FARLE PER TUTTE LE COMBINAZIONI DI QUARTIERI E CITTA'

  ; Regole per selezionare il best-ascensore 

  (rule (if ascensore is si)
        (then best-ascensore is si with certainty 40))

  (rule (if ascensore is no)
        (then best-ascensore is no with certainty 40))

  (rule (if ascensore is unknown)
        (then best-ascensore is si with certainty 20 and
              best-ascensore is no with certainty 20))

  (rule (if ha-piudi60anni is si)
      (then best-ascensore is si with certainty 70))  ;se ha più di 60 anni è bene consigliare appartamenti dotati di ascensore!

  ; Regole per selezionare il best-boxauto

  (rule (if boxauto is si)
        (then best-boxauto is si with certainty 40))

  (rule (if boxauto is no)
        (then best-boxauto is no with certainty 40))

  (rule (if boxauto is unknown)
        (then best-boxauto is si with certainty 20 and
              best-boxauto is no with certainty 20))

  ; TODO: Regole per selezionare il best-metri-quadri-boxauto  



  ; Regole per selezionare il best-terrazzino 

  (rule (if terrazzino is si)
        (then best-terrazzino is si with certainty 40))

  (rule (if terrazzino is no)
        (then best-terrazzino is no with certainty 40))

  (rule (if terrazzino is unknown)
        (then best-terrazzino is si with certainty 20 and
              best-terrazzino is no with certainty 20))


  ; TODO: Regole per selezionare il best-prezzo-richiesto 


;   (rule (if prezzo-massimo is unknown)
;       (then best-prezzo-richiesto is 200000 with certainty 20 and
;             best-prezzo-richiesto is 300000 with certainty 20 and
;             best-prezzo-richiesto is 400000 with certainty 20 and
;             best-prezzo-richiesto is 500000 with certainty 20 and
;             best-prezzo-richiesto is 600000 with certainty 20 and
;             best-prezzo-richiesto is 700000 with certainty 20 and
;             best-prezzo-richiesto is 800000 with certainty 20))


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

  (rule (if ha-piudi60anni is si)
      (then best-servizio-vicino is ospedale with certainty 70 and
            best-servizio-vicino is mezzipubblici with certainty 60))

)

