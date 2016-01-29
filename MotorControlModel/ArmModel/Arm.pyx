#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Author: Thomas Beucher
Cythonisation: Remi Cambuzat

Module: MusclesParameters

Description:    -We find here all muscles parameters
                -we use a model of arm with two joints and six muscles
'''
import numpy as np
cimport numpy as np # import special compile-time information about the numpy module for cython

import math


from ArmModel.MusclesParameters cimport MusclesParameters

from ArmModel.ArmParameters cimport ArmParameters


# @todo : define the proper output type
cpdef getDotQAndQFromStateVector(np.ndarray[np.float_t, ndim=1]  state):
      '''
      Returns dotq and q from the state vector state

      Input:    -state: numpy array, state vector

      Outputs:    -dotq: numpy array
      -q: numpy array
      '''

      cdef np.ndarray[np.float_t, ndim=1] dotq = np.array([state[0], state[1]],dtype = np.float_)
      cdef np.ndarray[np.float_t, ndim=1] q = np.array([state[2], state[3]],dtype = np.float_)

      return dotq,q

#-----------------------------------------------------------------------------

cdef class Arm:
    '''
    class Arm
    '''

    # ATTRIBUTE DECLARATIONS in Arm.pxd

    def __init__(self):
        print("init Arm")
        self.__dotq0 = np.array([0.,0.],dtype = np.float_)

        self.armP = ArmParameters()
        self.musclesP = MusclesParameters()

    # --- state ---

    cpdef setState(self, np.ndarray[np.float_t, ndim=1]  state):
        self.state = state

    cpdef np.ndarray[np.float_t, ndim=1] getState(self):
        return self.state

    # --- __dotq0 ---

    cpdef np.ndarray[np.float_t, ndim=1] get_dotq_0(self):
        return np.array(self.__dotq0)

    cpdef set_dotq_0(self,np.ndarray dotq_0):
        self.__dotq0 = dotq_0

    # --- dt ---

    cpdef setDT(self, float dt):
        self.dt = dt

    cpdef float getDT(self):
        return self.dt

    # --- ArmParameters &  MusclesParameters ---

    cdef ArmParameters get_ArmParameters(self):
        return self.armP

    cdef MusclesParameters get_MusclesParameters(self):
        return self.musclesP


    cpdef np.ndarray[np.float_t, ndim=1] computeNextState(self, np.ndarray U, np.ndarray[np.float_t, ndim=1]  state):
        '''
        Computes the next state resulting from the direct dynamic model of the arm given the muscles activation vector U

        Inputs:     -U: (6,1) numpy array
        -state: (4,1) numpy array (used for Kalman, not based on the current system state)

        Output:    -state: (4,1) numpy array, the resulting state
        '''
        #print ("state:", state)
        cdef np.ndarray[np.float_t, ndim=1] dotq, q
        dotq,q= getDotQAndQFromStateVector(state)
        # print ("U :",U)
        # print ("q:",q)
        # print ("dotq:",dotq)
        cdef np.ndarray[np.float_t, ndim=2] M = np.array([[self.armP.k1+2*self.armP.k2*math.cos(q[1]),self.armP.k3+self.armP.k2*math.cos(q[1])],[self.armP.k3+self.armP.k2*math.cos(q[1]),self.armP.k3]],dtype = np.float_)
        # print ("M:",M)
        cdef np.ndarray[np.float_t, ndim=2] Minv = np.linalg.inv(M)
        # print ("Minv:",Minv)
        cdef np.ndarray[np.float_t, ndim=1] C = np.array([-dotq[1]*(2*dotq[0]+dotq[1])*self.armP.k2*math.sin(q[1]),(dotq[0]**2)*self.armP.k2*math.sin(q[1])],dtype = np.float_)
        # print ("C:",C)
        #the commented version uses a non null stiffness for the muscles
        #beware of dot product Kraid times q: q may not be the correct vector/matrix
        #Gamma = np.dot((np.dot(armP.At, musclesP.fmax)-np.dot(musclesP.Kraid, q)), U)
        #Gamma = np.dot((np.dot(self.armP.At, self.musclesP.fmax)-np.dot(self.musclesP.Knulle, Q)), U)
        #above Knulle is null, so it can be simplified

        cdef np.ndarray[np.float_t, ndim=1]  Gamma = np.dot(np.dot(self.armP.At, self.musclesP.fmax), U)
        # print ("Gamma:",Gamma)

        # Gamma = np.dot(armP.At, np.dot(musclesP.fmax,U))
        # #computes the acceleration ddotq and integrates

        cdef np.ndarray[np.float_t, ndim=1] b = np.dot(self.armP.B, dotq)
        #print ("b:",b)

        cdef np.ndarray[np.float_t, ndim=1] ddotq = np.dot(Minv,Gamma - C - b)
        #print ("ddotq",ddotq)

        dotq += ddotq*self.dt
        q += dotq*self.dt
        #save the real state to compute the state at the next step with the real previous state
        q = self.jointStop(q)
        cdef np.ndarray[np.float_t, ndim=1] nextState = np.array([dotq[0], dotq[1], q[0], q[1]],dtype = np.float_)

        return nextState

    cdef np.ndarray[np.float_t, ndim=1] jointStop(self,np.ndarray[np.float_t, ndim=1] q):
        '''
        Articular stop for the human arm
        The stops are included in the arm parameters file
        Shoulder: -0.6 <= q1 <= 2.6
        Elbow: -0.2 <= q2 <= 3.0

        Inputs:    -q: (2,1) numpy array

        Outputs:    -q: (2,1) numpy array
        '''
        if q[0] < self.armP.slb:
            q[0] = self.armP.slb
        elif q[0] > self.armP.sub:
            q[0] = self.armP.sub
        if q[1] < self.armP.elb:
            q[1] = self.armP.elb
        elif q[1] > self.armP.eub:
            q[1] = self.armP.eub
        return q

    # @todo : define the proper output type
    cpdef tuple mgdFull(self, np.ndarray q):
        '''
        Direct geometric model of the arm

        Inputs:     -q: (2,1) numpy array, the joint coordinates

        Outputs:
        -coordElbow: elbow coordinate
        -coordHand: hand coordinate
        '''
        cdef list coordElbow = [self.armP.l1*np.cos(q[0]), self.armP.l1*np.sin(q[0])]
        cdef list coordHand = [self.armP.l1*np.cos(q[0])+self.armP.l2*np.cos(q[0] + q[1]), self.armP.l1*np.sin(q[0]) + self.armP.l2*np.sin(q[0] + q[1])]
        return coordElbow, coordHand

    cpdef np.ndarray[np.float_t, ndim=2] jacobian(self, np.ndarray[np.float_t, ndim=1] q):

        cdef np.ndarray[np.float_t, ndim=2] J = np.array([
                    [-self.armP.l1*np.sin(q[0]) - self.armP.l2*np.sin(q[0] + q[1]),
                     -self.armP.l2*np.sin(q[0] + q[1])],
                    [self.armP.l1*np.cos(q[0]) + self.armP.l2*np.cos(q[0] + q[1]),
                     self.armP.l2*np.cos(q[0] + q[1])]],dtype = np.float_)
        return J

    cpdef list mgdEndEffector(self, np.ndarray[np.float_t, ndim=1] q):
          '''
          Direct geometric model of the arm

          Inputs:     -q: (2,1) numpy array, the joint coordinates

          Outputs:
          -coordHand: hand coordinate
          '''
          cdef list coordHand = [self.armP.l1*np.cos(q[0])+self.armP.l2*np.cos(q[0] + q[1]), self.armP.l1*np.sin(q[0]) + self.armP.l2*np.sin(q[0] + q[1])]
          return coordHand

    cpdef tuple mgi(self, float xi, float yi):
          '''
          Inverse geometric model of the arm

          Inputs:     -xi: abscissa of the end-effector point
                  -yi: ordinate of the end-effectior point

          Outputs:
                  -q1: arm angle
                  -q2: foreArm angle
          '''
          cdef float a = ((xi**2)+(yi**2)-(self.armP.l1**2)-(self.armP.l2**2))/(2*self.armP.l1*self.armP.l2)
          cdef float q2,c,d,q1
          try:
            q2 = math.acos(a)
            c = self.armP.l1 + self.armP.l2*(math.cos(q2))
            d = self.armP.l2*(math.sin(q2))
            q1 = math.atan2(yi,xi) - math.atan2(d,c)
            return (q1, q2)
          except ValueError:
            print("forbidden value")
            print xi,yi
            return None
