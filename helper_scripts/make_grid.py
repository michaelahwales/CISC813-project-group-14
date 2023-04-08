# Create a connected square grid
# 2023-03-11

#size of grid
num_rows = 8
num_cols = 8

#connect across rows
print(";connect across rows")
for row in range(0, num_rows, 1):
    
    #row=row+1   #iterate before printing so we dont start @ 0
    
    for col in range(num_cols-1):
        
        col=col+1   #iterate before printing so we dont start @ 0

        print("(adj g", row, col, " g", row, col+1, ")", sep='') #connect row,col to row,col+1
        print("(adj g", row, col+1, " g", row, col, ")", sep='') #reverse


#connect down columns
print(";connect down columns")
for row in range(num_rows):
    
    row=row+1    #iterate before printing so we dont start @ 0
    
    for col in range(num_cols-1):
        
        col=col+1   #iterate before printing so we dont start @ 0
        
        print("(adj g", col, row, " g", col+1, row, ")", sep='') #connect col,row to col+1,row
        print("(adj g", col+1, row, " g", col, row, ")", sep='') #reverse
        
