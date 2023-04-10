#
# Generate the inital fluents for entities and structures in the
# problem file. User follows onscreen prompts to fill out the initalization
# and then can copy the output.
#
# written by: evelyn yach
# last edited: 2023-04-08
#

done = False

# iterate through for multiple single entries
while done == False:

    print(" adult / child / animal / farm / building / church ")
    type = input("Select entity type (case-sensitive): ")

    if (type == "adult") | (type == "child"):
        # user input
        entity_name = input("Enter the entities name (case-sensitive): ")
        entity_coord = input("Enter the entities name (row,col): ")
        entity_home = input("Enter the entities home (case-sensitive): ")
        entity_farm = input("Enter the entities farm (case-sensitive): ")
        entity_church = input("Enter the entities local church (case-sensitive): ")
        print("")

        # starting comment
        print("; " + type + " - " + entity_name)
        
        # entity location
        print("(location " + entity_name + " g" + str(entity_coord) + ")")
        
        # entity inital statuses
        print("(not (not-tired " + entity_name + "))")
        print("(not-moving " + entity_name + ")")
        print("(not-busy " + entity_name + ")")
        print("(owns " + entity_name + " " + entity_home + ")")
        print("(owns " + entity_name + " " + entity_farm + ")")
        print("(owns " + entity_name + " " + entity_church + ")")

        print("(= (meal-count-breakfast " + entity_name + ") 0)")
        print("(= (meal-count-lunch " + entity_name + ") 0)")
        print("(= (meal-count-dinner " + entity_name + ") 0)")

        if (type == "adult"):
            print("(= (repair-count " + entity_name + ") 0)")
            print("(= (tend-animal-count " + entity_name + ") 0)")
            print("(= (work-count " + entity_name + ") 0)") 

    elif (type == "animal"):
        # user input
        entity_name = input("Enter the entities name (case-sensitive): ")
        entity_coord = input("Enter the entities name (row,col): ")
        print("")

        # starting comment
        print("; " + type + " - " + entity_name)

        # entity location
        print("(location " + entity_name + " g" + str(entity_coord) + ")")
        
        # entity inital statuses
        print("(not-moving " + entity_name + ")")
        print("(not-tended " + entity_name + ")")

    elif (type == "farm") | (type == "building") | (type == "church"):
        # user input
        struct_name = input("Enter the structures name (case-sensitive): ")
        struct_coord = input("Enter the structures location (row,col): ")
        print("")

        # starting comment
        print("; " + type + " - " + struct_name)
        
        # structure location
        print("(location " + struct_name + " g" + str(struct_coord) + ")")
        
        # structure inital statuses
        print("(not-damaged " + struct_name + ") (not (damaged " + struct_name + "))")

    else:
        print("invalid entity")
        print("")

    print("")

    # does user want to continue?
    cont = input("Would you like to continue? (y/n) ")
    
    if cont == "n": #then stop
        done = True

    else:
        print("")
