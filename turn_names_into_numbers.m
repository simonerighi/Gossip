function [type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner]=turn_names_into_numbers(type_payoff,type_belief_update,type_comunication,type_choice_gossiped,type_choice_gossip_partner)
% this is a simple function to change the letters (easier to input and to
% remember) into numbers (faster to manipulate).


% type of payoff (not used in the main paper)
if type_payoff=='s' 
    type_payoff=0; 
else 
    type_payoff=1; 
end % substitute number with letters for speed


%type of belief update (not used in the main paper)
if type_belief_update=='ab'
    type_belief_update=0;
elseif type_belief_update=='tr'
    type_belief_update=1;
else
    type_belief_update=2;
end                           
                                     

% content of gossip                           
if type_comunication=='riz'
    type_comunication=0;
elseif type_comunication=='rep'
    type_comunication=1;
elseif type_comunication=='all';
    type_comunication=2;
else %type_comunication=='onc';
    type_comunication=3;
    
end                           
                           
                           
% choice of the gossip target                           
switch type_choice_gossiped
    case 'ri'
        type_choice_gossiped=0;
    case 'rp'
        type_choice_gossiped=1;
    case 'su'
        type_choice_gossiped=2;
    case 'hr'
        type_choice_gossiped=3;
    case 'si'
        type_choice_gossiped=4;
    case 'rj'
        type_choice_gossiped=5;
end


% choice of the gossip partner
switch type_choice_gossip_partner
    case 'ra'
        type_choice_gossip_partner=0;
    case 'pr'
        type_choice_gossip_partner=1;
    case 'ri'
        type_choice_gossip_partner=2;
    case 'pi'
        type_choice_gossip_partner=3;
end