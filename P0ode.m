function P0=P0solver(z,P,Pa,Pb,)



function dPdz = P0ode(z,P,p0,g)

dPdz=-p0*g;

end

function res = P0bc(Pa,Pb)