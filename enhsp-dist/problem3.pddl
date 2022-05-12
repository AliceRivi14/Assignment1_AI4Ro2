(define (problem PROBLEM3)
    (:domain DOMAIN_)

;Problem 3: there are 4 crates:
;- crate1: weight 70kg, 20 distance from loading bay. Crate in group A for extension 1.
;- crate2: fragile, weight 80kg, 20 distance from loading bay. Crate in group A for extension 1.
;- crate3: weight 60kg, 30 distance from loading bay. Crate in group A for extension 1
;- crate4: weight 30kg, 10 distance from loading bay.

    (:objects   crate1 crate2 crate3 crate4 - crate
                m1 m2 - mover
                l - loader
                ll - loader-light
    )

    (:init
            (m-at-loading_bay m1)
            (m-at-loading_bay m2)
            (on-ground crate1)
            (on-ground crate2)
            (on-ground crate3)
            (on-ground crate4)
            (= (dist crate1) 20)
            (= (dist crate2) 20)
            (= (dist crate3) 30)
            (= (dist crate4) 10)
            (free_m m1)
            (free_m m2)
            (= (weight crate1) 70)
            (= (weight crate2) 80)
            (= (weight crate3) 60)
            (= (weight crate4) 30)
            (fragile crate2)
            (= (loading_time l) 4)
            (= (loading_time_light ll) 4)
            (= (loading_time_F l) 6)
            (= (loading_time_light_F ll) 6)
            (free_l l)
            (free_ll ll)
            (different m1 m2)
            (= (charge m1) 20)
            (= (charge m2) 20)
            (label_A crate1)
            (label_A crate2)
            (label_A crate3)
            (= (amount_A) 3)
            (= (amount_B) 0)
    )

    (:goal (and
                (on-belt crate1)
                (on-belt crate2)
                (on-belt crate3)
                (on-belt crate4)
                (m-at-loading_bay m1)
                (m-at-loading_bay m2))
    )
)
