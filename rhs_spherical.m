function res = rhs_spherical(t,u)
%given a constant z, finds the functions with respect to t
% u = [zinit, pinit, Pinit]

z=u(1);
p=u(2);
P=u(3);

dz=???;
dp=p-p0;
dP=P-P0;


res = [dz dp dP];

