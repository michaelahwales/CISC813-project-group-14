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
        ; -- General --
        (location ?x - locatable ?y - mapseg) ; location of an entity or structure
        (adj ?x1 ?x2 - mapseg)                ; adjacency relationship for map segments

        ; -- Conditions --
        ; map segment conditions
        (embankment ?x - riverseg) ; has a river segment been embanked?
        (dredge ?x - riverseg)     ; has a river segment been dredged?
        (lowground ?x - landseg)         ; is a land segment lowground? Decides whether it can be flooded or not
        ;(flooded ?x - mapseg)            ; is a map segment flooded?
        (damaged ?x - structure)   ; is a structure damaged?
        (tired ?x - person)    ; is a person tired? (people become tired from doing things)             
        (tended ?x - animal)      ; are my crops watered and my sheep tended?          

        ; -- Scenes -- 
        ; scene fluents to specify scenario goals, which would be decided by what requirements are in the curriculum
        ;(floodingEvent)           ; does a flooding event occur in this scenario?
        (dredgeEvent)       ; does a dredge event occur in this scenario? 
        (embankEvent)       ; does a embankment event occur in this scenario?
        (breakfastEvent)    ; does a breakfast event occur in this scenario?
        (lunchEvent)        ; does a lunch event occur in this scenario?
        (dinnerEvent)       ; does a dinner event occur in this scenario?
        (workEvent)             ; does a work event occur in this scenario?
        (tendAnimalEvent)       ; does a tending animal event occur in this scenario?
    )
    
    (:functions)

    ; Action Scenes - actions that represents different components of the curriculum that can be 
    ;                 combined to form a narrative
    
    ; have an adult dredge a river segment to prevent it from flooding
    (:action dredgingScene
        :parameters (?a - adult  ?r - riverseg) 
    
      :precondition (and
            (not (dredgeEvent))         ; this event hasn't already occured in the scene
            (not (dredge ?r))           ; river must not have been dredged already
            (not (embankment ?r))       ; river is not already embanked
            (location ?a ?r)            ; adult must be at the location 
        )

        :effect (and
            (dredge ?r)                 ; river is dredged
            (dredgeEvent)               ; a dredging event has occured
        )
    )
    
    ; have an adult embank a river segment to prevent it from flooding
    (:action embankingScene
        :parameters (?a - adult  ?r - riverseg)

        :precondition (and 
            (not (embankEvent))         ; this event hasn't already occured in the scene
            (not (dredge ?r))           ; river must not have been dredged already
            (not (embankment ?r))       ; river is not already embanked
            (location ?a ?r)            ; adult must be at the location 
        )

        :effect (and 
            (embankment ?r)             ; river is embanked
            (embankEvent)               ; an embanking event has occured
        )
    
    )

    ; have a breakfast scene to remove the tired condition from a person
    (:action breakfastScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and
            ; make sure the person and the building are both on the same land segment
            (location ?p ?l)
            (location ?h ?l)    ; assume if entity on same tile as building, they may use it
            
            (not(breakfastEvent))   ; a breakfast has not yet occured
            (not(lunchEvent))       ; a lunch has not yet occured
            (not(dinnerEvent))      ; a dinner has not yet occured
            (not(damaged ?h))       ; can't eat in a damaged building
        )
        :effect (and 
            (breakfastEvent)        ; there has now been a breakfast event
            (not (tired ?p))        ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)
        )
    )
    
    ; have a lunch scene to remove the tired condition from a person
    (:action lunchScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and 
            ; make sure the person and the building are both on the same land segment
            (location ?p ?l)
            (location ?h ?l)    ; assume if entity on same tile as building, they may use it

            (breakfastEvent)    ; lunch must occur after breakfast...
            (not(lunchEvent))
            (not(dinnerEvent))  ;                          ... but before dinner

            (not(damaged ?h))   ; can't eat in a damaged building
        )
        :effect (and 
            (lunchEvent)        ; there has now been a lunch event
            (not (tired ?p))    ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)
        )
    )
    
    ; have a dinner scene to remove the tired condition from a person 
    (:action dinnerScene
        :parameters (?l - landseg ?p - person ?h - building)
        :precondition (and
            ; make sure the person and the building are both on the same land segment
            (location ?p ?l)
            (location ?h ?l)    ; assume if entity on same tile as building, they may use it

            (breakfastEvent)    ; can't have dinner before breakfast or lunch!
            (lunchEvent)
            (not(dinnerEvent))
            
            (not(damaged ?h))   ; can't eat in a damaged building  
        )
        :effect (and 
            (dinnerEvent)       ; there has now been a dinner event
            (not (tired ?p))    ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)
        )
    )

    ; execute a work scene which will make an adult tired
    (:action workScene
        :parameters (?l - landseg ?a - adult ?f - farm)
        :precondition (and 
            ; make sure the adult and the farm are both on the same land segment
            (location ?f ?l)
            (location ?a ?l)    ; assume if entity on same tile as the farm, they may use it

            (not(damaged ?f))   ; farm is not damaged
            (not(tired ?a))     ; adult is not tired
        )
        :effect (and 
            (tired ?a)          ; adult is now tired
            (workEvent)         ; work scene has now occured
        )
    )

    ; execute a animal tending scene where an adult becomes tired, but an animal is tended to
    (:action tendAnimalScene
        :parameters (?mal - animal ?a - adult ?l - landseg ?f - farm)
        :precondition (and 
            ; make sure the adult, animal and farm are all on the same land segment
            (location ?a ?l)
            (location ?mal ?l)
            (location ?f ?l)    ; assume if entity on same tile as the farm, they may use it

            (not(tended ?mal))  ; animal has not already been tended to
            (not(tired ?a))     ; adult is not tired
        )
        :effect (and
            (tendAnimalEvent)   ; tending to animal event has now occured
            (tended ?mal)       ; animal has now been tended to
            (tired ?a)          ; adult is now tired
        )
    )
    

    ; General Actions - for inbetween scene actions

    ; move an animal between map segments, requires an adult person to move them
    (:action move-animal
        :parameters (?a - adult ?mal - animal ?l1 ?l2 - mapseg)
        :precondition (and
            ; make sure animal and adult are on the same tile
            (location ?a ?l1) 
            (location ?mal ?l1)

            (adj ?l1 ?l2)       ; new tile is connected to the old tile

            ; check for flooding later (can't move to a flooded segment)
        )
        :effect (and
            ; move both adult and animal to the new tile 
            (location ?a ?l2)
            (location ?mal ?l2)
            ; no longer at old tile
            (not(location ?a ?l1))
            (not(location ?mal ?l1))
        )
    )
    
    ; move person between map segments
    (:action move-person
        :parameters (?p - person ?l1 ?l2 - mapseg)
        :precondition (and
            (location ?p ?l1)       ; person is on the old segment 
            (adj ?l1 ?l2)           ; old segment is connected to new segemnt
            
            ; check for flooding later (can't move to a flooded segment)
        )
        :effect (and 
            (location ?p ?l2)           ; person is now on the new segment
            (not (location ?p ?l1))     ; person is no longer on old segment
        )
    )

    ; repair a damaged farm or building! reuqires an adult!
    (:action repair-structure
        :parameters (?a - adult ?s - structure ?l - landseg)
        :precondition (and 
            ; make sure adult and strucutre are on the same tile
            (location ?a ?l)
            (location ?s ?l)    ; assume if entity on same tile as the structure, they can repair it 

            (damaged ?s)        ; structure is damaged
            (not(tired ?a))     ; adult is not tired
        )
        :effect (and 
            (not (damaged ?s))  ; structure is no longer damaged
            (tired ?a)          ; adult is now tired
        )
    )
    

    ; COMING SOON TO A DOMAIN NEAR YOU

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

    ; (:action recedingfloodScene()
    ;     :parameters ()
    ;     :precondition (and )
    ;     :effect (and )
    ; )
      
)