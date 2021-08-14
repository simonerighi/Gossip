% This function generates the figures that explore the effect of changing
% the process through which the partner and the target for gossip are
% choosen (these are reported in the main text (for the baseline) and
% in section 1 of the supplementary material.


clear all
close all
clc
load ContentOfGOssip_alternative.mat

commstypes=['riz';'rep';'all';'onc'];
gossiptarget=['ri';'rp';'su';'hr';'si';'rj'];
gossippartnertypes=['ra';'pr';'ri';'pi'];

commstypes_num=[0 1 2 3];
gossiptarget_num=[0 1 2 3 4 5];
gossippartnertypes_num=[0 1 2 3];
% introduce fist simulation without gossip

for i=1:97
    [type_comunication_num(i),type_choice_gossiped_num(i),type_choice_gossip_partner_num(i)]=turn_names_into_numbers_fig(type_comunication(i,:),type_choice_gossiped(i,:),type_choice_gossip_partner(i,:));
end


cooperation_levels_mean=squeeze(mean(prop_coop,2)); % I average on simulations
cooperation_levels_std=squeeze(std(prop_coop,0,2)); % note here i compute the std across simulation
time=[1:tmax];

numfig=1;
for j=1:4
    for z=1:6
        gp=find(type_choice_gossip_partner_num(2:97)==gossippartnertypes_num(j));
        gt=find(type_choice_gossiped_num(2:97)==gossiptarget_num(z));
        sel_gossip_partner=intersect(gp,gt);
        type_comunication(sel_gossip_partner,:)
        
        
        figure(numfig)
        semilogx(time,cooperation_levels_mean(1,:),'b','Linewidth',3); %,cooperation_levels_std(1,:)
        hold on
        semilogx(time,cooperation_levels_mean(sel_gossip_partner(1),:),'k','Linewidth',3); % ,cooperation_levels_std(2,:)
        hold on
        semilogx(time,cooperation_levels_mean(sel_gossip_partner(2),:),'r','Linewidth',3); %,cooperation_levels_std(3,:)
        hold on
        semilogx(time,cooperation_levels_mean(sel_gossip_partner(3),:),'m','Linewidth',3); %,cooperation_levels_std(4,:)
        hold on
        semilogx(time,cooperation_levels_mean(sel_gossip_partner(4),:),'g','Linewidth',3); % ,cooperation_levels_std(5,:)
        ax = gca; % current axes
        ax.FontSize = 14;
        title({'Average cooperation level for'; 'different contents of gossip'; ['Partner Sel: ' upper(gossippartnertypes(j,:)) ' - Target Sel: '  upper(gossiptarget(z,:))]},'FontSize',20);
        ylabel('Proportion of Cooperation','FontSize',20);
        xlabel('Time','FontSize',20);
        legend('no gossip','Gossip updates R_{iz}','Pass only R_{zi}','Pass R_{zi} and c_z','Pass only C_z','location','northwest');
        name_file=['Temporal_Fig1_alternative_' gossippartnertypes(j,:) '_' gossiptarget(z,:)];
        saveas(numfig,name_file,'png')
        
        numfig=numfig+1;
        figure(numfig)
        subplot(2,3,1)
        histogram(prop_coop(1,:,1000))
        ax = gca;
        ax.FontSize = 14;
        ylabel('Cooperation','FontSize',16)
        xlabel('No Gossip','FontSize',16);
        hold on
        subplot(2,3,2)
        histogram(prop_coop(sel_gossip_partner(1),:,1000))
        ax = gca;
        ax.FontSize = 14;
        xlabel('Gossip updates R_{iz}','FontSize',16);
        hold on
        subplot(2,3,3)
        histogram(prop_coop(sel_gossip_partner(2),:,1000))
        ax = gca;
        ax.FontSize = 14;
        xlabel('Pass only R_{zi}','FontSize',16)
        subplot(2,3,4)
        ylabel('Cooperation','FontSize',16)
        histogram(prop_coop(sel_gossip_partner(3),:,1000))
        ax = gca;
        ax.FontSize = 14;
        xlabel('Pass R_{zi} and c_{z}','FontSize',16)
        subplot(2,3,5)
        histogram(prop_coop(sel_gossip_partner(4),:,1000))
        ax = gca;
        ax.FontSize = 14;
        xlabel('Pass only C_{z}','FontSize',16)
        sgtitle({'Distribution of cooperation levels at t_{max}'; ['Partner Sel: ' upper(gossippartnertypes(j,:)) ' - Target Sel: '  upper(gossiptarget(z,:))]}, 'FontSize',20)
        name_file=['Outcome_Fig2_alternative_' gossippartnertypes(j,:) '_' gossiptarget(z,:)];
        saveas(numfig,name_file,'png')
        
        numfig=numfig+1;
        close all
    end
end


%---------

clear all
close all
load OutDatedInfoVsAmountGossip_alternative.mat

average_cooperation=mean(prop_coop,3);
std_cooperation=std(prop_coop,0,3);

timestheinteractions=[1 2 5 10 30 50]; % how many times the social interactiosn there is gossip?

commstypes_num=[2 3];
gossiptarget_num=[0 1 2 3 4 5];
gossippartnertypes_num=[0 1 2 3];


 for i=1:4*6*4*6
    [type_comunication_num(i),type_choice_gossiped_num(i),type_choice_gossip_partner_num(i)]=turn_names_into_numbers_fig(type_comunication(i,:),type_choice_gossiped(i,:),type_choice_gossip_partner(i,:));
 end
% 
 cooperation_levels_mean=squeeze(mean(prop_coop,2)); % I average on simulations
 cooperation_levels_std=squeeze(std(prop_coop,0,2)); % note here i compute the std across simulation
 
% 
numfig=1;
for i=1:length(gossippartnertypes_num)
    for j=1:length(gossiptarget_num) % count
        sel_gossip_partner=find(type_choice_gossip_partner_num==gossippartnertypes_num(i)); % select current Gossip partner
        sel_gossip_target=find(type_choice_gossiped_num==gossiptarget_num(j)); % select current Gossip partner
        index_to_print_type=intersect(sel_gossip_partner,sel_gossip_target);
        sel_infoDiffusion0=find(info_always_uptodate==0);
        sel_infoDiffusion1=find(info_always_uptodate==1);
        index_to_print_info0=intersect(index_to_print_type,sel_infoDiffusion0);
        index_to_print_info1=intersect(index_to_print_type,sel_infoDiffusion1);
        
        gc2=find(type_comunication_num==2); % select  type of comm 2
        gc3=find(type_comunication_num==3); % select  type of comm 3
        
        index_to_print2_0=intersect(index_to_print_info0,gc2);
        index_to_print3_0=intersect(index_to_print_info0,gc3);
        index_to_print2_1=intersect(index_to_print_info1,gc2);
        index_to_print3_1=intersect(index_to_print_info1,gc3);
        
        coop_to_print2_0=cooperation_levels_mean(index_to_print2_0);
        coop_to_print3_0=cooperation_levels_mean(index_to_print3_0);
        coop_to_print2_1=cooperation_levels_mean(index_to_print2_1);
        coop_to_print3_1=cooperation_levels_mean(index_to_print3_1);
        
        figure(numfig)
        plot(timestheinteractions,coop_to_print2_0,'k','LineWidth',3); %,cooperation_levels_std(1,:)
        hold on
        plot(timestheinteractions,coop_to_print3_0,'b','LineWidth',3); %,cooperation_levels_std(3,:)
        hold on
        plot(timestheinteractions,coop_to_print2_1,'r','LineWidth',3); % ,cooperation_levels_std(2,:)
        hold on
        plot(timestheinteractions,coop_to_print2_1,'g','LineWidth',3); %,cooperation_levels_std(4,:)
        
        ax = gca; % current axes
        ax.FontSize = 14;
        ylim([0 1.01])
        legend('Pass R_{zi} and c_z - Info ages',...
            'Pass only C_z - Info ages',...
            'Pass R_{zi} and c_z - Info updated',...
            'Pass only C_z  - Info updated','Location','southeast');
        title({'Average cooperation level for different'; 'contents of gossip and information characteristics'; ['Partner Sel: ' upper(gossippartnertypes(i,:)) ' - Target Sel: '  upper(gossiptarget(j,:))]},'FontSize',20);
        ylabel('Proportion of Cooperation','FontSize',20);
        xlabel('Relative amount of gossip','FontSize',20);
        saveas(numfig,['RelativeAmountGossip_Fig4_alternative_' gossippartnertypes(i,:) '_' gossiptarget(j,:)],'png');
        numfig=numfig+1;
    end
end

 

 
clear all
close all
clc

load MemoryVsAmountGossip_alternative.mat

average_cooperation=mean(prop_coop,2)';
std_cooperation=std(prop_coop,0,2)';

 commstypes_num=[2 3];
 gossiptarget_num=[0 1 2 3 4 5];
 gossippartnertypes_num=[0 1 2 3];
 
 
  for i=1:1584
     [type_comunication_num(i),type_choice_gossiped_num(i),type_choice_gossip_partner_num(i)]=turn_names_into_numbers_fig(type_comunication,type_choice_gossiped(i,:),type_choice_gossip_partner(i,:));
  end

memory=[1 5 10 20 40 80 100 200 400 800 1000]; % set below inf if you want limited memory
numfig=1;

for i=1:length(gossippartnertypes_num)
    for j=1:length(gossiptarget_num) % count
        sel_gossip_partner=find(type_choice_gossip_partner_num==gossippartnertypes_num(i)); % select current Gossip partner
        sel_gossip_target=find(type_choice_gossiped_num==gossiptarget_num(j)); % select current Gossip partner
        index_to_print_type=intersect(sel_gossip_partner,sel_gossip_target);
        
        sel_to_numinto1=find(timestheinteractions==timestheinteractions_vct(1));
        sel_to_numinto2=find(timestheinteractions==timestheinteractions_vct(2));
        sel_to_numinto3=find(timestheinteractions==timestheinteractions_vct(3));
        sel_to_numinto4=find(timestheinteractions==timestheinteractions_vct(4));
        sel_to_numinto5=find(timestheinteractions==timestheinteractions_vct(5));
        sel_to_numinto6=find(timestheinteractions==timestheinteractions_vct(6));
        
        toprint1=intersect(index_to_print_type,sel_to_numinto1);
        toprint2=intersect(index_to_print_type,sel_to_numinto2);
        toprint3=intersect(index_to_print_type,sel_to_numinto3);
        toprint4=intersect(index_to_print_type,sel_to_numinto4);
        toprint5=intersect(index_to_print_type,sel_to_numinto5);
        toprint6=intersect(index_to_print_type,sel_to_numinto6);
        
        
        figure(numfig)
        semilogx(memory,average_cooperation(toprint1),'k','LineWidth',3); %,cooperation_levels_std(1,:)
        hold on
        semilogx(memory,average_cooperation(toprint2),'b','LineWidth',3); % ,cooperation_levels_std(2,:)
        hold on
        semilogx(memory,average_cooperation(toprint3),'r','LineWidth',3); %,cooperation_levels_std(3,:)
        hold on
        semilogx(memory,average_cooperation(toprint4),'m','LineWidth',3); %,cooperation_levels_std(4,:)
        hold on
        semilogx(memory,average_cooperation(toprint5),'g','LineWidth',3); %,cooperation_levels_std(4,:)
        hold on
        semilogx(memory,average_cooperation(toprint6),'k-.','LineWidth',3); %,cooperation_levels_std(4,:)
        ax = gca; % current axes
        ax.FontSize = 14;
        legend('Gossip is 1 times the interactions','Gossip is 2 times the interactions','Gossip is 5 times the interactions','Gossip is 10 times the interactions','Gossip is 30 times the interactions','Gossip is 50 times the interactions','Location','southeast');
        title({'Average cooperation level for different'; 'memory lenghts and amounts of gossip'; ['Partner Sel: ' upper(gossippartnertypes(i,:)) ' - Target Sel: '  upper(gossiptarget(j,:))]},'FontSize',20);
        ylabel('Proportion of Cooperation','FontSize',20);
        xlabel('Memory','FontSize',20);
        ylim([0 1.01]);
        saveas(numfig,['Memory_Fig5_alternative_' gossippartnertypes(i,:) '_' gossiptarget(j,:)],'png')
        numfig=numfig+1;
    end       
end

close all