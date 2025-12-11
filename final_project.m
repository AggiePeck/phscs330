clear;
close all;


% Star characteristics
Teff=5000; % observed temperature of star at the photosphere (we'll say r=R)
R=1000; % radius of star
mu=42; % gas density constant??
kb=; % ???
mp=; % ???
pfac=42; % constant for density
Pc = p0*g*R % Pressure at center of star (assuming constant density. May need to do an integration instead)

% our equilibrium values
z0=42;

p0=@(z) pfac*(1-(z/R)^2); % for example, doesn't need to be this

P0=bvp4c(P0ode,P0bc,solinit);
T0=P0*mu*mp/p0/kb;

zinit = ;
pinit = ;
Pinit = ;

u0 = [zinit, pinit, Pinit];


[t,u]=ode45(@(t,u) rhs_spherical(t,u,p0,P0),tspan,u0);