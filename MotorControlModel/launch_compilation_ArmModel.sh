clear
rm ArmModel/*.so ArmModel/*.c ArmModel/*.o
python setup__ArmModel.py build_ext --inplace
rm -rf build
