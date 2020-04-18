function [t, x] = runga_kutta_integrate(f, t, x0)
    % RUNGA_KUTTA_INTEGRATE - Integrates a set of first order ordinary
    % differential equations using the 4th order Runga-Kutta method.
    %
    % Syntax: [t, x] = runga_kutta_integrate(f, t, x0)
    %
    % Inputs:
    %   f - An anonymous function that evaluates the right hand side of the
    %       first order ordinary differential equations, i.e. dx/dt. The
    %       function must follow the syntax dxdt = f(t, x) and return a size
    %       mx1 vector where t is size 1x1 and x is size mx1.
    %   t - Vector of monotonically increasing time values. [size 1xn]
    %   x0 - Vector a initial conditions for the states. [size mx1]
    % Outputs:
    %   t - Vector of monotonically increasing time values (same as the
    %       input t). [size 1xn]
    %   x - Matrix of state values as a function of time. [size nxm]

    % Create an "empty" matrix to hold the results n x m.
    x = nan * ones(length(t), length(x0));

    % Set the initial conditions to the first element.
    x(1, :) = x0;

    % Use a for loop to sequentially calculate each new x.
    for i = 2:length(t)
        deltat = t(i) - t(i-1);

        k1 = f(t(i - 1), x(i - 1, :)');
        k2 = f(t(i - 1) + deltat/2, x(i - 1, :)' + deltat.*k1./2);
        k3 = f(t(i - 1) + deltat/2, x(i - 1, :)' + deltat.*k2./2);
        k4 = f(t(i), x(i - 1, :)' + deltat.*k3);

        x(i, :) = x(i - 1, :)' + 1/6*deltat*(k1 + 2*k2 + 2*k3 + k4);

    end

end
