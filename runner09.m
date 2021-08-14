% This script runs on a cluster (Myriad of UCL) the simulations concerning
% the effect of population size on the evolution of the model.
% In particular it produces the data for the analysis of the relationship between
% the amount of gossip and wether the information acquired with gossip remains up to date or not
% (section 2.3 of supplementary material).
% If a cluster it is not available it is sufficient to substitute
% istructions from line 21 to line 88 with the call to the function:
% OutDatedInfoVsAmountGossip_theta(init,fin,iter);
% The function generates one .mat file for each 100 simulations, which can
% be then aggregated in a single mat file with the aggregate09.m script.

clear all

init=1;
fin=1;
maximumval=2*6*5;


while init<=maximumval
    display(['Initial: ' num2str(init)])
    for iter=1:100
        display(['iter: ' num2str(iter)])
        
        
        c = parcluster ('LegionGraceMyriadProfileR2018b');
        myJob1 = createCommunicatingJob (c, 'Type', 'Pool');
        num_workers = 1;
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
        myJob1.NumWorkersRange = [1, 1];
        task = createTask (myJob1, @OutDatedInfoVsAmountGossip_populationsize, 0, {init,fin,iter});
        submit (myJob1);
        clear myJob1 c task
        disp('...Done');
        
    end
    init=init+1;
    fin=fin+1;
    if fin>maximumval; fin=maximumval; end
    if init>maximumval; break; end
end
