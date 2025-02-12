function [V] = volume(A)

[~,p] = size( A);

A2 = [ones(1,p);A];       
V=abs(det(A2)/factorial(p-1));

end
