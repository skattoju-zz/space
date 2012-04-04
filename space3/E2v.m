function v = E2v(E,e)

% function v = E2v(E,e)
%
% converts Eccentric Anomoly (radians) and eccentricity to true anomoly (radians)
%
% Copyright @2011 Scott Gleason 
% License: GNU GPLv3
%

E=mod(E,2*pi);

Erads = E;

v = acos((e-cos(Erads))/(e*cos(Erads)-1));

if (E<0) | (E>pi) 
 	v = -v;
end

%%
