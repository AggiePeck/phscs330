function sphere_plot(rho_surf)
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

figure;
C0=rho_surf(1)*ones(size(X));
h=surf(X,Y,Z,C0,'EdgeColor','none');
axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
colormap(turbo);
colorbar;


cmin = min(rho_surf);
cmax=max(rho_surf);
clim([cmin,cmax]);

for i=1:length(rho_surf)

    
    
    
    title('Spherically symmetric density');
    h.CData = rho_surf(i) * ones(size(h.CData));
    pause(.01)
end
end
