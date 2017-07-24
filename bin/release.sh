#!/usr/bin/env bash

python setup.py sdist upload -r pypitest
python setup.py sdist upload -r pypimain

