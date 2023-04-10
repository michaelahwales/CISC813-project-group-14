# CISC813-project-group-14
CISC813 Automated Planning project. Winter 2023.
Group 14 - Evelyn Yach and Michaelah Wales

This planner generates a short narrative about daily activities in 
the medieval village populated in the problem file.

The goal in the problem file can be set to include any of the following events:

        (floodingEvent)           
        (preventedFloodingEvent)    
        (dredgeEvent)     
        (embankEvent)      
        (breakfastEvent)   
        (lunchEvent)        
        (dinnerEvent)    
        (workEvent)           
        (tendAnimalEvent)  
        (playEvent)    
        (repairEvent)            

and uses partial order planning forwards (POPF) planning to schedule
actions in the village to trigger the requested events in a logical order
for the entities and locations set up in the village problem


Domain: 
Actions:
- dredgingScene
- embankingScene
- breakfastScene
- lunchScene
- dinnerScene
- workScene
- tendAnimalScene
- playScene
- repairScene
- move-animal
- move-person
- floodingScene
- recedingFloodScene
- preventedFloodingScene___it_rains_hard_for_awhile

Problem:
- 8 by 8 map grid
- two adult villagers
- buildings
- farms
- animals