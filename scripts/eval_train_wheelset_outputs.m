function y = eval_train_wheelset_outputs(t, x, c)
% EVAL_TRAIN_WHEELSET_OUTPUTS - Returns the output vector at the specified
% time.
%
% Syntax: y = eval_train_wheelset_outputs(t, x, c)
%
% Inputs:
%   t - Scalar value of time, size 1x1.
%   x - State vector at time t, size 4x1, [q1; q2; u1; u2]
%   c - Constant parameter structure with 16 parameters.
% Outputs:
%   y - Output vector at time t, size 2x1, [Fx; Fy].

% unpack xdot and x as needed

replace this line with your lines

% unpack the parameters

replace this line with your lines

% calculate the forces

replace this line with your line(s)

% pack the outputs into a qx1 vector
y = [Fx; Fy];

end
