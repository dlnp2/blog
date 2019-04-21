from pathlib import Path
import pandas as pd


def retrieve_data(url: str, name: str) -> None:
    dfs = pd.read_html(url)
    dfs[1].iloc[2:].set_index(0).to_csv(Path("./data") / name)


Path("./data").mkdir(exist_ok=True)
url = "http://www1.river.go.jp/cgi-bin/DspWaterData.exe?KIND=7&ID=306041286606370&BGNDATE=20170131&ENDDATE=20171231&KAWABOU=NO"
retrieve_data(url, "kamogawa_2017.csv")
url = "http://www1.river.go.jp/cgi-bin/DspWaterData.exe?KIND=6&ID=306041286606370&BGNDATE=20170801&ENDDATE=20171231&KAWABOU=NO"
retrieve_data(url, "kamogawa_2017_08.csv")
