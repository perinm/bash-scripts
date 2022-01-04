from python_scripts.utils import get_latest_release_url


url = 'https://github.com/realthunder/FreeCAD_assembly3/releases/latest'
file_name = 'FreeCad_RealThunder'
xpath_ref = ['.AppImage','Stable']
url_image = 'https://b.thumbs.redditmedia.com/JLrSjGiPZlSI2FehAewKiAlSXy30RAwuLs_QzDHj1xA.png'
get_latest_release_url(url, file_name, url_image, xpath_ref)