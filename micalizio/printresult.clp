;;*****************************
;;* PRINT SELECTED APARTMENT RULES *
;;*****************************

(defmodule PRINT-RESULTS 
                            (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import APPARTAMENTI ?ALL)
                            (import MAIN ?ALL))

(defrule PRINT-RESULTS::header ""
   (declare (salience 10000))
   =>
   (printout t t)
   (printout t crlf "        SELECTED APARTMENT" t t)
   (printout t " APARTMENT                  CERTAINTY" t)
   (printout t " -------------------------------" t crlf)
   (assert (phase print-apartment)))

(defrule PRINT-RESULTS::print-apartment ""
 (declare (salience 1000))
  ?rem <- (attribute (name apartment) (value ?name) (certainty ?per))		  
  (not (attribute (name apartment) (certainty ?per1&:(> ?per1 ?per))))
  =>
  (retract ?rem)
  (format t " %-24s %2d%%%n" ?name ?per)
  )


(defrule PRINT-RESULTS::remove-poor-apartment-choices ""
  (declare (salience 1000))
  ?rem <- (attribute (name apartment) (certainty ?per&:(< ?per 20)))
  =>
  (retract ?rem))

(defrule PRINT-RESULTS::end-spaces ""
   (not (attribute (name apartment)))
   =>
   (printout t t)
   (assert (attribute (name fine-ciclo) (value "Fine ciclo di interazione") (certainty 100.0))))


