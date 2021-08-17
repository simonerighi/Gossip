# Gossip


This Repository contains the files necessary to reproduce the data and figures used in the article "Gossip: The Social Mind Reader
to Establish Cooperation", by Simone Righi (University of Venice Ca'Foscari) and Karoly Takacs (Linkoping University).


INSTALLATION
- Copy all files in a folder.
- Open Matlab and navigate to that folder.
- The software is now ready to be run (see instructions below)


REPRODUCTION INSTRUCTIONS
To generate the data it is necessary first to run the files runner##.m (where ## is a number from 01 to 10). These launch (on a computer cluster or on a computer) the parameters explorations used to generate the outputs. There are a total of 315000 individual simulations involved, hence the reproduction time might be significant on slower computers (in the order of weeks or months). 

The runner##.m files can be directly run if the simulations are launched on the Myriad Computer cluster of University College London. If only a standard computer is available, it is necessary to follow the instructions inside each of the runner##.m scripts.

Each simulation run generates a .mat file with the results.
Once all simulations are available, it is necessary to launch the "aggregate##.m" (where ## is a number from 01 to 10). These scripts aggregate the results of each parameter explorations in a single file, making them ready to use for the visualizations.

The remaining functions and scripts are required for the good working of the scripts described in this file. The working of each of them is described in the header of the function.

Expected reproduction time on a normal computerr (of year 2021): 3/4 months.
Expected reprodcution time on a cluster computer (strongly depends on computational power): about 3 weeks.


_ HOW TO RUN THE SOFTWARE ON DATA (how to generate figures)_

The files resulting from the operations hereby described are included in the subfolder "Results" of this repository.

The figures of the main text and of the supplementary material can be all generated launching the scripts:
figure_iterations_alternative.m
figure_iterations_populationsize.m
figure_iterations_theta.m

To generate the figures:
- copy the .mat files in the same folder as the figure_* files
- Launch, one by one, the three files named above.


VERSIONS AND DEPENDENCIES:
- The simulations were run in Matlab2020b
- The simulations require the installation of the Parallel Computing ToolBox of Matlab 2020b 
- Being written in matlab, the software is platform indipendent.

Typicall install time: 1 minute

DEMO
A simple demo is available, generating the baseline results reported in Figure 1 of the main text. 
Once the software is installed launch the script "demo.m"

Expected output: a figure reporting the baseline results of the model (figure 1 of the main text).

typical running time on a normal computer: 10 minutes.





