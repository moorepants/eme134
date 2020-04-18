% constant parameters
c.beta = 1/7;  % infectious contacts per day [person/days]
c.tau = 14;  % days infectious [day]

% intial population values
S0 = 39.56E6;  % population of California [person]
I0 = 1000;  % infected [person]
R0 = 200;  % recovered [person]

x0 = [S0; I0; R0];

num_months = 8;
num_days_per_month = 30;

ts = 0:num_months*num_days_per_month;  % units of days

% integrate the equations with both the Euler method and ode45 (Runga-Kutta
% method)
f = @(t, x) eval_SIR_rhs(t, x, c);
[ts, xs] = euler_integrate(f, ts, x0);

[ts2, xs2] = ode45(f, ts, x0);

% plot the results, comparing the two integration results
hold on
title(sprintf('R0 = %1.2f', c.beta*c.tau))
plot(ts, xs(:, 1), 'b', ts2, xs2(:, 1), 'b--')  % S(t)
plot(ts, xs(:, 2), 'r', ts2, xs2(:, 2), 'r--')  % I(t)
plot(ts, xs(:, 3), 'g', ts2, xs2(:, 3), 'g--')  % R(t)
xlabel('Time [days]')
ylabel('Number of people')
legend('S (Euler)', 'S (ode45)', ...
       'I (Euler)', 'I (ode45)', ...
       'R (Euler)', 'R (ode45)')
hold off
