using Distributions, Plots

function approx_cauchy(M::Int)
    x = rand(Cauchy(), M)
    f(y) = exp(-√abs(y)) * (sin(y)) ^ 2 * π * (1 + y ^ 2)
    mean(f.(x))
end

function approx_normal(M::Int)
    x = rand(Normal(), M)
    f(y) = sqrt(2π) * exp(y ^ 2 / 2 - √abs(y)) * (sin(y)) ^ 2
    mean(f.(x))
end

function demo()
    M = map(x -> ^(10, x), [2, 3, 4, 5, 6]) .|> Int
    values_cauchy = approx_cauchy.(M)
    values_normal = approx_normal.(M)
    println(values_cauchy)
    println(values_normal)
    plot(M, values_cauchy, xscale = :log10, lab = "Cauchy")
    plot!(M, values_normal, xscale = :log10, lab = "Normal")
    savefig("3.9.png")
end

demo()
