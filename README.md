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

All of these events are available in the problem_1 and problem_2 problem files,
any event which the user would like to occur in the output plan can be uncommented
for use.       

The planner partial order planning forwards (POPF) planning to schedule
actions in the village to trigger the requested events in a logical order
for the entities and locations set up in the village problem file.


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

Problem: (run the planner with the problem file of your choice)
- problem_1 (popf -T domain.pddl problem_1.pddl)
- problem_2 (popf -T domain.pddl problem_2.pddl)


Helper Functions:

entity_maker.py
    Generate the inital fluents for individual entities and structures in the
    problem file. User follows onscreen prompts to fill out the initalization
    and then can copy the output to a problem file.

make_grid.py
    Generate a connected grid for the specified size (default 8x8), with 
    connection relations which can be copied to the problem file.



