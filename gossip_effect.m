function R=gossip_effect(ego,alter,other,alpha,betaa,R,type_belief_update,token_info,Push)
% The information token is passed from ego to alter and alter acts upon it.
% When ego passes the information three things are possible:
% type_belief_update=='ab'==0 % ab= always believe what the gossiper says
% type_belief_update=='tr'==1 % tr= j belives i iff Rji>alpha
% type_belief_update=='bc'==2 % bc= j belives iff the information passed is
% close enough to the prior of j toward z: Rjz-I<beta
% Note: only ab is used in actual paper.
                         
if type_belief_update==0 % ab= always believe what the gossiper says
    R(ego,other)=simpleRUpdate(R(ego,other),token_info,Push);
elseif type_belief_update==1 % tr= j belives i iff Rji>alpha
    if R(alter,ego)>alpha
        R(alter,other)=simpleRUpdate(R(alter,other),token_info,Push);
    end
else   % bc= j belives iff the information passed is close enough to the prior of j toward z
    if R(alter,other) - token_info < betaa
        R(alter,other)=simpleRUpdate(R(alter,other),token_info,Push);
    end
end