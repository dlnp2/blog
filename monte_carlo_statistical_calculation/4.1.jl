using Plots
include("Common.jl")
using .Common: wright_fisher

function demo()
    N = 100
    T = 350
    plot([wright_fisher(x, N, T) for x in 5:10:95], lab = nothing)
    savefig("4.1.png")
end

demo()
