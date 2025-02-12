function [rmse] = F_rmse(X,endmember)

[L,N] = size(X);
S = hyperNnls(X,endmember);

S(S<0) = 0;

rmse = sum(sqrt(sum((X - endmember * S).^2)/L))/N;
end

