function c=ThresholdEvolution(c,PayoffsAtT,AltersOfIatT)
% This is the process through which cooperation threshold are evolved at
% each time step.
% For each individual i select the partner(s) of this step with strictly larger payoff
% than is own. If such node exists, then the threshold of i moves in the direction of 
% the one of one of the better-off individuals, of for a value 10.


c_old=c; % alla agents act syncronously
Push=10;
        
oneslist=ones(length(c),1);
zeroslist=zeros(length(c),1);

for i=1:length(c) % for all agents i
    
    % Among the interation partners, i selects those with a payoff (strictly) higher
    % than himself.
    PayoffsAtT_temp=PayoffsAtT;
    zeroslist_this=zeroslist;
    zeroslist_this(AltersOfIatT(i,:))=1;
    tokeep=oneslist-zeroslist_this;
    PayoffsAtT_temp(tokeep==1)=-1;
    Cbetteroffpartners=c_old(PayoffsAtT_temp>PayoffsAtT(i)); % payoff of i
    if ~isempty(Cbetteroffpartners) % if there is at least one better of agent.
        rr=rand;
        
        % i receives a push in the direction of a randomly choosen better
        % off agent.
        c(i)=c(i)+(Cbetteroffpartners(ceil(rr*length(Cbetteroffpartners)))>c(i))*Push -(Cbetteroffpartners(ceil(rr*length(Cbetteroffpartners)))<c(i))*Push;
        if c(i)>100; c(i)=100; end
        if c(i)<0; c(i)=0; end
    end
end
