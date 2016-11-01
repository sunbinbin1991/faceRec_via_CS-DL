function mu = calculate_mu( dic )
%==========================================================================
% to calculate a the mutual coherence for a given matrix dic
%--------------------------------------------------------------------------
%
% Input:
%         - dic, the given matrix
%--------------------------------------------------------------------------
% Output:
%         - mu, the mutual coherence of the given matrix dic
%==========================================================================
%                    Xiao Li    DEC. 2015  at ZJUT
%==========================================================================


 MU  = @(dic) max(max(abs((dic'*dic)-diag(diag(dic'*dic))))); %mutual coherence function
 
 mu = MU(dic);


end

