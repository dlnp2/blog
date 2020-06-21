using Distributions, Plots

function gen_mc(M, dist)
    function mc(x)
        I = mean(rand(dist, M) .>= x)
        return π * (1 / 2 - I)
    end
    mc
end

x = range(-10, 10, length=101)
dist = Cauchy()
M = map(x -> ^(10, x), [1, 2, 3, 4]) .|> Int
data = zeros(length(x), length(M))
for (index, m) in enumerate(M)
    approx_atan = gen_mc(m, dist)
    data[:, index] = approx_atan.(x)
end

for (index, m) in enumerate(M)
    plot!(x, data[:, index], lab = "$m", legend = :bottomright)
end
plot!(x, atan.(x), lab = "truth", legend = :bottomright)

savefig("3.6.png")
