% This script runs on a cluster (Myriad of UCL) the simulations concerning
% the alternative methods of selecting a partner and a target for gossip.
% In particular it produces the data for the analysis of the trade-off
% between the amount of gossip and the memory length (section 1.5 of
% supplementary material).
% It also generates the figure 3 of the main text.
% If a cluster it is not available it is sufficient to substitute
% istructions from line 27 to line 88 with the call to the function:
% MemoryVsAmountGossip_alternative(initial,final,iter);
% The function generates one .mat file for each 100 simulations, which can
% be then aggregated in a single mat file with the aggregate04.m script.


clear all

startpos=[1 10 20 30 40 50 60 70 80 90];
endpos=[9 19 29 39 49 59 69 79 89 99];

initial=1;
final=1;
maximumvalue=1584;
c = parcluster ('LegionGraceMyriadProfileR2018b');
while initial<=maximumvalue
    display(['Initial: ' num2str(initial)])
    for a=1:10
        for iter=startpos(a):endpos(a)
            
            myJob1 = createJob (c);
            myJob1.AttachedFiles = {
                'Compute_Payoffs.m'
                'Gossip_fct.m'
                'Gossip_fct_temporal.m'
                'MemoryExploration.m'
                'MemoryExploration_populationSize.m'
                'MemoryExploration_theta.m'
                'MemoryVsAmountGossip.m'
                'OutDatedInfoVsAmountGossip.m'
                'OutDatedInfoVsAmountGossip_populationsize.m'
                'OutDatedInfoVsAmountGossip_theta.m'
                'RegLatt.m'
                'RegLattRecall.m'
                'ThresholdEvolution.m'
                'TimeGraphs.m'
                'baseline.m'
                'baseline_probes.m'
                'choose_proportionally.m'
                'chose_gossip_partner.m'
                'chose_gossiped_agent.m'
                'compute_final_payoffs.m'
                'compute_move.m'
                'deridda_index.m'
                'diversity.m'
                'errorbarlogx.m'
                'fct_ContentOfGossip_temporal_populationsize.m'
                'figure_iterations.m'
                'gossip_effect.m'
                'main_regular_evolve.m'
                'makeringlatticeCIJ.m'
                'mtit.m'
                'passage_of_info.m'
                'polarization.m'
                'random_coupling.m'
                'random_coupling_2.m'
                'randomizer_bin_und.m'
                'randomizer_bin_und2.m'
                'reputation_evolution.m'
                'sequence1.m'
                'similarity.m'
                'simpleRUpdate.m'
                'turn_names_into_numbers.m'
                'untitled.m'
                'varianceR.m'
                'MemoryExploration_populationSize.m'
                'MemoryExploration_theta.m'
                'MemoryVsAmountGossip_alternative.m'
                'OutDatedInfoVsAmountGossip_alternative.m'
                'MemoryExploration_alternative.m'
                'ContentOfGossip_alternative.m'
                'OutDatedInfoVsAmountGossip.m'
                'ContentOfGossip_temporal.m'
                'ContentOfGossip_temporal_theta.m'
                'OutDatedInfoVsAmountGossip_theta.m'
                'OutDatedInfoVsAmountGossip_populationsize.m'};
            
            
            task = createTask (myJob1, @MemoryVsAmountGossip_alternative, 0, {initial,final,iter});
            submit (myJob1);
            clear myJob1 task
        end
    end
    initial=initial+1;
    final=final+1;
    if final>maximumvalue; final=maximumvalue; end
    if initial>maximumvalue; break; end
end

