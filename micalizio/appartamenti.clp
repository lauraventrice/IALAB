;;************************
;;* APARTMENT SELECTION RULES *
;;************************

(defmodule APPARTAMENTI (import MAIN ?ALL))

(deffacts any-attributes
  (attribute (name best-metri-quadri) (value any))
  (attribute (name best-numero-vani) (value any))
  (attribute (name best-numero-servizi) (value any))
  (attribute (name best-piano) (value any))
  (attribute (name best-citta) (value any))
  (attribute (name best-zona) (value any))
  (attribute (name best-quartiere) (value any))
  (attribute (name best-ascensore) (value any))
  (attribute (name best-boxauto) (value any))
  (attribute (name best-metri-quadri-boxauto) (value any))
  (attribute (name best-terrazzino) (value any))
  (attribute (name best-prezzo-richiesto) (value any))
)
;;******************************************************************************************************

;; magari possiamo aggiungere un campo indirizzo al posto di nome e un id per ogni appartamento!
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
    (multislot metri-quadri-boxauto (default any))
    (slot terrazzino (default ?NONE))
    (slot prezzorichiesto (default ?NONE))
    (multislot servizivicino (default any))
)

(deffacts APPARTAMENTI::the-apartment
    ; lista appartamenti a moncalieri (torino)
    (apartment  (name "Appartamento su due piani in vendita in strada dei Cunioli Alti, 137")
                (metriquadri 137) (numerovani 4) (numeroservizi 3) (piano secondo) (citta torino) (zona primacintura) (quartiere moncalieri)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 3) (terrazzino si) (prezzorichiesto 375000) (servizivicino parco scuola mezzipubblici)
    )

    (apartment  (name "Quadrilocale in vendita in strada Genova, 255 /4")
                (metriquadri 110) (numerovani 4) (numeroservizi 2) (piano primo) (citta torino) (zona primacintura) (quartiere moncalieri)
                (ascensore si) (boxauto si) (metri-quadri-boxauto 5) (terrazzino si) (prezzorichiesto 240000) (servizivicino ospedale parco scuola)
    )

    (apartment  (name "Trilocale in vendita in strada Genova, 208")
                (metriquadri 83) (numerovani 3) (numeroservizi 1) (piano primo) (citta torino) (zona periferia) (quartiere moncalieri)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 3) (terrazzino si) (prezzorichiesto 157000) (servizivicino parco mezzipubblici)
    )

    ; lista appartamenti a lingotto (torino)
    (apartment  (name "Attico in vendita in via Onorato Vigliani, 24")
                (metriquadri 170) (numerovani 7) (numeroservizi 2) (piano quinto) (citta torino) (zona centro) (quartiere lingotto)
                (ascensore si) (boxauto si) (metri-quadri-boxauto 7) (terrazzino si) (prezzorichiesto 465000) (servizivicino ospedale mezzipubblici)
    )

    (apartment  (name "Trilocale in vendita in via Fratel Teodoreto, 3")
                (metriquadri 75) (numerovani 3) (numeroservizi 1) (piano primo) (citta torino) (zona primacintura) (quartiere lingotto)
                (ascensore si) (boxauto no) (terrazzino si) (prezzorichiesto 114000) (servizivicino parco scuola) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Appartamento in vendita in via Filadelfia, 50")
                (metriquadri 130) (numerovani 5) (numeroservizi 2) (piano primo) (citta torino) (zona centro) (quartiere lingotto)
                (ascensore si) (boxauto si) (metri-quadri-boxauto 4) (terrazzino si) (prezzorichiesto 260000) (servizivicino ospedale mezzipubblici)
    )

    ; lista appartamenti a trastevere (roma)
    (apartment  (name "Appartamento in vendita in via di San Crisogono")
                (metriquadri 140) (numerovani 5) (numeroservizi 2) (piano secondo) (citta roma) (zona centro) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 895000) (servizivicino ospedale parco) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )
  
    (apartment  (name "Trilocale in vendita in vicolo del Bologna s.n.c")
                (metriquadri 68) (numerovani 3) (numeroservizi 2) (piano terra) (citta roma) (zona primacintura) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 315000) (servizivicino ospedale scuola) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita in via del Politeama")
                (metriquadri 84) (numerovani 2) (numeroservizi 2) (piano terra) (citta roma) (zona centro) (quartiere trastevere)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 500000) (servizivicino ospedale mezzipubblici) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a campitelli (roma)
    (apartment  (name "Bilocale in vendita in piazza Margana, 20")
                (metriquadri 60) (numerovani 2) (numeroservizi 1) (piano terra) (citta roma) (zona centro) (quartiere campitelli)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 460000) (servizivicino ospedale mezzipubblici); questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Quadrilocale in vendita in via fori imperiali")
                (metriquadri 120) (numerovani 4) (numeroservizi 2) (piano terzo) (citta roma) (zona centro) (quartiere campitelli)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 747000) (servizivicino ospedale); questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita a Aventino - San Saba")
                (metriquadri 120) (numerovani 2) (numeroservizi 2) (piano quarto) (citta roma) (zona periferia) (quartiere campitelli)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 950000) (servizivicino ospedale parco scuola) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a san siro (milano)
    (apartment  (name "Bilocale in vendita in piazza Margana, 20")
                (metriquadri 63) (numerovani 2) (numeroservizi 1) (piano primo) (citta milano) (zona primacintura) (quartiere sansiro)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 200000) (servizivicino ospedale parco) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Appartamento su due piani in vendita in via Matteo Civitali, 41")
                (metriquadri 66) (numerovani 2) (numeroservizi 1) (piano terzo) (citta milano) (zona primacintura) (quartiere sansiro)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 4) (terrazzino no) (prezzorichiesto 450000) (servizivicino scuola mezzipubblici)
    )

    (apartment  (name "Appartamento in vendita in piazza Santa Maria Nascente s.n.c")
                (metriquadri 200) (numerovani 5) (numeroservizi 1) (piano primo) (citta milano) (zona centro) (quartiere sansiro)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 6) (terrazzino no) (prezzorichiesto 890000) (servizivicino mezzipubblici)
    )

    ; lista appartamenti a navigli (milano)
    (apartment  (name "Trilocale in vendita in via San Calocero, 9")
                (metriquadri 102) (numerovani 3) (numeroservizi 3) (piano terzo) (citta milano) (zona centro) (quartiere navigli)
                (ascensore si) (boxauto si) (metri-quadri-boxauto 6) (terrazzino no) (prezzorichiesto 950000) (servizivicino parco mezzipubblici)
    )

    (apartment  (name "Bilocale in vendita in piazza Ventiquattro Maggio s.n.c")
                (metriquadri 50) (numerovani 2) (numeroservizi 2) (piano primo) (citta milano) (zona periferia) (quartiere navigli)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 4) (terrazzino si) (prezzorichiesto 235000) (servizivicino ospedale parco scuola mezzipubblici)
    )

    (apartment  (name "Monolocale in vendita in piazza Serafino Belfanti, 1")
                (metriquadri 36) (numerovani 1) (numeroservizi 1) (piano primo) (citta milano) (zona primacintura) (quartiere navigli)
                (ascensore si) (boxauto no) (terrazzino si) (prezzorichiesto 165000) (servizivicino parco scuola) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a santa croce (firenze)
    (apartment  (name "Trilocale in vendita in Campo San Giacomo da l'Orio s.n.c")
                (metriquadri 85) (numerovani 3) (numeroservizi 2) (piano primo) (citta firenze) (zona centro) (quartiere santacroce)
                (ascensore si) (boxauto no) (terrazzino no) (prezzorichiesto 330000) (servizivicino ospedale  mezzipubblici); questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Quadrilocale in vendita in Santa Croce")
                (metriquadri 110) (numerovani 4) (numeroservizi 1) (piano primo) (citta firenze) (zona centro) (quartiere santacroce)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 590000) (servizivicino mezzipubblici); questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita a Santa Croce")
                (metriquadri 39) (numerovani 2) (numeroservizi 1) (piano primo) (citta firenze) (zona primacintura) (quartiere santacroce)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 220000) (servizivicino parco scuola mezzipubblici) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    ; lista appartamenti a rovezzano (firenze)
    (apartment  (name "Quadrilocale in vendita in via SANT'ANDREA A ROVEZZANO s.n.c")
                (metriquadri 110) (numerovani 4) (numeroservizi 2) (piano primo) (citta firenze) (zona centro) (quartiere rovezzano)
                (ascensore no) (boxauto no) (terrazzino no) (prezzorichiesto 280000) (servizivicino ospedale scuola) ; questo appartamento non ha il boxauto e quindi non ha specificato la grandezza di esso
    )

    (apartment  (name "Bilocale in vendita in piazza Ventiquattro Maggio s.n.c")
                (metriquadri 250) (numerovani 1) (numeroservizi 2) (piano primo) (citta firenze) (zona primacintura) (quartiere rovezzano)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 6) (terrazzino si) (prezzorichiesto 500000) (servizivicino scuola mezzipubblici)
    )

    (apartment  (name "Monolocale in vendita in via di Rocca Tedalda s.n.c")
                (metriquadri 30) (numerovani 1) (numeroservizi 1) (piano terra) (citta firenze) (zona periferia) (quartiere rovezzano)
                (ascensore no) (boxauto si) (metri-quadri-boxauto 6) (terrazzino si) (prezzorichiesto 168000) (servizivicino parco scuola mezzipubblici)
    )
)


(defrule APPARTAMENTI::generate-apartments
  (apartment (name ?name)
        (metriquadri ?mq)
        (numerovani ?nv)
        (numeroservizi ?ns)
        (piano ?p)
        (citta ?c)
        (zona ?z)
        (quartiere ?q)
        (ascensore ?a)
        (boxauto ?ba)
        (metri-quadri-boxauto $? ?mqba $?)
        (terrazzino ?t)
        (prezzorichiesto ?pr))
  (attribute (name best-metri-quadri) (value ?mq) (certainty ?certainty-1))
  (attribute (name best-numero-vani) (value ?nv) (certainty ?certainty-2))
  (attribute (name best-numero-servizi) (value ?ns) (certainty ?certainty-3))
  (attribute (name best-piano) (value ?p) (certainty ?certainty-4))
  (attribute (name best-citta) (value ?c) (certainty ?certainty-5))
  (attribute (name best-zona) (value ?z) (certainty ?certainty-6))
  (attribute (name best-quartiere) (value ?q) (certainty ?certainty-7))
  (attribute (name best-ascensore) (value ?a) (certainty ?certainty-8))
  (attribute (name best-boxauto) (value ?ba) (certainty ?certainty-9))
  (attribute (name best-metri-quadri-boxauto) (value ?mqba) (certainty ?certainty-10))
  (attribute (name best-terrazzino) (value ?t) (certainty ?certainty-11))
  (attribute (name best-prezzo-richiesto) (value ?pr) (certainty ?certainty-12))
  =>
  (assert (attribute (name apartment) (value ?name)
                     (certainty (min ?certainty-1 ?certainty-2 ?certainty-3 ?certainty-4 ?certainty-5 ?certainty-6 ?certainty-7 ?certainty-8 ?certainty-9 ?certainty-10 ?certainty-11 ?certainty-12)))))

