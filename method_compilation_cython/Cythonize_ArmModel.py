from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

import numpy #
#
# extensions = [
#     Extension("MuscularActivation", ["MuscularActivation.pyx"]),
#     Extension("MusclesParameters", ["MusclesParameters.pyx"]),
#     Extension("ArmParameters", ["ArmParameters.pyx"]),
#     Extension("Arm", ["Arm.pyx"]),
#    ]


'''
    1) To launch the compilation run the command :
        python Cythonize_ArmModel.py build_ext --inplace
'''

extensions = [
    Extension("*", #  '*' sinon genere un 'mon_extension.so' (shared object) a la racine
              ["MotorControlModel/ArmModel/*.pyx"], #will all commpile all *.pyc in the directory
              include_dirs=[numpy.get_include()], #include the numpyPy directory path
              extra_compile_args=["-w"] # Option de comilation pour GCC : ici supprimer les warning
    )
    # D'autre Extension peuvent se trouver ici, pour des compilation avec d'autre parametres ou d'autre module a compiler
    # ...

]

setup(
	name = 'my cython app',
    ext_modules = cythonize(extensions)
)

'''
###### Important ####

The *.so files have to be at the root of the package folder (here /ArmModel),
otherwise it wont be possible to import them with : import ArmModel;

To check with module are inside the package, run at ../ArmModel :
    >> Python
    >> import ArmModel
    >> help(ArmModel)     # Display the PACKAGE CONTENTS

        PACKAGE CONTENTS
            Arm
            ArmParameters
            Cythonize_ArmModel
            MusclesParameters
            MuscularActivation
'''
'''
######### Documentation #####

    Documentation compilation cython:
        http://docs.cython.org/src/reference/compilation.html

    Information la classe Extension (distutils documentation) :
        https://docs.python.org/2/extending/building.html

    ARgument de compilation pour gcc:
        https://gcc.gnu.org/onlinedocs/gcc-3.4.4/gcc/Invoking-GCC.html#Invoking-GCC

'''

'''
###### TO DO ####

    @todo : Dependency Handling / Compile from the .py file
        Look at pyximport and *.pyxdep :

        If " import pyximport; pyximport.install() " is in toto.pyx, the compilation will be done for every new version of this file at startup ( no need of Cythonize_ArmModel.py anymore)
        However this compilation won't handle complex case, like import of external c-libraries

        http://docs.cython.org/src/userguide/source_files_and_compilation.html#pyximport
        http://docs.cython.org/src/reference/compilation.html#compiling-with-pyximport
'''

