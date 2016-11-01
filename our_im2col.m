function [blocks,mblk_I,nblk_I] = our_im2col(I,blkSize)
%==========================================================================
%in this function, the image will be transferd to imagedata. rearrange each
%blksize*blksize image patch
%--------------------------------------------------------------------------
%Input:    I,the real image,which could be a gray and a rgb.
%          blkSize,the size of image patch (blkSize times blkSize). 
%
%Output:   mblk_I,the number of blocks of the row.    
%          nblk_I,the number of blocks of the cloumn.
%          blocks,the image data of size : blkSize^2 times...
%                 dim*(mblk_I*nblk_I), the value of the dim is:
%                        1,while the image is a gray one.
%                        3,while the image is a rgb one
%
%                     Xiao Li  DEC. 2014
%==========================================================================


[m,n,dim]=size(I);


if (dim == 1)   %deal with the gray image
blocks = zeros(blkSize^2,(floor(m/blkSize)*floor(n/blkSize)));
k=1;
for i = 1:floor(m/blkSize)
    for j = 1:floor(n/blkSize)
        currBlock = I(blkSize*(i-1)+1:blkSize*(i-1)+blkSize,blkSize*(j-1)+1:blkSize*(j-1)+blkSize);
        blocks(:,k) = im2col(currBlock,[blkSize blkSize]);
        k = k + 1; 
    end
end
mblk_I = floor(m/blkSize);  nblk_I = floor(n/blkSize);
end



if (dim == 3)      %deal with the rgb image
blocks = zeros(blkSize^2,dim*(floor(m/blkSize)*floor(n/blkSize)));
k = 1;
for p = 1:dim
    for i = 1:floor(m/blkSize)
        for j = 1:floor(n/blkSize)
            currBlock = I(blkSize*(i-1)+1:blkSize*(i-1)+blkSize,blkSize*(j-1)+1:blkSize*(j-1)+blkSize,p);
            blocks(:,k) = im2col(currBlock,[blkSize blkSize]);
            k = k + 1; 
        end
    end
end
mblk_I = floor(m/blkSize);  nblk_I = floor(n/blkSize);
end

end