% time_evolution_on_sphere.m
clear; clf;

% --- user parameters ----
R = 1.0;               % stellar radius (units)
Nz = 100;              % spatial resolution in r
z = linspace(0, R, Nz)';   % radial grid
g = 9.81;              % gravity (constant)
pfac = 1e5;            % scale for rho0 example
gamma = 5/3;           % adiabatic index
tspan = [0, 5];        % time window for integration

% --- background density function p0(z) (user-defined) ---
p0fun = @(zz) pfac*(1 - (zz./R).^2);   % example; ensure non-negative in domain

% --- compute background pressure P0 on the z grid using your solver ---
P0vec = P0solver(z, p0fun, [g, R, pfac]);  % adapt signature if needed
% If P0solver returns column vector aligned to z, good. Otherwise interpolate inside it.

% create continuous background function handles
rho0 = p0fun(z);                           % vector rho0(z_i)
P0fun = @(zz) interp1(z, P0vec, zz, 'linear', 'extrap');
rho0fun = @(zz) interp1(z, rho0, zz, 'linear', 'extrap');

% --- derivative matrix (first derivative) D such that D*f approximates df/dz ---
dz = z(2) - z(1);
e = ones(Nz,1);
D = spdiags([ -0.5*e 0.5*e ], [-1 1], Nz, Nz) / dz;   % central for interior
% overwrite first and last rows with 2nd-order one-sided
D(1,1:3) = [-3/2, 2, -1/2] / dz;
D(end,end-2:end) = [1/2, -2, 3/2] / dz;

% --- sound speed on grid ---
cs = sqrt(gamma * (P0vec ./ rho0));   % Nzx1

% --- initial perturbation U0: stacked [v; rho'; P'] ---
v0 = zeros(Nz,1);
rhoprime0 = zeros(Nz,1);
% example: Gaussian pressure kick near r = 0.3R
Pprime0 = 1e-6 * exp(-(z - 0.3*R).^2 / (0.02*R)^2);

U0 = [v0; rhoprime0; Pprime0];

% --- RHS function for method-of-lines ---
function dUdt = rhs_mol(t, U)
    % U: 3*Nz vector
    v = U(1:Nz);
    rho_p = U(Nz+1:2*Nz);
    P_p = U(2*Nz+1:3*Nz);

    % compute spatial derivatives
    dPdz = D * P_p;                     % ∂P'/∂z
    rho0_vec = rho0;                    % precomputed
    d_rho0v_dz = D * (rho0_vec .* v);   % ∂(rho0 v')/∂z

    % time derivatives
    drhodt = - d_rho0v_dz;
    dvdt   = (- dPdz - rho_p * g) ./ rho0_vec;
    dPdt   = (cs.^2) .* drhodt;

    dUdt = [dvdt; drhodt; dPdt];
end

% --- integrate in time (use stiff solver) ---
opts = odeset('RelTol',1e-6,'AbsTol',1e-8);
[tSol, Usol] = ode15s(@rhs_mol, linspace(tspan(1), tspan(2), 200), U0, opts);

% --- extract P'(t,z) matrix ---
Nt = length(tSol);
Pprime_all = zeros(Nt, Nz);
for k = 1:Nt
    Uk = Usol(k,:)';
    Pprime_all(k,:) = Uk(2*Nz+1:3*Nz)';   % row = z
end

% --- animate mapped to sphere ---
n = 80;
[XS, YS, ZS] = sphere(n);
XS = R*XS; YS = R*YS; ZS = R*ZS;
radius_grid = sqrt(XS.^2 + YS.^2 + ZS.^2);  % equals R but kept for generality

figure('color','w');
for k = 1:Nt
    P_snapshot = Pprime_all(k,:);  % 1 x Nz
    % map radial-only perturbation to sphere surface by interpolation
    P_surf = interp1(z, P_snapshot, radius_grid, 'linear', 0);

    surf(XS, YS, ZS, P_surf, 'EdgeColor','none');
    shading interp; axis equal off;
    caxis([-max(abs(Pprime_all(:))) max(abs(Pprime_all(:)))]);
    colorbar;
    title(sprintf('P''(r, t) mapped to sphere, t = %.3f', tSol(k)));
    drawnow;
end
