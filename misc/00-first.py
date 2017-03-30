from __future__ import print_function
import os

def conda_environment_name():
    """ check conda environment """
    import subprocess
    loc = os.path.abspath(os.path.join(os.path.dirname(__file__), __file__))
    envs = subprocess.check_output(['conda-env', 'list']).splitlines()
    env = list(filter(lambda s: '*' in str(s), envs))[0]
    name = env.decode('utf-8').split('*')[0].strip()
    print("\nloading the default libraries for {} environment specified in\n{}".format(name, loc))
    return name

# default libraries
name = conda_environment_name()
from datetime import datetime
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

# remove the module-local variables to avoid polluting the namespace
del name
del conda_environment_name

print('done.')
