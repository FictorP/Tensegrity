# Tensegrity
MATLAB scripts for tensegrity systems

This work is part of the PhD thesis entitled "Statics, form-finding and dynamics of tensegrity systems" authored by Victor Paiva, advised by Dr. Paulo Kurka and co-advised by Dr. Jaime Izuka at the Universidade Estadual de Campinas UNICAMP (Brazil). The article entitled "A form-finding method for deployable tensegrity arms and inverse kinematics" published in Meccanica integrates the thesis as a chapter. Please access https://link.springer.com/article/10.1007/s11012-024-01880-5 for a full description of the method and consider citing our work.

Scripts descriptions:
ffQuad.m - Solves the form-finding problem of a counterclockwise quadruplex tensegrity by nonlinear programming 
ffQuadNEG.m - Solves the form-finding problem of a clockwise quadruplex tensegrity by nonlinear programming 
nonLinSys.m - Runs the nonlinear system of equations associated with a counterclockwise quadruplex tensegrity module
nonLinSysNEG.m - Runs the nonlinear system of equations associated with a clockwise quadruplex tensegrity module
ffArmS.m - Calls ffQuad.m and ffQuadNEG.m to solve the form-finding problem of a stacking of quadruplex modules
plotTensegrity.m - Plots a tensegrity structure using plot3()
surfFit20.m - Surface fit of the mechanism workspace
vallp.mat - Stores 2875 raw sets of vertical cables
tnmpallp.mat - Stores 2875 raw top node mean (end-effector) coordinates
codmyNNFtrainbr10l5s.m - Neural network trained function for inverse kinematics
main.m - Calls other functions to create some of the plots published in the paper

Contact: victorasmpaiva@gmail.com
