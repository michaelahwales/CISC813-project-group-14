(define (problem northeye1)

    (:domain northeye)
    
    (:objects
        g1 g2 g3 - ground
        r1 - river
    )
    
    (:init

        (lowground g1)
        (lowground g2)
        (lowground g3)

        ;
        ;   g1 <-> g2 <-> g3 <-> r1
        ;

        (adj g1 g2)
        (adj g1 g2)
        (adj g2 g3)
        (adj g3 g2)
        (adj r1 g3)
        (adj g3 r1)
    )
    
    (:goal
        (and
            (floodingEvent)
        )
    )
    
)