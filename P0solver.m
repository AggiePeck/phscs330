function P0=P0solver(z,P,constants)

    p0=constants(1); % density, obtained through other means
    g=constants(2); % gravitational constant for this star (assumed constant)
    R=constants(3); % Radius of star
    Pc=constants(4); % Pressure at center
    
    dPdz=P0ode(z,P,p0,g);

end


function dPdz = P0ode(z,P,p0,g)

    dPdz=-p0*g;

end


function res = P0bc(Pa,Pb)

    res = [Pa-Pc; Pb-0];
    
end