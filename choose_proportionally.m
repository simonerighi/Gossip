function chosen_element=choose_proportionally(proportionalityvar)
% Chooses an element proportionally to the relative size in proportionalityvar
% if all values are 0, it returns a uniformly random number

if sum(proportionalityvar~=0)>0
    wR=proportionalityvar./sum(proportionalityvar);   % wR sums to 1
    chosen_element= find(rand <= cumsum(wR), 1);
else
    chosen_element=ceil(rand*length(proportionalityvar));
end