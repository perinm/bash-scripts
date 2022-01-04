from lxml import html
import requests
from pathlib import Path
import os


def get_latest_release_url(url, file_name, url_image, xpath_ref):
    file_abbv = '.AppImage'
    downloaded_name = file_name+file_abbv
    print(downloaded_name)
    start_path = Path(f'{os.environ["HOME"]}/apps')
    final_path = start_path / file_name.lower()
    final_path.mkdir(parents=True, exist_ok=True)
    final_file = final_path / downloaded_name
    print(final_file)

    page = requests.get(url)
    tree = html.fromstring(page.content)
    xpath_comp = [
        f"contains(@href,'{xpath_i}')"
        if i == 0
        else
        f" and contains(@href,'{xpath_i}')"
        for i, xpath_i in enumerate(xpath_ref)
    ]
    download_link = tree.xpath(f"//a[{''.join(xpath_comp)}]/@href")[0]
    download_link = 'https://github.com' + download_link
    print(download_link)
    downloaded_obj = requests.get(download_link)
    with open(final_file, "wb") as file:
        file.write(downloaded_obj.content)

    # https://image.topuwp.com/icon/2020-09-07/e356cb4c21d2630beff2eb8446cacd53.png
    # https://camo.githubusercontent.com/8f3df8f6350f6ac42ebfc4bef15638faa1fac1477c51d56dacba4f53bfd1ea6a/68747470733a2f2f646c2e666c61746875622e6f72672f7265706f2f61707073747265616d2f7838365f36342f69636f6e732f313238783132382f6d642e6f6273696469616e2e4f6273696469616e2e706e67
    final_path = start_path / 'app-icons'
    final_path.mkdir(parents=True, exist_ok=True)
    final_file = final_path / f"{file_name.lower()}.png"
    print(final_file)

    downloaded_obj = requests.get(url_image)
    with open(final_file, "wb") as file:
        file.write(downloaded_obj.content)