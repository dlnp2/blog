using Plots

function scatter_2d(x)
    reshaped = reshape(x, (2, length(x) ÷ 2))'
    scatter(reshaped[:, 1], reshaped[:, 2], label = nothing)
end
