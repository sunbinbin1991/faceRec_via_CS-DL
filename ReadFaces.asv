function [faceContainer]=ReadFaces( BlockSize, faceLib, nPerson, nFacesPerPerson, flag_pre, flag_test, ColNum)
% read faces from faceLib for train or test
%
% input£ºfaceLib --- -the face library
%        nPerson --- the number of person to be trained or tested
%       nFacesPerPerson --- the number of samples needed to be read, the default number is 5
%       flag_test --- bool typed parameter. Default is 0, mean reading train samples(first nFacesPerPerson samples)
%                     if it is 1, mean reading test samples(last nFacesPerPerson samples)
%
% output£ºfaceContainer --- vector face container, 2-dim matrix£¬every row refers to one face vector
%       faceLabel --- face laber, denote this face belonging to which people

if nargin == 0     %set default value
    imgRow = 112;
    imgCol =  92;
    BlockSize = 8;
    faceLib = 'ORL';
    nPerson =  40;
    nFacesPerPerson = 5;    %first 5 samples used for train
    flag_test = 0; 
    flag_pre = 0;
elseif nargin < 5
    flag_test = 0;
end


faceContainer = zeros(BlockSize^2, ColNum*nFacesPerPerson, nPerson );%save some memory for matrix;The totol label have nFPP*nP picture

        
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
                    
                
%                 img = our_im2col(img,BlockSize);
%                 
%                 faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;
               



%                 faceContainer((i-1)*nFacesPerPerson+j, :) = img(:)';
%                 faceLabel((i-1)*nFacesPerPerson+j) = i;
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
                    StdThr =25;
                    ids1=find(std(img)>StdThr);
                    ids2=randperm(numel(ids1));
                    pos=ids1(ids2(1:ColNum));
                    img=img(:,pos);
                    faceCo ntainer(:,ColNum*(i-1)+1:ColNum*i,n-2) = img;
                    
                end   
            else
                 for i = 6:10
                    imagePath = strcat(filePath2,'\',num2str(i),'.pgm')                 
                    img = imread(imagePath)
                    img = double(img)                    
                     % faceContainer(:,ColNum*(j-1)+1:ColNum*j,i) = img;                               
                     img = im2col(img,[BlockSize,BlockSize],'sliding');
                     % varience
                    StdThr =25;
                    ids1=find(std(img)>StdThr);
                    ids2=randperm(numel(ids1));
                    pos=ids1(ids2(1:ColNum));
                    img=img(:,pos);
                    faceContainer(:,ColNum*(i-6)+1:ColNum*(i-5),n-2) = img;
                 end
            end
        end
    case 'Yale-e'
        imagePathList = dir('FaceLib\YALE_EXTENDED')
        % use dir(filepath),the first two number is '.' '..'
        for n=3:length(imagePathList)
            filePath1 = imagePathList(n).name
            filePath2 = strcat('FaceLib\YALE-EXTENDED\',filePath1)
            imagePathtemp = dir(filePath2)
            randPath=randperm(10)
            
            
        end
end

      