from pathlib import Path
import pandas as pd

Path("./data").mkdir(exist_ok=True)
dfs = pd.read_html("http://www1.river.go.jp/cgi-bin/DspWaterData.exe?KIND=7&ID=306041286606370&BGNDATE=20170131&ENDDATE=20171231&KAWABOU=NO")
dfs[1].iloc[2:].set_index(0).to_csv("./data/kamowaga_2017.csv")
