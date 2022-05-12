(define (problem PROBLEM4)
    (:domain DOMAIN_)

;Problem 4: there are 6 crates:
;- crate1: weight 30kg, 20 distance from loading bay. Crate in group A for extension 1.
;- crate2: fragile, weight 20kg, 20 distance from loading bay. Crate in group A for extension 1.
;- crate3: fragile, weight 30kg, 10 distance from loading bay. Crate in group B for extension 1
;- crate4: fragile, weight 20kg, 20 distance from loading bay. Crate in group B for extension 1.
;- crate5: fragile, weight 30kg, 30 distance from loading bay. Crate in group B for extension 1
;- crate6: weight 20kg, 10 distance from loading bay.


    (:objects   crate1 crate2 crate3 crate4 crate5 crate6 - crate
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
            (on-ground crate5)
            (on-ground crate6)
            (= (dist crate1) 20)
            (= (dist crate2) 20)
            (= (dist crate3) 10)
            (= (dist crate4) 20)
            (= (dist crate5) 30)
            (= (dist crate6) 10)
            (free_m m1)
            (free_m m2)
            (= (weight crate1) 30)
            (= (weight crate2) 20)
            (= (weight crate3) 30)
            (= (weight crate4) 20)
            (= (weight crate5) 30)
            (= (weight crate6) 20)
            (fragile crate2)
            (fragile crate3)
            (fragile crate4)
            (fragile crate5)
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
            (label_B crate3)
            (label_B crate4)
            (label_B crate5)
            (= (amount_A) 2)
            (= (amount_B) 3)
    )

    (:goal (and
                (on-belt crate1)
                (on-belt crate2)
                (on-belt crate3)
                (on-belt crate4)
                (on-belt crate5)
                (on-belt crate6)
                (m-at-loading_bay m1)
                (m-at-loading_bay m2))
    )
)
