function [ class] = CRC( Dic, testbatch, blocksize)

[~,K]=size(Dic);
testlen = size(testbatch,2);
blocknum=K/blocksize;% 38 Blocknum
kappa=0.08;
stemp = inv(Dic'*Dic+kappa*eye(size(Dic,2)))*Dic';
for k=1:testlen 
    s=stemp*testbatch(:,k);
    for i=1:blocknum
        coef_c =s(blocksize*(i-1)+1:blocksize*(i));    
        Dc =Dic(:,blocksize*(i-1)+1:blocksize*(i));
         error(i) = norm(testbatch(:,k)-Dc*coef_c,2)^2/sum(coef_c.*coef_c);
    end
    temp1=  find(error==min(error));
    class(k,1)=temp1(1,1);
end
end

