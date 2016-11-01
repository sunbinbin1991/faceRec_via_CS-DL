function [ class] = BatchSRC( Dic, testbatch, blocksize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes her

% why this two situation is different I cant find the reason about it.

% DicMeans = mean(Dic);
% Dic = Dic-ones(size(Dic,1),1)*DicMeans;
%
% testbatchMeans = mean(testbatch);
% testbatch = testbatch-ones(size(testbatch,1),1)*testbatchMeans;

[~,K]=size(Dic);
%X=random('Discrete Uniform',64,1024);
%X=random('Poisson',64,1024);
testlen = size(testbatch,2);
blocknum=K/blocksize;% 38 Blocknum
      in = [];   
    in.tau = 5e-2;  
    in.delx_mode = 'mil';
    in.debias = 0;
    in.verbose = 0;
    in.plots = 0;
    in.record = 0;
%     err_fun = @(z) (norm(x-z)/norm(x))^2;
%     in.err_fun = err_fun;
     
        
       
for k=1:testlen
    %     [temp] = NNGOMP(Dic, testbatch(:,k), block);
    %     [temp] = calculateS(Dic, testbatch(:,k), block);
    %     [s] = sparse_solution(Dic, testbatch(:,k));
    
          s = l1homotopy(Dic, testbatch(:,k), in);
            xh = s.x_out;
    for i=1:blocknum
        err(i)=  norm(testbatch(:,k) -Dic(:,blocksize*(i-1)+1:blocksize*(i))*xh(blocksize*(i-1)+1:blocksize*(i)));
%         err(i)=  norm(testbatch(:,k) -Dic*s(blocksize*(i-1)+1:blocksize*(i)));
    end;
    temp1=  find(err==min(err));
    class(k,1)=temp1(1,1);
end

end

