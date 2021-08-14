function  R=simpleRUpdate(R,token_info,Push)
% this is a simple, rule for the update of the reputation.:
% it says that if you receive a signal different from the current value of R
% then R moves in its direction.
% 
% When used after interactions it basically increases or decreases of a
% value Push the reputation depending on whether the alter cooperated or
% defected.

if token_info>R
    R=R+Push;
    if R>100; R=100; end % reputation can't exceed 100.
elseif token_info<R
    R=R-Push;
    if R<0; R=0; end % reputation can't be below  0.
end