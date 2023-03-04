(define (problem northeye1)

    (:domain northeye)
    
    (:objects
        g1 g2 g3 - landseg
        r1 - riverseg
        muise - adult
        house - structure
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

        (location muise g1)
        (location house g3)

        (damaged house)
    )
    
    (:goal
        (and
            ; (floodingEvent)
            ;(location muise g1)
            ;(embankEvent)
            (not (damaged house))
        )
    )
    
)