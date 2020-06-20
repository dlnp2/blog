using Distributions, Plots

function approx_ci(f, dist, M, α)
    @assert M > 1

    I = zeros(M-1)
    l = similar(I)
    u = similar(I)
    c = quantile(Normal(), 1 - α / 2)
    for m in 2:M
        x = rand(dist, m)
        f_x = f.(x)
        I_m = mean(f_x)
        σ = sqrt(sum((f_x .- I_m) .^ 2) / (m - 1))
        l_m = I_m - σ * c / sqrt(m)
        u_m = I_m + σ * c / sqrt(m)
        I[m-1] = I_m
        l[m-1] = l_m
        u[m-1] = u_m
    end
    return I, l, u
end

f(x) = x >= 2 ? 1 : 0
dist = Cauchy()
M = 1000
α = 0.05
I, l, u = approx_ci(f, dist, M, α)
plot(I, ribbon = (l, u), fillalpha = 0.3)
hline!([0.5 - atan(2) / pi])
savefig("ex_3.6.png")
