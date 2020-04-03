function xdot = eval_SIR_rhs(t, x, c)
  % Inputs:
  % t : 1x1 scalar time
  % x : 3x1 state vector [S; I; R]
  % c : structure containing 2 constant parameters
  % Outputs:
  % xdot : 3x1 state derivative vector [S'; I', R']
  
  S = x(1); % susceptible [person]
  I = x(2); % infected [person]
  R = x(3); % recovered [person]
  
  beta = c.beta;  % infectious contacts per time [person/day]
  tau = c.tau;  % mean infectious period [day]
  
  N = S + I + R;
  
  Sdot = -beta*I*S/N;
  
  Idot = beta*I*S/N - I/tau;
  
  Rdot = I/tau;
  
  xdot = [Sdot; Idot; Rdot];

end