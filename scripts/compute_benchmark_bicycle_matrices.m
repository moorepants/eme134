function [M, C1, K0, K2] = compute_benchmark_bicycle_matrices(p)
% COMPUTE_BENCHMARK_BICYCLE_MATRICES - Returns the canonical matrices of the
% benchmark Whipple-Carvallo bicycle model linearized about the upright
% constant velocity configuration. It uses the parameter definitions from:
%
% J.P Meijaard, Jim M Papadopoulos, Andy Ruina and A.L Schwab, 2007,
% Linearized dynamics equations for the balance and steer of a bicycle: a
% benchmark and review, Proc. R. Soc. A. 4631955–1982
% http://doi.org/10.1098/rspa.2007.1857
%
% Syntax: [M, C1, K0, K2] = compute_benchmark_bicycle_matrices(p)
%
% Inputs:
% p - structure
%     A dictionary of the benchmark bicycle parameters. Make sure your units
%     are correct and match the benchmark paper's units.
%
% Outputs:
% M - matrix, size 2x2
%     The mass matrix.
% C1 - matrix, size 2x2
%     The part of the damping matrix that is proportional to the speed, v.
% K0 - matrix, size 2x2
%     The part of the stiffness matrix proportional to gravity, g.
% K2 - matrix, size 2x2
%     The part of the stiffness matrix proportional to the speed squared,
%     v^2.

mT = p.mR + p.mB + p.mH + p.mF;
xT = (p.xB*p.mB + p.xH*p.mH + p.w*p.mF)/mT;
zT = (-p.rR*p.mR + p.zB*p.mB + p.zH*p.mH - p.rF*p.mF)/mT;

ITxx = (p.IRxx + p.IBxx + p.IHxx + p.IFxx + p.mR*p.rR^2 + p.mB*p.zB^2 + ...
        p.mH*p.zH^2 + p.mF*p.rF^2);
ITxz = (p.IBxz + p.IHxz - p.mB*p.xB*p.zB - p.mH*p.xH*p.zH + p.mF*p.w*p.rF);
p.IRzz = p.IRxx;
p.IFzz = p.IFxx;
ITzz = (p.IRzz + p.IBzz + p.IHzz + p.IFzz + p.mB*p.xB^2 + p.mH*p.xH^2 + ...
        p.mF*p.w^2);

mA = p.mH + p.mF;
xA = (p.xH*p.mH + p.w*p.mF)/mA;
zA = (p.zH*p.mH - p.rF*p.mF)/mA;

IAxx = (p.IHxx + p.IFxx + p.mH*(p.zH - zA)^2 + p.mF*(p.rF + zA)^2);
IAxz = (p.IHxz - p.mH*(p.xH - xA)*(p.zH - zA) + p.mF*(p.w - xA)*(p.rF + ...
        zA));
IAzz = (p.IHzz + p.IFzz + p.mH*(p.xH - xA)^2 + p.mF*(p.w - xA)^2);
uA = (xA - p.w - p.c)*cos(p.lambda) - zA*sin(p.lambda);
IAll = (mA*uA^2 + IAxx*sin(p.lambda)^2 + 2*IAxz*sin(p.lambda)*cos(p.lambda) + ...
        IAzz*cos(p.lambda)^2);
IAlx = (-mA*uA*zA + IAxx*sin(p.lambda) + IAxz*cos(p.lambda));
IAlz = (mA*uA*xA + IAxz*sin(p.lambda) + IAzz*cos(p.lambda));

mu = p.c/p.w*cos(p.lambda);

SR = p.IRyy/p.rR;
SF = p.IFyy/p.rF;
ST = SR + SF;
SA = mA*uA + mu*mT*xT;

Mpp = ITxx;
Mpd = IAlx + mu * ITxz;
Mdp = Mpd;
Mdd = IAll + 2*mu*IAlz + mu^2*ITzz;
M = [Mpp, Mpd; Mdp, Mdd];

K0pp = mT*zT;
K0pd = -SA;
K0dp = K0pd;
K0dd = -SA*sin(p.lambda);
K0 = [K0pp, K0pd; K0dp, K0dd];

K2pp = 0.0;
K2pd = (ST - mT*zT)/p.w*cos(p.lambda);
K2dp = 0.0;
K2dd = (SA + SF*sin(p.lambda))/p.w*cos(p.lambda);
K2 = [K2pp, K2pd; K2dp, K2dd];

C1pp = 0.0;
C1pd = (mu*ST + SF*cos(p.lambda) + ITxz/p.w*cos(p.lambda) - mu*mT*zT);
C1dp = -(mu*ST + SF*cos(p.lambda));
C1dd = (IAlz/p.w*cos(p.lambda) + mu*(SA + ITzz / p.w*cos(p.lambda)));
C1 = [C1pp, C1pd; C1dp, C1dd];

end
