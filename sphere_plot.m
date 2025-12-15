function sphere_plot(rho_mean)
% visualize spherically symmetric density on a sphere

nTheta = 40;
nPhi   = 80;

theta = linspace(0,pi,nTheta);
phi   = linspace(0,2*pi,nPhi);
[TH,PH] = meshgrid(theta,phi);

R = 1.0;
X = R.*sin(TH).*cos(PH);
Y = R.*sin(TH).*sin(PH);
Z = R.*cos(TH);

rho_ang = rho_mean * ones(size(X));  % same density everywhere

figure;
surf(X,Y,Z,rho_ang,'EdgeColor','none');
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
colormap(turbo);
colorbar;
title('Spherically symmetric density');
end
