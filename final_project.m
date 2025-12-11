clear;
close all;

% Universal constants
kb=1.3806504*10^(-23); % Boltzmann's constant
mp=1.672621637*10^(-27); % Proton mass
c=2.99792458*10^8; % Speed of light

% Star-specific constants
R=1000; % radius of star
Teff=5000; % Effective temperature (at r=R)
mu=42; % ?? gas density constant ??
pfac=42; % ?? constant for density ??
Pc = p0*g*R; % Pressure at center of star (assuming constant density. May need to do an integration instead)
g=G*M/R^2; % ?? This star's gravitational constant ??

% Our knot values (for the purposes of solving perturbation equations)
z0=linspace(0,R,10);
p0=@(z) pfac*(1-(z/R)^2); % ?? This function is just one possible ??
P0=P0solver(z0,p0,[g,R,Pc]);

T0=P0*mu*mp/p0/kb;

pinit = ;
zinit = ;
Pinit = ;

u0 = [ pinit, zinit, Pinit];

[t,u]=ode45(@(t,u) rhs_spherical(t,u,p0,P0),tspan,u0);