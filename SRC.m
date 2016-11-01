function [ class] = SRC( Dic, testbatch, blocksize)
%UNTITLED Summary of this function goes here
% testbatch = testbatch-ones(size(testbatch,1),1)*testbatchMeans;

[~,K]=size(Dic);
testlen = size(testbatch,2);
blocknum=K/blocksize;% 38 Blocknum

for k=1:testlen
    %     [temp] = NNGOMP(Dic, testbatch(:,k), block);
    %     [temp] = calculateS(Dic, testbatch(:,k), block);
    [s] = sparse_solution(Dic, testbatch(:,k));
    %      s = analyticalS(Dic,testbatch(:,k));
    %     s = sparse_solution(Dic, testbatch(:,k));
    %      xh = s.x_out;
    for i=1:blocknum
        err(i)=  norm(testbatch(:,k) -Dic(:,blocksize*(i-1)+1:blocksize*(i))*s(blocksize*(i-1)+1:blocksize*(i)));
        %         err(i)=  norm(testbatch(:,k) -Dic*s(blocksize*(i-1)+1:blocksize*(i)));
    end;
    temp1=  find(err==min(err));
    class(k,1)=temp1(1,1);
end

end

