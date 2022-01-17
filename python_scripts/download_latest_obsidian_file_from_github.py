from lxml import html
from utils import get_latest_release_url
# from python_scripts.utils import get_latest_release_url

url = 'https://github.com/obsidianmd/obsidian-releases/releases/latest'
file_name = 'Obsidian'
xpath_ref = ['.AppImage']
url_image = 'https://avatars.githubusercontent.com/u/65011256?s=280&v=4'
get_latest_release_url(url, file_name, url_image, xpath_ref)