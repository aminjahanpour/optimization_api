using HTTP
using Formatting
using JSON


"""
    obj_fun(individual, lower_bound = -15., upper_bound = 30.)

This is the Ackley test function with -15. < x < 30.
Replace with your own cost function and update the bounds accordingly

# Examples
```jldoctest
julia> obj_fun([0.0;0.0;0.0], 0.0, 1.0)
0.0
```
"""
function obj_fun(individual, lower_bound::Float64 = -15., upper_bound::Float64 = 30.)::Float64
    # this line is necessary to denormalize the decision variables
    individual = individual .* (upper_bound - lower_bound) .+ lower_bound        
    N = length(individual)
    return 20.0 - 20.0 * exp(-0.2 * sqrt(1.0 / N * sum(individual.^2))) + exp(1.0) - exp(1.0 / N * sum(cos.(2 * pi * individual)))
end


"""
    run_minimizaton(server, key, id, budget, dim)

Run the minimization on the specified server using the supplied key, project id and budget
"""
function run_minimizaton(server::String, key::String, id::String, budget::Int)
    # The dimensionality of the problem
    dim = 10

    url_post = server * "?key=" * key * "&req=del&id=" * id
    resp = HTTP.request("POST", url_post)    

    url_post = server * "?key=" * key * "&req=create&id=" * id * "&dim=" * string(dim) * "&budget=" * string(budget)
    resp = HTTP.request("POST", url_post)

    url_post = server * "?key=" * key * "&req=ask&id=" * id 
    resp = HTTP.request("POST", url_post)

    f_best = 10e20
    x_best = 0.0
    
    dv = JSON.parse(String(resp.body))["dv"]
    while !occursin("budget_used_up", string(dv))
        # creating the vector of objective functions from recoeved solutions
        f = map(obj_fun, dv)

        # updating the best objective function (for logging only)
        if minimum(f) < f_best
            f_best =  minimum(f)
            x_best = dv[1]
            println("x_best: ", x_best, "     f_best: ", f_best)            
        end

        # creating a string of evaluated objective function values
        f = string(f)
        f = replace(f, " " => "")
        f = replace(f, "[" => "")
        f = replace(f, "]" => "")

        # submitting the objective function values to the server and requesting for new solutions
        url_post = server * "?key=" * key * "&req=roll&id=" * id * "&dim=" * string(dim) * "&f=" * f
        resp = HTTP.request("POST", url_post)

        dv = JSON.parse(String(resp.body))["dv"]
    end
    
    println("---------\nbest_found dv: ", x_best)
    println("best found objective function: ", f_best)
end


server = "http://45.32.158.25/"
key = "email mjahanpo@uwaterloo.ca for a key"
id = "julia_example"
budget = 100

run_minimizaton(server, key, id, budget)