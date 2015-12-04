import numpy as np
cimport numpy as np # import special compile-time information about the numpy module for cython

cimport MusclesParameters  # cython equivalent to c *.h
from MusclesParameters cimport MusclesParameters

cimport ArmParameters
from ArmParameters cimport ArmParameters

cdef class Arm:
    '''
    class Arm
    '''

    # ATTRIBUTE DECLARATIONS

    cdef np.ndarray state #numpy array, state vector
    cdef np.ndarray __dotq0
    cdef float dt # Pas de temps utilise pour l'experimentation
    cdef ArmParameters armP
    cdef MusclesParameters musclesP

    # Function

    cpdef setState(self, np.ndarray state)
    cpdef setDT(self, float dt)
    cpdef np.ndarray get_dotq_0(self)
    cpdef set_dotq_0(self, np.ndarray value)
    cpdef np.ndarray computeNextState(self, np.ndarray U, np.ndarray state)
    cdef np.ndarray jointStop(self,np.ndarray q)
    # @todo : define the proper output type
    cpdef mgdFull(self, np.ndarray q)
    cpdef np.ndarray jacobian(self, np.ndarray q)
    cpdef list mgdEndEffector(self, np.ndarray q)
    cpdef mgi(self, float xi, float yi)