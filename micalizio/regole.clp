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

(defrule RULES::remove-is-condition-when-satisfied ;TODO (in caso rimuovere commento): saranno appartamenti che non andranno bene?
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
   (declare (salience 10000))
   (attribute (name numero-vani) (value ?vaniirisposta))
   ;(apartment (name ?name1) (numerovani ?vaniappartamento))
   (not (test (eq ?vaniirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ;(or (test (= (float (str-cat ?vaniappartamento)) (float (str-cat ?vaniirisposta)))))
   =>
   (assert (attribute (name best-numero-vani) (value ?vaniirisposta) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-vani-1
   (declare (salience 10000))
   (attribute (name numero-vani) (value 1))
   ;(apartment (name ?name1) (numerovani ?vaniappartamento))
   ;(not (test (eq ?vaniirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?vaniappartamento)) (+ (float (str-cat ?vaniirisposta)) 1)))
   ;      (test (= (float (str-cat ?vaniappartamento)) (- (float (str-cat ?vaniirisposta)) 1))))
   =>
   (assert (attribute (name best-numero-vani) (value 2) (certainty 70.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 40.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-vani-2
   (declare (salience 10000))
   (attribute (name numero-vani) (value 2))
   ;(apartment (name ?name1) (numerovani ?vaniappartamento))
   ; (not (test (eq ?vaniirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?vaniappartamento)) (+ (float (str-cat ?vaniirisposta)) 2)))
   ;      (test (= (float (str-cat ?vaniappartamento)) (- (float (str-cat ?vaniirisposta)) 2))))
   =>
   (assert (attribute (name best-numero-vani) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 70.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-vani-3
   (declare (salience 10000))
   (attribute (name numero-vani) (value 3))
   ;(apartment (name ?name1) (numerovani ?vaniappartamento))
   ; (not (test (eq ?vaniirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?vaniappartamento)) (+ (float (str-cat ?vaniirisposta)) 2)))
   ;      (test (= (float (str-cat ?vaniappartamento)) (- (float (str-cat ?vaniirisposta)) 2))))
   =>
   (assert (attribute (name best-numero-vani) (value 1) (certainty 40.0)))
   (assert (attribute (name best-numero-vani) (value 2) (certainty 70.0)))
)


(defrule CHOOSE-QUALITIES::numero-vani-unk
   (declare (salience 10000))
   (attribute (name numero-vani) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   ;(apartment (name ?name1) (numerovani ?vaniappartamento))
   =>
   ;(printout t "numero-vani UNKNOWN: " crlf)
   (assert (attribute (name best-numero-vani) (value 1) (certainty 20.0)))
   (assert (attribute (name best-numero-vani) (value 2) (certainty 20.0)))
   (assert (attribute (name best-numero-vani) (value 3) (certainty 20.0)))
)


; ------ REGOLE NUMERO SERVIZI --------

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-uguale
   (declare (salience 10000))
   (attribute (name numero-servizi) (value ?servizirisposta))
   ;(apartment (name ?name1) (numeroservizi ?serviziappartamento))
   (not (test (eq ?servizirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ;(or (test (= (float (str-cat ?serviziappartamento)) (float (str-cat ?servizirisposta)))))
   =>
   (assert (attribute (name best-numero-servizi) (value ?servizirisposta) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-1
   (declare (salience 10000))
   (attribute (name numero-servizi) (value 1))
   ; (apartment (name ?name1) (numeroservizi ?serviziappartamento))
   ; (not (test (eq ?servizirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?serviziappartamento)) (+ (float (str-cat ?servizirisposta)) 1)))
   ;      (test (= (float (str-cat ?serviziappartamento)) (- (float (str-cat ?servizirisposta)) 1))))
   =>
   (assert (attribute (name best-numero-servizi) (value 2) (certainty 70.0)))
   (assert (attribute (name best-numero-servizi) (value 3) (certainty 40.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-2
   (declare (salience 10000))
   (attribute (name numero-servizi) (value 2))
   ; (apartment (name ?name1) (numeroservizi ?serviziappartamento))
   ; (not (test (eq ?servizirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?serviziappartamento)) (+ (float (str-cat ?servizirisposta)) 2)))
   ;      (test (= (float (str-cat ?serviziappartamento)) (- (float (str-cat ?servizirisposta)) 2))))
   =>
   (assert (attribute (name best-numero-servizi) (value 1) (certainty 70.0)))
   (assert (attribute (name best-numero-servizi) (value 3) (certainty 70.0)))
)

(defrule CHOOSE-QUALITIES::tentativo-numero-servizi-3
   (declare (salience 10000))
   (attribute (name numero-servizi) (value 3))
   ; (apartment (name ?name1) (numeroservizi ?serviziappartamento))
   ; (not (test (eq ?servizirisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   ; (or (test (= (float (str-cat ?serviziappartamento)) (+ (float (str-cat ?servizirisposta)) 2)))
   ;      (test (= (float (str-cat ?serviziappartamento)) (- (float (str-cat ?servizirisposta)) 2))))
   =>
   (assert (attribute (name best-numero-servizi) (value 1) (certainty 40.0)))
   (assert (attribute (name best-numero-servizi) (value 2) (certainty 70.0)))
)


(defrule CHOOSE-QUALITIES::numero-servizi-unk
   (declare (salience 10000))
   (attribute (name numero-servizi) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   (apartment (name ?name1) (numeroservizi ?serviziappartamento))
   =>
   ;(printout t "numero-servizi UNKNOWN: " crlf)
   (assert (attribute (name best-numero-servizi) (value ?name1) (certainty 20.0)))
   ; (assert (attribute (name best-numero-servizi) (value 2) (certainty 20.0)))
   ; (assert (attribute (name best-numero-servizi) (value 3) (certainty 20.0)))
)





; ------ REGOLE NUMERO PIANO --------

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-uguale
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano ?pianoappartamento))
   (not (test (eq ?pianorisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (or (test (= (float (str-cat ?pianoappartamento)) (float (str-cat ?pianorisposta)))))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 90.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-piano-1
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano ?pianoappartamento))
   (not (test (eq ?pianorisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (or (test (= (float (str-cat ?pianoappartamento)) (+ (float (str-cat ?pianorisposta)) 1)))
        (test (= (float (str-cat ?pianoappartamento)) (- (float (str-cat ?pianorisposta)) 1))))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 70.0))))

(defrule CHOOSE-QUALITIES::tentativo-numero-piano-2
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano ?pianoappartamento))
   (not (test (eq ?pianorisposta unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   (or (test (= (float (str-cat ?pianoappartamento)) (+ (float (str-cat ?pianorisposta)) 2)))
        (test (= (float (str-cat ?pianoappartamento)) (- (float (str-cat ?pianorisposta)) 2))))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 40.0))))


(defrule CHOOSE-QUALITIES::tentativo-numero-piano-pidi60anni      ; se l'appartamento non ha l'ascensore e la persona ha più di 60 anni conviene non proporlo con alta certezza
   (declare (salience 10000))
   (attribute (name ha-piudi60anni) (value si))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano ?pianoappartamento) (ascensore no))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 25.0))))


;; a prescindere dal pinao che ha scelto l'utente per ogni appartamento asserisco una certainty in base al fatto che abbia o meno l'ascensore
(defrule CHOOSE-QUALITIES::ascensore-no-piano0   ; se l'appartamento è al piano terra e non ha l'ascensore meglio dargli una certainty alta
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 0) (ascensore no))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::ascensore-no-piano1   ; se l'appartamento è al primo piano e non ha l'ascensore meglio dargli una certainty medio-alta
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 1) (ascensore no))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 75.0)))
)


(defrule CHOOSE-QUALITIES::ascensore-no-piano2   ; se l'appartamento è al secondo piano e non ha l'ascensore meglio dargli una certainty media
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 2) (ascensore no))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 50.0)))
)


(defrule CHOOSE-QUALITIES::ascensore-no-piano3   ; se l'appartamento è al terzo piano e non ha l'ascensore meglio dargli una certainty bassa
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 3) (ascensore no))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 25.0)))
)


; per le seguenti ho messo delle certainties descrescenti al crescere del piano perchè in caso di rottura dell'ascensore bisogna farsi a piedi tutte le scale!

(defrule CHOOSE-QUALITIES::ascensore-si-piano0   
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 0) (ascensore si))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 95.0)))
)

(defrule CHOOSE-QUALITIES::ascensore-si-piano1  
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 1) (ascensore si))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 85.0)))
)


(defrule CHOOSE-QUALITIES::ascensore-si-piano2   
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 2) (ascensore si))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 75.0)))
)


(defrule CHOOSE-QUALITIES::ascensore-si-piano3  
   (declare (salience 10000))
   (attribute (name numero-piano) (value ?pianorisposta))
   (apartment (name ?name1) (piano 3) (ascensore si))
   =>
   (assert (attribute (name best-numero-piano-apartment) (value ?name1) (certainty 65.0)))
)





; (defrule CHOOSE-QUALITIES::tentativo-numero-piano-pidi60anni-v2     ; se l'appartamento non ha l'ascensore ha senso proporre appartamenti ai piani più bassi
;    (declare (salience 10000))
;    ;(attribute (name ha-piudi60anni) (value si))   ; penso che questa riga sia rimasta per un mio copia e incolla della regola sopra, ma non ha senso averla!
;    (attribute (name numero-piano) (value ?pianorisposta))
;    (apartment (name ?name1) (piano ?pianoappartamento) (ascensore no))
;    =>
;    (assert (attribute (name best-numero-piano) (value 0) (certainty 90.0)))
;    (assert (attribute (name best-numero-piano) (value 1) (certainty 75.0)))
;    (assert (attribute (name best-numero-piano) (value 2) (certainty 50.0)))
;    (assert (attribute (name best-numero-piano) (value 3) (certainty 25.0)))
; )
; ; TODO: credo che abbia senso riscrivere questa regola! se effettivamente l'appartmaneto non ha l'ascensore ha più senso dare la certainty all'appartamento stesso in abse al piano che ha, o no?
; ; TODO: forse anche così in fin dei conti potrebbe andare bene
; ; TODO: terzao ragionamento! non va bene! andrei ad asserire le cose scritte nelle 4 righe del conseguente per ogni appartamento che non ha l'ascensore!!!!


; (defrule CHOOSE-QUALITIES::numero-piano-unk
;    (declare (salience 10000))
;    (attribute (name numero-piano) (value ?val))
;    (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
;    (apartment (name ?name1) (piano ?piano))
;    =>
;    ;(printout t "numero-piano UNKNOWN: " crlf)
;    (assert (attribute (name best-numero-piano) (value 0) (certainty 20.0)))
;    (assert (attribute (name best-numero-piano) (value 1) (certainty 20.0)))
;    (assert (attribute (name best-numero-piano) (value 2) (certainty 20.0)))
;    (assert (attribute (name best-numero-piano) (value 3) (certainty 20.0)))
; )



; ------ REGOLE CITTA --------

; Regole per selezionare il best-citta
(defrule CHOOSE-QUALITIES::citta-valorized
   (declare (salience 10000))
   (attribute (name citta) (value ?val))
   (not (test (eq ?val unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "citta SI O NO: " crlf)
   (assert (attribute (name best-citta) (value ?val) (certainty 40.0))))


(defrule CHOOSE-QUALITIES::citta-unkwown-second-iteration-mont
   (declare (salience 10000))
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
   (declare (salience 10000))
   (attribute (name fine-ciclo))  
   (attribute (name citta) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   (attribute (name preferisce) (value mare))
   =>
   (printout t "citta SI O NO: " crlf)
   (assert (attribute (name best-citta) (value roma) (certainty 85.0)))
   (assert (attribute (name best-citta) (value firenze) (certainty 85.0))) 
)

; Questa regola non dovrebbe servire dato che abbiamo messa quella del "preferisce" ->
; se l'utente risponde citta unknown e preferisce unknown avviene proprio ciò che faceva avvenire questa regola seguente
; (defrule CHOOSE-QUALITIES::citta-unk
;    (declare (salience 10000))
;    (attribute (name citta) (value ?val))
;    (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
;    =>
;    ;(printout t "citta UNKNOWN: " crlf)
;    (assert (attribute (name best-citta) (value torino) (certainty 20.0)))
;    (assert (attribute (name best-citta) (value roma) (certainty 20.0)))
;    (assert (attribute (name best-citta) (value milano) (certainty 20.0)))
;    (assert (attribute (name best-citta) (value firenze) (certainty 20.0)))
; )


; ------ REGOLE ZONA --------

; Regole per selezionare il best-zona
(defrule CHOOSE-QUALITIES::zona-valorized
   (declare (salience 10000))
   (attribute (name zona) (value ?val))
   (not (test (eq ?val unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "zona SI O NO: " crlf)
   (assert (attribute (name best-zona) (value ?val) (certainty 40.0))))

; Se l'utente vuole la casa in centro penso sia sensa proporne qualcuna nella prima cintura della città
(defrule CHOOSE-QUALITIES::zona-valorized-centro
   (declare (salience 10000))
   (attribute (name zona) (value centro))
   =>
   (assert (attribute (name best-zona) (value primacintura) (certainty 30.0))))

(defrule CHOOSE-QUALITIES::zona-unk
   (declare (salience 10000))
   (attribute (name zona) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "zona UNKNOWN: " crlf)
   (assert (attribute (name best-zona) (value centro) (certainty 20.0)))
   (assert (attribute (name best-zona) (value primacintura) (certainty 20.0)))
   (assert (attribute (name best-zona) (value periferia) (certainty 20.0)))
)


(defrule CHOOSE-QUALITIES::zona-unk-torino
   (declare (salience 10000))
   (attribute (name zona) (value unknown))
   (attribute (name citta) (value torino))
   =>
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-milano
   (declare (salience 10000))
   (attribute (name zona) (value unknown))
   (attribute (name citta) (value milano))
   =>
   (assert (attribute (name best-quartiere) (value navigli) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-roma
   (declare (salience 10000))
   (attribute (name zona) (value unknown))
   (attribute (name citta) (value roma))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 20.0)))
)

(defrule CHOOSE-QUALITIES::zona-unk-firenze
   (declare (salience 10000))
   (attribute (name zona) (value unknown))
   (attribute (name citta) (value firenze))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 20.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 20.0)))
)


; ------ REGOLE PER IL BEST QUARTIERE --------

; Regole per selezionare il best-quartiere di Torino
(defrule CHOOSE-QUALITIES::quartiere-valorized-torino-1
   (declare (salience 10000))
   (or (attribute (name citta) (value torino)) (attribute (name best-citta) (value torino)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-torino-2
   (declare (salience 10000))
   (or (attribute (name citta) (value torino)) (attribute (name best-citta) (value torino)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 80.0)))
)

; Regole per selezionare il best-quartiere di Milano
(defrule CHOOSE-QUALITIES::quartiere-valorized-milano-1
   (declare (salience 10000))
   (or (attribute (name citta) (value milano)) (attribute (name best-citta) (value milano)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value navigli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-milano-2
   (declare (salience 10000))
   (or (attribute (name citta) (value milano)) (attribute (name best-citta) (value milano)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value navigli) (certainty 80.0)))
)


; Regole per selezionare il best-quartiere di Firenze
(defrule CHOOSE-QUALITIES::quartiere-valorized-firenze-1
   (declare (salience 10000))
   (or (attribute (name citta) (value firenze)) (attribute (name best-citta) (value firenze)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-firenze-2
   (declare (salience 10000))
   (or (attribute (name citta) (value firenze)) (attribute (name best-citta) (value firenze)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 80.0)))
)


; Regole per selezionare il best-quartiere di Roma
(defrule CHOOSE-QUALITIES::quartiere-valorized-roma-1
   (declare (salience 10000))
   (or (attribute (name citta) (value roma)) (attribute (name best-citta) (value roma)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val periferia)) (test (eq ?val primacintura)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::quartiere-valorized-roma-2
   (declare (salience 10000))
   (or (attribute (name citta) (value roma)) (attribute (name best-citta) (value roma)))
   (attribute (name zona) (value ?val))
   (or (test (eq ?val primacintura)) (test (eq ?val centro)))
   =>
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 60.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 80.0)))
)

; Regole per selezionare il best-ascensore 

(defrule CHOOSE-QUALITIES::ascensore-si-no
   (declare (salience 10000))
   (attribute (name ascensore) (value ?val))
   (not (test (eq ?val unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "ASCENSORE SI O NO: " crlf)
   (assert (attribute (name best-ascensore) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::ascensore-unk
   (declare (salience 10000))
   (attribute (name ascensore) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "ASCENSORE UNKNOWN: " crlf)
   (assert (attribute (name best-ascensore) (value si) (certainty 20.0)))
   (assert (attribute (name best-ascensore) (value no) (certainty 20.0))))


; ------ FINE REGOLE PER IL BEST QUARTIERE --------


; ------ REGOLE BOXAUTO --------

; Regole per selezionare il best-boxauto 
(defrule CHOOSE-QUALITIES::boxauto-si
   (declare (salience 10000))
   (attribute (name boxauto) (value ?val))
   (not (test (eq ?val unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "boxauto SI O NO: " crlf)
   (assert (attribute (name best-boxauto) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::boxauto-unk
   (declare (salience 10000))
   (attribute (name boxauto) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "boxauto UNKNOWN: " crlf)
   (assert (attribute (name best-boxauto) (value si) (certainty 20.0)))
   (assert (attribute (name best-boxauto) (value no) (certainty 20.0))))



; ------ REGOLE TERRAZZINO --------

; Regole per selezionare il best-terrazzino 
(defrule CHOOSE-QUALITIES::terrazzino-valorized
   (declare (salience 10000))
   (attribute (name terrazzino) (value ?val))
   (not (test (eq ?val unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "terrazzino SI O NO: " crlf)
   (assert (attribute (name best-terrazzino) (value ?val) (certainty 40.0))))

(defrule CHOOSE-QUALITIES::terrazzino-unk
   (declare (salience 10000))
   (attribute (name terrazzino) (value ?val))
   (test (eq ?val unknown))    ; se la risposta è unknown bisogna usare una regola apposita
   =>
   ;(printout t "terrazzino UNKNOWN: " crlf)
   (assert (attribute (name best-terrazzino) (value si) (certainty 20.0)))
   (assert (attribute (name best-terrazzino) (value no) (certainty 20.0))))



;---------------------------------------------------------------------REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-input-20-perc
   (declare (salience 10000))
   (attribute (name prezzo-massimo) (value ?prezzomassimo))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   (not (attribute (name best-prezzo-richiesto) (value ?name1) (certainty ?perc)))
   (not (test (eq ?prezzomassimo unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
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
   (and (test (<= (float (str-cat ?prezzomassimo)) (+ (float  (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?prezzomassimo)) (- (float (str-cat ?prezzorichiesto)) (float (/ (float (* (float ?prezzomassimo) (float "100"))) (float "100")))))))
   =>
   ;(printout t "PREZZO 90 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-prezzo-unknown
   (declare (salience 10))
   (attribute (name prezzo-massimo) (value unknown))
   (apartment (name ?name1) (prezzorichiesto ?prezzorichiesto))
   =>
   ;(printout t "VERSIONE 1 PREZZO UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-prezzo-richiesto) (value ?name1) (certainty 20.0))))


;---------------------------------------------------------------------FINE REGOLE PER IL MIGLIOR PREZZO---------------------------------------------------------------------


;---------------------------------------------------------------------REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------

; regola che controlla se il prezzo massimo che l'utente vuole spendere èì compreso tra il prezzo della casa meno il 20 % e il prezzo della casa più il 20%
(defrule CHOOSE-QUALITIES::checking-mq-20-perc
   (declare (salience 10000))
   (attribute (name metri-quadri) (value ?mq))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?perc)))
   (not (test (eq ?mq unknown)))    ; se la risposta è unknown bisogna usare una regola apposita
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
   (and (test (<= (float (str-cat ?mq)) (+ (float  (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100"))))))
       (test (>= (float (str-cat ?mq)) (- (float (str-cat ?metriquadriapartment)) (float (/ (float (* (float ?mq) (float "100"))) (float "100")))))))
   =>
   ;(printout t "MQ 90 PERC APPARTAMENTO: " ?name1 crlf)
   ;(retract ?s)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 10.0))))

; ; regola che viene eseguita solo se la risposta è unknown
(defrule CHOOSE-QUALITIES::checking-mq-unknown
   (declare (salience 10))
   (attribute (name metri-quadri) (value unknown))
   (apartment (name ?name1) (metriquadri ?metriquadriapartment))
   (not (attribute (name best-metri-quadri) (value ?name1) (certainty ?cert)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-metri-quadri) (value ?name1) (certainty 20.0))))


;---------------------------------------------------------------------FINE REGOLE PER I MIGLIORI MQ---------------------------------------------------------------------


; TORINO
(defrule CHOOSE-QUALITIES::torino-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::torino-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::torino-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value torino)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value lingotto) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value moncalieri) (certainty 80.0)))
)

; MILANO
(defrule CHOOSE-QUALITIES::milano-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value navigli) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::milano-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value navigli) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::milano-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value milano)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value navigli) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value sansiro) (certainty 80.0)))
)



; ROMA
(defrule CHOOSE-QUALITIES::roma-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::roma-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::roma-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value roma)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value trastevere) (certainty 80.0)))
   (assert (attribute (name best-quartiere) (value campitelli) (certainty 80.0)))
)




; FIRENZE
(defrule CHOOSE-QUALITIES::firenze-1
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value centro)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 90.0)))
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 90.0)))
)

(defrule CHOOSE-QUALITIES::firenze-2
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value periferia)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
   (assert (attribute (name best-quartiere) (value santacroce) (certainty 30.0)))
   (assert (attribute (name best-quartiere) (value rovezzano) (certainty 60.0)))
)

(defrule CHOOSE-QUALITIES::firenze-3
   (attribute (name preferisce) (value ~unknown))
   (exists (attribute (name  best-citta) (value firenze)))
   (exists (attribute (name  best-zona) (value primacintura)))
   =>
   ;(printout t "MQ UNKNOWN APPARTAMENTO: " ?name1 crlf)
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

  ; se l'utente preferisce il terzo piano e non vuole l'ascensore può avere senso proporre appartamenti ad un piano più basso
  ; NB: ho messo il primo piano perchè mettere il piano terra potrebbe essere troppo esagerato dato che ne voleva uno più alto
  (rule (if best-piano is 3 and
            ascensore is no)
        (then best-piano is 1 with certainty 60))

  (rule (if best-piano is 2 and
            ascensore is no)
        (then best-piano is 1 with certainty 80))


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

   ; ; regole per il best-quartiere quando l'utente non ha risposto con la città, ma ha risposto cosa preferisce
   
   ; ; TORINO
   ; (rule (if preferisce is not unknown and 
   ;           best-citta is torino and
   ;           best-zona is centro)
   ;      (then best-quartiere is lingotto with certainty 90 and
   ;            best-quartiere is moncalieri with certainty 70))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is torino and
   ;           best-zona is periferia)
   ;      (then best-quartiere is lingotto with certainty 30 and
   ;            best-quartiere is moncalieri with certainty 60))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is torino and
   ;           best-zona is primacintura)
   ;      (then best-quartiere is lingotto with certainty 80 and
   ;            best-quartiere is moncalieri with certainty 80))

   ; ; MILANO
   ; (rule (if preferisce is not unknown and 
   ;           best-citta is milano and
   ;           best-zona is centro)
   ;      (then best-quartiere is navigli with certainty 90 and
   ;            best-quartiere is sansiro with certainty 70))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is milano and
   ;           best-zona is periferia)
   ;      (then best-quartiere is navigli with certainty 30 and
   ;            best-quartiere is sansiro with certainty 60))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is milano and
   ;           best-zona is primacintura)
   ;      (then best-quartiere is navigli with certainty 80 and
   ;            best-quartiere is sansiro with certainty 80))

   ; ; ROMA
   ; (rule (if preferisce is not unknown and 
   ;           best-citta is roma and
   ;           best-zona is centro)
   ;      (then best-quartiere is trastevere with certainty 90 and
   ;            best-quartiere is campitelli with certainty 70))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is roma and
   ;           best-zona is periferia)
   ;      (then best-quartiere is trastevere with certainty 30 and
   ;            best-quartiere is campitelli with certainty 60))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is roma and
   ;           best-zona is primacintura)
   ;      (then best-quartiere is trastevere with certainty 80 and
   ;            best-quartiere is campitelli with certainty 80))

   ; ; FIRENZE
   ; (rule (if preferisce is not unknown and 
   ;           best-citta is firenze and
   ;           best-zona is centro)
   ;      (then best-quartiere is santacroce with certainty 90 and
   ;            best-quartiere is rovezzano with certainty 70))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is firenze and
   ;           best-zona is periferia)
   ;      (then best-quartiere is santacroce with certainty 30 and
   ;            best-quartiere is rovezzano with certainty 60))

   ; (rule (if preferisce is not unknown and 
   ;           best-citta is firenze and
   ;           best-zona is primacintura)
   ;      (then best-quartiere is santacroce with certainty 80 and
   ;            best-quartiere is rovezzano with certainty 80))
)

