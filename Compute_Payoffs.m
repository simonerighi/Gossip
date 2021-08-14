function [payoff_ego, payoff_alter]= Compute_Payoffs (play_ego,play_alter,Punishment,Sucker,Temptation,Reward)
% Calculate payoffs realized as consequence of agent's moves according to
% the Prisoner's dilemma payoff matrix.
%
% Inputs:
%   play_ego & play_alter: moves, in char, of the two players
%   Payoffs types, i.e.: Punishment,Sucker,Temptation,Reward (by changing
%   them we can have different social dilemmas.
%
% Outputs: 
%   payoff_ego & payoff_alter: Payoffs of the two agents
%
% Created by Simone Righi 10/01/2013 


%if play_ego ~='D' && play_ego  ~='C' 
%    error('Players strategies can only be either C or D');
%end
%if play_alter ~='D' && play_alter ~='C'
%    error('Players strategies can only be either C or D');
%end


if play_ego==-1 % if ego plays D
    if play_alter==-1 % and alter plays D
        payoff_ego=Punishment; % they both get punished
        payoff_alter=Punishment;
    else % if alter plays C he is the sucker
        payoff_ego=Temptation;
        payoff_alter=Sucker;
    end
else % if ego plays C
    if play_alter==-1 % and alter D
        payoff_ego=Sucker; % ego is the sucker
        payoff_alter=Temptation;
    else % if alter plays C
        payoff_ego=Reward; % they are rewarded
        payoff_alter=Reward;
    end
end
        
        


