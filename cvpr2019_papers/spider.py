import argparse
import time
from pathlib import Path
from typing import Callable, List, Any

import pandas as pd
from selenium import webdriver

ENTRYPOINTS = [
    "https://arxiv.org/search/?query=cvpr2019&searchtype=all&source=header&start=0",
    "https://arxiv.org/search/?query=cvpr2019&searchtype=all&source=header&start=50"]


class Spider:
    def __init__(self, output_dir: Path) -> None:
        self._output_dir = output_dir
        self._papers_dir = output_dir / "papers"
        self._papers_dir.mkdir(parents=True, exist_ok=True)
        self._results = []
        self._driver = self._create_driver()

    def _create_driver(self) -> Any:
        options = webdriver.ChromeOptions()
        # options.add_argument("--headless")
        options.add_argument("--disable-gpu")
        # for downloading pdfs
        options.add_experimental_option("prefs", {
            "download.default_directory": str(self._papers_dir),
            "plugins.always_open_pdf_externally": True
        })
        return webdriver.Chrome(chrome_options=options)

    def run(self) -> None:
        for entrypoint in ENTRYPOINTS:
            self._find_results(entrypoint)
        self._save()

    def _get(self, url: str) -> None:
        print("Accessing", url)
        self._driver.get(url)

    def _find_results(self, entrypoint: str):
        self._get(entrypoint)

        all_abst = self._driver.find_elements_by_css_selector("span.abstract-short")
        for abst in all_abst:
            button = abst.find_element_by_css_selector("a.is-size-7")
            button.click()

        all_li = self._driver.find_elements_by_class_name("arxiv-result")
        for li in all_li:
            paragraphs = li.find_elements_by_tag_name("p")
            result = []
            for idx, p in enumerate(paragraphs):
                if idx == 0:
                    result.append(p.find_element_by_tag_name("a").get_attribute("href"))
                elif idx == 1:
                    result.append(p.text)
                elif idx == 3:
                    result.append(p.find_elements_by_tag_name("span")[2].text)
            self._results.append(result)

    def _save(self):
        data = pd.DataFrame(self._results)
        data.to_csv(self._output_dir / "cvpr2019_papers.csv", index=False)

    def close(self) -> None:
        self._driver.quit()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output_dir", type=str, default="./data")
    args = parser.parse_args()

    spider = Spider(Path(args.output_dir))
    spider.run()
    spider.close()
