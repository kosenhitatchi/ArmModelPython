#!/bin/sh
./method_compilation_cython/clear_build.sh #Remove all file from compilation
clear
python method_compilation_cython/Cythonize_ArmModel.py build_ext --inplace #Lauch the compilation of the module ArmModel
rm -r build #On supprime les fichiers temporaires de compilations
