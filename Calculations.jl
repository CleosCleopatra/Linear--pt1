using JuMP      #load the package JuMP
   #load the package Clp (an open linear-programming solver)
using Gurobi   #The commercial optimizer Gurobi requires installation

"""
  Construct and returns the model of this assignment.
"""
include(parameter_value)

function build_model(parameter_value::String)
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

  _y(i) = y[crop2idx[i]]
  _w(i) = w[crop2idx[i]]
  _o(i) = o[crop2idx[i]]

  _f(j) = f[fuel2idx[j]]
  _c(j) = c[fuel2idx[j]]
  _t(j) = t[fuel2idx[j]]

  _A_tot = A_tot 
  _M_c = M_c
  _P_c = P_c
  _P_max = P_max
  _W_max = W_max
  _F_min = F_min

  m = Model()

  @variable(m, a[crops] >= 0) #Area for each crop
  @constraint(m, sum(a[i] for i in crops) <= _A_tot)
  @constraint(m, sum(a[i] * _w(i) for i in crops) <= _W_max)
  V = sum(_y(i) * a[i] * _o(i) for i in crops)
  B_tot = 0.9 * V
  M = 0.2 * V
  @variable(m, B[fuels] >= 0) #Amount of the differnt fuel types
  @constraint(m, sum(B[j] * _f(j) for j in fuels)<= B_tot)
  P = sum(B[j] * (1 - _f(j)) for j in fuels)
  @constraint(m, P <= _P_max)

  @objective(m, Max, sum(_c(j) * B[j] * (1-_t(j)) for j in fuels) - P*_P_c - M * _M_c)

  @constraint(m, sum(B[j] for j in fuels) >= _F_min)

  return m, a, B, P, M
end

include("parameter_values.jl")

m, a, B, P, M = build_model("parameter_values.jl")
print(m) # prints the model instance

set_optimizer(m, Gurobi.Optimizer)
set_optimizer_attribute(m, "OutputFlag", 1)
optimize!(m)

println("Objective value =  ", objective_value(m))   		# display the optimal solution
println("area for each crop =  ", value.(a.data))               
println("fuel amounts =  ", value.(B.data)) 
println("petrol diesel amount =  ", value(P))
println("Methanol amount =  ", value(M))    