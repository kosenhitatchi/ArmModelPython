import numpy as np
import os

print("--------------Muscles---------------")

print("--toto--")

import ArmModel
from ArmModel import MusclesParameters as MusclesParam
from ArmModel import ArmParameters as ArmParam
# from ArmModel import Arm


Muscles = MusclesParam.MusclesParameters()

print("--------------ArmParam---------------")

ArmParam = ArmParam.ArmParameters()

print("--------------Arm---------------")

U = np.array([0,1,2,3,4,5])
state = np.array([00,11,22,33])

print(U,state)

# import ArmModel.Arm
# arm1 = Arm.Arm()

# dotq1,q1 = ArmModel.Arm.getDotQAndQFromStateVector(state)
# print dotq1
# print q1

# print ("Compute Next state : ",arm1.computeNextState(U, state))







