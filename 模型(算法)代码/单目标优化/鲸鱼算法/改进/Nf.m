function x=NF()
for i=1:1000
     y=randn;
     if(y<1 &&y>-1)
         x=y;
        break;
     end
end