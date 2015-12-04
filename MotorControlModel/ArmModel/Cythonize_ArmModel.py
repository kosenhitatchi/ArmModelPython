from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [
    Extension("MuscularActivation", ["MuscularActivation.pyx"]),
    Extension("MusclesParameters", ["MusclesParameters.pyx"]),
    Extension("ArmParameters", ["ArmParameters.pyx"]),
    Extension("Arm", ["Arm.pyx"]),
   ]


'''
    1) To launch the compilation run the command :
        python Cythonize_ArmModel.py build_ext --inplace
'''
setup(

    #  ext_modules = cythonize("DevCython/*.pyx") # Complile all *.pyx file in this folder
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
###### TO DO ####

    @todo : Dependency Handling / Compile from the .py file
        Look at pyximport and *.pyxdep

        http://docs.cython.org/src/userguide/source_files_and_compilation.html#pyximport
'''

