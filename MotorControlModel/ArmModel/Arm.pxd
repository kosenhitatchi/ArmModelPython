import numpy as np
cimport numpy as np # import special compile-time information about the numpy module for cython


from ArmModel.MusclesParameters cimport MusclesParameters

from ArmModel.ArmParameters cimport ArmParameters


cdef class Arm:
    '''
    class Arm
    '''

    # ATTRIBUTE DECLARATIONS

    # @todo : set the type in the array

    # cdef np.ndarray[np.float_t, ndim=1]  state #numpy array, state vector
    # cdef np.ndarray[np.float_t, ndim=1] dotq

    cdef np.ndarray state #numpy array, state vector
    cdef np.ndarray __dotq0

    cdef float dt # Pas de temps utilise pour l'experimentation
    cdef ArmParameters armP
    cdef MusclesParameters musclesP

    # Function

    cpdef setState(self, np.ndarray[np.float_t, ndim=1]  state)
    cpdef np.ndarray[np.float_t, ndim=1] getState(self)

    cpdef np.ndarray[np.float_t, ndim=1] get_dotq_0(self)
    cpdef set_dotq_0(self, np.ndarray dotq_0)

    cpdef setDT(self, float dt)
    cpdef float getDT(self)


    cdef ArmParameters get_ArmParameters(self)
    cdef MusclesParameters get_MusclesParameters(self)

    # @todo : set the type of U in the array
    cpdef np.ndarray[np.float_t, ndim=1] computeNextState(self, np.ndarray  U, np.ndarray[np.float_t, ndim=1]  state)
    cdef np.ndarray[np.float_t, ndim=1] jointStop(self,np.ndarray[np.float_t, ndim=1] q)

    # @todo : solve "[np.float_t, ndim=1] q" dimension problem
    cpdef tuple mgdFull(self, np.ndarray q)
    cpdef np.ndarray[np.float_t, ndim=2]jacobian(self, np.ndarray[np.float_t, ndim=1] q)
    cpdef list mgdEndEffector(self, np.ndarray[np.float_t, ndim=1] q)
    cpdef tuple mgi(self, float xi, float yi)
