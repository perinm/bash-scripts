#!/bin/bash

# Replace these with the actual versions you're using
PYTHON_MAJOR_VERSION=3.12
PYTHON_MINOR_VERSION=1

files=(
    "/usr/local/bin/python${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/pip${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/pydoc"
    "/usr/local/bin/include/python${PYTHON_MAJOR_VERSION}"
    "/usr/local/lib/libpython${PYTHON_MAJOR_VERSION}.a"
    "/usr/local/lib/python${PYTHON_MAJOR_VERSION}"
    "/usr/local/share/man/python${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}"
    "/usr/local/lib/pkgconfig"
    "/usr/local/bin/idle"
    "/usr/local/bin/easy_install-${PYTHON_MAJOR_VERSION}"
    "/usr/local/include/python${PYTHON_MAJOR_VERSION}"
    "/usr/local/lib/pkgconfig/python3.pc"
    "/usr/local/lib/pkgconfig/python3-embed.pc"
    "/usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}.pc"
    "/usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}-embed.pc"
    "/usr/local/bin/easy_install-${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/idle3"
    "/usr/local/bin/idle${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/ipython"
    "/usr/local/bin/ipython3"
    "/usr/local/bin/iptest"
    "/usr/local/bin/iptest3"
    "/usr/local/bin/2to3"
    "/usr/local/bin/2to3-${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/f2py"
    "/usr/local/bin/f2py3"
    "/usr/local/bin/f2py${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/pip"
    "/usr/local/bin/pip3"
    "/usr/local/bin/pip${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/pydoc3"
    "/usr/local/bin/pydoc${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/pygmentize"
    "/usr/local/bin/python3"
    "/usr/local/bin/python${PYTHON_MAJOR_VERSION}"
    "/usr/local/bin/python3-config"
    "/usr/local/bin/python${PYTHON_MAJOR_VERSION}-config"
    "/usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}.pc"
)

for file in "${files[@]}"; do
    if [ -f "$file" ] || [ -d "$file" ]; then
        mod_date=$(stat --format='%y' "$file")
        printf "%-60s %s\n" "$file:" "$mod_date"
    else
        printf "%-60s %s\n" "$file:" "not found"
    fi
done