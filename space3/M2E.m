function E = M2E(M,e)

%	E = M2E(M,e);
%
% Calculates eccentric anomalies given mean anomaly, and eccentricity.
% M and E in degrees.  
% 
% Reference: Montenbruck and Gill, Satellite Orbits, Section 2.2.2
%
% Copyright @2011 Scott Gleason 
% License: GNU GPLv3
%

Mrad = M;
E0rad = Mrad;
f_f1 = 2*pi;

while f_f1 > 1.e-12

    f = E0rad - e*sin(E0rad) - Mrad;
    f1 = 1 - e*cos(E0rad);
    f_f1 = f/f1;
    E0rad = E0rad - f_f1;

end

E = E0rad;
