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
                            (import MAIN ?ALL))

(defrule CHOOSE-QUALITIES::startit => (focus RULES))

(deffacts the-apartment-rules

  ; Regole per selezionare il best-metri-quadri 


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

  ; Regole per selezionare il best-quartiere  


  ; Regole per selezionare il best-ascensore 

  (rule (if ascensore is si)
        (then best-ascensore is si with certainty 40))

  (rule (if ascensore is no)
        (then best-ascensore is no with certainty 40))

  (rule (if ascensore is unknown)
        (then best-ascensore is si with certainty 20 and
              best-ascensore is si with certainty 20))

  ; Regole per selezionare il best-boxauto

  (rule (if boxauto is si)
        (then best-boxauto is si with certainty 40))

  (rule (if boxauto is no)
        (then best-boxauto is no with certainty 40))

  (rule (if boxauto is unknown)
        (then best-boxauto is si with certainty 20 and
              best-boxauto is si with certainty 20))

  ; Regole per selezionare il best-metri-quadri-boxauto  



  ; Regole per selezionare il best-terrazzino 

  (rule (if terrazzino is si)
        (then best-terrazzino is si with certainty 40))

  (rule (if terrazzino is no)
        (then best-terrazzino is no with certainty 40))

  (rule (if terrazzino is unknown)
        (then best-terrazzino is si with certainty 20 and
              best-terrazzino is si with certainty 20))


  ; Regole per selezionare il best-prezzo-richiesto 

)