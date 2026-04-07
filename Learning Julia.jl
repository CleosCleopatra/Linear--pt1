

f(x1, x2) = - x1 - 2 * x2

using Gurobi

m = Model()
set_optimizer(m, Gurobi.Optimizer)

@variable(m, x1 >= 0)
@variable(m, x2 >= 0)
@objective(m, Min, f(x1, x2))
@constraint(m, - 2 * x1 + x2 <=2)
@constraint(m, -x1+x2 <= 3)
@constraint(m, x1 <= 3)

print(m)
optimize!(m)
println("Optimal value: ", objective_value(m))
println("x1: ", value(x1))  
println("x2: ", value(x2))


function say_hello(name::String, current_year)
    println("Hello, $name ! The current year is $current_year.")
end

say_hello("Alice", 2024)