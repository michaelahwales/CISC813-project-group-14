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
        :universal-preconditions
    )

    (:types
        mapseg locatable - object
        riverseg landseg lowgroundseg - mapseg
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
        (not-embanked ?x - riverseg) ; has a river segment been embanked?
        (not-dredged ?x - riverseg)     ; has a river segment been dredged?
        (lowground ?x - mapseg)         ; is a land segment lowground? Decides whether it can be flooded or not
        (not-flooded ?x - mapseg)            ; is a map segment flooded?
        (damaged ?x - structure)           ; confirms damaged structure - how we apply flood damage will impact the repair action
        (not-damaged ?x - structure)   ; is a structure damaged? 
        (not-tended ?x - animal)      ; are my crops watered and my sheep tended?      
        (not-just-flooded)    

        ; -- Scenes -- 
        ; scene fluents to specify scenario goals, which would be decided by what requirements are in the curriculum
        (floodingEvent)           ; does a flooding event occur in this scenario?
        (preventedFloodingEvent)    ; is a flood successfully prevented in this scenario?
        (dredgeEvent)       ; does a dredge event occur in this scenario? 
        (embankEvent)       ; does a embankment event occur in this scenario?
        (breakfastEvent)    ; does a breakfast event occur in this scenario?
        (lunchEvent)        ; does a lunch event occur in this scenario?
        (dinnerEvent)       ; does a dinner event occur in this scenario?
        (workEvent)             ; does a work event occur in this scenario?
        (tendAnimalEvent)       ; does a tending animal event occur in this scenario?
        (playEvent)
        

        ; -- Time --
        (not-busy ?x - person) ; make sure person is not doing another activity
        (not-moving ?x - entity)
        (not-tired ?x - person)    ; is a person tired? (people become tired from doing things) 
        ;(not-moving-animal ?x - adult) ; a relic from ancient times
        
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
        (move-animal-duration)

        (work-count ?a - adult)
        (work-max)

        (move-duration)

        (work-duration)

        (total-flood-struct)
        (dredge-duration)
        (embank-duration)

        (flood-duration)
        (reced-duration)

        ;(event-duration ?l - length)
        ;(meal-count ?e - event)      ; meals consumed so far in this narrative - maybe switch to event-count?
    
    )

    ; Action Scenes - actions that represents different components of the curriculum that can be 
    ;                 combined to form a narrative

    ; DURATIVE - have an adult dredge a river segment to prevent it from flooding
    (:durative-action dredgingScene
        :parameters (?r - riverseg ?a - adult)
        :duration (= ?duration (dredge-duration))
        :condition (and
            ; make sure an adult person is on a river segment
            (over all (location ?a ?r))

            (at start (not-dredged ?r))     ; river segment hasn't already been dredged
            (at start (not-embanked ?r))     ; river segment hasn't already been embanked

            (at start (not-busy ?a))        ; not already busy

            (at start (not-tired ?a))       ; not already tired

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (work-count ?a) (work-max)))    ; adult has not done more than the work limit
            
        )
        :effect (and 
            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))             ; no longer busy

            (at end (dredgeEvent))             ; there has now been a dredge scene

            (at start (not (not-dredged ?r)))    ; river segment now dredged (have to do at start or multiple people will try dredging the same thing lol)
            (at end (not (not-tired ?a)))      ; adult now tired

            (at end (increase (total-flood-struct) 1))        ; increase number of flood structures
            (at end (increase (current-time) (dredge-duration)))
            (at end (increase (work-count ?a) 1))  
        )
    )

    ; DURATIVE - have an adult embank a river segment to prevent it from flooding
    (:durative-action embankingScene
        :parameters (?r - riverseg ?a - adult)
        :duration (= ?duration (embank-duration))
        :condition (and
            ; make sure an adult person is on a river segment
            (over all (location ?a ?r))

            (at start (not-embanked ?r))     ; river segment hasn't already been embanked
            (at start (not-dredged ?r))     ; river segment hasn't already been dredged

            (at start (not-busy ?a))        ; not already busy

            (at start (not-tired ?a))       ; not already tired

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (work-count ?a) (work-max)))    ; adult has not done more than the work limit
            
        )
        :effect (and 
            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))             ; no longer busy

            (at end (embankEvent))             ; there has now been a dredge scene

            (at start (not (not-embanked ?r)))    ; river segment now embanked (have to do at start or multiple people will try embanked the same thing lol)
            (at end (not (not-tired ?a)))      ; adult now tired

            (at end (increase (total-flood-struct) 1))        ; increase number of flood structures
            (at end (increase (current-time) (embank-duration)))
            (at end (increase (work-count ?a) 1))  
        )
    )  

    ; DURATIVE - have a breakfast scene to remove the tired condition from a person
    (:durative-action breakfastScene
        :parameters (?l - landseg ?p - person ?h - building)
        :duration (= ?duration (meal-duration))
        :condition (and
            ; make sure the person and the building are both on the same land segment
            (over all (location ?p ?l))
            (over all (location ?h ?l))                 ; assume if entity on same tile as building, they may use it

            (at start (not-busy ?p))                    ; not already busy

            (at start (= (meal-count-breakfast ?p) 0))  ; a breakfast has not yet occured     
            (at start (= (meal-count-lunch ?p) 0))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-breakfast ?p) (meal-max)))
        )
        :effect (and 
            (at start (not (not-busy ?p)))     ; become busy
            (at end (not-busy ?p))           ; no longer busy

            (at end (breakfastEvent))        ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)

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

            (at start (not-busy ?p))                    ; not already busy

            (at start (= (meal-count-breakfast ?p) 1))  ; a breakfast has occured 
            (at start (= (meal-count-lunch ?p) 0))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-lunch ?p) (meal-max)))
        )
        :effect (and 
            (at start (not (not-busy ?p)))     ; become busy
            (at end (not-busy ?p))           ; no longer busy

            (at end (lunchEvent))            ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)
            
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

            (at start (not-busy ?p))                    ; not already busy

            (at start (= (meal-count-breakfast ?p) 1))  ; a breakfast has not yet occured
            (at start (= (meal-count-lunch ?p) 1))      ; a lunch has not yet occured
            (at start (= (meal-count-dinner ?p) 0))     ; a dinner has not yet occured
            (over all (not-damaged ?h))                 ; can't eat in a damaged building
            (over all (owns ?p ?h))                     ; person lives in this building

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (meal-count-dinner ?p) (meal-max)))
        )
        :effect (and 
            (at start (not (not-busy ?p)))     ; become busy
            (at end (not-busy ?p))           ; no longer busy

            (at end (dinnerEvent))           ; there has now been a breakfast event
            (at end (not-tired ?p))          ; person is no longer tired (perhaps change this to apply for everyone on the tile? group meal!)

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
            (over all (not-flooded ?l))
            (over all (not-damaged ?f))

            (at start (not-busy ?a))       ; not already busy
            
            (at start (not-tired ?a))     ; adult is not tired
            (over all (owns ?a ?f))       ; person owns this farm

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (work-count ?a) (work-max)))    ; adult has not done more than the work limit
        )
        :effect (and 
            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))           ; no longer busy

            (at end (not (not-tired ?a)))  ; adult is now tired
            (at end (workEvent))           ; work scene has now occured

            (at end (increase (current-time) (work-duration)))
            (at end (increase (work-count ?a) 1))
        )
    )

    ;DURATIVE - execute a animal tending scene where an adult becomes tired, but an animal is tended to
    (:durative-action tendAnimalScene
        :parameters (?mal - animal ?a - adult ?l - landseg ?f - farm)
        :duration (= ?duration (work-duration))
        :condition (and 
            ; make sure the adult, animal and farm are all on the same land segment
            (over all (location ?a ?l))
            (over all (location ?mal ?l))
            (over all (location ?f ?l))    ; assume if entity on same tile as the farm, they may use it
            (over all (not-flooded ?l))
            ;(over all (not-damaged ?f))

            (at start (not-tended ?mal))  ; animal has not already been tended to
            (at start (not-tired ?a))     ; adult is not tired

            (at start (not-busy ?a))       ; not already busy

            (at start (not-moving ?a))      ; adult is not moving
            (at start (not-moving ?mal))    ; animal is not moving

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
            (at start (<= (tend-animal-count ?a) (work-max)))   ; can only tend animals as many times as the work limit will allow
        )
        :effect (and
            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))           ; no longer busy

            (at end (tendAnimalEvent))   ; tending to animal event has now occured

            (at end (not (not-tended ?mal)))       ; animal has now been tended to
            (at end (not (not-tired ?a)))          ; adult is now tired

            (at end (increase (work-count ?a) 1)) 
            (at end (increase (current-time) (work-duration)))
        )
    )

    ;DURATIVE - children can play together!
    (:durative-action playScene
        :parameters (?c1 ?c2 - child ?l - landseg)
        :duration (= ?duration (work-duration))
        :condition (and
            (over all (location ?c1 ?l))     ; person is on the old segment
            (over all (location ?c2 ?l))     ; person is on the old segment
            (over all (not-flooded ?l))

            (at start (not-busy ?c1))
            (at start (not-busy ?c2))
            (at start (not-tired ?c1))
            (at start (not-tired ?c2))
            (at start (not-moving ?c1))       ; person is not already moving
            (at start (not-moving ?c2))

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
        )
        :effect (and 
            (at end (playEvent))

            (at start (not (not-busy ?c1)))     ; become busy
            (at end (not-busy ?c1))           ; no longer busy
            (at start (not (not-busy ?c2)))     ; become busy
            (at end (not-busy ?c2))           ; no longer busy

            (at start (not (not-moving ?c1)))   ; person begins moving
            (at end (not-moving ?c1))           ; person finishes moving
            (at start (not (not-moving ?c2)))   ; person begins moving
            (at end (not-moving ?c2))           ; person finishes moving

            (at end (not (not-tired ?c1)))      ; all tuckered out
            (at end (not (not-tired ?c2)))

            (at end (increase (current-time) (work-duration)))
        )
    )
    
    

    ; ; General Actions - for inbetween scene actions

    ; DURATIVE - move an animal between map segments, requires an adult person to move them
    (:durative-action move-animal
        :parameters (?a - adult ?mal - animal ?l1 ?l2 - mapseg)
        :duration (= ?duration (move-animal-duration))
        :condition (and
            ; make sure animal and adult are on the same tile
            (over all(location ?a ?l1))
            (over all (location ?mal ?l1))
            (over all (adj ?l1 ?l2))       ; new tile is connected to the old tile
            (over all (not-flooded ?l2))

            (at start (not-busy ?a))       ; not busy doing something else

            (at start (not-moving ?a))     ; not already moving in general
            (at start (not-moving ?mal))   ; animal is not already being moved

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            ; check for flooding later (can't move to a flooded segment)
            (at start (<= (current-time) (max-time)))
        )
        :effect (and
            (at start (not (not-moving ?a)))      ; begin moving the person
            (at start (not (not-moving ?mal)))    ; begin moving the animal

            (at end (not-moving ?a))     ; person finished moving
            (at end (not-moving ?mal))   ; animal finished moving

            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))           ; no longer busy

            ; move both adult and animal to the new tile 
            (at end (location ?a ?l2))
            (at end (location ?mal ?l2))
            ; no longer at old tile
            (at end (not(location ?a ?l1)))
            (at end (not(location ?mal ?l1)))

            (at end (increase (current-time) (move-animal-duration)))
        )
    )

    ; DURATIVE - move person between map segments
    (:durative-action move-person
        :parameters (?p - person ?l1 ?l2 - mapseg)
        :duration (= ?duration (move-duration))
        :condition (and
            (at start (location ?p ?l1))     ; person is on the old segment 
            (over all (adj ?l1 ?l2))         ; old segment is connected to new segment
            (over all (not-flooded ?l2))

            (at start (not-busy ?p))
            (at start (not-moving ?p))       ; person is not already moving

            (over all (not-just-flooded))   ; receding action hasn't occured yet

            (at start (<= (current-time) (max-time)))
        )
        :effect (and 
            (at start (not (not-busy ?p)))     ; become busy
            (at end (not-busy ?p))           ; no longer busy

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
            (over all (not-flooded ?l))

            (at start (damaged ?s))       ; structure is damaged
            (at start (not-tired ?a))     ; adult is not tired

            (at start (not-busy ?a))   ; adult is not already working

            (over all (not-just-flooded))   ; receding action hasn't occured yet
 
            (at start (<= (repair-count ?a) (repair-max))) ; this person has not completed more the max repairs today
            (at start (<= (current-time) (max-time)))
        )
        :effect (and 
            (at start (not (not-busy ?a)))     ; become busy
            (at end (not-busy ?a))             ; no longer busy

            (at end (not-damaged ?s))        ; structure is now not-damaged
            (at end (not (damaged ?s)))      ; and no longer damaged  - doubled up, to get around no negative preconditions
            (at end (not (not-tired ?a)))    ; adult is now tired

            (at end (increase (current-time) (repair-duration)))
            (at end (increase (repair-count ?a) 1))   ; one repair job completed
        )
    )
    

    ; NOW IN A DOMAIN NEAR YOU

    ; DURATIVE - salt the earth! a flooding event occurs which stunts just about everything
    (:durative-action floodingScene
        :parameters ()
        :duration (= ?duration flood-duration)
        :condition (and 
            (at start (< (total-flood-struct) 3))   ; number of flood structures is not enough to prevent the flood (<3)
            (at start (<= (current-time) (max-time)))
        )
        :effect (and 

            (at start (floodingEvent))
            (at end (not (not-just-flooded)))   ; receding action trigger next

            (forall (?t - landseg) (at start (not (not-flooded ?t))))
            (forall (?r - riverseg) (and
                (at end (not-embanked ?r))
                (at end (not-dredged ?r))
            ))
            (forall (?s - structure) (and
                (at start (damaged ?s))
                (at start (not (not-damaged ?s)))
            ))
            (forall (?p - person) (at start (not (not-tired ?p))))
            (forall (?a - animal)  (at end (not (not-tended ?a))))

            (at end (increase (current-time) (flood-duration)))
        )
    )
    ; note: would have liked to make this more complicated however due to conditionals not being compatible with temporal
    ;       planners we present a simplified version that's all or nothing

    ; DURATIVE - the flood waters recede
    (:durative-action recedingfloodScene
        :parameters ()
        :duration (= ?duration reced-duration)
        :condition (and
            (at start (floodingEvent))
            (at start (<= (current-time) (max-time)))
        )
        :effect (and
            (at start (not-just-flooded))   ; receding action occcurs

            (forall (?t - landseg) (at start (not-flooded ?t)))

            (at end (increase (current-time) (reced-duration)))
        )
    )

    ; DURATIVE - Oh no a flood! but look! you prevented it!
    (:durative-action preventedFloodingScene___it_rains_hard_for_awhile
        :parameters ()
        :duration (= ?duration flood-duration)
        :condition (and
            (at start (>= (total-flood-struct) 3))   ; number of flood structures is enough to prevent the flood (>=3)
            (at start (<= (current-time) (max-time)))
        )
        :effect (and 

            (at start (preventedFloodingEvent))
            (at end (increase (current-time) (flood-duration)))
        )
    )
      
)