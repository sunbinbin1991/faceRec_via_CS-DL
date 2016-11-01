function [eigvector, eigvalue] = fe(fea,options)
%	Usage:
%	[eigvector, eigvalue] = feature(fea,options)
%
%	fea: Rows of vectors of data points. Each row is x_i
%   options: Struct value in Matlab. The fields in options that can be set:
%                  
%           NeighborMode -  Indicates how to construct the graph. Choices
%                           are: [Default 'KNN']
%                'KNN'            -  k = 0
%                                       Complete graph
%                                    k > 0
%                                      Put an edge between two nodes if and
%                                      only if they are among the k nearst
%                                      neighbors of each other. You are
%                                      required to provide the parameter k in
%                                      the options. Default k=5.
%               'Supervised'      -  k = 0
%                                       Put an edge between two nodes if and
%                                       only if they belong to same class. 
%                                    k > 0
%                                       Put an edge between two nodes if
%                                       they belong to same class and they
%                                       are among the k nearst neighbors of
%                                       each other. 
%                                    Default: k=0
%                                   You are required to provide the label
%                                   information gnd in the options.
%                                              
%           WeightMode   -  Indicates how to assign weights for each edge
%                           in the graph. Choices are:
%               'Binary'       - 0-1 weighting. Every edge receiveds weight
%                                of 1. 
%               'HeatKernel'   - If nodes i and j are connected, put weight
%                                W_ij = exp(-norm(x_i - x_j)/2t^2). You are 
%                                required to provide the parameter t. [Default One]
%               'Cosine'       - If nodes i and j are connected, put weight
%                                cosine(x_i,x_j). 
%               
%            k         -   The parameter needed under 'KNN' NeighborMode.
%                          Default will be 5.
%            gnd       -   The parameter needed under 'Supervised'
%                          NeighborMode.  Colunm vector of the label
%                          information for each data point.
%            bLDA      -   0 or 1. Only effective under 'Supervised'
%                          NeighborMode. If 1, the graph will be constructed
%                          to make LPP exactly same as LDA. Default will be
%                          0. 
%            t         -   The parameter needed under 'HeatKernel'
%                          WeightMode. Default will be 1
%         bNormalized  -   0 or 1. Only effective under 'Cosine' WeightMode.
%                          Indicates whether the fea are already be
%                          normalized to 1. Default will be 0
%      bSelfConnected  -   0 or 1. Indicates whether W(i,i) == 1. Default 0
%                          if 'Supervised' NeighborMode & bLDA == 1,
%                          bSelfConnected will always be 1. Default 0.
%            bTrueKNN  -   0 or 1. If 1, will construct a truly kNN graph
%                          (Not symmetric!). Default will be 0. Only valid
%                          for 'KNN' NeighborMode
%
%
%    Examples:
%
%       fea = rand(50,15);
%       options = [];
%       options.NeighborMode = 'KNN';
%       options.k = 5;
%       options.WeightMode = 'HeatKernel';
%       options.t = 1;
%       W = constructW(fea,options);
%       
%       
%       fea = rand(50,15);
%       gnd = [ones(10,1);ones(15,1)*2;ones(10,1)*3;ones(15,1)*4];
%       options = [];
%       options.NeighborMode = 'Supervised';
%       options.gnd = gnd;
%       options.WeightMode = 'HeatKernel';
%       options.t = 1;
%       W = constructW(fea,options);
%       
%       
%       fea = rand(50,15);
%       gnd = [ones(10,1);ones(15,1)*2;ones(10,1)*3;ones(15,1)*4];
%       options = [];
%       options.NeighborMode = 'Supervised';
%       options.gnd = gnd;
%       options.bLDA = 1;
%       W = constructW(fea,options);      
%       
%
%    For more details about the different ways to construct the W, please
%    refer:
%       Deng Cai, Xiaofei He and Jiawei Han, "Document Clustering Using
%       Locality Preserving Indexing" IEEE TKDE, Dec. 2005.
%    
%
%    Written by Deng Cai (dengcai2 AT cs.uiuc.edu), April/2004, Feb/2006,
%                                             May/2007
% 

% bSpeed  = 1;

   soptions.gnd = options.gnd;
   soptions.ReducedDim=options.ReducedDim; 
%      soptions.k=options.step;
   switch lower(options.Mode)
       %     {'SPP','PCA', 'LDA', 'LPP', 'NPE','SRC','CSC'};
       case {lower('SPP')}  %For simplicity, we include the data point itself in the kNN
           [eigvector, eigvalue]= SPP(fea,soptions);
       case {lower('DSPP')}  %For simplicity, we include the data point itself in the kNN
           
           [eigvector, eigvalue]= DSPP(fea,soptions);
       case {lower('PCA')}
           [eigvector, eigvalue]= PCA( fea,soptions);
        case {lower('KPCA')}
            soptions.KernelType = 'Gaussian';
          soptions.t = 1;
           [eigvector, eigvalue]= KPCA( fea,soptions);
           
       case {lower('LDA')}
           soptions.Regu =1;
           soptions.Fisherface = 1;
           gnd= options.gnd;
           [eigvector, eigvalue]= LDA( gnd,soptions,fea);
       case {lower('LPP')}
           soptions.Metric = 'Euclidean';
           soptions.NeighborMode = 'KNN';        
           soptions.WeightMode = 'HeatKernel';
           soptions.k=1;
           soptions.t=1;
           W = constructW(fea,options);
         
           [eigvector, eigvalue]= LPP(W, fea,soptions);
       case {lower('NPE')}
           soptions.k = 4;
           soptions.NeighborMode = 'Supervised';
           [eigvector, eigvalue]= NPE( fea,soptions);   
       case {lower('SRC')}
           eigvector= eye(size(fea,2));
           eigvalue=fea;
       case {lower('POM')}
           soptions.delta=options.delta;
           [eigvector, eigvalue]= POM( fea,soptions);
       otherwise
           disp('error');
end

%=================================================

