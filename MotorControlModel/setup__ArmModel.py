
print "compilation"
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

extensions = [
   Extension("ArmModel.MusclesParameters", ["ArmModel/MusclesParameters.pyx"]),
   Extension("ArmModel.MuscularActivation", ["ArmModel/MuscularActivation.pyx"]),
   Extension("ArmModel.ArmParameters", ["ArmModel/ArmParameters.pyx"]),
   Extension("ArmModel.Arm", ["ArmModel/Arm.pyx"]),
   ]

setup(
   ext_modules = cythonize(extensions)
)

print "compilation ended"
