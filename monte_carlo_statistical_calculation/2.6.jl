function gen_weibull_variables(a, b, n_samples)
    x = b .* (.- log.(1 - rand(n_samples))) .^ (1 / a)
end
println(gen_weibull_variables(1, 1, 10))
