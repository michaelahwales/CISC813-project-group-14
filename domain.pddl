(define (domain northeye)

    (:requirements :typing :strips :conditional-effects :quantified-preconditions :disjunctive-preconditions :negative-preconditions)

    (:types
        landseg locatable - object
        ground river - landseg
        structure entity - locatable
        animal person - entity
        cow dog pig sheep - animal
        adult child - person
    )
    
    (:predicates
        ; General
        (location ?x - locatable ?y - landseg) ; location of an entity or structure
        (adj ?x1 ?x2 - landseg)                ; adjacency relationship

        ; Conditions
        (embankment ?x - river) ; is there an embankment on this river segment (area of land with a river structure)
        (dredge ?x - river)     ; has this river segment been dredged already 
        (highground ?x - ground) ; highground cannot be flooded
        (lowground ?x - ground)  ; lowground can be flooded
        (flooded ?x - ground)    ; flood status of a land segment
        (damaged ?x - structure)    ; structure status


        ; Scene Fluents 
        (floodingEvent)        ; does a flooding event occur in this scenario?
        ; scene fluents to specify scenario goals...
    )
    
    (:functions)
    
    ;(:action dredge-river)
    
    ;(:action build-embankment)

    (:action floodingScene
        :parameters ()

        :precondition (and
            (not (floodingEvent))   ; scene hasn't happened
        )

        :effect (and
            (floodingEvent)         ; scene has happened

            (forall (?g - ground ?r - river)        ; for every ground and river segment
                (when (and (adj ?g ?r) (lowground ?g) (not (and (embankment ?r) (dredge ?r))))  ; river and ground connected, is low ground, and no flood precaution in place
                    (and 
                        (flooded ?g)    ; ground segment gets the flooded condition
                    )
                )
            )

            (forall (?g - ground ?s - structure)    ; for every ground segment and structure
                (when (and (location ?s ?g) (flooded ?g))   ; structure is on ground segment, and ground is flooded
                    (and
                        (damaged ?s)    ; structure gets the damaged condition
                    )
                )
            )
        )
    )
    
)