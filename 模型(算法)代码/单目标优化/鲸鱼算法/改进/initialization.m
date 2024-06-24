function Positions=initialization(dim,SearchAgents_no)
Positions=zeros(SearchAgents_no,dim);
Positions(1,:)=rand(1,dim);
for i=1:SearchAgents_no-1    
    for nn=1:dim
        if  (Positions(i,nn)<0.7)
            Positions(i+1,nn)=Positions(i,nn)/0.7;
        else
            Positions(i+1,nn)=(1-Positions(i,nn))/0.3;
        end
    end
end


