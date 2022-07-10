;;*****************************
;;* RESTART PROGRAM RULES *
;;*****************************

(defmodule RESTART 
                            (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import APPARTAMENTI ?ALL)
                            (import MAIN ?ALL)
                            
                            (export ?ALL))

(defrule RESTART::end-cycle      
  (declare (salience 1000))
  ;(attribute (name fine-ciclo))         
  (test (neq (length$ (find-all-facts ((?f attribute)) (eq ?f:name fine-ciclo))) 2))         
   =>
    (printout t crlf "        Vuoi cambiare le risposte alle domande a cui hai risposto unknown? : " )
    (assert (attribute (name risposta) (value (read)) (certainty 100.0)))
)


(defrule RESTART::first-change-response-done     
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  (attribute (name ?name) (value unknown))     
   =>
    ;(printout t "ASSERISCO UN FATTO PER LE RISPOSTE UNKNOWN " crlf)
    (assert (attribute (name risposta-unknown) (value ?name)))
    )

(defrule RESTART::change-response-done     
    (declare (salience 1000))
  (attribute (name risposta) (value si))   
  ?a <- (attribute (name ?name) (value ?val))   
  ?r <- (attribute (name risposta-unknown) (value ?name))
  ?f <- (question (already-asked TRUE)
                (precursors)
                (the-question ?the-question)
                (attribute ?name)
                (valid-answers $?valid-answers))
  (not (test (eq ?name preferisce)))  ; quando riparte il ciclio meglio non rifare la domanda "preferisce il mare o la montagna?"
   =>
    (printout t "MODIFICO DOMANDA; ORA POSSO RIFARLA " crlf)
    (retract ?a)
    (retract ?r)
    (modify ?f (already-asked FALSE))
)

(defrule RESTART::change-response-done-preferisce   
    (declare (salience 1000))
  (attribute (name risposta) (value si))   
  ?a <- (attribute (name ?name) (value ?val))   
  ?r <- (attribute (name risposta-unknown) (value ?name))
  ?f <- (question (already-asked TRUE)
                (precursors)
                (the-question ?the-question)
                (attribute ?name)
                (valid-answers $?valid-answers))
  (test (eq ?name preferisce))  ; quando riparte il ciclio meglio non rifare la domanda "preferisce il mare o la montagna?"
   =>
    ;(printout t "MODIFICO DOMANDA; ORA POSSO RIFARLA " crlf)
    (retract ?a)
    (retract ?r)
)

;-------- eregole per cancellare le vecchie risposte ------------

(defrule RESTART::delete-old-answer-prezzo-massimo
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value prezzo-massimo))   
  ?a <- (attribute (name best-prezzo-richiesto) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-zona
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value zona))   
  ?a <- (attribute (name best-zona) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-metri-quadri
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value metri-quadri))   
  ?a <- (attribute (name best-metri-quadri) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-numero-vani
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value numero-vani))   
  ?a <- (attribute (name best-numero-vani) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-numero-servizi
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value numero-servizi))   
  ?a <- (attribute (name best-numero-servizi) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-numero-piano
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value numero-piano))   
  ?a <- (attribute (name best-numero-servizi) (value ?val))   
   =>
    (retract ?a)
)

; TODO: qua c'è qualcosa da sistemare -> non so se faccia ciòò che vada fatto
(defrule RESTART::delete-old-answer-citta
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value citta))   
  ?a <- (attribute (name best-citta) (value ?val))
  (attribute (name preferisce) (value ?preferisce))
   =>
   ;(printout t "RIMUOVO VECCHIE RISPOSTE CITTA: " crlf)
    (assert (attribute (name preferisce) (value ?preferisce) (certainty 22.0)))  ; riasserisco il valore di preferisce così poi mi serve per far riscattare la regola per determinare la migliore città se poi risponde con un valore
    (retract ?a)
)

(defrule RESTART::delete-old-answer-quartiere
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value quartiere))   
  ?a <- (attribute (name best-quartiere) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-ascensore
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value ascensore))   
  ?a <- (attribute (name best-ascensore) (value ?val))   
   =>
   ;(printout t "RIMUOVO VECCHIE RISPOSTE ASCENSORE: " crlf)
    (retract ?a)
)

(defrule RESTART::delete-old-answer-boxauto
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value boxauto))   
  ?a <- (attribute (name best-boxauto) (value ?val))   
   =>
    (retract ?a)
)

(defrule RESTART::delete-old-answer-terrazzino
  (declare (salience 10000))
  (attribute (name risposta) (value si))   
  ?r <- (attribute (name risposta-unknown) (value terrazzino))   
  ?a <- (attribute (name best-terrazzino) (value ?val))   
   =>
    (retract ?a)
)

;-------- fine regole per cancellare le vecchie risposte ------------


; TODO: i commenti nella regola seguente teoricamente possono essere cancellati - il comportamento giusto si ottiene senza di loro

(defrule RESTART::restart
  (declare (salience 100))
  (not (exists (attribute (name risposta-unknown) (value ?name))))
  ;(forall (attribute (name ?name) (value unknown)) (attribute (name risposta-unknown) (value ?name)))
  ;not (attribute (name risposta-unknown) (value ?name)))
  (question (already-asked FALSE))  
  ?s <- (attribute (name risposta) (value si))  
  ?f <- (attribute (name fine-ciclo)) 
  =>
  (retract ?s)
  ;(retract ?f)
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-QUALITIES APPARTAMENTI PRINT-RESULTS RESTART)
)
