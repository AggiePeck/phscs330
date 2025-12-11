clear;
close all;


% Star characteristics
T0=5000; % observed temperature of star
R=1000; % radius of star
mu=42; % gas density constant??
kb=; % ???
mp=; % ???
pfac=42; % constant for density

% our equilibrium values
z0=42;

p0=pfac*(1-(z0/R)^2); % for example, doesn't need to be this
P0=T0*p0:kb/mu/mp;

zinit = ;
pinit = ;
Pinit = ;

u0 = [zinit, pinit, Pinit];


[t,u]=ode45(@rhs_spherical,tspan,u0);