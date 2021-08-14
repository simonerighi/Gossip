% This function generates the figures that explore the effect of the
% size of the reputation change taking place after an interaction. 
% Figures are reported in section 3 of the supplementary material.


clear all
close all
clc
load ContentOfGOssip_theta.mat

commstypes=['riz';'rep';'all';'onc'];
gossiptarget=['ri';'rp';'su';'hr';'si';'rj'];
gossippartnertypes=['ra';'pr';'ri';'pi'];

commstypes_num=[0 1 2 3];
gossiptarget_num=[0 1 2 3 4 5];
gossippartnertypes_num=[0 1 2 3];
% introduce fist simulation without gossip

cooperation_levels_mean=squeeze(mean(prop_coop,3)); % I average on simulations
cooperation_levels_std=squeeze(std(prop_coop,0,3)); % note here i compute the std across simulation
time=[1:tmax];



numfig=1;
for j=1:5       
        figure(numfig)
        semilogx(time,squeeze(cooperation_levels_mean(1,j,:)),'b','Linewidth',3); %,cooperation_levels_std(1,:)
        hold on
        semilogx(time,squeeze(cooperation_levels_mean(2,j,:)),'k','Linewidth',3); % ,cooperation_levels_std(2,:)
        hold on
        semilogx(time,squeeze(cooperation_levels_mean(3,j,:)),'r','Linewidth',3); %,cooperation_levels_std(3,:)
        hold on
        ax = gca; % current axes
        ax.FontSize = 14;
        title({'Average cooperation level for'; 'different contents of gossip'; ['\theta = ' num2str(DDeltaR(j))]},'FontSize',20);
        ylabel('Proportion of Cooperation','FontSize',20);
        xlabel('Time','FontSize',20);
        legend('no gossip','Pass R_{zi} and c_z','Pass only C_z','location','northwest');
        name_file=['Temporal_Fig1_theta_' num2str(round(DDeltaR(j)*100))];
        saveas(numfig,name_file,'png')
        
        numfig=numfig+1;
        figure(numfig)
        subplot(1,3,1)
        histogram(prop_coop(1,j,:,1000));
        ax = gca;
        ax.FontSize = 14;
        ylabel('Cooperation','FontSize',16)
        xlabel('No Gossip','FontSize',16);
        hold on
        subplot(1,3,2)
        histogram(prop_coop(2,j,:,1000));
        ax = gca;
        ax.FontSize = 14;
        xlabel('Pass R_{zi} and c_z','FontSize',16);
        hold on
        subplot(1,3,3)
        histogram(prop_coop(3,j,:,1000));
        ax = gca;
        ax.FontSize = 14;
        xlabel('Pass only C_z','FontSize',16)
        sgtitle({'Distribution of cooperation levels at t_{max}' ['\theta = ' num2str(DDeltaR(j))]}, 'FontSize',20)
        name_file=['Outcome_Fig2_theta_' num2str(round(DDeltaR(j)*100))];
        saveas(numfig,name_file,'png')
        
        numfig=numfig+1; 
        close all
end



%-----------------------------------------------
% 
clear all
close all
load OutDatedInfoVsAmountGossip_theta.mat

average_cooperation=mean(prop_coop,3);
std_cooperation=std(prop_coop,0,3);

timestheinteractions=[1 2 5 10 30 50]; % how many times the social interactiosn there is gossip?



 for i=1:2*6*5
     type_comunication(i,:)
     if type_comunication(i,:)=='riz'
         type_comunication_num(i)=0;
     elseif type_comunication(i,:)=='rep'
         type_comunication_num(i)=1;
     elseif type_comunication(i,:)=='all'
         type_comunication_num(i)=2;
     else %type_comunication=='onc';
         type_comunication_num(i)=3;
     end
     type_comunication_num(i)
     clc
 end
% 
 cooperation_levels_mean=squeeze(mean(prop_coop,2)); % I average on simulations
 cooperation_levels_std=squeeze(std(prop_coop,0,2)); % note here i compute the std across simulation
 
% 
 numfig=1;
 for i=1:length(DDeltaR_vct) % count deltas    
         index_to_print=find(DDeltaR==DDeltaR_vct(i)); % select current Delta
         gc2=find(type_comunication_num==2); % select  type of comm 2
         gc3=find(type_comunication_num==3); % select  type of comm 3
         index_to_print2=intersect(index_to_print,gc2);
         index_to_print3=intersect(index_to_print,gc3);
         
         
         coop_to_print2=cooperation_levels_mean(index_to_print2);
         coop_to_print3=cooperation_levels_mean(index_to_print3);
         
         figure(numfig)
         plot(timestheinteractions,coop_to_print2,'k','LineWidth',3); %,cooperation_levels_std(1,:)
         hold on
         plot(timestheinteractions,coop_to_print3,'b','LineWidth',3); %,cooperation_levels_std(3,:)
         hold on
         ax = gca; % current axes
         ax.FontSize = 14;
         ylim([0 1.01])
         legend('Pass R_{zi} and c_z - Info ages',...
             'Pass only C_z - Info ages',...
             'Location','southeast');
         title({'Average cooperation level for different'; 'contents of gossip and information characteristics'; ['\theta = ' num2str(DDeltaR_vct(i))]},'FontSize',20);
         ylabel('Proportion of Cooperation','FontSize',20);
         xlabel('Relative amount of gossip','FontSize',20);
         saveas(numfig,['RelativeAmountGossip_Fig4_theta_' num2str(round(DDeltaR_vct(i)*100))],'png');
         numfig=numfig+1;
 end


close all

