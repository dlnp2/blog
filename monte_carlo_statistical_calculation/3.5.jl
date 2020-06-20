using Distributions, Plots

function approx_ci(dist, c, M)
    f_x = rand(dist, M) .>= 2.0
    I = mean(f_x)
    σ = std(f_x)
    l = I - σ * c / sqrt(M)
    u = I + σ * c / sqrt(M)
    return I, l, u
end

function run(M)
    α = 0.05
    c = quantile(Normal(), 1 - α / 2)
    dist = Cauchy()

    I = zeros(length(M))
    l = zeros(length(M))
    u = zeros(length(M))
    for (index, m) in enumerate(M)
        I_m, l_m, u_m = approx_ci(dist, c, m)
        I[index] = I_m
        l[index] = l_m
        u[index] = u_m
    end
    return I, l, u
end

M = map(x -> ^(10, x), [1, 2, 3, 4, 5, 6]) .|> Int
I, l, u = run(M)

println("Estimated: ", I[end])
println("lower bound: ", l[end])
println("upper bound: ", u[end])

plot(M, I, xscale=:log10, frange=l, falpha=0.2, fcolor=:black, lab=nothing)
plot!(M, I, xscale=:log10, lalpha=0, frange=u, falpha=0.2, fcolor=:black, lab=nothing)
savefig("3.5.png")
