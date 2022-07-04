;;*****************************
;;* PRINT SELECTED APARTMENT RULES *
;;*****************************

(defmodule PRINT-RESULTS 
                            (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import APPARTAMENTI ?ALL)
                            (import MAIN ?ALL))

(defrule PRINT-RESULTS::header ""
   (declare (salience 1000))
   =>
   (printout t t)
   (printout t "        SELECTED APARTMENT" t t)
   (printout t " APARTMENT                  CERTAINTY" t)
   (printout t " -------------------------------" t crlf)
   (assert (phase print-apartment)))

(defrule PRINT-RESULTS::print-apartment ""
  ?rem <- (attribute (name apartment) (value ?name) (certainty ?per))		  
  (not (attribute (name apartment) (certainty ?per1&:(> ?per1 ?per))))
  =>
  (retract ?rem)
  (format t " %-24s %2d%%%n" ?name ?per)
  )

(defrule PRINT-RESULTS::remove-poor-apartment-choices ""
  ?rem <- (attribute (name apartment) (certainty ?per&:(< ?per 20)))
  =>
  (retract ?rem))

(defrule PRINT-RESULTS::end-spaces ""
   (not (attribute (name apartment)))
   =>
   (printout t t)
   (assert (attribute (name fine-ciclo) (value "Fine ciclo di interazione") (certainty 100.0))))


(defrule PRINT-RESULTS::end-cycle      ;Quindi al principio questa regola sarà attivata per tutte le domande
  (attribute (name fine-ciclo))                  
   =>
    (printout t "Vuoi cambiare le risposte? : " crlf)
    (assert (attribute (name risposta) (value (read)) (certainty 100.0)))
)


(defrule PRINT-RESULTS::first-change-response-done      ;Quindi al principio questa regola sarà attivata per tutte le domande
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  (attribute (name ?name) (value unknown))     
   =>
    (printout t "ASSERISCO UN FATTO PER LE RISPOSTE UNKNOWN " crlf)
    (assert (attribute (name risposta-unknown) (value ?name)))
    )

(defrule PRINT-RESULTS::change-response-done      ;Quindi al principio questa regola sarà attivata per tutte le domande
  (attribute (name risposta) (value si))   
  (attribute (name ?name) (value unknown))   
  ?r <- (attribute (name risposta-unknown) (value ?name))
  ?f <- (question (already-asked TRUE)
                (precursors)
                (the-question ?the-question)
                (attribute ?name)
                (valid-answers $?valid-answers))     
   =>
    (printout t "MODIFICO DOMANDA; ORA POSSO RIFARLA " crlf)
    (retract ?r)
    (modify ?f (already-asked FALSE))
)

(defrule PRINT-RESULTS::restart
  (declare (salience 100))
  (not (exists (attribute (name risposta-unknown) (value ?name))))
  ;(forall (attribute (name ?name) (value unknown)) (attribute (name risposta-unknown) (value ?name)))
  ;not (attribute (name risposta-unknown) (value ?name)))
  (question (already-asked FALSE))  
  ?s <- (attribute (name risposta) (value si))  
  ?f <- (attribute (name fine-ciclo)) 
  =>
  (retract ?s)
  (retract ?f)
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-QUALITIES APPARTAMENTI PRINT-RESULTS)
)

; (defrule PRINT-RESULTS::generate-apartments-2
;   (apartment (name ?name)
;         (metriquadri ?mq)
;         (numerovani ?nv)
;         (numeroservizi ?ns)
;         (piano ?p)
;         (citta ?c)
;         (zona ?z)
;         (quartiere ?q)
;         (ascensore ?a)
;         (boxauto ?ba)
;         (metri-quadri-boxauto $? ?mqba $?)
;         (terrazzino ?t)
;         (prezzorichiesto ?pr))
;   ; ; (attribute (name best-metri-quadri) (value ?mq) (certainty ?certainty-1))
;   ; (attribute (name best-numero-vani) (value ?nv) (certainty ?certainty-2))
;   ; (attribute (name best-numero-servizi) (value ?ns) (certainty ?certainty-3))
;   ; (attribute (name best-numero-piano) (value ?p) (certainty ?certainty-4))
;   ; (attribute (name best-citta) (value ?c) (certainty ?certainty-5))
;   ; (attribute (name best-zona) (value ?z) (certainty ?certainty-6))
;   ; (attribute (name best-quartiere) (value ?q) (certainty ?certainty-7))
;    (attribute (name best-ascensore) (value ?a) (certainty ?certainty-8))
;   ; (attribute (name best-boxauto) (value ?ba) (certainty ?certainty-9))
;   ; ; (attribute (name best-metri-quadri-boxauto) (value ?mqba) (certainty ?certainty-10))
;   ; (attribute (name best-terrazzino) (value ?t) (certainty ?certainty-11))

;   (attribute (name best-prezzo-richiesto) (value ?name) (certainty ?certainty-12))
;   ;(attribute (name best-metri-quadri) (value ?name) (certainty ?certainty-1))
;   =>
;   (printout t "GENERO ASSERT APPARTAMENTI" crlf)
;   (assert (attribute (name apartment) (value ?name)
;                      (certainty (min ?certainty-8 ?certainty-12)))))

; (defrule PRINT-RESULTS::check-responses      ;Quindi al principio questa regola sarà attivata per tutte le domande
;    (attribute (name ?name) (value unknown))
;   ;  ?f <- (question (already-asked ?val)
;   ;                  (precursors)
;   ;                  (the-question ?the-question)
;   ;                  (attribute ?name)
;   ;                  (valid-answers $?valid-answers))
  
;                          ;(printout t "RISPOSTA DATA: " ?the-question crlf)
;    =>
;      (assert (attribute (name unknown-available)
;                       (value "")))
;   ;  (modify ?f (already-asked TRUE))
;   ;  (assert (attribute (name ?the-attribute)
;   ;                     (value (ask-question ?the-question ?valid-answers))))
;   ;                        ;(printout t "RISPOSTA DATA: " ?the-question crlf)
;                          )