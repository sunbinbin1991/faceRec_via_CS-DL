clc;clear;tic;
datasets={'ORL','AR_Pure','AR_fix','Yale_E','Yale'};
for i=5:5
    load(['..\Mat3\', datasets{i}, '.mat']);
    [Dimm TrainNum] = size(TrainFaces);
    [Dim TestNum]=size(TestFaces);
    %index=unique(samplesnum);
    labelnum=numel(unique(trainLabels)) ;%labelnum=nperson~40*10=block
    Block=trainLabels/labelnum;%block=nFacesPerperson
    techniques = {'PCA','LPP','POM'};
    %     for j=1:length(techniques)
    accuracy=zeros(1,10,5);
    fea=TrainFaces;
    tfea=TestFaces;
    gnd=trainLabels;
    tgnd=testLabels;
    
    for ii =1:TrainNum           %   Normalized
        temp = norm(fea(:,ii),2);
        fea(:,ii) = fea(:,ii)./temp;
    end
    for times=1:1
        for j=1:3
            for step=1:10
                options = [];
                options.gnd = gnd';
                options.ReducedDim=20*step;
                %  options.ReducedDim=100;
                options.Mode=techniques{j};
                %  options.delta=0.1*step;
                options.delta=0.5;
                [eigvector, eigvalue]=fe(fea',options);
                tfea1=tfea'*eigvector;
                fea1=fea'*eigvector;
                %                 end
                for m=4:4
                    modal = {'BatchSRC','CRC','CSC','SRC'};
                    options.Mode=modal{m};
                    rgnd= myclassify( tfea1,fea1,gnd,options);
                    nError = sum(rgnd ~= tgnd);
                    accuracy(times,step,j)= 1 - nError/length(tgnd');
                end
            end
            
        end
    end
end
pmean=mean(accuracy,1);
pvar=var(accuracy,1);
 x=20:20:200;
figure ;
% for j=1:3
%     Maker={'*-.k','s:g','x--c'};
 plot(x,pmean(:,:,1),'*-.k','Linewidth',2); hold on; 
 plot(x,pmean(:,:,2),'s:g','Linewidth',2);hold on;
 plot(x,pmean(:,:,3),'x--c','Linewidth',2);hold on;
% % semilogy(xs,Y4,'o--b','Linewidth',2);hold on;
% semilogy(xs,Y5,'+-r','Linewidth',2);hold on;
xlabel('Dim');set(gca,'xtick',x); 
axis([0 200 0 1]); 
ylabel('Recognition Rate');

% legend('PCA+SRC','LDA+SRC','PCA+SRC+L1');
% legend('PCA+CSC','LDA+CSC', 'LPP+CSC','SPP+CSC', 'POM+CSC');
% legend('POM+SRC','POM+CRC','POM+CSC');
legend('PCA+SRC','LPP+SRC','POM+SRC');
legend('PCA+L2C','LPP+L2C','POM+L2C');
% legend('PCA+CSC','LDA+CSC', 'LPP+CSC','SPP+CSC', 'POM+CSC');
% legend('PCA+SRC','LDA+SRC','LPP+SRC','SPP+SRC','POM+SRC');
% legend('SPP+SRC');
% legend('PCA+SRC','SPP+SRC');
toc;