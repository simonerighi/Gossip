% This script loads and aggregates in a single file all the single
% simulation files generated by the cluster for the simulation made through
% the runner05 script.

clear all

Niter=100;

initial=1;
final=1;
maxval=60;
sstep=1;

prop_coop_good=zeros(maxval,Niter);
prop_coop_good(:,:)=NaN;
touched_good=zeros(maxval,Niter);
touched_good(:,:)=NaN;

Simnamebase='OutDatedInfoVsAmountGossip_theta';

while initial<=maxval
    [initial final]
    
    SimName=[Simnamebase '_' num2str(initial) '_' num2str(final) '.mat']; %create name file
    if isfile(SimName)
        SimName
        load(SimName); %load file
        
        
        for i=initial:final
            for iter=1:Niter
                if touched(i,iter)==1
                    prop_coop_good(i,iter)=prop_coop(i,iter);
                    touched_good(i,iter)=touched(i,iter);
                end
            end
        end
        
    end
    initial=initial+sstep;
    final=final+sstep;
    if final>maxval; final=maxval; end

    
end


clear prop_coop touched
touched=touched_good;
prop_coop=prop_coop_good;
clear prop_coop_good touched_good


save([Simnamebase '.mat']);