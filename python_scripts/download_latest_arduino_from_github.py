from utils import get_latest_release_url
# from python_scripts.utils import get_latest_release_url

url = 'https://github.com/arduino/arduino-ide/releases/latest'
file_name = 'ArduinoIDE_BETA'
xpath_ref = ['.AppImage']
url_image = 'https://p1.hiclipart.com/preview/116/721/160/macos-app-icons-arduino-png-icon.jpg'
get_latest_release_url(url, file_name, url_image, xpath_ref)