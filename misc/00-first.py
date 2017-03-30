from datetime import datetime
import os
loc = os.path.abspath(os.path.join(os.path.dirname(__file__), __file__))

# check conda environment
import subprocess
envs = subprocess.check_output(['conda-env', 'list']).splitlines()
env = list(filter(lambda s: '*' in str(s), envs))[0]
name = env.decode('utf-8').split('*')[0].strip()

print("\nloading the default libraries for {} environment specified in\n{}".format(name, loc))

# default libraries
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('whitegrid')

# project specific libraries
if name == 'tf':
    import tensorflow as tf
    import cv2
else:
    from scipy import stats
    import pandas as pd
    from pandas import Series, DataFrame
    pd.options.display.max_columns = 40

print('done.')
