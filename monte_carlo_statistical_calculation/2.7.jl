using BenchmarkTools, Distributions, Plots

function gen_binomial_variables(N, θ, n_samples)
    x = zeros(Int, n_samples)
    for i in 1:n_samples
        u = rand()
        n = 0
        F = (1 - θ) ^ N
        while u > F
            n = n + 1
            F = F + binomial(N, n) * θ ^ n * (1 - θ) ^ (N - n)
        end
        x[i] = n
    end
    x
end

N = 10
θ = 0.3
n_samples = 1000
dbinom = Binomial(N, θ)
a = gen_binomial_variables(N, θ, n_samples)
b = rand(dbinom, n_samples)
histogram(a, label = "inversion")
histogram!(b, label = "Distributions", alpha = 0.5)
savefig("2.7.png")
