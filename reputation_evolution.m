function  R=reputation_evolution(play_ego,play_alter,R_old,ego,alter,Push)
% This function updates the reputation, under the condition that 
% players didn't both defect (otherwise it remains the same).

if ~(play_ego==-1 && play_alter==-1)
    R=simpleRUpdate(R_old(ego,alter),play_alter*100,Push);
else
    R=R_old(ego,alter);
end