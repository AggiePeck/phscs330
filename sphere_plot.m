% sphere_contraction_demo.m
clear; close all; clc

% time vector
Nt  = 200;
t   = linspace(0,20,Nt);

% make a unit sphere grid
[nx,ny,nz] = sphere(60);          % base coordinates for radius = 1

% initial radius and figure
R0 = 1;

figure;
ax = axes;
axis equal
hold(ax,'on');
xlabel('x'); ylabel('y'); zlabel('z');
view(40,25);

% some dummy "density" perturbation that changes in time
% here it is just a traveling wave on the surface
theta = acos(nz);                 % polar angle
phi   = atan2(ny,nx);             % azimuth

for k = 1:Nt

    % radius oscillates in time (contraction / expansion)
    R = R0*(1 + 0.1*sin(2*pi*t(k)/max(t)));

    % update coordinates
    X = R*nx;
    Y = R*ny;
    Z = R*nz;

    % color map from a surface perturbation (you can use your rho' or v')
    surf_mode = sin(theta).*cos(phi - 0.5*t(k));
    % normalize colors
    C = (surf_mode - min(surf_mode(:)))/(max(surf_mode(:)) - min(surf_mode(:)));

    if k == 1
        h = surf(ax,X,Y,Z,C);
        shading interp
        colormap jet
        colorbar
    else
        set(h,'XData',X,'YData',Y,'ZData',Z,'CData',C);
    end

    drawnow;
end
