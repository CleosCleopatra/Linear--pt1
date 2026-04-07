#Consult http://www.juliaopt.org/JuMP.jl/stable/ for detials
#Installation, Required first time write:
#]
#add JuMP
#add Clp
#add MathOptInterface
using JuMP      #load the package JuMP
using Clp       #load the package Clp (an open linear-programming solver)
using Gurobi   #The commercial optimizer Gurobi requires installation

#The ? can be put infront of commands, variables, and functions to get more information.
#Note that is applied on the main object, hence to ask about an element in an array do:
#element = array[5]
#?element

#Build the model and get variables and constraints back (see intro_mod.jl)
include("intro_mod (1).jl")
include("intro_dat (1).jl")
m, x, nutrition_demands = build_diet_model()
print(m) # prints the model instance

set_optimizer(m, Gurobi.Optimizer)
set_optimizer_attribute(m, "OutputFlag", 1)
set_optimizer(m, Clp.Optimizer)
optimize!(m)

println("z =  ", objective_value(m))   		# display the optimal solution
println("x =  ", value.(x.data))               # f.(arr) applies f to all elements of arr
println("Foods in solution: ", foods[[value(x[i]) > 0 for i in I]])
println("reduced cost =  ", dual.(LowerBoundRef.(x.data)))
protein_demand = nutrition_demands[findfirst(nutrients .== "protein")]
println("protein dual =  ", dual(protein_demand)) # See JuMP doc for dual vs shadow_price

using MathOptInterface
# You can always define aid functions to simply your life, as below
# Moreover, it's good practice to place this functions in a seperate file
# and use include("lp_util_functions.jl"), to keep the code structured.
"""
 Gets the current slack of the constraint, for feasible solution it's always positive.
 For double sided inequalities it's the least slack that is given.
"""
function get_slack(constraint::ConstraintRef)::Float64  # If you dont want you dont have to specify types
  con_func = constraint_object(constraint).func
  interval = MOI.Interval(constraint_object(constraint).set)
  row_val = value(con_func)
  return min(interval.upper - row_val, row_val - interval.lower)
end
fat_demand = nutrition_demands[findfirst(nutrients .== "fat")]
println("fat slack =  ", get_slack(fat_demand))


# Note the level of sodium, modify the model to restrict it e.g.
amount_of_sodium = @expression(m, sum(N[i,4]*x[i] for i in I))
sodium_constarint = @constraint(m, amount_of_sodium <= 2000 )
optimize!(m)
println("amount of sodium = ", value(amount_of_sodium))

# And modify the constraint
set_normalized_rhs(sodium_constarint, 1500)
optimize!(m)
println("Solve status = ", termination_status(m))
# Multiple times
set_normalized_rhs(sodium_constarint, 2000)
optimize!(m)
println("Solve status = ", termination_status(m))

#To modify the objective, change c then change the objective by calling:
#@objective(m, Min, sum(c[i]*x[i] for i in I))
