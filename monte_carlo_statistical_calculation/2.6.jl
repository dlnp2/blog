function gen_weibull_variables(a, b, n_samples)
    u = rand(n_samples)
    x = similar(u)
    @. x = b * (-log(1 - u)) ^ (1 / a)
end
println(gen_weibull_variables(1, 1, 10))
