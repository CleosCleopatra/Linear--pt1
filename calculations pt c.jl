using JuMP      #load the package JuMP
   #load the package Clp (an open linear-programming solver)
using Gurobi   #The commercial optimizer Gurobi requires installation


include("parameter_values_sensitivity.jl")

function build_model(parameter_value_sensitivity::String, _A_tot, _D_max, _W_max, yi, wi, oi)
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

  @objective(m, Max, sum(_c(j) * B[j] * (1-_t(j)) for j in fuels) - D*_D_c - M * _M_c)

  @constraint(m, sum(B[j] for j in fuels) >= _F_min)

  return m, a, B, D, M
end

include("parameter_values_sensitivity.jl")


println("Sensitivity analysis for parameter values: ")


non_zero = 0
println("Wedfrgth")
for i in 1:length(y)
  for j in 1:length(w)
    for x in 1:length(o)
        println("gdgrt")
        println("y = ", y[i])
        m, a, B, D, M = build_model("parameter_values_sensitivity.jl", A_tot[1], D_max[1], W_max[1], y[i], w[j], o[x])
        #print(m) # prints the model instance

        set_optimizer(m, Gurobi.Optimizer)
        set_optimizer_attribute(m, "OutputFlag", 0)
        optimize!(m)

        println(value(a["sunflower seeds"]))
        if value(a["sunflower seeds"]) > 0
            println("y = ", y[i])
            println("w = ", w[j])
            println("o = ", o[x])
            println("area for each crop =  ", value(a["sunflower seeds"]))  
        end 
                     
  
    end
  end
end

println("Done")