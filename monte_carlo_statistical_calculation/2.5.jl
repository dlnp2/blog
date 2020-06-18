function gen_rayleigh_variables(σ, n_samples)
    u = rand(n_samples)
    x = similar(u)
    @. x = sqrt(-2σ^2 * log(u))
end
println(gen_rayleigh_variables(1, 10))
