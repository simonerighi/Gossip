function [type_comunication,type_choice_gossiped,type_choice_gossip_partner]=turn_names_into_numbers_fig(type_comunication,type_choice_gossiped,type_choice_gossip_partner)
% this is a simple function to change the letters (easier to input and to
% remember) into numbers (faster to manipulate).
% this is a marginally different version  of turn_names_into_numbers used in the context of figure
% creation. 


                           
if type_comunication=='riz'
    type_comunication=0;
elseif type_comunication=='rep'
    type_comunication=1;
elseif type_comunication=='all';
    type_comunication=2;
else %type_comunication=='onc';
    type_comunication=3;
end                           
                           
                           
                           
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