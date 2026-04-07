"""
  Construct and returns the model of this assignment.
"""
function build_diet_model_named(data_file::String)
  # The diet problem
  include(data_file)
  name2idx = Dict{String,Int64}()
  for i in I
    name2idx[foods[i]] = i
  end
  for j in J
    name2idx[nutrients[j]] = j
  end
  #I: set of  foods
  #J: set of nutrients
  #Foods: name of the foods, i in I
  #Nutrients: name of the nutrients, j in J
  #N_min Minimum amount of nutrients [kcal, g, g, mg], j in J
  _N_min(j) = N_min[name2idx[j]]
  #c cost of food i in I [$/meal]
  _c(i) = c[name2idx[i]]
  # N[i,j] amount of nutrion j in food  i
  _N(i, j) = N[name2idx[i], name2idx[j]]
  #name the model
  m = Model()

  @variable(m, x[foods] >= 0) # amount of food i [meal]

  #minimize the cost
  @objective(m, Min, sum(_c(i)*x[i] for i in foods))

  # Nutrition constraints
  @constraint(m, nutrition_demands[j in nutrients], sum(_N(i,j)*x[i] for i in foods) >= _N_min(j))
  #equivalent formulation

  return m, x, nutrition_demands
end
