function P0sol=P0solver(z,constants)
% Takes the P0 ODE and returns the solution given BCs
% z = linspace from 0 to R
% Constants = [p0, g, R, Pc]

    p0=constants(1); % density, obtained through other means
    g=constants(2); % gravitational constant for this star (assumed constant)
    R=constants(3); % Radius of star
    Pc=constants(4); % Pressure at center (BC at r=0)
    
    guess = bvpinit(z,@(z) P0guess(z,R,Pc));
    P0sol = bvp4c(@(z,P) P0ode(z,P,p0,g),@P0bc,guess);

end


function dPdz = P0ode(z,P,p0,g)
% Creates the ode

    dPdz=-p0*g; % ?? p0 could be a function of z here ??

end


function res = P0bc(Pa,Pb)
% Creates the BCs
    res = [Pa-Pc; Pb-0];
    
end


function guess = P0guess(z,R,Pc)
% Our initial guess for it to start from

    guess=Pc*(1-z/R); % ?? Could try different guesses ??

end