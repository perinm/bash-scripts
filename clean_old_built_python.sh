#!/bin/bash

PYTHON_MAJOR_VERSION=3.12
PYTHON_MINOR_VERSION=1

rm -f /usr/local/bin/python${PYTHON_MAJOR_VERSION}
rm -f /usr/local/bin/pip${PYTHON_MAJOR_VERSION}
rm -f /usr/local/bin/pydoc
rm -rf /usr/local/bin/include/python${PYTHON_MAJOR_VERSION}
rm -f /usr/local/lib/libpython${PYTHON_MAJOR_VERSION}.a
rm -rf /usr/local/lib/python${PYTHON_MAJOR_VERSION}
rm -f /usr/local/share/man/python${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}
rm -rf /usr/local/lib/pkgconfig
rm -f /usr/local/bin/idle
rm -f /usr/local/bin/easy_install-${PYTHON_MAJOR_VERSION}
rm -r /usr/local/include/python${PYTHON_MAJOR_VERSION}
rm /usr/local/lib/pkgconfig/python3.pc
rm /usr/local/lib/pkgconfig/python3-embed.pc
rm /usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}.pc
rm /usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}-embed.pc
rm /usr/local/bin/easy_install-${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/idle3
rm /usr/local/bin/idle${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/ipython
rm /usr/local/bin/ipython3
rm /usr/local/bin/iptest
rm /usr/local/bin/iptest3
rm /usr/local/bin/2to3
rm /usr/local/bin/2to3-${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/f2py
rm /usr/local/bin/f2py3
rm /usr/local/bin/f2py${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/pip
rm /usr/local/bin/pip3
rm /usr/local/bin/pip${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/pydoc3
rm /usr/local/bin/pydoc${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/pygmentize
rm /usr/local/bin/python3
rm /usr/local/bin/python${PYTHON_MAJOR_VERSION}
rm /usr/local/bin/python3-config
rm /usr/local/bin/python${PYTHON_MAJOR_VERSION}-config
rm /usr/local/lib/pkgconfig/python-${PYTHON_MAJOR_VERSION}.pc

