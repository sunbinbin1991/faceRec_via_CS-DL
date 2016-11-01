function [ recg_class ] = SRC_DL(DIC, TestFace, ColNum, K, nPerson, nFacesPerPerson  )
%==========================================================================
%this function is used to classify the face based on sparse
%representation,different from the traditional ones, our classification use
%the trained dictionarys corresponding to each person's face 
%--------------------------------------------------------------------------
%
% Input:
%
%         - DIC, the dictionaries, each person has their own related
%           dictionary.
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
%==========================================================================










%==========================================================================


for I = 3:3 %classify one person by one person
    disp(['classify for ' num2str(I) ' -th person'])
    for J = 1:nFacesPerPerson %classify one face by one face
        
        for P = 1:nPerson %using different dictionary to represent the face and calculate the representation err
        
            CoeffMatrix = OMP(DIC(:,:,P), TestFace(:,ColNum*(J-1)+1:ColNum*J,I), K);
            Err(P) = norm(TestFace(:,ColNum*(J-1)+1:ColNum*J,I) - DIC(:,:,P)*CoeffMatrix, 'fro');
            
        
        end
        
        recg_class(J,I) = find(Err == min(Err)); %classify for each person
  
        
    end  
    
end


end

