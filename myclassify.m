function [ class ] = myclassify( tfea,fea,gnd,options);
%UNTITLED2
%   labelnum=npersons
%   block=allface/(lablenum)=nFacesPerPerson
     labelnum=numel(unique(gnd)) ;
              block=length(gnd)/labelnum;
switch lower(options.Mode)
      case {lower('BatchCSC')}
%           BatchCSC( Dic, testbatch, block)
        [ class]=  BatchCSC( fea', tfea', block);
        class=class';         
    case  {lower('BatchSRC')}   % L1homony
        [class]= BatchSRC( fea', tfea', block);
    case {lower('SRC')}
        [class]=SRC(fea', tfea', block);
%            [class] = BatchSRC( fea', tfea', block);
    case{lower('CSC')}
        [class]=BatchCSC( fea', tfea', block);
         class=class';
    case{lower('CRC')}
        [class]=CRC(fea', tfea', block);
          case{lower('CBC')}
        [class]=BatchCBC( fea', tfea', block);
        

          
end

