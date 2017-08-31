%Function twoDimDist: caculating the distance between n_0 and n1 in a 2D plane.
%Parameters: n_0 and n_1 are two nodes, each denoted by (x,y) coordinates in a 2D plane
%Returned value: y is the distance between them.
function y=twoDimDist(n_0, n_1)
y=((n_0(1)-n_1(1))^2+(n_0(2)-n_1(2))^2)^0.5;