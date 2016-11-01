function [I] = our_col2im(blocks,blkSize,mblk_I,nblk_I);
%==========================================================================
%this function is used to reconsrtrcut the image from the processed imagedata.
%--------------------------------------------------------------------------
%
% Input:  
%
%           - blocks, the processed imagedata, such as, the denoised one.
%           - blkSize,blkSize,the size of image patch (blkSize times blkSize).
%           - mblk_I,the number of blocks of the row.    
%           - nblk_I,the number of blocks of the cloumn.
%--------------------------------------------------------------------------
%
% Output:  
%           - I, the processed image
%
%==========================================================================







I = zeros(mblk_I*blkSize,nblk_I*blkSize);
k=1;
for i = 1:mblk_I
    for j=1:nblk_I
    currBlock = blocks(:,k);
    I(blkSize*(i-1)+1:blkSize*(i-1)+blkSize,blkSize*(j-1)+1:blkSize*(j-1)+blkSize) = col2im(currBlock,[blkSize blkSize],[blkSize blkSize],'distinct');
    k=k+1; 
    end
end