using JuMP      #load the package JuMP
   #load the package Clp (an open linear-programming solver)
using Gurobi   #The commercial optimizer Gurobi requires installation

const GRB_ENV = Gurobi.Env()
model = Model(() -> Gurobi.Optimizer(GRB_ENV))

include("parameter_values_sensitivity_f.jl")

function build_model(parameter_value_sensitivity::String, water_dem)
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
  _w(i) = w[crop2idx[i]] * water_dem
  _o(i) = o[crop2idx[i]]

  _f(j) = f[fuel2idx[j]]
  _c(j) = c[fuel2idx[j]]
  _t(j) = t[fuel2idx[j]]

  _A_tot = A_tot 
  _M_c = M_c
  _D_c = D_c
  _D_max = D_max
  _W_max = W_max
  _F_min = F_min

  m = Model(() -> Gurobi.Optimizer(GRB_ENV))
  set_optimizer_attribute(m, "OutputFlag", 0)


  @variable(m, a[crops] >= 0) #Area for each crop
  @constraint(m, sum(a[i] for i in crops) <= _A_tot)
  @constraint(m, sum(a[i] * _w(i) for i in crops) <= _W_max)
  V = sum(_y(i) * a[i] * _o(i) for i in crops)
  @constraint(m, V >= 0)
  B_tot = 0.9 * V
  M = 0.2 * V
  @variable(m, F[fuels] >= 0) #Amount of the differnt fuel types
  @constraint(m, sum(F[j] * _f(j) for j in fuels)<= B_tot)
  D = sum(F[j] * (1 - _f(j)) for j in fuels)
  @constraint(m, D >= 0)
  @constraint(m, D <= _D_max)

  @objective(m, Max, sum(_c(j) * F[j] * (1-_t(j)) for j in fuels) - D*_D_c - M * _M_c)

  @constraint(m, sum(F[j] for j in fuels) >= _F_min)

  return m, a, F, D, M
end

include("parameter_values_sensitivity_f.jl")


println("Sensitivity analysis for parameter values: ")


non_zero = 0
#global worst_work = [y[1], w[1], o[1]]
for j in 1:length(water_demand)
    m, a, F, D, M = build_model("parameter_values_sensitivity_f.jl", water_demand[j])
    #print(m) # prints the model instance

    #set_optimizer(m, model)
    optimize!(m)

    println("water_demand: ", water_demand[j])
    println("area ", value.(a.data))  
    println("profit", objective_value(m))
end

println("Done")