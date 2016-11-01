function [ PSNR ] = calcu_psnr( image_or,image_new )
%in this function, to calculate the PSNR
%==========================================================================
%Input:      image_or,the original real image
%            image_new, the reconstructed image
%
%Output:     PSNR,the Sigma_PSNR in dB
%                    X. Li   
%==========================================================================

MSE = (norm((image_new(:)-image_or(:)),'fro'))^2/numel(image_or(:));  % mean square error
PSNR =10*log10(255^2/MSE);  % peak signal to noise ratio

end

