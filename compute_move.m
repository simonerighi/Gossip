function play_ego=compute_move(ego,c,RankAltersI,noise,knowsof,RankAltersJ,alter,type_comunication,Cstore,Rstore,info_always_uptodate)
% Compute the move that the agent called ego will play. 
% The strategy to decide depeds on the content of gossip choosen
% (type_comunication) and on whether agent ego knows R or C of alter.


% if the information acquired with gossip is always kept up-to-date, i rely
% on the current R and C matrices to condition behaviour...
if info_always_uptodate==1
    switch type_comunication
        case 0 % j passes the R_jz to i, so that i can update R_iz (nothing changes here as the only thing that matter in this case is the adaptation of own treshold
            if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                play_ego=1;
            else
                play_ego=-1;
            end
            return
        case 1 %rep= j passes to i the reputation that z has
            % of i: Rzi, i can then condition on its
            % behaviour on what the other believes,
            % projecting his threshold on him
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                if RankAltersI>=c(ego) && RankAltersJ>c(ego)  % cooperate if R of the other is is sufficiently high compared to my threshold
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end        
        case 2 % all= j passes to i the reputation that z has
            % of i and c_z as well. Perfect information
            
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                noisedR=RankAltersJ+randn*noise(1); % i introduce the noise for R (checking also that is within 0 and 100).
                if noisedR<0; noisedR=0; end
                if noisedR>100; noisedR=100; end
                noisedC=c(alter)+randn*noise(2); % i introduce the noise for C (checking also that is within 0 and 100).
                if noisedC<0; noisedC=0; end
                if noisedC>100; noisedC=100; end
                if RankAltersI>=c(ego) && noisedR>noisedC  % cooperate if R is sufficiently high w.r.t own threshold and accounting for noisy info.
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end
            
        otherwise %onc= j passes to i the threshold of z. I can project his R_iz onto the other guy
            % projecting his threshold on him
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                if RankAltersI>=c(ego) && RankAltersI>c(alter)  % cooperate if R of the other is is sufficiently high compared to my threshold
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end
            
    end
    
else % if information is not always uptodate, then i rely on the historical data, from the last gossip received on a person.
    
    switch type_comunication
        case 0 % j passes the R_jz to i, so that i can update R_iz (nothing changes here as the only thing that matter in this case is the adaptation of own treshold
            if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                play_ego=1;
            else
                play_ego=-1;
            end
            return
        case 1 %rep= j passes to i the reputation that z has
            % of i: Rzi, i can then condition on its
            % behaviour on what the other believes,
            % projecting his threshold on him
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                if RankAltersI>=c(ego) && Rstore(ego,alter)>c(ego)  % cooperate if R of the other is is sufficiently high compared to my threshold
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end
            
            
            
        case 2 % all= j passes to i the reputation that z has
            % of i and c_z as well. Perfect information
            
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                noisedR=Rstore(ego,alter)+randn*noise(1); % i introduce the noise for R (checking also that is within 0 and 100).
                if noisedR<0; noisedR=0; end
                if noisedR>100; noisedR=100; end
                noisedC=Cstore(ego,alter)+randn*noise(2); % i introduce the noise for C (checking also that is within 0 and 100).
                if noisedC<0; noisedC=0; end
                if noisedC>100; noisedC=100; end
                if RankAltersI>=c(ego) && noisedR>noisedC  % cooperate if R is sufficiently high w.r.t own threshold and accounting for noisy info.
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end
            
        otherwise %onc= j passes to i the threshold of z. I can project his R_iz onto the other guy
            % projecting his threshold on him
            if knowsof==0
                if RankAltersI>=c(ego)  % cooperate if R is sufficiently high
                    play_ego=1;
                else
                    play_ego=-1;
                end
            else
                if RankAltersI>=c(ego) && RankAltersI>Cstore(ego,alter)  % cooperate if R of the other is is sufficiently high compared to my Rij
                    play_ego=1;
                else
                    play_ego=-1;
                end
            end
            
    end
end

