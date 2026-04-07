# Sets
I = 1:9 # 9 different foods
J = 1:4 # Set of nutrients

#Labels
foods = ["hamburger", "chicken", "hot dog", "fries", "macaroni", "pizza", "salad", "milk", "ice cream"] # for i in I
nutrients  = ["calories", "protein", "fat", "sodium"]

#Parameters
N_min = [1800, 91, 60, 880]        #Minimum amount of nutrients [kcal, g, g, mg]
c = [2.49, 2.89, 1.50, 1.89, 2.09, 1.99, 2.49, 0.89, 1.59] # [$/meal]
N = [410 24 26 730;
     420 32 10 1190;
     560 15 32 1800;
     380  4 19 270;
     320 12 10 930;
     320 15 12 820;
     320 31 12 1230;
     100  8 2.5 125;
     330 8 10 180]   # N[i,j] amount of nutrion j in food  i [(kcal, g, g, mg)/meal]
