function [posvel,status] = sgp4(tsince,keps)
% function [posvel,status] = sgp4(tsince,keps)
%==========================================================================
%    filename: sgp4
%    purpose : norad propagator for the near-earth satellites
%    Code in the Public Domain
%===========================================================================*/

%function [posvel] = sgp4(tsince,keps)

%        input
%            tsince  :   elapsed seconds since 2-line epoch
%            keps    :   2-line data buffer
%                        [1] epoch of 2 line element (2l format: not used)
%                        [2] mean motion (rad/sec)
%                        [3] eccentricity (nd)
%                        [4] inclination (rad)
%                        [5] right ascending node (rad)
%                        [6] argument of perigee (rad)
%                        [7] mean anomaly (rad)
%                        [8] mean motion dot / 2 (rad/s/s: not used)
%                        [9] mean motion dot dot /6 (rad/s/s/s: not used)
%                        [10] the sgp4 type drag coefficient (1/du)
%        output
%            position and velocity in ECI (m and m/s)
%            status

TWOPI = (2.0*3.14159265358979);      
                                
E6A =      1.e-6;               %  kepler eq. tolerance            
Q0 =     120.0;              %  sgp4/sdp4 density func.         
S0 =     78.0;                %  sgp4/sdp4 density func.         
TOTHRD = (2.0/3.0);           %  2/3                             
XJ2 =    1.082616e-3;         %  J2 (sdp4 defined)               
XJ3 =   -0.253881e-5;         %  J3 (sdp4 defined)               
XJ4 =   -1.65597e-6;          %  J4 (sdp4 defined)               
XKE =    0.743669161e-1;      %  sqrt(GM) (sdp4 unit)            
XKMPER = 6378.135;            %  earth radius                    
XSCPMN = 60.0 ;               %  seconds per minute              
XKM2MR = 1000.0;              %  km to metres                    
ER =     1.0;                 %  normalised earth radius         
MAXLOOP = 100;                 %  max. loop for iteration         

%  INITIALISE DOMINANT PARAMETER

    K2  =   0.5*XJ2*ER*ER;          %  j2 term                                   
    A30 =  -XJ3*ER*ER*ER;           %  j3 term                         
    K4  =  -0.375*XJ4*ER*ER*ER*ER;  %  j4 term                         
    n0  =   keps(2)*XSCPMN;           %  "mean" mean motion rad/min      
    e0  =   keps(3);                  %  "mean" eccentricty              
    i0  =   keps(4);                  %  "mean" inclination              
    an0 =   keps(5);                  %  "mean" ascending node           
    ap0 =   keps(6);                  %  "mean" augument of perigee      
    M0  =   keps(7);                  %  "mean" mean anomaly             
    B   =   keps(10)/ER;               %  sgp4 type drag term b-star      

% sgp4 would not accept zero eccentricity

    if(e0 < 1.e-14)
       status = 1;
    end	
  
    t   =   tsince/XSCPMN;          %  second => minutes              
    t2  =   t*t;
    t3  =   t*t2;
    t4  =   t*t3;
    t5  =   t*t4;                   %  tsince parameters               
    
    thi     =   cos(i0);
    thi2    =   thi*thi;
    thi3    =   thi*thi2;
    thi4    =   thi*thi3;
    x3thm1  =   3.0*thi2 - 1.0;     %  cos(i)s and 3cosi2 - 1          
    
    x1      =   sqrt(1.0 - e0*e0);
    beta2   =   x1*x1;
    beta3   =   x1*beta2;
    beta4   =   x1*beta3;
    beta7   =   x1*beta4;
    beta8   =   x1*beta7;           %  beta = sqrt(1 - e2)             

%  RECOVER ORIGINAL MEAN MOTION
%  AND DSEMIMAJOR AXIS FROM INPUT
%  ELEMENTS    

    a       =   (XKE/n0)^TOTHRD;
    del     =   1.5*K2*x3thm1/a/a/beta3;
    a       =  a * (1.0 - del*(0.5*TOTHRD + del*(1.0 + 134.0/81.0*del)));
    del     =   1.5*K2*x3thm1/a/a/beta3;

    n       =   n0/(1.0 + del);
    a       = a/(1.0 - del);

% original semi-major axis and mean motion recovered

    a2      =   a*a;
    a4      =   a2*a2;

%  INTIALISATION
%  FOR PERIGEE LESS THAN 220 KILOMETERS, THE EQUATIONS ARE
%  TRUNCATED TO LINEAR VARIATION IN SQRT(A) AND QUADRATIC 
%  VARIATION IN MEAN ANOMALY. ALSO THE C3 TERM, THE DELTA OMEGA
%  TERM, AND DELTA M TERM ARE DROPPED

%  FOR PERIGEE BELOW 156 KM, THE 
%  VALUE OF S AND QOMS2T ARE
%  ALTERED   

    perigee =   (a*(1.0 - e0) - ER)*XKMPER;

    if(perigee <  98.0)
	S   =   20.0;
    elseif(perigee < 156.0)
	S   =   perigee - S0;
    else
	S   =   S0;
    end	
    
    QOMS2T  =   ((Q0 - S)*ER/XKMPER)^4.0;
    S       =   S/XKMPER + ER;

    xai     =   1.0/(a - S);
    xai2    =   xai*xai;
    xai3    =   xai*xai2;
    xai4    =   xai*xai3;
    xai5    =   xai*xai4;
    
    eta     =   a*e0*xai;
    eta2    =   eta*eta;
    eta3    =   eta*eta2;
    eta4    =   eta*eta3;


    x3  =   1.0 - eta2;
    x1  =   1.0/(x3^3.5);

    x2  =   a*(1.0 + 1.5*eta2 + 4.0*e0*eta + e0*eta3);
    x2  =  x2 + 1.5*K2*xai*(-0.5 + 1.5*thi2)*(8.0 + 24.0*eta2 + 3.0*eta4)/x3;

    C2  =   QOMS2T*xai4*n*x1*x2;
    C1  =   B*C2;
    C3  =   QOMS2T*xai5*A30*n*ER*sin(i0)/K2/e0;  

    x2  =  -3.0*x3thm1*(1.0 + 1.5*eta2 - 2.0*e0*eta - 0.5*e0*eta3); 
    
    x2  =  x2 + 0.75*(1.0 - thi2)*(2.0*eta2 - e0*eta - e0*eta3)*cos(2.0*ap0);
    
    x2  =   2.0*K2*xai*x2/a/x3;
    x2  =   2.0*eta*(1.0 + e0*eta) + 0.5*(e0 + eta3) - x2;
    
    C4  =   2.0*n*QOMS2T*xai4*a*beta2*x1*x2;

    x2  =   1.0 + 2.75*eta*(eta + e0) + e0*eta3;
    C5  =   2.0*QOMS2T*xai4*a*beta2*x1*x2;

    D2  =   4.0*a*xai*C1*C1;
    D3  =   2.0*TOTHRD*a*xai2*(17.0*a + S)*C1*C1*C1;
    D4  =   TOTHRD*a*xai3*(221.0*a + 31.0*S)*C1*C1*C1*C1;

% sgp4 type drag coefficients of C1, C2, C3, C4, C5 and D2, D3, D4 are all derived

%  UPDATE FOR SECULAR GRAVITY AND
%  ATMOSPHERIC DRAG  

    x2  =   0.1875*K2*K2*(13.0 - 78.0*thi2 + 137.0*thi4)/a4/beta7;
    x2  = x2 + 1.5*K2*x3thm1/a2/beta3;
    x2  = x2 + 1.0;

    mDF     =   M0 + x2*n*t;

    x2  =   1.25*K4*(3.0 - 36.0*thi2 + 49.0*thi4)/a4/beta8;
    x2  = x2 + 0.1875*K2*K2*(7.0 - 114.0*thi2 + 395.0*thi4)/a4/beta8;
    x2  = x2 - 1.5*K2*(1.0 - 5.0*thi2)/a2/beta4;

    apDF    =   ap0 + x2*n*t;

    x2  =   2.5*K4*thi*(3.0 - 7.0*thi2)/a4/beta8;
    x2  = x2 + 1.5*K2*K2*(4.0*thi - 19.0*thi3)/a4/beta8;
    x2  =  x2 - 3.0*K2*thi/a2/beta4;

    anDF    =   an0 + x2*n*t;

    dap     =   B*C3*cos(ap0)*t;

    x1      =   (1.0 + eta*cos(mDF))^3.0;
    x2      =   (1.0 + eta*cos(M0))^3.0;
    x2      =   x1 - x2;

    dM      =   -TOTHRD*QOMS2T*B*xai4*ER*x2/e0/eta;
    
    if(perigee >= 220.0)
        Mp  =   mDF  + dap + dM;
        ap  =   apDF - dap - dM;
        an  =   anDF - 10.5*n*K2*thi*C1*t2/a2/beta2;
        e   =   e0 - B*C4*t - B*C5*(sin(Mp) - sin(M0));
        del =   1.0 - C1*t - D2*t2 - D3*t3 - D4*t4;
        a   =   a*del*del;
        L   =   (0.6*D4 + 1.2*D2*D2 + C1*(2.4*D3 + C1*(6.0*D2 + C1*C1)))*t5;
        L   = L + (0.75*D3 + 3.0*C1*D2 + 2.5*C1*C1*C1)*t4;
        L   = L + (D2 + 2.0*C1*C1)*t3;
        L   = L + 1.5*C1*t2;
        L   =   Mp + ap + an + n*L;
    else
        Mp  =   mDF;
        ap  =   apDF;
        an  =   anDF - 10.5*n*K2*thi*C1*t2/a2/beta2;
        e   =   e0 - B*C4*t;
        del =   1.0 - C1*t;
        a   =   a*del*del;
        L   =   1.5*C1*t2;
        L   =   Mp + ap + an + n*L;
    end
    
    beta2   =   1.0 - e*e;
    n       =   XKE/(a^1.5);
    
%  LONG PERIOD PREIODICS   

    axN     =    e*cos(ap);
    LL      =    A30*sin(i0)*e*cos(ap)*(3.0 + 5.0*thi);
    LL      =    LL/8.0/K2/a/beta2/(1.0 + thi);
    ayNL    =    A30*sin(i0)/4.0/K2/a/beta2;
    LT      =    L + LL;
    ayN     =    e*sin(ap) + ayNL;

%  SOLVE KEPLERS EQUATION  

    Fi      =   LT - an;
    Fi      =   mod(Fi,TWOPI);
    F0      =   Fi;

    loop    =   1;
    j       =   0;
    
    while(loop ~= 0)                  

        Fn  =   Fi;
        dFi =   F0 - ayN*cos(Fn) + axN*sin(Fn) - Fn;
        dFi =   dFi/(-ayN*sin(Fn) - axN*cos(Fn) + 1.0);
        Fi  =   Fn + dFi;
        
        if(abs(Fi - Fn) < E6A)
		loop    =   0;
	end        

        j = j + 1;

        if(j == MAXLOOP)
		status = 2;  % iteration would not converge    
	end

	end

%  SHORT PERIOD PRELIMINARY
%  QUANTITIES   
                                     
    ecosE   =   axN*cos(Fi) + ayN*sin(Fi);
    esinE   =   axN*sin(Fi) - ayN*cos(Fi);

    eL      =   sqrt(axN*axN + ayN*ayN);
    PL      =   a*(1.0 - eL*eL);

    r       =   a*(1.0 - ecosE);
    rdot    =   XKE*sqrt(a)*esinE/r;
    rfdot   =   XKE*sqrt(PL)/r;

    cosu    =   cos(Fi) - axN + ayN*esinE/(1.0 + sqrt(1.0 - eL*eL));
    cosu    =   a*cosu/r;

    sinu    =   sin(Fi) - ayN - axN*esinE/(1.0 + sqrt(1.0 - eL*eL));
    sinu    =   a*sinu/r;

    u       =   atan2(sinu, cosu);

% UPDATE FOR SHORT PERIODICS   

    cos2u   =   2.0*cosu*cosu - 1.0;
    sin2u   =   2.0*cosu*sinu;  

    dr      =   0.50*K2*(1.0 - thi2)*cos2u/PL;
    du      =  -0.25*K2*(7.0*thi2 - 1.0)*sin2u/PL/PL;
    dan     =   1.50*K2*thi*sin2u/PL/PL;
    di      =   1.50*K2*thi*sin(i0)*cos2u/PL/PL;
    drdot   =   -K2*n*(1.0 - thi2)*sin2u/PL;
    drfdot  =   (1.0 - thi2)*cos2u + 1.5*x3thm1;
    drfdot  =   K2*n*drfdot/PL;

    rk      =   1.0 - 1.5*K2*sqrt(1.0 - eL*eL)*x3thm1/PL/PL;
    rk      =   r*rk + dr;
    uk      =   u + du;
    ank     =   an + dan;
    ik      =   i0 + di;
    rdotk   =   rdot + drdot;
    rfdotk  =   rfdot + drfdot;
 
%  ORIENTATION VECTORS

    sinuk   =   sin(uk);
    cosuk   =   cos(uk);
    sinik   =   sin(ik);
    cosik   =   cos(ik);
    sinnok  =   sin(ank);
    cosnok  =   cos(ank);
    
    xmx     =  -sinnok*cosik;
    xmy     =   cosnok*cosik;
    
    ux      =   xmx*sinuk + cosnok*cosuk;
    uy      =   xmy*sinuk + sinnok*cosuk;
    uz      =   sinik*sinuk;
    vx      =   xmx*cosuk - cosnok*sinuk;
    vy      =   xmy*cosuk - sinnok*sinuk;
    vz      =   sinik*cosuk;

%  POSITION AND VELOCITY

    x1      =   XKMPER*XKM2MR/ER;
    x2      =   x1/XSCPMN;

    posvel(1)   =   rk*ux*x1;
    posvel(2)   =   rk*uy*x1;
    posvel(3)   =   rk*uz*x1;
    posvel(4)   =   (rdotk*ux + rfdotk*vx)*x2;
    posvel(5)   =   (rdotk*uy + rfdotk*vy)*x2;
    posvel(6)   =   (rdotk*uz + rfdotk*vz)*x2;

status = 0;

% end

