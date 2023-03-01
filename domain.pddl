(define (domain northeye)

    (:requirements :typing :strips :conditional-effects :quantified-preconditions :disjunctive-preconditions)

    (:types
        land locatable - object
        structure entity - locatable
        river building - structure
        animal person - entity
        cow dog pig sheep - animal
        adult child - person
    )
    
    (:predicates
        (location ?e - entity ?l - land) ; location of an entity
        (adj ?l1 ?l2 - land)   ; adjacency relationship
        (embankment ?l - land) ; is there an embankment on this river segment (area of land with a river structure)
        (dredge ?l - land)     ; has this river segment been dredged already 
        (highground ?l - land) ; highground cannot be flooded
        (lowground ?l - land)  ; lowground can be flooded
        (flooded ?l - land)    ; flood status of a land segment
        (floodingEvent)        ; does a flooding event occur in this scenario?
        ; scene fluents to specify scenario goals...
    )
    
    (:functions)
    
    
    (:action dredge-river)
    
    (:action build-embankment)

    (:action )
    
)