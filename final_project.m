clear; clc; close all;

% Which rho index you want to animate at (80 max)
startrho = 80;

%% build Sun background (rho0(r), P0(r))

useSolarFile = false;   % We'd set true if file for data were present, but not right now

Nr = 80;
rmin = 0.0;
rmax = 1.0; % radius in units of R_sun
r = linspace(rmin,rmax,Nr).';

if useSolarFile
    % columns: 1 mass frac, 2 radius/Rsun, 3 T, 4 rho, 5 P, 6 Lfrac
    data = load('bp2004stdmodel.dat');
    r_tab   = data(:,2); % radius / R_sun
    rho_tab = data(:,4); % g/cm^3
    P_tab   = data(:,5); % dyn/cm^2

    rho0 = interp1(r_tab,rho_tab,r,'pchip','extrap');
    P0   = interp1(r_tab,P_tab  ,r,'pchip','extrap');
else
    % simple analytic background: n=3-like polytrope 
    rho_c = 150; % g/cm^3 central density scale
    P_c   = 2.5e17; % dyn/cm^2 central pressure scale
    rho0  = rho_c*(1 - r.^2).^3;
    rho0(r>=1) = 0;
    P0    = P_c*(1 - r.^2).^4;
    P0(r>=1) = 0;
end

%% perturbation parameters
params.omega   = 2*pi/(300); % oscillation period ~300 s (solar p-modes) [web:111][web:119]
params.gamma   = 1/2000; % damping rate (controls decay)
params.kr      = 8*pi; % radial wavenumber -> number of nodes
params.c_s     = 1.0; % scaled sound speed
params.r       = r;
params.rho0    = rho0;
params.P0      = P0;

% initial perturbations: small sinusoidal mode
A_rho = 0.02; % 2% density perturbation
A_P   = 0.02; % 2% pressure perturbation

drho0 = A_rho * rho0 .* sin(params.kr*r);
dP0   = A_P   * P0   .* sin(params.kr*r);
v0    = zeros(Nr,1);

y0 = [drho0; dP0; v0];

%% integrate in time with ode45
tspan = [0 2000]; % seconds (dimensionless here)
odefun = @(t,y) rhs_sun_perturb(t,y,params);
opts   = odeset('RelTol',1e-6,'AbsTol',1e-9);

[t,y] = ode45(odefun,tspan,y0,opts);

Nr = numel(r);
drho = y(:,1:Nr);
dP   = y(:,Nr+1:2*Nr);
v    = y(:,2*Nr+1:3*Nr);

rho = drho + rho0.'; % total density
P   = dP   + P0.'; % total pressure

%% plots: profiles at start and end
figure;
subplot(3,1,1);
plot(r,rho(1,:),'-k',r,rho(end,:),'-r','LineWidth',1.2);
ylabel('\rho (g/cm^3)');
legend('t=0','t=end','Location','best');
title('Radial profiles of density');

subplot(3,1,2);
plot(r,P(1,:),'-k',r,P(end,:),'-r','LineWidth',1.2);
ylabel('P (dyn/cm^2)');

subplot(3,1,3);
plot(r,v(1,:),'-k',r,v(end,:),'-r','LineWidth',1.2);
ylabel('v (arb)'); xlabel('r/R_\odot');

%% spacetime plots (rho and P) 

figure;
imagesc(r,t,rho); axis xy;
xlabel('r/R_\odot'); ylabel('t'); colorbar;
title('\rho(r,t)');
caxis([0.9*min(rho0) 1.1*max(rho0)]);   

figure;
imagesc(r,t,P); axis xy;
xlabel('r/R_\odot'); ylabel('t'); colorbar;
title('P(r,t)');
caxis([0.9*min(P0) 1.1*max(P0)]);
%% simple pulsating-sphere view using surface density
rho_surf = rho(:,startrho);
sphere_plot(rho_surf);
