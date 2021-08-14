# Gossip

This Repository contains the files necessary to reproduce the data and figures used in the article "Gossip: The Social Mind Reader and The Social Mirror
to Establish Cooperation", by Simone Righi (University of Venice Ca'Foscari) and Karoly Takacs (Linkoping University).

To obtain the data it is necessary first to run the files runner##.m (where ## is a number from 01 to 10). These launch (on a computer cluster or on a computer) the parameters explorations used to generate the outputs. There are a total of 315000 individual simulations involved, hence the reproduction time might be significant on slower computers (in the order of weeks or months). 

The runner##.m files can be directly run if the simulations are launched on the Myriad Computer cluster of University College London. If only a computer is available, it is necessary to follow the instructions inside each of the runner##.m scripts.

Each simulation run generates a .mat file with the results.
Once all simulations are available, it is necessary to launch the "aggregate##.m" (where ## is a number from 01 to 10). These scripts aggregate the results of each parameter explorations in a single file, making them ready to use for the visualizations.

For completeness the files resulting from the operations hereby described are included in the subfolder "Results" of this repository.

The figures of the main text and of the supplementary material can be all generated launching the scripts:
figure_iterations_alternative.m
figure_iterations_populationsize.m
figure_iterations_theta.m

The remaining functions and scripts are required for the good working of the scripts described in this file. The working of each of them is described in the header of the function.



