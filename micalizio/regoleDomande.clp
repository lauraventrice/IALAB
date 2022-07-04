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
   
(defrule QUESTIONS::ask-a-question      ;Quindi al principio questa regola sarà attivata per tutte le domande
   ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers))))
                         ;(printout t "RISPOSTA DATA: " ?the-question crlf)
                         )
   
(defrule QUESTIONS::ask-a-question-2      ;Quindi al principio questa regola sarà attivata per tutte le domande
     (declare (salience 10000))
   ?f <- (question (already-asked FALSE)
                   (precursors)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   ?a <- (attribute (name ?the-attribute)
                      (value unknown))
   =>
   (printout t crlf "ASK A QUESTION 2 " crlf)
   (retract ?a)
   ; (modify ?f (already-asked TRUE))
   ; (assert (attribute (name ?the-attribute)
   ;                    (value (ask-question ?the-question ?valid-answers))))
                         ;(printout t "RISPOSTA DATA: " ?the-question crlf)
                         )

(defrule QUESTIONS::precursor-is-satisfied 
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is ?value $?rest))
         (attribute (name ?name) (value ?value))
   =>
   (if (eq (nth$ 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))

(defrule QUESTIONS::precursor-is-not-satisfied
   ?f <- (question (already-asked FALSE)
                   (precursors ?name is-not ?value $?rest))
         (attribute (name ?name) (value ~?value))
   =>
   (if (eq (nth$ 1 ?rest) and) 
    then (modify ?f (precursors (rest$ ?rest)))
    else (modify ?f (precursors ?rest))))
