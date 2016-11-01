%% This summuary want to READ the face Library
clc;clear;
rootPath='FaceLibrary/Bean/YALE_504D/yaleB01/yaleB01_P00A+000E+00Downsample';
imgInf=imread(strcat(rootPath,'.pgm'));
[imgRow,imgCol]=size(imgInf);
nPerson=38;                 %set the num of train class
nFacesPerPerson=32;         %set the num need train of each class
Train_DAT=[];
TrainLabels=zeros(1,nPerson*nFacesPerPerson);
Test_DAT=[];
% testlabels=zeros(1,1202);
tt=zeros(nPerson,nFacesPerPerson);
%% read the train samples,and save the train labels
for i=1:nPerson
    i1=mod(i,10);     % units
    i0=char(i/10);
    strPath='FaceLibrary/Bean/YALE_504D/yaleB';%
    if( i0~=0 )
        strPath=strcat(strPath,'0'+i0);
    else
        strPath=strcat(strPath,'0');
    end
    strPath=strcat(strPath,num2str(i1));
    ImgList = BatchReadImg(strPath);  
    num = size(ImgList,2);
    %     if flag_test==0
    N=(1:num);                      % N是一个从一到文件总数的数组
    Num=N(randperm(length(N),nFacesPerPerson));  % 从图像中随机抽取32个图像
    A=Num(1,1:nFacesPerPerson);
    N(A(1,1:nFacesPerPerson))=[];    %去除已经选择的图片
    
    if size(N,2)<nFacesPerPerson
        N(1,(num-nFacesPerPerson+1):nFacesPerPerson)=0;
    end
    for j = 1:nFacesPerPerson
        img = cell2mat(ImgList(1,Num(1,j)));
       Train_DAT(:,(i-1)*nFacesPerPerson+j) = img(:)';
        TrainLabels(1,(i-1)*nFacesPerPerson+j) = i;
    end
    tt(i,:)=N(:);
 
    save(['MAT2/Randm','.mat'],'tt');
end
%把读入的图像按列存储为行向量放入向量化人脸容器faceContainer的对应行中
%% Read the test faces,save the test labels
for i=1:nPerson
    i1=mod(i,10);     % units
    i0=char(i/10);
    strPath='FaceLibrary/Bean/YALE_504D/yaleB';%
    if( i0~=0 )
        strPath=strcat(strPath,'0'+i0);
    else
        strPath=strcat(strPath,'0');
    end
    strPath=strcat(strPath,num2str(i1));
    ImgList = BatchReadImg(strPath); 
    load(['MAT/Randm','.mat']);
    A=[32 32 32 32 32 32 32 32 32 32 28 27 28 32 31 ...
        30 31 31 32 32 32 32 32 32 32 32 32 32 32 32 ...
        32 32 32 32 32 32 32 32 ];
    for  j= 1:A(i)
        img = cell2mat(ImgList(1,tt(i,j)));
        Test_DAT(:,sum(A(1:i))-A(i)+j)= img(:)';
        %             NewTest_DAT=NewTest_DAT';
        TestLabels(1,sum(A(1:i))-A(i)+j) = i;
    end
end
save(['MAT2/YalB_E','.mat'],'Test_DAT','Train_DAT','TestLabels','TrainLabels');
