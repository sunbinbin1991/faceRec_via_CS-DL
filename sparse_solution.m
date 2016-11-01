
%
%
function s = sparse_solution(Psi,x)

[M,~] = size(x);

[N,L] = size(Psi);

cvx_begin quiet
variable s(L,1)
minimize norm(s,1)
subject to
x == Psi*s;
%  ones(1,L)*s == 1;
cvx_end


