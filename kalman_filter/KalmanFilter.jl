module KalmanFilter

export sample_process, kalman_filter

# parameters
const dim_x = 2
const dim_y = 1
const A = [0.0 1.0; -1.5 -1.0]
const G = [0.0, 0.45]
const H = [1.0 0.0]
const R = [0.3]
const dt = 0.001
const x0 = [1.0, 0.0]
const y0 = [0.0]
const P0 = [[2. 0.]; [0. 2.]]

"""
generate a samle process
"""
function sample_process(n_steps::Int64)    
    # Gaussian noise
    dw() = randn()*sqrt(dt)
    dv() = randn()*sqrt(dt)

    #  solution/deterministic process
    x = zeros(n_steps, dim_x)
    y = zeros(n_steps, dim_y)
    x_det = zeros(n_steps, dim_x)
    y_det = zeros(n_steps, dim_y)
    x[1, :] = x_det[1, :] = x0
    y[1, :] = y_det[1, :] = y0

    for i in 1:(n_steps-1)
        dx = A*x[i, :]*dt + G*dw()
        dy = H*x[i, :]*dt + R*dv()
        x[i+1, :] = x[i, :] + dx
        y[i+1, :] = y[i, :] + dy
        dx_det = A*x_det[i, :]*dt
        dy_det = H*x_det[i, :]*dt
        x_det[i+1, :] = x_det[i, :] + dx_det
        y_det[i+1, :] = y_det[i, :] + dy_det
    end

    x, y, x_det, y_det
end

"""
execute kalman filtering
"""
function kalman_filter(y::Array{Float64, 2})
    dy = y[2:end] - y[1:end-1]
    n_steps = size(dy, 1) + 1

    x = zeros(n_steps, dim_x)  # optimal estimate
    P = zeros(n_steps, dim_x, dim_x)  # estimation error matrix
    x[1, :] = x0
    P[1, :, :] = P0
    cur_x = Vector{Float64}(undef, dim_x)
    cur_P = Array{Float64}(undef, dim_x, dim_x)

    for i in 1:(n_steps-1)
        cur_x = x[i, :]
        cur_P = P[i, :, :]
        dx = A*cur_x*dt + cur_P*H'* inv(R*R')*(dy[i, :] - H*cur_x*dt)
        P_dot = A*cur_P + cur_P*A' + G*G' - cur_P*H'*inv(R*R')*H*cur_P
        x[i+1, :] = cur_x + dx
        P[i+1, :, :] = cur_P + P_dot .* dt
    end

    x, P    
end

end # module KalmanFilter