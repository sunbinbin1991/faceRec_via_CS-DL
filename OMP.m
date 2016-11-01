function [A]=OMP(D,X,L)
% ========================================================
% Sparse coding of a group of signals based on a given dictionary and specified number of
% atoms to use.     X=DA
% input arguments:  D - the dictionary
%                   X - the signals to represent
%                   L - the maximum number of coefficients to use in OMP
% output arguments: A - sparse coefficient matrix.
% ========================================================
[n,P]=size(X);  %(^SS^):there are P signals with n dimensions
[n,K]=size(D);  %(^SS^):the dictionary is n-by-K
 D_nor = diag(1./sqrt(diag(D'*D)));  %normalization
 D = D*D_nor;

for k=1:1:P,    %(^SS^):���ź����ν���ϡ�����
    a=[];       %(^SS^):��ʼ����Ϊ������
    x=X(:,k);   %(^SS^):get the k-th signal and give it to x
    residual=x; %(^SS^):initialize the residual
    indx=zeros(L,1);%(^SS^):L - the maximum number of coefficients to use in OMP��indx-the solution support������Ԫ��λ��
    for j=1:1:L
        proj=D'*residual;%��D��residual���ڻ����ڻ��Ľ��ֵԽ�������Խǿ��
        [maxVal,pos]=max(abs(proj));
        pos=pos(1);%ֻ��Ҫ����һ��λ�þͺ�
        indx(j)=pos;
        a=pinv(D(:,indx(1:j)))*x;%pinv ��α�棬a��D(:,indx(1:j))����ͬ��ά��
        residual=x-D(:,indx(1:j))*a;
        if sum(residual.^2) < 1e-6
            break;
        end
    end;
    temp=zeros(K,1);    %(^SS^):�ֵ�D��K�У����a��K�У�tempΪ�����A����������ʼ�����������
    temp(indx(1:j))=a;  %(^SS^):a��temp�ķ��㲿��
    A(:,k)=sparse(temp);%(^SS^):��tempȥ����A�ĵ�k��
end;
    A = D_nor * A;
end