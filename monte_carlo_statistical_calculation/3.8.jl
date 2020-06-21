using Distributions, Plots

function likelihood(x::Array{Float64, 1}, θ::Float64)
    p(y) = pdf(Cauchy(θ), y)
    prod(p.(x))
end

"Self-nomalized Monte Carlo"
function snmc(x::Array{Float64, 1}, params::Array{Float64, 1})
    l = likelihood.([x], params)
    numerator = sum(l .* params)
    denominator = sum(l)
    numerator / denominator
end

function demo()
    θ = 1.0
    d_obs = Cauchy(θ, 1)
    d_prior = Cauchy()
    N = 100
    M = map(x -> ^(10, x), [1, 2, 3, 4, 5]) .|> Int
    I = zeros(length(M))
    
    for (index, m) in enumerate(M)
        x = rand(d_obs, N)
        params = rand(d_prior, m)
        I[index] = snmc(x, params)
    end
    
    println(I)
    plot(M, I, xscale = :log10)
    savefig("3.8.png")
end

demo()
