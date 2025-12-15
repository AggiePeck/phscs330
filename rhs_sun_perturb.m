function dydt = rhs_sun_perturb(t,y,params)

r    = params.r;
rho0 = params.rho0;
P0   = params.P0;
omega= params.omega;
gamma= params.gamma;

Nr   = numel(r);
drho = y(1:Nr);
dP   = y(Nr+1:2*Nr);
v    = y(2*Nr+1:3*Nr);

% simple radius‑dependent phase (standing wave)
phi_r = 2*pi*r;                  % different phase with radius

% damped driven oscillator for density perturbation at each r
d_drho_dt = -gamma*drho + 0.02*rho0.*sin(omega*t + phi_r);

% tie pressure perturbation linearly to density perturbation
Gamma1 = 5/3;
d_dP_dt = -gamma*dP + Gamma1*P0.*(d_drho_dt./(rho0+1e-6));

% very small velocity just to have something to plot
d_v_dt  = -gamma*v;

dydt = [d_drho_dt; d_dP_dt; d_v_dt];
end
