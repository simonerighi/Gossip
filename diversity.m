function Diver=diversity(N,R)
%diversity: 
%number of different vectors of R present (we can do it with c also, 
%that's a measure of convergence)/N
%NOTE: rounding to nearest integer to reduce diversity

RR=round(R./10)*10; % round to the nearest integer;
Diver=0;
while size(RR,1)>0 % until i cleaned the whole matrix
    paragonterm=RR(1,:); % i take the current first line a meter of paragon
    i=1;
    while i<=size(RR,1) % and i check agains any other still existing line
        if sum(RR(i,:)==paragonterm)==N % it that line is equal, then eliminate the line
            RR(i,:)=[];
        else
            i=i+1; % otherwise look for the new line;
        end
    end
    Diver=Diver+1; % anyway increase the value of diversity by one;
end
Diver=Diver/N; % normalize to one
