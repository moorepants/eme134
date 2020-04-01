function xdot = eval_train_wheelset_rhs(t, x, c)
% EVAL_TRAIN_WHEELSET_RHS - Returns the time derivative of the states, i.e.
% evaluates the right hand side of the explicit ordinary differential
% equations for the train wheelset model.
%
% Syntax: xdot = eval_train_wheelset_rhs(t, x, c)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   x - State vector at time t, size 4x1, [q1; q2; u1; u2]
%   c - Constant parameter structure with 16 parameters.
% Outputs:
%   xdot - Time derivative of the states at time t, size 4x1.

% unpack the states into useful variable names
% replace the question marks with useful variable names
? = x(1);
? = x(2);
? = x(3);
? = x(4);

% unpack the parameters into useful variable names
% replace the question marks with your code and add all constants
? = c.?;
? = c.?;
? = c.?;

% calculate the derivatives of the state variables

replace this line of code with your lines of code

% pack the state derivatives into an mx1 vector
xdot = [q1dot; q2dot; u1dot; u2dot];

end
