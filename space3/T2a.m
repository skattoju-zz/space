function a = T2a(T);
% function T = a2T(a);
%
%	T = orbital period (sec)
%	a = semimajor axis (m)
%
% Copyright @2011 Scott Gleason 
% License: GNU GPLv3
%

misc_constants

%T = 2*pi*sqrt(a^3/u);
% solve for a
a = ((T^2*u)/(4*pi^2))^(1/3);

%%
