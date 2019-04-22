import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class SST:
    """Singular Spectrum Transformation with von Mises-Fisher distribution"""

    def __init__(self, s):
        assert s.ndim == 1, "1-dimensional series are accepted."
        self.s = s
        self.a = None  # predicted abnormalities
        self._sv_X = []  # singular values of the history matrix
        self._sv_Z = []  # svs of the test matrix
        
    def predict(self, M: int, n: int, k: int, L: int, r: int, m: int,
                keep_len: bool = False) -> np.ndarray:
        """Perform abnormality calculation"""
        
        start = M + n - 1
        end = self.s.size - L - M + 2
        if not start <= end:
            raise ValueError("M, n, k, and L must satisfy "
                             "M + n - 1 <= T - L - M + 2.")

        a = np.array(
            [self._predict(t, M, n, k, L, r, m) for t in range(start, end + 1)])

        # fill abnormality series with 0.0
        # and keep its length the same as the original series.
        if keep_len:
            a = np.append(
                    np.append([0]*start, a), [0]*(self.s.size-a.size-start))
        self.a = a
        
        self._sv_X = np.array(self._sv_X)
        self._sv_Z = np.array(self._sv_Z)

    def _predict(self, t, M, n, k, L, r, m):
        # history matrix
        X = np.r_[[self.s[t-M-n+1+i: t-n+1+i] for i in range(0, n)]].T
        msg = "t={:05d}, X.shape={}, not {}".format(t, X.shape, (M, n))
        assert X.shape == (M, n), msg

        # test matrix
        Z = np.r_[[self.s[t-k+L-M+1+i: t-k+L+1+i] for i in range(0, k)]].T
        msg = "t={:05d}, Z.shape={}, not {}".format(t, Z.shape, (M, k))
        assert Z.shape == (M, k), msg

        # principal subspaces
        u, sv_x, _ = np.linalg.svd(X)
        U = u[:, :r]
        self._sv_X.append(sv_x)
        
        q, sv_z, _ = np.linalg.svd(Z)
        Q = q[:, :m]
        self._sv_Z.append(sv_z)

        # abnormality: maximum singular value of U^T * Q
        return 1 - np.linalg.svd(U.T.dot(Q))[1][0]

    def plot(self, txt=""):
        if self.a is not None:
            fig, axes = plt.subplots(2, 1, figsize=(15, 7), sharex=True)
            axes[0].plot(self.s)
            axes[0].set_title("original series")
            axes[1].plot(self.a)
            axes[1].set_title("abnormality" + txt)
        else:
            raise RuntimeError("Call SST().predict first.")
            
    def plot_hist_sv(self):
        if (self._sv_X.size==0) or (self._sv_Z.size==0):
            raise RuntimeError("Call SST().predict first.")
        else:
            sv_X = pd.DataFrame(np.array(self._sv_X))
            sv_Z = pd.DataFrame(np.array(self._sv_Z))
            fig = plt.figure(figsize=(15, 5))
            sv_X.hist(ax=fig.gca(), bins=30, sharey=True, sharex=True,
                      layout=(1, self._sv_X.shape[1]))
            fig = plt.figure(figsize=(15, 5))
            sv_Z.hist(ax=fig.gca(), bins=30, sharey=True, sharex=True,
                      layout=(1, self._sv_Z.shape[1]))
