function gen_pareto_variables(a, b, n_samples)
    x = zeros(n_samples)
    for i in 1:n_samples
        x[i] = b * (1 - rand()) ^ (-1 / a)
    end
    x
end
