

clear; clc; close all;


%param setting=============================================================
K = 1;                   %the sparsity level used in the dictionary training
%errorGoal = 20;         %the errorgoal used in the OMPerr Algorithm
N = 100;                 %the dimension of each minor dictionary
L = 256;                 %the number of atoms(column) in each minor dictionary
BlockSize = 10;          %the size of the block you extracted from images: BlockSize*BlockSize

imgRow = 192;            %the row dimension of the face size
imgCol = 168;             %the column dimension of each face
faceLib = 'Yale-e';    %the face label used to train and test
nPerson = 38;            %the number of the people in the lab
nFacesPerPerson = 32;     %the number of pictures to read for each person
flag_pre = 0;
flag_train = 0;          %in deed,flag_train and flag_test use the same flag,if it is 0, extract the                   
flag_test = 1;           % first nFacesPerPerson for training, 1, extract the last nFacesPerPerson for testing
IterNum = 5;             %the iteration number used in the KSVD algorithm

%==========================================================================




%read the traning and testing face=========================================
ColNum = 100; %the number of columns of each face used for training
% ColNum = floor(imgRow/BlockSize)*floor(imgCol/BlockSize); %the number of columns of each face used for testing

[TrainFace,TestFace,testLables] =ReadFaces2( BlockSize, faceLib, nPerson, ...
     nFacesPerPerson,flag_pre, flag_train, ColNum);



%reduce the the DC of the images
for i = 1:nPerson
    
    TrainFaceMeans(i,:) = mean(TrainFace(:,:,i));            %the means of training face
    TrainFace(:,:,i) = TrainFace(:,:,i)-ones(size(TrainFace(:,:,i),1),1)*TrainFaceMeans(i,:);     %remove the means, now you could use the 'TrainFace' to train
    
    TestFaceMeans(i,:) = mean(TestFace(:,:,i));            %the means of image
    TestFace(:,:,i) = TestFace(:,:,i)-ones(size(TestFace(:,:,i),1),1)*TestFaceMeans(i,:);     %remove the means, now you could use the 'TestFace' to test
    
end
%==========================================================================






%using dictionary learning algorithm to leaning dictionary=================

%generate the container for these dictionarys

DIC = zeros(N,L,nPerson); %the dimension of each dictionary is N*L, and each person has their own dictionary


%firstly, using DCT as the initial dictionary
bb=BlockSize;
Pn=ceil(sqrt(L));
DCT=zeros(bb,Pn);
for k=0:1:Pn-1,
    V=cos([0:1:bb-1]'*k*pi/Pn);
    if k>0, V=V-mean(V); end;
    DCT(:,k+1)=V/norm(V);
end;
DCT=kron(DCT,DCT);
DCT = DCT*diag(1./sqrt(diag(DCT'*DCT)));


%----------------------------------KSVD------------------------------------
for iter = 1:nPerson %train dictionary for different people

    disp(['KSVD start, training the ' num2str(iter) ' -th person'])
    param=struct('K',L,'numIteration',IterNum,'errorFlag',0,'preserveDCAtom',0, ...
        'L',K,'InitializationMethod','GivenMatrix','initialDictionary',DCT,'displayProgress',1);
    
    DIC(:,:,iter) = KSVD(TrainFace(:,:,iter),param);                %the KSVD algorithm

end

%==========================================================================



%using SRC to classify=====================================================
predicLables = []
testLables_unque = unique(testLables)
testLables_num = histc(testLables,testLables_unque)

for I = 1:nPerson %classify one person by one person
    disp(['classify for ' num2str(I) ' -th person'])
    for J = 1:testLables_num(I) %classify one face by one face
        
        for P = 1:nPerson %using different dictionary to represent the face and calculate the representation err
        
%             CoeffMatrix = OMP(DIC(:,:,P), TestFace(:,ColNum*(J-1)+1:ColNum*J,I), K);
            
%           
            CoeffMatrix = OMP(DIC(:,:,P), TestFace(:,ColNum*(J-1)+1:ColNum*J,I),K);
           
            Err(P) = norm(TestFace(:,ColNum*(J-1)+1:ColNum*J,I) - DIC(:,:,P)*CoeffMatrix, 'fro');
%             Err(P) = length(find(CoeffMatrix))/size(CoeffMatrix,2);
        
        end
        
        index = find(Err == min(Err)); %classify for each person
        predictLables= [predictLables,index(1)]
        recg_class(J,I)=index(1);
        
    end  
    
end

err=0;
for jj=1:nPerson
    for ii =1:nFacesPerPerson
    recg(ii,jj)=jj;
    if(recg(ii,jj)~=recg_class(ii,jj))
        err=err+1;
    end
    end
end
recog_rate=1-err/(nPerson*nFacesPerPerson);
 disp(['The recognition rate in ' faceLib '.....is.....' num2str(recog_rate)]);


































