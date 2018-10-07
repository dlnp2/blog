using Gadfly, DataFrames
include("KalmanFilter.jl")
using .KalmanFilter

const dt = 0.001
const n_steps = Int(10 / dt)

println("Generating a sample process...")
x, y, x_det, y_det = sample_process(n_steps)
println("Filtering...")
xhat, P = kalman_filter(y)

println("Visualizing...")
df = DataFrame(steps=collect(1:n_steps)*dt,
               solution=x[:, 1],
               observation=y[:],
               deterministic=x_det[:, 1],
               estimation=xhat[:, 1]);
cols = [:solution, :observation, :deterministic, :estimation]
p1 = plot(df, x=:steps, y=Col.value(cols...), Geom.line, color=Col.index(cols...), Guide.title("provess values"), Guide.xlabel("time"))

df = DataFrame(steps=collect(1:n_steps)*dt, p11=P[:, 1, 1], p22=P[:, 2, 2], p12=P[:, 1, 2]);
cols = [:p11, :p22, :p12]
p2 = plot(df, x=:steps, y=Col.value(cols...), Geom.line, color=Col.index(cols...), Guide.title("(co)variance"), Guide.xlabel("time"))

set_default_plot_size(1280px, 720px)
hstack(p1, p2) |> SVG("kalman_filter.svg")
