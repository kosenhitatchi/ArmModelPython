from distutils.core import setup
from Cython.Build import cythonize

'''
    1) To launch the compilation run the commend :
        python Cythonize_ArmModel.py build_ext --inplace
'''
setup(
    # Complile all *.pyx file in this folder
     ext_modules = cythonize("ArmModel/*.pyx")
)

'''
    @todo : Dependency Handling / Compile from the .py file
        Look at pyximport and *.pyxdep

        http://docs.cython.org/src/userguide/source_files_and_compilation.html#pyximport
'''
