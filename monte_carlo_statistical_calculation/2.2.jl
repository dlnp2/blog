include("Common.jl")

function linear_congruential_generator(a, b, y, n, n_samples)
    x = zeros(n_samples)
    for i in 1:n_samples
        y = (a * y + b) % n
        x[i] = y / n
    end
    x
end

a = 13
b = 0
n = 67
y_init = 1234
n_samples = 1000
x = linear_congruential_generator(a, b, y_init, n, n_samples)
scatter_2d(x)
savefig("2.2.png")
