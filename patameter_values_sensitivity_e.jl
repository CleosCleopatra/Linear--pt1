# Sets
I = 1:3 # 3 different crops
J = 1:3 # Set of different types of fuels

#Labels
crops = ["soybeans", "sunflower seeds", "cotton seeds"] # for i in I
fuels  = ["b5", "b30", "b100"]

#Parameters
#N_min = [1800, 91, 60, 880]        #Minimum amount of nutrients [kcal, g, g, mg]
#For crop
y = [2600 1400 900]# Yield [t/ha]
w = [5.0 4.2 1.0] #Water demand [Ml/ha]
o = [0.178 0.216 0.433] #Oil content[l/kg]
#For fuels
f = [0.05 0.3 1.0] # Biodiesel percentage [%]
c = [1.43 1.29 1.16] #Cost of biodiesel [pound/litre]
t1_tax = [0.2 0.1 0.05 0 0.5]
t2_tax = [0.05 0.1 0.2 0 0.5]
t3_tax = [0 0.05 0.1 0.2 0.5]
t = [[i j k] for i in t1_tax for j in t2_tax for k in t3_tax] #Tax on fuel [percentage]

A_tot = 1600 # Maximum area available [ha]
M_c = 1.5 #Cost of methanol [pound/litre]
D_c = 1.20 # Cost of petrol diesel [pound/litre]
D_max = 150000 #Total amount of petrol diesel available [litre]
W_max = 5000 #Total amount of water available [Ml]
F_min = 280000 #minimum amount of fuel that needs to be delievered [litre]