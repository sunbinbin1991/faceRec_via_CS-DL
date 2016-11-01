clc;clear;tic;
datasets={'ORL','YALE','YALE_EXTENDED','PIE','AR'};
for i=2:2
    load(['..\Mat3\Data_', datasets{i}, '.mat']);
    samples=double(samples);
    samples=mapstd(samples);
    [samplenum ~] = size(samples);
    index=unique(samplesnum);
    labelnum=numel(unique(samplesnum)) ;
    Block=samplenum/labelnum;
    s= fix(Block/2);
    %  techniques = {'PCA','SPP', 'LDA','DSPP', 'NPE','LPP', 'POSRC','CSC', 'SRC'};
    techniques = {'PCA' ,'LPP', 'POM','SPP','CSC', 'SRC'};
    accuracy=zeros(1,10,9);
         for times=1:1
            series = randperm(Block);
            tfea=[];
            tgnd=[];
            fea=[];
            gnd=[];
            for k=0: labelnum-1
                fea=[fea; samples(k*Block+series(1:s),:)];
                gnd=[gnd ;samplesnum(k*Block+series(1:s),:)];
                tfea=[tfea; samples(k*Block+series(s+1:end),:)];
                tgnd=[tgnd ;samplesnum(k*Block+series(s+1:end),:)];
            end
              for j=1:1
              for step=1:10               
                options = [];
                options.gnd = gnd;
                options.ReducedDim=20*step;
%               options.ReducedDim=100;
                options.Mode=techniques{j};
                %   options.delta=0.02*step;
                options.delta=0;
                [eigvector, eigvalue]=fe(fea,options);
                tfea1=tfea*eigvector;
                fea1=fea*eigvector;
                %                 end
                for m=1:1
                    modal = {'BatchSRC','CRC','CSC','CBC'};
                    options.Mode=modal{m};
                    rgnd= myclassify( tfea1,fea1,gnd,options);
                    nError = sum(rgnd ~= tgnd);
                    A=[1 2 3; 4 5 6; 7 8 9];
                    accuracy(times,step,A(j,m))= 1 - nError/length(tgnd);
                end
                
            end
            
        end
        
    end
    
end
pmean=mean(accuracy,1);
pvar=var(accuracy,1);
x=20:20:200;
figure ;
 plot(x,1-pmean(:,:,1),'*-.k','Linewidth',2);hold on;%
 plot(x,1-pmean(:,:,2),'*-.g','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,3),'*-.r','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,4),'s-k','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,5),'s-g','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,6),'s-r','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,7),'o--k','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,8),'o--g','Linewidth',2);hold on;
 plot(x,1-pmean(:,:,9),'o--r','Linewidth',2);hold on;
% legend('POM_{SRC}','POM_{CRC}','POM_{l_2C}');
legend('PCA_{SRC}','PCA_{CRC}','PCA_{l_2C}','LPP_{SRC}','LPP_{CRC}','LPP_{l_2C}','POM_{SRC}','POM_{CRC}','POM_{l_2C}');
xlabel('\itm');set(gca,'xtick',x);
axis([20 200 0 1]);
ylabel('Error rate');
toc;
