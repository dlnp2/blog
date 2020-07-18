using Distributions, Plots
using StatsBase: autocor

function sample_gmm(n::Int, θ::Float64)::Vector{Float64}
    gmm = MixtureModel(Normal, [(0, 1), (1, 1)], [1 - θ, θ])
    rand(gmm, n)
end

function sample_index(x::Float64, param::Float64)::Float64
    p0 = Normal(0, 1)
    p1 = Normal(1, 1)
    p = param * pdf(p1, x) / (param * pdf(p1, x) + (1 - param) * pdf(p0, x))
    return rand(Bernoulli(p))
end

function gibbs_sampling_gmm(xs::Vector{Float64}, θ::Float64, chain_len::Int)::Vector{Float64}
    n = length(xs)
    params = zeros(chain_len)
    params[1] = rand()
    for step in 2:chain_len
        indices = sample_index.(xs, params[step - 1])
        m = sum(indices)
        params[step] = rand(Beta(m + 1, n - m + 1))
    end
    params
end

function demo()
    n = 100
    chain_len = 1000
    θ = 0.3

    data = sample_gmm(n, θ)
    params = gibbs_sampling_gmm(data, θ, chain_len)
    ac = autocor(params, 1:75)

    data_hist = histogram(data, title = "histogram (raw data)", lab = nothing)
    params_hist = histogram(params, title = "histogram (parameters)", lab = nothing)
    series_plot = plot(params, title = "chain", lab = nothing)
    autocor_plot = plot(ac, st = :bar, title = "autocorrelation", lab = nothing)
    plot(data_hist, params_hist, series_plot, autocor_plot, layout = 4, size = (1080, 1080))
    savefig("5.1.png")
    println("Mean: ", mean(params))
    println("Quantile[0.05, 0.95]: ", [quantile(params, 0.05), quantile(params, 0.95)])
end

demo()
