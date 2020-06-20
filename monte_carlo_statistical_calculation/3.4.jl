using Plots

function composite_trapezoidal_integral(N)
    func(x) = (cos(50x) + sin(20x)) ^ 2
    f = func.(collect(range(0, 1, length=N)))
    (2 * sum(f) - f[1] - f[end]) / 2 / (N - 1)
end
 
N = 100
I = composite_trapezoidal_integral.(2:N)
plot(I)
hline!([0.9605764394771032])
savefig("3.4.png")
