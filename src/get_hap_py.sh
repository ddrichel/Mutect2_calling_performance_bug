#/bin/bash

## note that hap.py requires python 2, version >2.7.8
mkdir -p hap_py
mkdir -p hap_py_install
git clone https://github.com/Illumina/hap.py.git ../hap_py/
cd ../hap_py/
python install.py ../hap_py_install
cd ../src/
