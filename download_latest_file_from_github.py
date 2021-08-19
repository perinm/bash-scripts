from lxml import html
import requests
import urllib
from pathlib import Path

url = 'https://github.com/obsidianmd/obsidian-releases/releases/latest'
file_name = 'Obsidian'
file_abbv = '.AppImage'
downloaded_name = f'{file_name}.AppImage'
start_path = Path('/home/salvorhardin/apps')
final_path = start_path / file_name.lower()
final_path.mkdir(parents=True, exist_ok=True)
final_file = final_path / downloaded_name
print(final_file)

# page = requests.get(url)
# tree = html.fromstring(page.content)
# download_link = tree.xpath(f"//a[contains(@href,'{file_abbv}')]/@href")[0]
# download_link = 'https://github.com' + download_link
# print(download_link)
# downloaded_obj = requests.get(download_link)
# with open(final_file, "wb") as file:
#     file.write(downloaded_obj.content)

# https://image.topuwp.com/icon/2020-09-07/e356cb4c21d2630beff2eb8446cacd53.png
# https://camo.githubusercontent.com/8f3df8f6350f6ac42ebfc4bef15638faa1fac1477c51d56dacba4f53bfd1ea6a/68747470733a2f2f646c2e666c61746875622e6f72672f7265706f2f61707073747265616d2f7838365f36342f69636f6e732f313238783132382f6d642e6f6273696469616e2e4f6273696469616e2e706e67
url_image = 'https://avatars.githubusercontent.com/u/65011256?s=280&v=4'
final_path = start_path / 'app-icons'
final_path.mkdir(parents=True, exist_ok=True)
final_file = final_path / f"{file_name.lower()}.png"
print(final_file)

downloaded_obj = requests.get(url_image)
with open(final_file, "wb") as file:
    file.write(downloaded_obj.content)