function gen_rayleigh_variables(σ, n_samples)
    x = sqrt.(-2σ^2 .*log.(1 .- rand(n_samples)))
end
println(gen_rayleigh_variables(1, 10))
