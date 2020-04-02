% define the initial conditions
x0 = ?

% define a set of time values
ts = ?

% set the numerical values for the constants
c.? = ?;
c.? = ?;
c.? = ?;
c.? = ?;

% integrate the differential equations
rhs = @(t, x) eval_train_wheelset_rhs(t, x, c);
[ts, xs] = ode45(rhs, ts, x0);

% evaluate the outputs
ys = zeros(length(ts), 2);  % place to store outputs
for i=1:length(ts)
    % calculate the outputs and store them
    ys(i, :) = eval_train_wheelset_outputs(ts(i), xs(i, :), c);
end

% write your code to make the plots below
