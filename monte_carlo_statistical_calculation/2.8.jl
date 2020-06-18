using Distributions, Plots

function gen_negative_binomial(r, θ, n_samples)
    dgamma = Gamma(r, (1 - θ) / θ)
    x = zeros(n_samples)
    @. x = rand(Poisson(rand(dgamma)))
end

r = 10
θ = 0.5
n_samples = 1000
x = gen_negative_binomial(r, θ, n_samples)
y = rand(NegativeBinomial(r, θ), n_samples)
histogram(x, normalized = true, label = "implemented")
histogram!(y, normalized = true, label = "Distributions", alpha = 0.5)
savefig("2.8.png")
