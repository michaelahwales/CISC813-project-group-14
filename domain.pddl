(define (domain northeye)

    ;(:requirements :typing :strips :conditional-effects :quantified-preconditions :disjunctive-preconditions :negative-preconditions)
    (:requirements
        :durative-actions
        :timed-initial-literals
        :typing
        :strips
        :conditional-effects
        :quantified-preconditions
        ;:negative-preconditions
        :disjunctive-preconditions
        :duration-inequalities
        :equality
        :fluents
    )

    (:types
        mapseg locatable - object
        riverseg landseg - mapseg
        structure entity - locatable
        building farm - structure
        animal person - entity
        cow dog pig sheep - animal
        adult child - person

        event
        length
    )
    
    (:predicates
        ; -- General --
        (location ?x - locatable ?y - mapseg) ; location of an entity or structure
        (adj ?x1 ?x2 - mapseg)                ; adjacency relationship for map segments
        (owns ?x - person ?y - structure)         ; ownership for structures

        ; -- Conditions --
        ; map segment conditions
        (embankment ?x - riverseg) ; has a river segment been embanked?
        (dredge ?x - riverseg)     ; has a river segment been dredged?
        (lowground ?x - landseg)         ; is a land segment lowground? Decides whether it can be flooded or not
        ;(flooded ?x - mapseg)            ; is a map segment flooded?
        (damaged ?x - structure)           ; confirms damaged structure - how we apply flood damage will impact the repair action
        (not-damaged ?x - structure)   ; is a structure damaged?
        (not-tired ?x - person)    ; is a person tired? (people become tired from doing things)             
        (not-tended ?x - animal)      ; are my crops watered and my sheep tended?          

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


        ; -- Time --
        (not-eating)
        (not-working ?x - adult)
        (not-busy ?x - person) ; make sure person is not doing another activity
        ;(not-moving-animal ?x - adult) ; a relic from ancient times
        (not-moving ?x - entity)
    )
    
    (:functions

        ; -- 
        ;(scenario-length) ; the length of the finished scenario 
        (max-time) ; the maximum length a narrative (set of scenes) is allowed to be 

        (current-time)  ; how long the story has taken so far

        ; -- Event Timings --
        (meal-duration)   ; how long it takes to sit down to a meal 
        (meal-count-breakfast ?p - person)
        (meal-count-lunch ?p - person)
        (meal-count-dinner ?p - person)
        (meal-max)  ; maximum number of meals that may be consumed in a day

        (repair-duration)     ; replace this with one work duration for work actions?
        (repair-count ?a - adult)
        (repair-max)

        (tend-animal-count ?a - adult)

        (work-count ?a - adult)
        (work-max)

        (move-duration)

        (work-duration)

        ;(event-duration ?l - length)
        ;(meal-count ?e - event)      ; meals consumed so far in this narrative - maybe switch to event-count?
    
    )

    ; Action Scenes - actions that represents different components of the curriculum that can be 
    ;                 combined to form a narrative
    
    ; ; have an adult dredge a river segment to prevent it from flooding
    ; (:action dredgingScene
    ;     :parameters (?a - adult  ?r - riverseg) 
    
    ;   :precondition (and
    ;         (not (dredgeEvent))         ; this event hasn't already occured in the scene
    ;         (not (dredge ?r))           ; river must not have been dredged already
    ;         (not (embankment ?r))       ; river is not already embanked
    ;         (location ?a ?r)            ; adult must be at the location 
    ;     )

    ;     :effect (and
    ;         (dredge ?r)                 ; river is dredged
    ;         (dredgeEvent)               ; a dredging event has occured
    ;     )
    ; )
    
    ; ; have an adult embank a river segment to prevent it from flooding
    ; (:action embankingScene
    ;     :parameters (?a - adult  ?r - riverseg)

    ;     :precondition (and 
    ;         (not (embankEvent))         ; this event hasn't already occured in the scene
    ;         (not (dredge ?r))           ; river must not have been dredged already
    ;         (not (embankment ?r))       ; river is not already embanked
    ;         (location ?a ?r)            ; adult must be at the location 
    ;     )

    ;     :effect (and 
    ;         (embankment ?r)             ; river is embanked
    ;         (embankEvent)               ; an embanking event has occured
    ;     )
    
    ; )

    ; DURATIVE - have a breakfast scene to remove the tired condition from a person
    (:durative-action breakfastScene
        :parameters (?l - landseg ?p - person ?h - building)
        :duration (= ?duration (meal-duration))
        :condition (and
            ; make sure the person and the building are both on the same land segment
            (over all (location ?p ?l))
            (over all (location ?h ?l))                 ; assume if entity on same tile as building, they may use it
            (at start (not-eating))                     ; not already eating a meal
            (at start (= (meal-count-breakfast ?p) 0))  ; a breakfast has not yet occured     
            (at start (= (meal-count-lunch ?p) 0))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-breakfast ?p) (meal-max)))
        )
        :effect (and 
            (at start (not(not-eating)))     ; begin eating
            (at end (breakfastEvent))        ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)

            (at end (not-eating))            ; no longer eating
            (at end (increase (current-time) (meal-duration)))
            (at end (increase (meal-count-breakfast ?p) 1))  
        )
    )  

    ; DURATIVE - have a lunch scene to remove the tired condition from a person
    (:durative-action lunchScene
        :parameters (?l - landseg ?p - person ?h - building)
        :duration (= ?duration (meal-duration))
        :condition (and
            ; make sure the person and the building are both on the same land segment
            (over all (location ?p ?l))
            (over all (location ?h ?l))                 ; assume if entity on same tile as building, they may use it
            (at start (not-eating))                     ; not already eating a meal
            (at start (= (meal-count-breakfast ?p) 1))  ; a breakfast has occured 
            (at start (= (meal-count-lunch ?p) 0))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-lunch ?p) (meal-max)))
        )
        :effect (and 
            (at start (not(not-eating)))     ; begin eating
            (at end (lunchEvent))            ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)

            (at end (not-eating))            ; no longer eating
            (at end (increase (current-time) (meal-duration)))
            (at end (increase (meal-count-lunch ?p) 1))  
        )
    ) 

    ; DURATIVE - have a dinner scene to remove the tired condition from a person
    (:durative-action dinnerScene
        :parameters (?l - landseg ?p - person ?h - building)
        :duration (= ?duration (meal-duration))
        :condition (and
            ; make sure the person and the building are both on the same land segment
            (over all (location ?p ?l))
            (over all (location ?h ?l))                 ; assume if entity on same tile as building, they may use it
            (at start (not-eating))                     ; not already eating a meal
            (at start (= (meal-count-breakfast ?p) 1))  ; a breakfast has not yet occured
            (at start (= (meal-count-lunch ?p) 1))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-dinner ?p) (meal-max)))
        )
        :effect (and 
            (at start (not(not-eating)))     ; begin eating
            (at end (dinnerEvent))           ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)

            (at end (not-eating))            ; no longer eating
            (at end (increase (current-time) (meal-duration)))
            (at end (increase (meal-count-dinner ?p) 1))  
        )
    ) 

    ; execute a work scene which will make an adult tired
    (:durative-action workScene
        :parameters (?l - landseg ?a - adult ?f - farm)
        :duration (= ?duration (work-duration))
        :condition (and 
            ; make sure the adult and the farm are both on the same land segment
            (over all (location ?f ?l))
            (over all (location ?a ?l))    ; assume if entity on same tile as the farm, they may use it

            (at start (not-damaged ?f))   ; farm is not damaged
            (at start (not-tired ?a))     ; adult is not tired
            (over all (owns ?a ?f))       ; person owns this farm

            (at start (not-working ?a))  
            (at start (<= (current-time) (max-time)))
            (at start (<= (work-count ?a) (work-max)))    ; adult has not done more than the work limit
        )
        :effect (and 
            (at start (not (not-working ?a)))  ; start working
            (at end (not-working ?a))          ; finish working

            (at end (not (not-tired ?a)))  ; adult is now tired
            (at end (workEvent))           ; work scene has now occured

            (at end (increase (current-time) (work-duration)))
            (at end (increase (work-count ?a) 1))

        )
    )

    ; ; execute a animal tending scene where an adult becomes tired, but an animal is tended to
    ; (:action tendAnimalScene
    ;     :parameters (?mal - animal ?a - adult ?l - landseg ?f - farm)
    ;     :precondition (and 
    ;         ; make sure the adult, animal and farm are all on the same land segment
    ;         (location ?a ?l)
    ;         (location ?mal ?l)
    ;         (location ?f ?l)    ; assume if entity on same tile as the farm, they may use it

    ;         (not(tended ?mal))  ; animal has not already been tended to
    ;         (not(tired ?a))     ; adult is not tired
    ;         (owns ?a ?f)        ; person owns this farm
    ;     )
    ;     :effect (and
    ;         (tendAnimalEvent)   ; tending to animal event has now occured
    ;         (tended ?mal)       ; animal has now been tended to
    ;         (tired ?a)          ; adult is now tired
    ;     )
    ; )

    ; DURATIVE - INCOMPLETE - execute a animal tending scene where an adult becomes tired, but an animal is tended to
    ; (:durative-action tendAnimalScene
    ;     :parameters (?mal - animal ?a - adult ?l - landseg ?f - farm)
    ;     :duration (= ?duration (work-duration))
    ;     :condition (and 
    ;         ; make sure the adult, animal and farm are all on the same land segment
    ;         (over all (location ?a ?l))
    ;         (over all (location ?mal ?l))
    ;         (over all (location ?f ?l))    ; assume if entity on same tile as the farm, they may use it

    ;         (at start (not-tended ?mal))  ; animal has not already been tended to
    ;         (at start (not-tired ?a))     ; adult is not tired
    ;         ;(over all (owns ?a ?f))       ; person owns this farm  - person owns, not adult

    ;         (at start (not-working ?a))   ; adult is not already working

            

    ;         (at start (<= (current-time) (max-time)))
    ;         (at start (<= (work-count ?a) (work-max)))    ; adult has not done more than the work limit
    ;         ;(at start (<= (tend-animal-count ?a) (work-max)))   ; can only tend animals as many times as the work limit will allow
    ;     )
    ;     :effect (and

    ;         (at start (not (not-working ?a))) ; begin working
    ;         (at end (not-working ?a))         ; finish working

    ;         ;(at end (tendAnimalEvent))   ; tending to animal event has now occured
    ;         (at end (workEvent))    ; a work event has occured
    ;         (at end (not (not-tended ?mal)))       ; animal has now been tended to
    ;         (at end (not (not-tired ?a)))          ; adult is now tired

    ;         (at end (increase (current-time) (work-duration)))
    ;         (at end (increase (work-count ?a) 1)) 
    ;         ;(at end (increase (tend-animal-count ?a) 1))
    ;     )
    ; )
    

    ; ; General Actions - for inbetween scene actions

    ; ; move an animal between map segments, requires an adult person to move them
    ; (:action move-animal
    ;     :parameters (?a - adult ?mal - animal ?l1 ?l2 - mapseg)
    ;     :precondition (and
    ;         ; make sure animal and adult are on the same tile
    ;         (location ?a ?l1) 
    ;         (location ?mal ?l1)

    ;         (adj ?l1 ?l2)       ; new tile is connected to the old tile

    ;         ; check for flooding later (can't move to a flooded segment)
    ;     )
    ;     :effect (and
    ;         ; move both adult and animal to the new tile 
    ;         (location ?a ?l2)
    ;         (location ?mal ?l2)
    ;         ; no longer at old tile
    ;         (not(location ?a ?l1))
    ;         (not(location ?mal ?l1))
    ;     )
    ; )

    ; DURATIVE - move an animal between map segments, requires an adult person to move them
    (:durative-action move-animal
        :parameters (?a - adult ?mal - animal ?l1 ?l2 - mapseg)
        :duration (= ?duration (move-duration))
        :condition (and
            ; make sure animal and adult are on the same tile
            (at start (location ?a ?l1))
            (at start (location ?mal ?l1))

            (over all (adj ?l1 ?l2))       ; new tile is connected to the old tile

            ;(at start (not-busy ?a))       ; not busy doing something else
            ;(at start (not-moving-animal ?a)) ; not already moving an animal
            (at start (not-moving ?a))     ; not already moving in general
            (at start (not-moving ?mal))   ; animal is not already being moved

            ; check for flooding later (can't move to a flooded segment)
        )
        :effect (and
            ;(at start (not (not-moving-animal ?a))) ; begin moving the animal
            ;(at end (not-moving-animal ?a))         ; finish moving the animal

            (at start (not (not-moving ?a)))      ; begin moving the person
            (at start (not (not-moving ?mal)))    ; begin moving the animal

            (at end (not-moving ?a))     ; person finished moving
            (at end (not-moving ?mal))   ; animal finished moving

            ; move both adult and animal to the new tile 
            (at end (location ?a ?l2))
            (at end (location ?mal ?l2))
            ; no longer at old tile
            (at end (not(location ?a ?l1)))
            (at end (not(location ?mal ?l1)))

            (at end (increase (current-time) (move-duration)))
        )
    )

    ; DURATIVE - move person between map segments
    (:durative-action move-adult
        :parameters (?p - person ?l1 ?l2 - mapseg)
        :duration (= ?duration (move-duration))
        :condition (and
            (at start (location ?p ?l1))     ; person is on the old segment 
            (over all (adj ?l1 ?l2))         ; old segment is connected to new segment
            ;(over all (not-moving-animal ?a))  ; person is not moving with an animal
            (at start (not-moving ?p))

            (at start (<= (current-time) (max-time)))
            ; check for flooding later (can't move to a flooded segment)
        )
        :effect (and 
            (at start (not (not-moving ?p)))   ; person begins moving
            (at end (not-moving ?p))           ; person finishes moving
            (at end (location ?p ?l2))         ; person is now on the new segment
            (at end (not (location ?p ?l1)))   ; person is no longer on old segment

            (at end (increase (current-time) (move-duration)))
        )
    )

    ; DURATIVE - repair a damaged farm or building! requires an adult!
    (:durative-action repair-structure
        :parameters (?a - adult ?s - structure ?l - landseg)
        :duration (= ?duration (repair-duration))
        :condition (and 
            ; make sure adult and strucutre are on the same tile
            (over all (location ?a ?l))
            (over all (location ?s ?l))    ; assume if entity on same tile as the structure, they can repair it 

            (at start (damaged ?s))       ; structure is damaged
            (at start (not-tired ?a))     ; adult is not tired

            (at start (not-working ?a))   ; adult is not already working
 
            (at start (<= (repair-count ?a) (repair-max))) ; this person has not completed more the max repairs today

            (at start (<= (current-time) (max-time)))
        )
        :effect (and 
            (at start (not (not-working ?a)))  ; begin working
            
            (at end (not-working ?a))          ; finished working

            (at end (not-damaged ?s))  ; structure is not-damaged
            (at end (not (damaged ?s)))      ; structure is not (damaged)  - doubled up, pick one when flood damage is applied
            (at end (not (not-tired ?a)))    ; adult is now tired

            (at end (increase (current-time) (repair-duration)))
            (at end (increase (repair-count ?a) 1))   ; one repair job completed
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