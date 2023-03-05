(define (domain northeye)

    (:requirements :typing :strips :conditional-effects :quantified-preconditions :disjunctive-preconditions :negative-preconditions)

    (:types
        mapseg locatable - object
        riverseg landseg - mapseg
        structure entity - locatable
        building farm - structure
        animal person - entity
        cow dog pig sheep - animal
        adult child - person
    )
    
    (:predicates
        ; General
        (location ?x - locatable ?y - mapseg) ; location of an entity or structure
        (adj ?x1 ?x2 - mapseg)                ; adjacency relationship

        ; Conditions
        (embankment ?x - riverseg) ; is there an embankment on this river segment (area of land with a river structure)
        (dredge ?x - riverseg)     ; has this river segment been dredged already 
        (highground ?x - landseg) ; highground cannot be flooded
        (lowground ?x - landseg)  ; lowground can be flooded
        (flooded ?x - mapseg)    ; flood status of a map segment
        (damaged ?x - structure)    ; structure status
        (drowned ?x - entity)
        (tired ?x - person)
        (tended ?x - animal)


        ; Scene Fluents 
        (floodingEvent)        ; does a flooding event occur in this scenario?
        ; scene fluents to specify scenario goals...
        (dredgeEvent)
        (embankEvent)
        (breakfastEvent)
        (lunchEvent)
        (dinnerEvent)
        (workEvent)
        (tendAnimalEvent)
    )
    
    (:functions)
    
    (:action dredgingScene
        :parameters (?a - adult  ?r - riverseg) 
    
      :precondition (and
            (not (dredgeEvent)) ; this event hasn't already occured in the scene
            (not (dredge ?r)) ; river must not have been dredged already
            (not (embankment ?r)) ; river is not already embanked
            (location ?a ?r) ; adult must be at the location 
        )

        :effect (and
            (dredge ?r) ; river is dredged
            (dredgeEvent) ; a dredging event has occured
        )
    )
    
    (:action embankingScene
        :parameters (?a - adult  ?r - riverseg)

        :precondition (and 
            (not (embankEvent)) ; this event hasn't already occured in the scene
            (not (dredge ?r)) ; river must not have been dredged already
            (not (embankment ?r)) ; river is not already embanked
            (location ?a ?r) ; adult must be at the location 
        )

        :effect (and 
            (embankment ?r) ; river is embanked
            (embankEvent) ; an embanking event has occured
        )
    
    )

    ; (:action floodingScene
    ;     :parameters ()

    ;     :precondition (and
    ;         (not (floodingEvent))   ; scene hasn't happened
    ;     )

    ;     :effect (and
    ;         (floodingEvent)         ; scene has happened

    ;         (forall (?g - landseg ?r - riverseg)        ; for every ground and river segment
    ;             (when (and (adj ?g ?r) (lowground ?g) (not (and (embankment ?r) (dredge ?r))))  ; river and ground connected, is low ground, and no flood precaution in place
    ;                 (and 
    ;                     (flooded ?g)    ; ground segment gets the flooded condition
    ;                 )
    ;             )
    ;         )
    ;         ; finagling for river segments to flood ---------------
    ;         (forall (?g - landseg ?s - structure)    ; for every ground segment and structure
    ;             (when (and (location ?s ?g) (flooded ?g))   ; structure is on ground segment, and ground is flooded
    ;                 (and
    ;                     (damaged ?s)    ; structure gets the damaged condition
    ;                 )
    ;             )
    ;         )

    ;         (forall (?g - landseg ?e - entity)
    ;             (when (and (location ?e ?g) (flooded ?g))
    ;                 (and
    ;                     (drowned ?e)
    ;                 )
    ;             )
    ;         )
    ;     )
    ; )

    (:action breakfastScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and
            (location ?p ?l)
            (location ?h ?l)
            ; assume if entity on same tile as building, they may use it
            (not(breakfastEvent)) 
            (not(lunchEvent))
            (not(dinnerEvent))
            (not(damaged ?h))
        )
        :effect (and 
            (breakfastEvent)
            (not (tired ?p))
        )
    )
    
    (:action lunchScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and 
            (location ?p ?l)
            (location ?h ?l)
            ; assume if entity on same tile as building, they may use it
            (breakfastEvent)
            (not(lunchEvent))
            (not(dinnerEvent))
            (not(damaged ?h))
        )
        :effect (and 
            (lunchEvent)
            (not (tired ?p))
        )
    )
    
    (:action dinnerScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and
            (location ?p ?l)
            (location ?h ?l)
            ; assume if entity on same tile as building, they may use it
            (breakfastEvent)
            (lunchEvent)
            ; must have had breakfast and lunch before eating dinner
            (not(dinnerEvent))
            (not(damaged ?h))
        )
        :effect (and 
            (dinnerEvent)
            (not (tired ?p))
        )
    )

    (:action workScene
        :parameters (?l - landseg ?a - adult ?f - farm)
        :precondition (and 
            (location ?f ?l)
            (location ?a ?l)
            (not(damaged ?f))
            (not(tired ?a))
        )
        :effect (and 
            (tired ?a)
            (workEvent)
        )
    )

    (:action tendAnimalScene
        :parameters (?mal - animal ?a - adult ?l - landseg ?f - farm)
        :precondition (and 
            (location ?a ?l)
            (location ?mal ?l)
            (location ?f ?l)
            (not(tended ?mal))
            (not(tired ?a))
        )
        :effect (and
            (tendAnimalEvent)
            (tended ?mal)
            (tired ?a)
        )
    )
    
    (:action move-animal
        :parameters (?a - adult ?mal - animal ?l1 ?l2 - mapseg)
        :precondition (and 
            (location ?a ?l1)
            (location ?mal ?l1)
            (adj ?l1 ?l2)
        )
        :effect (and 
            (location ?a ?l2)
            (location ?mal ?l2)
            (not(location ?a ?l1))
            (not(location ?mal ?l1))
        )
    )
    

    (:action move-person
        :parameters (?p - person ?l1 ?l2 - mapseg)
        :precondition (and 
            (adj ?l1 ?l2)
            (location ?p ?l1)
            ; check for flooding later
        )
        :effect (and 
            (location ?p ?l2)
            (not (location ?p ?l1))
        )
    )

    (:action repair-structure
        :parameters (?a - adult ?s - structure ?l - landseg)
        :precondition (and 
            (location ?a ?l)
            (location ?s ?l)
            (damaged ?s)
            (not(tired ?a))
        )
        :effect (and 
            (not (damaged ?s))
            (tired ?a)
        )
    )
    


    
)