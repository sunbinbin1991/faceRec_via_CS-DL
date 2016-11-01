

clc;clear;close all;

%param setting=============================================================

BlockSize = 8;               %the size of image patch(BlockSize*BlockSize) you want to extract from the image

%==========================================================================




%fisrtly, load the image to data matrix====================================
pathForImages ='images/';                          %the path where your images are
imageName = 'lena512.png';                         %the image you want to read, attention please, the format of the image could be 'png'.'JPEG'. Please write the whole name 
%of the image, including the standard format name, in this case, it is '.png'.
image = imread(strcat([pathForImages,imageName])); %transfer the real image to matrix form, now, image is a matrix. the dimension is the same as the real image.such as 512*512.
image = double(image);                             %transfer the data to double
image_or = image;                                  %use 'image_or' to store the original image
%==========================================================================




% extract patches from the image, and rearrange it to a matrix form, such
% as 512*512 ----> 64*4096=================================================

[image,mblk_I,nblk_I] = our_im2col(image,BlockSize);

%==========================================================================



%remove the means from the rearranged image, fro the next processing=======
imageMeans = mean(image);            %the means of image
image = image-ones(size(image,1),1)*imageMeans;     %remove the means, now you could use the 'image' to train or test 
%==========================================================================




%  ------------------ Processing using some  algorithms------------------------------------------------------
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%
%---------------------End of the processing, you will have a processed'image'------------------------------







%re-add the means of the image AND rearrange it to the size of real image,
%such as 64*4096 ----> 512*512 ============================================

image = image + ones(size(image,1),1)*imageMeans;   %re-add the means of the image

image = our_col2im(image,BlockSize,mblk_I,nblk_I);  %rearrange the processed data matrix to the same size of the real image


%==========================================================================






%calculate the PSNR between the processed image and the original image===========================

PSNR = calcu_psnr(image_or,image)






%show the processed image and the original one

figure(1)
imshow(image_or/255)
title('Original')

figure(2)
imshow(image/255)
title('Processed')








