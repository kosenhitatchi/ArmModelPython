#!/bin/sh
rm -f *.so *.c #Remove all file from compilation
rm -fr build/

find . -name "*.pyc" -type f -delete # clear all *.pyc in the subdirectory (compiled python file resulted from execution) 
find . -name "*.so" -type f -delete  # clear all *.so in the subdirectory (cython compiled files)


