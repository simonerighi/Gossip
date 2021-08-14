% This script loads and aggregates in a single file all the single
% simulation files generated by the cluster for the simulation made through
% the runner01 script.

clear all

Niter=100;

initial=1;
final=3;
maxval=97;
sstep=3;

prop_coop_good=zeros(maxval,Niter,1000);
prop_coop_good(:,:,:)=NaN;
touched_good=zeros(maxval,Niter);
touched_good(:,:)=NaN;

Simnamebase='ContentOfGOssip_alternative';

while initial<=maxval
    [initial final]
    
    SimName=[Simnamebase '_' num2str(initial) '_' num2str(final) '.mat']; %creo nome file
    if isfile(SimName)
        SimName
        load(SimName); %caricofile
    end
    
    for i=initial:final
            for iter=1:Niter
                if touched(i,iter)==1
                    prop_coop_good(i,iter,:)=prop_coop(i,iter,:);
                    touched_good(i,iter)=touched(i,iter);
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