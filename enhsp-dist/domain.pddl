(define (domain DOMAIN_)
    (:requirements :adl :negative-preconditions :equality :fluents)

    (:types crate mover loader loader-light)

    (:predicates  (m-at-loading_bay ?m - mover)                               ;mover at loading_bay
                  (c-at-loading_bay ?c - crate)                               ;crate at loading_bay
                  (m-moving ?c - crate ?m - mover)                            ;mover is moving towards a crate
                  (l-loading ?c - crate ?l - loader)                          ;loader is loading a crate on the conveyor belt
                  (l-loading_light ?c - crate ?ll - loader-light)             ;loader-light (the cheaper loader ) is loading a crate in the conveyor belt
                  (at-crates ?c - crate ?m  - mover)                          ;mover at crate position
                  (carry ?c - crate ?m - mover)                               ;crate on the mover
                  (on-ground ?c - crate)                                      ;crate on the ground
                  (on-belt ?c - crate)                                        ;crate on the conveyor belt
                  (free_m ?m - mover)                                         ;mover free
                  (free_l ?l - loader)                                        ;loader free
                  (free_ll ?ll - loader-light)                                ;loader light free
                  (fragile ?c - crate)                                        ;fragile crate
                  (different ?m - mover ?m - mover)                           ;used to differentiate two movers
                  (label_A ?c - crate)                                        ;A labelled crate
                  (label_B ?c - crate)                                        ;B labelled crate

    )

    (:functions (dist ?c - crate)                                            ;distance crate-loading bay at the start
                (weight ?c - crate)                                          ;crate's weight
                (dist_m-c ?c - crate ?m - mover)                             ;distance mover-crate
                (loading_time ?l - loader)                                   ;loading time for the standard loader
                (loading_time_light ?ll - loader-light)                      ;loading time for the cheap loader
                (loading_time_F ?l - loader)                                 ;loading time for the standard loader if the crate is fragile
                (loading_time_light_F ?ll - loader-light)                    ;loading time for the cheap loader if the crate is fragile
                (charge ?m - mover)                                          ;mover charge
                (amount_A)                                                   ;amount of A-labelled crates
                (amount_B)                                                   ;amount of B-labelled crates

    )

;LEGEND

; H = HEAVY
; L = LIGHT
; F = FRAGILE
; A = A LABELLED
; B = B LABELLED

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;MOVER GOES FROM LOADING BAY TO THE CRATE POSITION

    (:action m-move_to_crate
        :parameters (?c - crate ?m - mover)
        :precondition (and
                        (= (amount_A) 0)
                        (= (amount_B) 0)
                        (m-at-loading_bay ?m)
                        (not (c-at-loading_bay ?c))
                        (free_m ?m)
                        (on-ground ?c)
                        (= (charge ?m) 20))

        :effect (and
                    (m-moving ?c ?m)
                    (not (m-at-loading_bay ?m))
                    (assign (dist_m-c ?c ?m) (dist ?c)))
    )


    (:process m-moving_to_crate
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (= (amount_A) 0)
                          (= (amount_B) 0)
                          (m-moving ?c ?m))
        :effect (and
                    (decrease (dist_m-c ?c ?m) (* #t 10))
                    (decrease (charge ?m) (* #t 1)))
    )


    (:event m-at_crates
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (= (amount_A) 0)
                          (= (amount_B) 0)
                          (m-moving ?c ?m)
                          (<= (dist_m-c ?c ?m) 0)
                          (free_m ?m))
        :effect (and
                     (at-crates ?c ?m)
                     (not (m-moving ?c ?m)))
    )

;Label A

   (:action m-move_to_crate-A
        :parameters (?c - crate ?m - mover)
        :precondition (and
                        (label_A ?c)
                        (> (amount_A) 0)
                        (not (label_B ?c))
                        (m-at-loading_bay ?m)
                        (not (c-at-loading_bay ?c))
                        (free_m ?m)
                        (on-ground ?c)
                        (= (charge ?m) 20))
        :effect (and
                    (m-moving ?c ?m)
                    (not (m-at-loading_bay ?m))
                    (assign (dist_m-c ?c ?m) (dist ?c))

                    )
    )

    (:process m-moving_to_crate-A
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_A ?c)
                          (> (amount_A) 0)
                          (not (label_B ?c))
                          (m-moving ?c ?m))
        :effect (and
                    (decrease (dist_m-c ?c ?m) (* #t 10))
                    (decrease (charge ?m) (* #t 1)))
    )

    (:event m-at_crates-A
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_A ?c)
                          (> (amount_A) 0)
                          (not (label_B ?c))
                          (m-moving ?c ?m)
                          (<= (dist_m-c ?c ?m) 0)
                          (free_m ?m))
        :effect (and
                     (at-crates ?c ?m)
                     (not (m-moving ?c ?m)))
    )

;Label B

    (:action m-move_to_crate-B
        :parameters (?c - crate ?m - mover)
        :precondition (and
                        (label_B ?c)
                        (> (amount_B) 0)
                        (not (label_A ?c))
                        (= (amount_A) 0)
                        (m-at-loading_bay ?m)
                        (not (c-at-loading_bay ?c))
                        (free_m ?m)
                        (on-ground ?c)
                        (= (charge ?m) 20))
        :effect (and
                    (m-moving ?c ?m)
                    (not (m-at-loading_bay ?m))
                    (assign (dist_m-c ?c ?m) (dist ?c)))
    )

    (:process m-moving_to_crate-B
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_B ?c)
                          (> (amount_B) 0)
                          (= (amount_A) 0)
                          (not (label_A ?c))
                          (m-moving ?c ?m))
        :effect (and
                    (decrease (dist_m-c ?c ?m) (* #t 10))
                    (decrease (charge ?m) (* #t 1)))
    )

    (:event m-at_crates-B
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_B ?c)
                          (> (amount_B) 0)
                          (= (amount_A) 0)
                          (not (label_A ?c))
                          (m-moving ?c ?m)
                          (<= (dist_m-c ?c ?m) 0)
                          (free_m ?m))
        :effect (and
                     (at-crates ?c ?m)
                     (not (m-moving ?c ?m)))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;MOVER'S LOADING ACTION

    (:action m-load
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (= (amount_A) 0)
                          (= (amount_B) 0)
                          (on-ground ?c)
                          (at-crates ?c ?m)
                          (free_m ?m)
                          (not (c-at-loading_bay ?c)))
        :effect (and
                    (carry ?c ?m)
                    (not (free_m ?m))
                    (not (on-ground ?c)))
    )

;Label A

    (:action m-load-A
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_A ?c)
                          (> (amount_A) 0)
                          (not (label_B ?c))
                          (on-ground ?c)
                          (at-crates ?c ?m)
                          (free_m ?m)
                          (not (c-at-loading_bay ?c)))
        :effect (and
                    (carry ?c ?m)
                    (not (free_m ?m))
                    (not (on-ground ?c))
                    (decrease (amount_A) 1))
    )

;Label B

    (:action m-load-B
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (label_B ?c)
                          (> (amount_B) 0)
                          (not (label_A ?c))
                          (= (amount_A) 0)
                          (on-ground ?c)
                          (at-crates ?c ?m)
                          (free_m ?m)
                          (not (c-at-loading_bay ?c)))
        :effect (and
                    (carry ?c ?m)
                    (not (free_m ?m))
                    (not (on-ground ?c))
                    (decrease (amount_B) 1))
    )

;HEAVY crates

;HEAVY standard crate

    (:action m-load-H
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (= (amount_A) 0)
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c)))
    )

;Label A and HEAVY crate

    (:action m-load_H-A
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (label_A ?c)
                          (> (amount_A) 0)
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c))
                    (decrease (amount_A) 1))
    )


;Label B and HEAVY crate

    (:action m-load_H-B
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (label_B ?c)
                          (> (amount_B) 0)
                          (= (amount_A) 0)
                          (not (label_A ?c))
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c))
                    (decrease (amount_B) 1))
    )

;FRAGILE crate

;FRAGILE standard crate

    (:action m-load-F
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (= (amount_A) 0)
                          (= (amount_B) 0)
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c)))
    )

;Label A and FRAGILE crate

    (:action m-load-F_A
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (label_A ?c)
                          (> (amount_A) 0)
                          (not (label_B ?c))
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c))
                    (decrease (amount_A) 1))
    )


;Label B and FRAGILE crate

    (:action m-load-F_B
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (label_B ?c)
                          (> (amount_B) 0)
                          (= (amount_A) 0)
                          (not (label_A ?c))
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (on-ground ?c)
                          (at-crates ?c ?m1)
                          (free_m ?m1)
                          (on-ground ?c)
                          (at-crates ?c ?m2)
                          (free_m ?m2))
        :effect (and
                    (carry ?c ?m1)
                    (not (free_m ?m1))
                    (not (on-ground ?c))
                    (carry ?c ?m2)
                    (not (free_m ?m2))
                    (not (on-ground ?c))
                    (decrease (amount_B) 1))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;GOING BACK TO LOADING BAY PROCEDURE: the mover brings the crate back to loading bay

;LIGHT and NOT FRAGILE crate

    (:action m-move_create_to_loading_bay
        :parameters (?c - crate ?m - mover)
        :precondition (and
                        (< (weight ?c) 50)
                        (not(fragile ?c))
                        (at-crates ?c ?m)
                        (carry ?c ?m))
        :effect (and
                    (m-moving ?c ?m)
                    (not (at-crates ?c ?m)))

    )

    (:process m-moving_crate_to_loading_bay
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (< (weight ?c) 50)
                          (not(fragile ?c))
                          (m-moving ?c ?m)
                          (carry ?c ?m))
        :effect (and
                    (decrease (dist ?c) (* #t (/ 100 (weight ?c))))
                    (decrease (charge ?m) (* #t 1)))
    )

    (:event crate_at_loading_bay
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (< (weight ?c) 50)
                          (not(fragile ?c))
                          (m-moving ?c ?m)
                          (<= (dist ?c) 0)
                          (carry ?c ?m))
        :effect (and
                     (c-at-loading_bay ?c)
                     (m-at-loading_bay ?m)
                     (not (m-moving ?c ?m)))
    )

;HEAVY crates

;HEAVY crate

    (:action m-move_create_to_loading_bay-H
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                        (different ?m1 ?m2)
                        (>= (weight ?c) 50)
                        (at-crates ?c ?m1)
                        (carry ?c ?m1)
                        (at-crates ?c ?m2)
                        (carry ?c ?m2))
        :effect (and
                    (m-moving ?c ?m1)
                    (not (at-crates ?c ?m1))
                    (m-moving ?c ?m2)
                    (not (at-crates ?c ?m2)))

    )

    (:process m-moving_crate_to_loading_bay-H
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (m-moving ?c ?m1)
                          (carry ?c ?m1)
                          (m-moving ?c ?m2)
                          (carry ?c ?m2))
        :effect (and
                    (decrease (dist ?c) (* #t (/ 100 (weight ?c))))
                    (decrease (charge ?m1) (* #t 1))
                    (decrease (charge ?m2) (* #t 1)))
    )

    (:event crate_at_loading_bay-H
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (m-moving ?c ?m1)
                          (m-moving ?c ?m2)
                          (<= (dist ?c) 0))
        :effect (and
                     (c-at-loading_bay ?c)
                     (m-at-loading_bay ?m1)
                     (not (m-moving ?c ?m1))
                     (m-at-loading_bay ?m2)
                     (not (m-moving ?c ?m2)))
    )

;HEAVY and FRAGILE crate

    (:action m-move_create_to_loading_bay-H_F
        :parameters (?c - crate ?m1 ?m2 - mover )
        :precondition (and
                        (>= (weight ?c) 50)
                        (different ?m1 ?m2)
                        (fragile ?c)
                        (at-crates ?c ?m1)
                        (carry ?c ?m1)
                        (at-crates ?c ?m2)
                        (carry ?c ?m2))
        :effect (and
                    (m-moving ?c ?m1)
                    (not (at-crates ?c ?m1))
                    (m-moving ?c ?m2)
                    (not (at-crates ?c ?m2)))

    )

    (:process m-moving_crate_to_loading_bay-H_F
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (>= (weight ?c) 50)
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (m-moving ?c ?m1)
                          (carry ?c ?m1)
                          (m-moving ?c ?m2)
                          (carry ?c ?m2))
        :effect (and
                    (decrease (dist ?c) (* #t (/ 100 (weight ?c))))
                    (decrease (charge ?m1) (* #t 1))
                    (decrease (charge ?m2) (* #t 1)) )
    )

    (:event crate_at_loading_bay-H_F
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (>= (weight ?c) 50)
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (m-moving ?c ?m1)
                          (m-moving ?c ?m2)
                          (<= (dist ?c) 0))
        :effect (and
                     (c-at-loading_bay ?c)
                     (m-at-loading_bay ?m1)
                     (not (m-moving ?c ?m1))
                     (m-at-loading_bay ?m2)
                     (not (m-moving ?c ?m2)))
    )


;LIGHT and FRAGILE crate

    (:action m-move_create_to_loading_bay-L_F
        :parameters (?c - crate ?m1 ?m2 - mover )
        :precondition (and
                        (< (weight ?c) 50);;;;;
                        (different ?m1 ?m2)
                        (fragile ?c)
                        (at-crates ?c ?m1)
                        (carry ?c ?m1)
                        (at-crates ?c ?m2)
                        (carry ?c ?m2))
        :effect (and
                    (m-moving ?c ?m1)
                    (not (at-crates ?c ?m1))
                    (m-moving ?c ?m2)
                    (not (at-crates ?c ?m2)))

    )

    (:process m-moving_crate_to_loading_bay-L_F
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (< (weight ?c) 50);;;;;
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (m-moving ?c ?m1)
                          (carry ?c ?m1)
                          (m-moving ?c ?m2)
                          (carry ?c ?m2))
        :effect (and
                    (decrease (dist ?c) (* #t (/ 150 (weight ?c))))
                    (decrease (charge ?m1) (* #t 1))
                    (decrease (charge ?m2) (* #t 1)) )
    )

    (:event crate_at_loading_bay-L_F
        :parameters (?c - crate ?m1 ?m2 - mover)
        :precondition (and
                          (< (weight ?c) 50);;;;;
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (m-moving ?c ?m1)
                          (m-moving ?c ?m2)
                          (<= (dist ?c) 0))
        :effect (and
                     (c-at-loading_bay ?c)
                     (m-at-loading_bay ?m1)
                     (not (m-moving ?c ?m1))
                     (m-at-loading_bay ?m2)
                     (not (m-moving ?c ?m2)))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;DOWNLOAD PROCEDURE: The mover downloads the crate on loading bay

;LIGHT and NOT FRAGILE crate

    (:action m-download
        :parameters (?c - crate ?m - mover)
        :precondition (and
                          (< (weight ?c) 50)
                          (not (fragile ?c))
                          (carry ?c ?m)
                          (c-at-loading_bay ?c))
        :effect (and
                    (on-ground ?c)
                    (free_m ?m)
                    (not (carry ?c ?m)))
    )

;HEAVY and NOT FRAGILE crate

    (:action m-download-H
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :precondition (and
                          (not (fragile ?c))
                          (different ?m1 ?m2)
                          (>= (weight ?c) 50)
                          (carry ?c ?m1)
                          (carry ?c ?m2)
                          (c-at-loading_bay ?c))


        :effect (and
                    (on-ground ?c)
                    (free_m ?m1)
                    (not (carry ?c ?m1))
                    (free_m ?m2)
                    (not (carry ?c ?m2)))
)

;FRAGILE crate

(:action m-download-F
        :parameters (?c - crate ?m1 - mover ?m2 - mover)
        :precondition (and
                          (different ?m1 ?m2)
                          (fragile ?c)
                          (carry ?c ?m1)
                          (carry ?c ?m2)
                          (c-at-loading_bay ?c))


        :effect (and
                    (on-ground ?c)
                    (free_m ?m1)
                    (not (carry ?c ?m1))
                    (free_m ?m2)
                    (not (carry ?c ?m2)))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LOADING ON CONVEYOR BELT PROCEDURE: the loader or the cheap-loader takes the crate from ground and downloads it on the conveyor belt

;NOT FRAGILE crate and STANDARD LOADER

     (:action l-load
        :parameters (?c - crate ?l - loader)
        :precondition (and
                        (not (fragile ?c))
                        (c-at-loading_bay ?c)
                        (on-ground ?c)
                        (free_l ?l))
        :effect (and
                    (l-loading ?c ?l)
                    (not (on-ground ?c))
                    (not (free_l ?l)))

    )

    (:process l-loading
        :parameters (?c - crate ?l - loader)
        :precondition (and
                          (not (fragile ?c))
                          (l-loading ?c ?l))
        :effect (and
                    (decrease (loading_time ?l) (* #t 1)))
    )

    (:event crate_on_conveyor_belt
        :parameters (?c - crate ?l - loader)
        :precondition (and
                          (not (fragile ?c))
                          (l-loading ?c ?l)
                          (<= (loading_time ?l) 0))
        :effect (and
                     (on-belt ?c)
                     (not (l-loading ?c ?l))
                     (free_l ?l)
                     (assign (loading_time ?l) 4))
    )

;NOT FRAGILE and LIGHT crate, CHEAP LOADER

        (:action l-load_cheap-L
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                        (not (fragile ?c))
                        (< (weight ?c) 50)
                        (c-at-loading_bay ?c)
                        (on-ground ?c)
                        (free_ll ?ll))
        :effect (and
                    (l-loading_light ?c ?ll)
                    (not (on-ground ?c))
                    (not (free_ll ?ll)))

    )

    (:process l-loading_cheap-L
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                          (not (fragile ?c))
                          (l-loading_light ?c ?ll))
        :effect (and
                    (decrease (loading_time_light ?ll) (* #t 1)))
    )

    (:event crate_on_conveyor_belt_cheap-L
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                          (not (fragile ?c))
                          (l-loading_light ?c ?ll)
                          (<= (loading_time_light ?ll) 0))
        :effect (and
                     (on-belt ?c)
                     (not (l-loading_light ?c ?ll))
                     (free_ll ?ll)
                     (assign (loading_time_light ?ll) 4))
    )


;FRAGILE and LIGHT crate, CHEAP LOADER

(:action l-load_cheap-L_F
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                        (fragile ?c)
                        (< (weight ?c) 50)
                        (c-at-loading_bay ?c)
                        (on-ground ?c)
                        (free_ll ?ll))
        :effect (and
                    (l-loading_light ?c ?ll)
                    (not (on-ground ?c))
                    (not (free_ll ?ll)))

    )

    (:process l-loading_cheap-L_F
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                          (fragile ?c)
                          (l-loading_light ?c ?ll))
        :effect (and
                    (decrease (loading_time_light_F ?ll) (* #t 1)))
    )

    (:event crate_on_conveyor_belt_cheap-L_F
        :parameters (?c - crate ?ll - loader-light)
        :precondition (and
                          (fragile ?c)
                          (l-loading_light ?c ?ll)
                          (<= (loading_time_light_F ?ll) 0))
        :effect (and
                     (on-belt ?c)
                     (not (l-loading_light ?c ?ll))
                     (free_ll ?ll)
                     (assign (loading_time_light_F ?ll) 6))
    )


;FRAGILE crate, STANDARD LOADER

    (:action l-load-F
        :parameters (?c - crate ?l - loader)
        :precondition (and
                        (fragile ?c)
                        (c-at-loading_bay ?c)
                        (on-ground ?c)
                        (free_l ?l))
        :effect (and
                    (l-loading ?c ?l)
                    (not (on-ground ?c))
                    (not (free_l ?l)))

    )

    (:process l-loading-F
        :parameters (?c - crate ?l - loader)
        :precondition (and
                          (fragile ?c)
                          (l-loading ?c ?l))
        :effect (and
                    (decrease (loading_time_F ?l) (* #t 1)))
    )

    (:event crate_on_conveyor_belt_fragile-F
        :parameters (?c - crate ?l - loader)
        :precondition (and
                          (fragile ?c)
                          (l-loading ?c ?l)
                          (<= (loading_time_F ?l) 0))
        :effect (and
                     (on-belt ?c)
                     (not (l-loading ?c ?l))
                     (free_l ?l)
                     (assign (loading_time_F ?l) 6))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;MOVER'S CHARGING ACTION: the mover charge himself up at loading bay

    (:action m-charging
        :parameters (?m - mover)
        :precondition (and
                            (m-at-loading_bay ?m)
                            (< (charge ?m) 20)
                            (free_m ?m))
        :effect (and
                    (assign (charge ?m) 20))
    )

)
