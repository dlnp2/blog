# Optimize the compositional ratios of mixed gaussian distributions with Optuna.
# Here we fix the means and covariances for simplicity.

from functools import partial

import numpy as np
import optuna

# Fixed distribution parameters.
gt_mean1 = np.array([-2, 0])
gt_mean2 = np.array([0, 0])
gt_mean3 = np.array([2, 0])
gt_mean = np.stack([gt_mean1, gt_mean2, gt_mean3])
gt_cov = [[1, 0], [0, 1]]


def gen_data(ratios, total_size):
    gt_data = None
    for i, ratio in enumerate(ratios):
        size = int(total_size * ratio)
        data = np.random.multivariate_normal(gt_mean[i], gt_cov, size)
        if gt_data is None:
            gt_data = data
        else:
            gt_data = np.concatenate([gt_data, data])
    return gt_data


def objective(data, trial):
    # Minimze negative log likelihood of mixed gaussian distribution.

    w1 = trial.suggest_uniform("w1", 0, 1.0)
    w2 = trial.suggest_uniform("w2", 0, 1.0)
    w3 = trial.suggest_uniform("w3", 0, 1.0)
    ws = np.array([w1, w2, w3])
    ws /= ws.sum()  # normalize for the summation to be 1.
    nll = 0.0
    for i in range(len(data)):
        nll += -np.log(
            sum(
                [
                    ws[j] * np.exp(-np.sum((data[i] - gt_mean[j]) ** 2) / 2)
                    for j in range(len(gt_mean))
                ]
            )
        )
    return nll


def main():
    ratios = [0.2, 0.3, 0.5]
    total_size = 300
    gt_data = gen_data(ratios, total_size)

    study = optuna.create_study()
    study.optimize(partial(objective, gt_data), n_trials=100)
    best_params = np.array(list(study.best_params.values()))
    print(f"Best params: {best_params / best_params.sum()}")
    print(f"Truth: {ratios}")


if __name__ == "__main__":
    main()
