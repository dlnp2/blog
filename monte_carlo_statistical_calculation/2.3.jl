using BenchmarkTools, Distributions

function gen_logistic_variables(n_samples)
    x = zeros(n_samples)
    for i in 1:n_samples
        u = rand()
        x[i] = -log(1/u - 1)
    end
    x
end

n_samples = 1000
dlogistic = Logistic(0, 1)
a = @benchmark gen_logistic_variables(n_samples)
b = @benchmark rand(dlogistic, n_samples)
println(a)
println(b)
