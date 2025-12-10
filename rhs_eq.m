function equi = rhs_eq(z,u)
% finds our equilibrium functions of density and Pressure with respect to z
% u = [p0, P0, dp0, dP0]

p0=u(1);
P0=u(2);

dp0=???;
dP0=-p0*g;

equi = [p0; P0; dp0; dP0];