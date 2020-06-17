function gen_pareto_variables(a, b, n_samples)
    x = b .* (1 .- rand(n_samples)) .^ (-1 / a)
end
println(gen_pareto_variables(1, 1, 10))
