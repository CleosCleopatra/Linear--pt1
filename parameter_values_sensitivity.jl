# Sets
I = 1:3 # 3 different crops
J = 1:3 # Set of different types of fuels

#Labels
crops = ["soybeans", "sunflower seeds", "cotton seeds"] # for i in I
fuels  = ["b5", "b30", "b100"]

#Parameters
#N_min = [1800, 91, 60, 880]        #Minimum amount of nutrients [kcal, g, g, mg]
#For crops
y = [[2600, 1400, 900], [2600, 2000, 900], [2600, 2500, 900], [2600, 3000, 900]] # Yield [t/ha]
w = [[5.0, 4.2, 1.0], [5.0, 4.1, 1.0], [5.0, 4.0, 1.0], [5.0, 3.5, 1.0], [5.0, 3.0, 1.0], [5.0, 2.0, 1.0], [5.0, 1.5, 1.0], [5.0, 1.0, 1.0], [5.0, 0.5, 1.0]] #Water demand [Ml/ha]
o = [[0.178, 0.216, 0.433], [0.178, 0.3, 0.433], [0.178, 0.4, 0.433], [0.178, 0.45, 0.433], [0.178, 0.5, 0.433]] #Oil content[l/kg]
#For fuels
f = [0.05 0.3 1.0] # Biodiesel percentage [%]
c = [1.43 1.29 1.16] #Cost of biodiesel [pound/litre]
t = [0.2 0.05 0] #Tax on fuel [percentage]

A_tot = [1600 3300 3500 4000 10000 500 1000 3000 5000 7000 15000] # Maximum area available [ha]
M_c = 1.5 #Cost of methanol [pound/litre]
D_c = 1 # Cost of petrol diesel [pound/litre]
D_max = [150000 100000 200000 500000 170000 190000 250000 400000 1000000] #Total amount of petrol diesel available [litre]
W_max = [5000 50000 1000 500 10000 2000 25000 100000] #Total amount of water available [Ml]
F_min = 280000 #minimum amount of fuel that needs to be delievered [litre]
