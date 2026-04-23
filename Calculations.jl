using JuMP      #load the package JuMP
   #load the package Clp (an open linear-programming solver)
using Gurobi   #The commercial optimizer Gurobi requires installation


include("parameter_values.jl")

function build_model(parameter_value::String, _A_tot, _D_max, _W_max, yi, wi, oi)
  # The diet problem
  crop2idx = Dict{String,Int64}()
  fuel2idx = Dict{String,Int64}()
  for i in I
    crop2idx[crops[i]] = i
  end
  for j in J
    fuel2idx[fuels[j]] = j
  end
  #I: set of  crops
  #J: set of fuels
  #crops: name of the foods, i in I
  #fuels: name of the fuels, j in J

  _y(i) = yi[crop2idx[i]]
  _w(i) = wi[crop2idx[i]]
  _o(i) = oi[crop2idx[i]]

  _f(j) = f[fuel2idx[j]]
  _c(j) = c[fuel2idx[j]]
  _t(j) = t[fuel2idx[j]]

  #_A_tot = A_tot 
  _M_c = M_c
  _D_c = D_c
  #_D_max = D_max
  #_W_max = W_max
  _F_min = F_min

  m = Model()

  @variable(m, a[crops] >= 0) #Area for each crop
  @constraint(m, sum(a[i] for i in crops) <= _A_tot)
  @constraint(m, sum(a[i] * _w(i) for i in crops) <= _W_max)
  V = sum(_y(i) * a[i] * _o(i) for i in crops)
  @constraint(m, V >= 0)
  B_tot = 0.9 * V
  M = 0.2 * V
  @variable(m, B[fuels] >= 0) #Amount of the differnt fuel types
  @constraint(m, sum(B[j] * _f(j) for j in fuels)<= B_tot)
  D = sum(B[j] * (1 - _f(j)) for j in fuels)
  @constraint(m, D >= 0)
  @constraint(m, D <= _D_max)

  @objective(m, Min, D)

  @constraint(m, sum(B[j] for j in fuels) >= _F_min)

  return m, a, B, D, M
end

include("parameter_values.jl")


println("Sensitivity analysis for parameter values: ")



m, a, B, D, M = build_model("parameter_values.jl", A_tot, D_max, W_max, y, w, o)

set_optimizer(m, Gurobi.Optimizer)
set_optimizer_attribute(m, "OutputFlag", 0)
optimize!(m)

println("Objective value =  ", objective_value(m))   		# display the optimal solution
println("area for each crop =  ", value.(a.data))               
println("fuel amounts =  ", value.(B.data)) 
println("petrol diesel amount =  ", value(D))
println("Methanol amount =  ", value(M))    



"""
for j in 1:length(D_max)
  m, a, B, D, M = build_model("parameter_values_sensitivity.jl", A_tot[1], D_max[j], W_max[1], y[1], w[1], o[1])
  println("D_max = ", D_max[j])
  #print(m) # prints the model instance

  set_optimizer(m, Gurobi.Optimizer)
  set_optimizer_attribute(m, "OutputFlag", 0)
  optimize!(m)

  #println("Objective value =  ", objective_value(m))   		# display the optimal solution
  println("area for each crop =  ", value.(a.data))               
  #println("fuel amounts =  ", value.(B.data)) 
  #println("petrol diesel amount =  ", value(D))
  #println("Methanol amount =  ", value(M))    
end
"""

"""
for x in 1:length(W_max)
  m, a, B, D, M = build_model("parameter_values_sensitivity.jl", A_tot[1], D_max[1], W_max[x], y[1], w[1], o[1])
  println("W_max = ", W_max[x])
  #print(m) # prints the model instance

  set_optimizer(m, Gurobi.Optimizer)
  set_optimizer_attribute(m, "OutputFlag", 0)
  optimize!(m)

  #println("Objective value =  ", objective_value(m))   		# display the optimal solution
  println("area for each crop =  ", value.(a.data))               
  #println("fuel amounts =  ", value.(B.data)) 
  #println("petrol diesel amount =  ", value(D))
  #println("Methanol amount =  ", value(M))    
end
"""


#Ordinary results: 
#ideal area for each crop = [850, 0, 750]
#Fuel amounts = [0, 214285.7142857143, 552803.7857142857]
#Petrol diesel amount = 150 000
#Methanol amount = 137 131.0
#Profit = 548 163.0342857142

#When a_tot = 1600:area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 214285.7142857143, 552803.7857142857]
#When a_tot = 1400:area for each crop =  [900.0, 0.0, 500.0], fuel amounts =  [0.0, 214285.7142857143, 485947.2857142857]
#When a_tot = 1200:area for each crop =  [950.0, 0.0, 250.0], fuel amounts =  [0.0, 214285.7142857143, 419090.7857142857]
#When a_tot = 1000: area for each crop =  [1000.0, 0.0, 0.0], fuel amounts =  [0.0, 214285.7142857143, 352234.2857142857]
#WHen a_tot = 800: area for each crop =  [800.0, 0.0, 0.0], fuel amounts =  [0.0, 214285.7142857143, 268930.2857142857]
#When a_tot = 600: area for each crop =  [600.0, 0.0, 0.0], fuel amounts =  [0.0, 214285.7142857143, 185626.2857142857]
#When a_tot = 400: area for each crop =  [400.0, 0.0, 0.0], fuel amounts =  [0.0, 214285.7142857143, 102322.28571428571]
#WHen a_tot = 300: Error


#When W_max=5000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 214285.7142857143, 552803.7857142857]
#When W_max = 4000: Area for each crop =  [600.0, 0.0, 1000.0], fuel amounts =  [0.0, 214285.7142857143, 536356.2857142857]
#When W_max = 3000: area for each crop =  [350.0, 0.0, 1250.0], fuel amounts =  [0.0, 214285.7142857143, 519908.7857142857]
#When W_max = 2000: area for each crop =  [100.0, 0.0, 1500.0], fuel amounts =  [0.0, 214285.7142857143, 503461.2857142857]
#When W_max = 1000: area for each crop =  [0.0, 0.0, 1000.0], fuel amounts =  [0.0, 214285.7142857143, 286444.2857142857]
#When W_max = 500: area for each crop =  [0.0, 0.0, 500.0], fuel amounts =  [0.0, 214285.7142857143, 111079.28571428571]
#When W_max = 200: Error

#When D_max = 150000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 214285.7142857143, 552803.7857142857]
#When D_max = 100000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 142857.14285714287, 574232.3571428572]
#When D_max = 50000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 71428.57142857143, 595660.9285714286]
# When D_max = 25 000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 35714.28571428572, 606375.2142857143]
#When D_max = 10000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 14285.714285714286, 612803.7857142857]
#When D_max = 1000: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 1428.5714285714287, 616660.9285714286]
#WHen D_max = 0: area for each crop =  [850.0, 0.0, 750.0], fuel amounts =  [0.0, 0.0, 617089.5]