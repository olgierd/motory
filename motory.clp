
;; (assert (attribute (name PRZEZNACZENIE) (value WYSCIGI)))
;; (assert (attribute (name NOWA_CENA) (value 1500)))
;; (assert (attribute (name NOWA_MARKA) (value HONDA)))

;;----DEFINICJA ATRYBUTU ------
;; ----------------------------
(deftemplate attribute
	(slot name)                     	
	(slot value)			   	
	(slot certainty (default 100.0))) 	

(deftemplate wynik
	(slot name)                     	
	(slot marka)			   	
	(slot model) 
	(slot certainty (default 100.0))) 

;;----DEFINICJA MOTORU      ------
;; ----------------------------------
(deftemplate motor
  (slot MARKA (default ?NONE))
  (slot MODEL (default ?NONE))
  (slot MOC_SILNIKA (default any))
  (slot POJEMNOSC_SILNIKA (default any))
  (slot MASA (default any))
  (slot POJEMNOSC_BAKU (default any))
  (slot CENA (default any)))

;;----DEFAULTY ------
;; ----------------------------------

(deffacts any-attributes
  (attribute (name PRZEZNACZENIE) (value NONE))
  (attribute (name C_MARKA) (value DEFAULT))
  (attribute (name C_MOC_SILNIKA) (value -1))
  (attribute (name C_POJEMNOSC_SILNIKA) (value -1))
  (attribute (name C_MASA) (value 10000000))
  (attribute (name C_POJEMNOSC_BAKU) (value -1))
  (attribute (name C_CENA) (value 10000000))
)

;; ---REGULY STERUJACE -----------------
;;--------------------------------------



(defrule zmiana_marki
?f1 <- (attribute (name NOWA_MARKA) (value ?arg) ) 
?f2 <- (attribute (name C_MARKA))
=>  (retract ?f1 ?f2) 
(assert (attribute (name C_MARKA) (value ?arg) (certainty 100) ) ) 
)

(defrule zmiana_ceny
?f1 <- (attribute (name NOWA_CENA) (value ?arg) ) 
?f2 <- (attribute (name C_CENA))
=>  (retract ?f1 ?f2) 
(assert (attribute (name C_CENA) (value ?arg) (certainty 100) ) ) 
)

(defrule reg1 
?f1 <- (attribute (name PRZEZNACZENIE) (value WYSCIGI) ) 
?f2 <- (attribute (name C_MOC_SILNIKA))
?f3 <- (attribute (name C_POJEMNOSC_SILNIKA))
?f4 <- (attribute (name C_MASA))
?f5 <- (attribute (name C_POJEMNOSC_BAKU))
=>  (retract ?f1 ?f2 ?f3 ?f4 ?f5) 
(assert (attribute (name C_MOC_SILNIKA) (value 70) (certainty 100) ) ) 
(assert (attribute (name C_POJEMNOSC_SILNIKA) (value 100) (certainty 50) ) ) 
(assert (attribute (name C_MASA) (value 200) (certainty 80) ) ) 
(assert (attribute (name C_POJEMNOSC_BAKU) (value 100) (certainty 20) ) ) 
)

;; --- DANE MOTOROW ------------
;; -----------------------------

(deffacts the-motor-list 
  (motor (MARKA SUZUKI) (MODEL X11) (MOC_SILNIKA 100.0) (POJEMNOSC_SILNIKA 140.0) (MASA 100) (POJEMNOSC_BAKU 150) (CENA 1000.0))
  (motor (MARKA HONDA) (MODEL ABC) (MOC_SILNIKA 80.0) (POJEMNOSC_SILNIKA 130.0) (MASA 150) (POJEMNOSC_BAKU 100) (CENA 2000.0))
  (motor (MARKA SUZUKI) (MODEL XYZ) (MOC_SILNIKA 60.0) (POJEMNOSC_SILNIKA 200.0) (MASA 200) (POJEMNOSC_BAKU 250) (CENA 4000.0))
)


;; ----- GENERATOR

(defrule generate-motory

	(motor (MARKA ?marka) (MODEL ?model) (MOC_SILNIKA ?moc) (POJEMNOSC_SILNIKA ?pojemnosc_silnika) (MASA ?masa) (POJEMNOSC_BAKU ?pojemnosc_baku) (CENA ?cena))
	(attribute (name C_MARKA) (value ?ogr0) (certainty ?mod0))
	(attribute (name C_MOC_SILNIKA) (value ?ogr1) (certainty ?mod1))
	(attribute (name C_POJEMNOSC_SILNIKA) (value ?ogr2) (certainty ?mod2))	
	(attribute (name C_MASA) (value ?ogr3) (certainty ?mod3))
	(attribute (name C_POJEMNOSC_BAKU) (value ?ogr4) (certainty ?mod4))		
	(attribute (name C_CENA) (value ?ogr5) (certainty ?mod5))	

	(test (>= ?moc ?ogr1)) 
	(test (>= ?pojemnosc_silnika ?ogr2)) 
	(test (<= ?masa ?ogr3)) 
	(test (>= ?pojemnosc_baku ?ogr4))
	(test (<= ?cena ?ogr5))

	=> 
	
	(if (or (= (str-compare ?ogr0 DEFAULT) 0) (= (str-compare ?ogr0 ?marka) 0)    )  then

		(assert (wynik (name motor) (marka ?marka) (model ?model) 
		(certainty  (+ (* (abs (- ?moc ?ogr1)) ?mod1) (* (abs (- ?pojemnosc_silnika ?ogr2)) ?mod2) (* (abs (- ?masa ?ogr3)) ?mod3) (* (abs (- ?pojemnosc_baku ?ogr4)) ?mod4) ) 
	
	)

	))

	)
)


(deffunction motor-sort (?w1 ?w2)
   (< (fact-slot-value ?w1 certainty)
      (fact-slot-value ?w2 certainty)
   )
)

(deffunction get-motor-list ()
(bind ?facts (find-all-facts ((?f wynik)) (and (eq ?f:name motor) (>= ?f:certainty 20))))
(sort motor-sort ?facts))