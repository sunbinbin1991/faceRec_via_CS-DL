function S = analyticalS(D,X)

[r_d,c_d]=size(D); [r_x,c_x]=size(X);
[U_d,Sigma_d,V_d]=svd(D);
rr=rank(Sigma_d);
Sigma_d=Sigma_d(1:rr,1:rr);

X_tilde=U_d'*X;
X_tilde_1=X_tilde(1:rr,:);

% randn('state',1)
S_tilde_2=randn(c_d-rr,c_x);

S=V_d*[Sigma_d\X_tilde_1;S_tilde_2];
