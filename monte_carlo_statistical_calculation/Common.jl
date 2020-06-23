module Common
using Distributions, Plots

function scatter_2d(x)
    reshaped = reshape(x, (2, length(x) ÷ 2))'
    scatter(reshaped[:, 1], reshaped[:, 2], label = nothing)
end

function wright_fisher(x1, N, T)
    x = zeros(T)
    x[1] = x1
    for n in 2:T
        x[n] = rand(Binomial(N, x[n - 1] / N))
    end
    x
end

export scatter_2d, wright_fisher
end # module
