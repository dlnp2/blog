function gen_pareto_variables(a, b, n_samples)
    u = rand(n_samples)
    x = similar(u)
    @. x = b * u ^ (-1 / a)
end
println(gen_pareto_variables(1, 1, 10))
