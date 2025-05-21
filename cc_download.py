# warc_downloader.py
from nemo_curator.download import CommonCrawlWARCDownloader
from pathlib import Path
import gzip, random, requests

SNAPSHOT = "2025-18"
N_WARCS  = 2

idx_url = f"https://data.commoncrawl.org/crawl-data/CC-MAIN-{SNAPSHOT}/warc.paths.gz"
paths   = gzip.decompress(requests.get(idx_url).content).decode().splitlines()
sampled = paths[:N_WARCS]
warc_urls = [f"https://data.commoncrawl.org/{p}" for p in sampled]

downloader = CommonCrawlWARCDownloader(download_dir="cc_sample", aws=False)
local_warcs = [downloader.download(u) for u in warc_urls]

print(f"✔ 下載完成：{len(local_warcs)} 個 WARC 存在 ./cc_sample/")
