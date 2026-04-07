"""
  Construct and returns the model of this assignment.
"""
function build_diet_model()
  # The diet problem
  #I: set of  foods
  #J: set of nutrients
  #Foods: name of the foods, i in I
  #Nutrients: name of the nutrients, j in J
  #N_min Minimum amount of nutrients [kcal, g, g, mg], j in J
  #c cost of food i in I [$/meal]
  # N[i,j] amount of nutrion j in food  i

  #name the model
  m = Model()

  @variable(m, x[I] >= 0) # amount of food i [meal]

  #minimize the cost
  @objective(m, Min, sum(c[i]*x[i] for i in I))

  # Nutrition constraints
  @constraint(m, nutrition_demands[j in J], sum(N[i,j]*x[i] for i in I) >= N_min[j] )
  #equivalent formulation
  #@constraintref nutrition_demands[J]
  #for j in J
  #   nutrition_demands[j] = @constraint(m,  sum(N[i,j]*x[i] for i in I) >= N_min[j])
  #end

  return m, x, nutrition_demands
end
