using BenchmarkTools, Distributions

function gen_logistic_variables(n_samples)
    x = -log.(1 ./ rand(n_samples) .- 1)
end

n_samples = 1000
dlogistic = Logistic(0, 1)
a = @benchmark gen_logistic_variables(n_samples)
b = @benchmark rand(dlogistic, n_samples)
println(a)
println(b)
