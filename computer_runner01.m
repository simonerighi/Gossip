% This script runs on a cluster (Myriad of UCL) the simulations concerning
% the alternative methods of selecting a partner and a target for gossip.
% In particular it produces the data for the temporal analyses (section 1.1
% of Supplementary material), and the relative distributions (sections 1.2 and 1.3).
% It also generates the figure 1 of the main text).
% If a cluster it is not available it is sufficient to substitute
% istructions from line 12 to line 76 with the call to the function:
% ContentOfGossip_alternative(initial,final);
% The function generates one .mat file for each 100 simulations, which can
% be then aggregated in a single mat file with the aggregate01.m script.

clear all
initial=2;
final=4;
while initial<=97
    initial
    ContentOfGossip_alternative(initial,final);
    
    initial=initial+3;
    final=final+3;
    if final>97; final=97; end
end
