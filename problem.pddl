(define (problem northeye1)

    (:domain northeye)
    
    (:objects
        g1 g2 g3 - landseg
        r1 - riverseg
        muise - adult
        house - building
        muiseFarm whoseFarm - farm
        trevor - sheep
    )
    
    (:init

        (lowground g1)
        (lowground g2)
        (lowground g3)

        ;
        ;   g1 <-> g2 <-> g3 <-> r1
        ;

        (adj g1 g2)
        (adj g2 g1)
        (adj g2 g3)
        (adj g3 g2)
        (adj r1 g3)
        (adj g3 r1)

        (location muise g3)
        (location house g3)
        (location muiseFarm g3)
        (location whoseFarm g1)
        (location trevor g1)

        (tired muise)
        
    )
    
    (:goal
        (and
            ; (floodingEvent)
            ;(location muise g1)
            ;(embankEvent)
            ;(not (damaged house))
            ;(breakfastEvent)
            ;(lunchEvent)
            ;(dinnerEvent)
            ;(workEvent)
            (location trevor g3)
            (tended trevor)

        )
    )
    
)