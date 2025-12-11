function P0sol=P0solver(z,p0,constants)
% Takes the P0 ODE and returns the solution given BCs
% z         = linspace from 0 to R
% p0        = density function of z
% Constants = [g, R, Pc]

    % Define our constants
    g=constants(1); % gravitational constant for this star (assumed constant)
    R=constants(2); % Radius of star
    Pc=constants(3); % Pressure at center (BC at r=0)
    
    % Define ODE, BCs, and initial guess of solution
    dPdz = @(z,P) -p0(z)*g; 
    BCs = @(Pa,Pb) [Pa-Pc; Pb-0];
    guess = @(z) Pc*(1-z/R); % ?? Could try different guesses ??


    % Solves our ODE
    solinit = bvpinit(z,guess);
    P0sol = bvp4c(dPdz,BCs,solinit);





