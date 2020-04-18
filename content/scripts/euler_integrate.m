function [ts, xs] = euler_integrate(f, ts, x0)
% f: function handle for the state derivative function
% ts: 1xn vector of time values
% x0: mx1 vector of initial states
% xs: nxm matrix where each column is the state at the ith time

xs = zeros(length(ts), length(x0));  % nxm matrix of zeros

xs(1, :) = x0;  % set first row to initial condition

for i=2:length(ts)
    deltat = ts(i) - ts(i - 1);
    % note the transpose ' operators to ensure the dimensions match,
    % as xs(i - 1, :) is 1xm instead of mx1
    xs(i, :) = xs(i - 1, :)' + deltat * f(ts(i - 1), xs(i - 1, :)');
end

end
