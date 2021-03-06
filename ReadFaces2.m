function [trainFaceContainer,testFaceContainer,testLabels]=ReadFaces( BlockSize, faceLib, nPerson,nFacesPerPerson, flag_pre, flag_test, ColNum)
%==============================================================================================================
% read faces from faceLib for train and test
%
% input��
%        faceLib --- -the face library
%        nPerson --- the number of person to be trained or tested 
%        flag_test --- bool typed parameter. Default is 0, mean reading train samples(first nFacesPerPerson samples)
%                     if it is 1, mean reading test samples(last nFacesPerPerson samples)
%==============================================================================================================================
% output��
%        trainfaceContainer --- vector face container, 2-dim matrix��every
%        row refers to one face vector for train
%        testfaceContainer --- vector face container, 2-dim matrix��every row
%       refers to one face vector for test
%       testLabel---labels for test
%
%        by:            binbin sun 2016/10/31
%=======================================================================================================================



testLables = []
trainPercent = 0.5
nfacesForTrain= 5
% varience
StdThr =10
trainFaceContainer = zeros(BlockSize^2, ColNum*nfacesForTrain, nPerson );%save some memory for matrix;The totol label have nFPP*nP picture

%testFaceContainer = zeros(BlockSize^2, ColNum*nFacesPerPerson, nPerson );%save some memory for matrix;The totol label have nFPP*nP picture

switch faceLib;
    case 'ORL'
        % read the train samples
        for i=1:nPerson
            i1=mod(i,10);     % units mod values
            i0=char(i/10);
            strPath='FaceLib/ORL/s';
            if( i0~=0 )
                strPath=strcat(strPath,'0'+i0);
            end
            strPath=strcat(strPath,num2str(i1));
            strPath=strcat(strPath,'/');
            tempStrPath=strPath;
            for j=1:nFacesPerPerson
                strPath=tempStrPath;
                if flag_test == 0     % read the train samples
                    strPath = strcat(strPath, num2str(j));
                else                  % read the test samples
                    strPath = strcat(strPath, num2str(11-j));
                end
                strPath=strcat(strPath,'.pgm');
                img=imread(strPath);
                [~, ~, channels] = size(img);
                %rearrange the image
                img = double(img);
                img = our_im2col(img,BlockSize);
                img = imresize(img,[32,32]);
                
                % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                
                
                img = im2col(img,[BlockSize,BlockSize],'sliding');
                % varience
                StdThr =5;
                ids1=find(std(img)>StdThr);
                ids2=randperm(numel(ids1));
                pos=ids1(ids2(1:ColNum));
                img=img(:,pos);
                faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                
                %                 faceContainer((i-1)*nFacesPerPerson+j, :) = img(:)';
                %                 faceLabel((i-1)*nFacesPerPerson+j) = i;
            end % j
        end % i
        %break;
    case 'YALE'
        % read the train samples
        for i=1:nPerson
            strPath='FaceLib/YALE/s';
            tempStrPath=strPath;
            for j=1:nFacesPerPerson
                strPath=tempStrPath;
                if flag_test == 0     % read the train samples
                    strPath = strcat(strPath, num2str((i-1)*11+j));
                else                  % read the test samples
                    strPath = strcat(strPath, num2str((i-1)*11+12-j));
                end
                %                 strPath=strcat(strPath,'.bmp');
                img=imread(strPath,'bmp');
                [~, ~, channels] = size(img);
                if channels == 3
                    img = rgb2gray(img);
                end
                
                if bitand(flag_pre,1)
                    img = medfilt2(img,[3,3]);
                end
                if bitand(flag_pre,10)
                    img = histeq(img);
                end
                if bitand(flag_pre,100)
                    img = LBP(img);
                end
                %rearrange the image
                img = double(img);
                
                img = im2col(img,[BlockSize,BlockSize],'sliding');
                StdThr = 10;
                ids1=find(std(img)>StdThr);
                ids2=randperm(numel(ids1));
                pos=ids1(ids2(1:ColNum));
                img=img(:,pos);
                faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
            end % j
        end % i
        %break
        
        
    case 'ORL_test'
        imagePathList = dir('FaceLib\ORL')
        % use dir(filepath),the first two number is '.' '..'
        for n=3:length(imagePathList)
            filePath1 = imagePathList(n).name
            filePath2 = strcat('FaceLib\orl\',filePath1)
            imagePathtemp = dir(filePath2)
            randPath=randperm(10)
            if flag_test ==0
                for i = 1:5
                    imagePath = strcat(filePath2,'\',num2str(i),'.pgm')
                    img=imread(imagePath)
                    img = double(img)
                    % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                    img = im2col(img,[BlockSize,BlockSize],'sliding');
                    % varience
                    StdThr =20;
                    ids1=find(std(img)>StdThr);
                    ids2=randperm(numel(ids1));
                    pos=ids1(ids2(1:ColNum));
                    img=img(:,pos);
                    faceContainer(:,ColNum*(i-1)+1:ColNum*i,n-2) = img;
                    
                end
            else
                for i = 6:10
                    imagePath = strcat(filePath2,'\',num2str(i),'.pgm')
                    img = imread(imagePath)
                    img = double(img)
                    % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                    img = im2col(img,[BlockSize,BlockSize],'sliding');
                    % varience
                    StdThr =20;
                    ids1=find(std(img)>StdThr);
                    ids2=randperm(numel(ids1));
                    pos=ids1(ids2(1:ColNum));
                    img=img(:,pos);
                    faceContainer(:,ColNum*(i-6)+1:ColNum*(i-5),n-2) = img;
                end
            end
        end
    case 'Yale-e'
        
        imagePathList = dir('FaceLib/YALE_EXTENDED')
        
        for n = 3:length(imagePathList)
            filePath1 = imagePathList(n).name               %'yaleB01'
            filePath2 = strcat('FaceLib/YALE_EXTENDED/',filePath1,'/*.pgm')
            imagePathtemp = dir(filePath2)                  %'(yaleB01_P00A+000E+00.pgm,yaleB01_P00A+000E+20,...)'
            facesPerPerson = length(imagePathtemp)            
            randPath=randperm(facesPerPerson)
            trainlable = randPath(1:nfacesForTrain)
            testlable = randPath(nfacesForTrain:end)
            for i=1:nfacesForTrain
                % get the imagePath
                imagePath = strcat('FaceLib/YALE_EXTENDED/',imagePathList(n).name,'/',imagePathtemp(trainlable(i)).name)
                
                img = imread(imagePath)
                img = double(img)
                % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                img = im2col(img,[BlockSize,BlockSize],'sliding');
                
                ids1=find(std(img)>StdThr)
                ids2=randperm(numel(ids1))
                pos=ids1(ids2(1:ColNum))
                img=img(:,pos);
                trainFaceContainer(:,ColNum*(i-1)+1:ColNum*i,n-2) = img
            end
            testLables = [testLables,ones(1,(facesPerPerson-nfacesForTrain)*(n-2))]
            for i=nfacesForTrain+1:facesPerPerson
                % get the imagePath
                imagePath = strcat('FaceLib/YALE_EXTENDED/',imagePathList(n).name,'/',imagePathtemp(testlable(i-nfacesForTrain)).name)                
                img = imread(imagePath)
                img = double(img)
                % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
                img = im2col(img,[BlockSize,BlockSize],'sliding');                
                ids1=find(std(img)>StdThr)
                ids2=randperm(numel(ids1))
                pos=ids1(ids2(1:ColNum))
                img=img(:,pos);
                testFaceContainer(:,ColNum*(i-1-nfacesForTrain)+1:ColNum*(i-nfacesForTrain),n-2) = img
            end
            
        end
end



% imagePathList = dir('FaceLib/YALE_EXTENDED')
% filePath1 = imagePathList(3).name               %'yaleB01'
% filePath2 = strcat('FaceLib/YALE_EXTENDED/',filePath1,'/*.pgm')
% imagePathtemp = dir(filePath2)                  %'(yaleB01_P00A+000E+00.pgm,yaleB01_P00A+000E+20,...)'
% facesPerPerson = length(imagePathtemp)
% 
% randPath=randperm(facesPerPerson)
% trainlable = randPath(1:floor(facesPerPerson/2))
% testlable = randPath(floor(facesPerPerson/2)+1:end)
% 
% for i=1:floor(facesPerPerson/2)
%     % get the imagePath
%     imagePath = strcat('FaceLib/YALE_EXTENDED/',imagePathList(n).name,'/',imagePathtemp(trainlable(i)).name)
%     
%     img = imread(imagePath)
%     img = double(img)
%     % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
%     img = im2col(img,[BlockSize,BlockSize],'sliding');
%     
%     ids1=find(std(img)>StdThr)
%     ids2=randperm(numel(ids1))
%     pos=ids1(ids2(1:ColNum))
%     img=img(:,pos);
%     trainfaceContainer(:,ColNum*(i-1)+1:ColNum*i,n-2) = img
% end
% 
