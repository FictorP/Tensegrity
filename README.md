# Tensegrity
MATLAB scripts for tensegrity systems

This work is part of the PhD thesis entitled "Statics, form-finding and dynamics of tensegrity systems" authored by Victor Paiva, advised by Dr. Paulo Kurka and co-advised by Dr. Jaime Izuka at the Universidade Estadual de Campinas UNICAMP (Brazil). 

Contact: victorasmpaiva@gmail.com

# Form-finding
The article entitled "A form-finding method for deployable tensegrity arms and inverse kinematics" published in Meccanica integrates the thesis as a chapter. Please access https://link.springer.com/article/10.1007/s11012-024-01880-5 for a full description of the method and consider citing our work.


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


# Tensegrity beam
The article entitled "A Dynamical Model for the Control of a Guyed Tensegrity Beam Under Large Displacements" published in the Journal of Mechanisms and Robotics integrates the thesis as a chapter. Please access https://asmedigitalcollection.asme.org/mechanismsrobotics/article-abstract/16/9/091004/1192603 for a full description of the method and consider citing our work.


Scripts descriptions:

torreModalImpressa.m - Solves the modal analysis of the structure in configurations 0 to 4 and plots their modes.

torreModalImpressaAuto.m - Solves the modal analysis of the structure in all intermediate configurations and plots their frequencies.

torreModalImpressa.txt - AnsysAPSL script to solves the nonlinear static and modal analyses of the structure in configurations 0 to 4.

loads148.mat - Intermediate loads.

CoSim148.mat - Intermediate node coordinates found by the static model

estaticaImpressaFinal.m - Solves the nonlinear static analysis

densidadeForca.m - Calculates the force densities of all members

calculaKsig.m - Calculates the stiffness matrix

incidencia.m - Converts incidence to connectivity

circle.m - Auxiliary function to generate a circle in the plot



