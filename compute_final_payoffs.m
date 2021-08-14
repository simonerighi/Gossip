function Payoff_i=compute_final_payoffs(mu,nu,PayoffsAtT,type_payoff)
% for each individual i only keep nu out of mu interactions, i compute the
% total payoff either with sum (if type_payoff is ==0(s)) or by average (if type_payoff is ==1(a))
% Note: mu=nu in all simulations of the actual paper.

if nu<mu %if there is an actual selection to do
    payoff_to_use=zeros(nu,1);
    for j=1:nu % choose nu random values from the vector of this agents results
        val=ceil(rand*mu); %position to keep
        payoff_to_use(j)=PayoffsAtT(val); % 
        PayoffsAtT(val)=[]; %eliminate this position so that it cannot be reused
    end
    if type_payoff==0
        Payoff_i=sum(payoff_to_use);   
    else
        Payoff_i=mean(payoff_to_use);
    end
else  % if there is no selection just compute the payoff
    if type_payoff==0
        Payoff_i=sum(PayoffsAtT);   
    else
        Payoff_i=mean(PayoffsAtT);
    end
end