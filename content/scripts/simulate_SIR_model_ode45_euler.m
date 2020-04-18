% constant parameters
c.beta = 1/7;  % infectious contacts per day [person/days]
c.tau = 14;  % days infectious [day]

% initial population values
S0 = 39.56E6;  % population of California [person]
I0 = 1000;  % infected [person]
R0 = 200;  % recovered [person]

x0 = [S0; I0; R0];

num_months = 8;
num_days_per_month = 30;

ts = 0:num_months*num_days_per_month;  % units of days

% integrate the equations
f = @(t, x) eval_SIR_rhs(t, x, c);
[ts, xs] = ode45(f, ts, x0);

[ts2, xs2] = euler_integrate(f, ts, x0);

[ts3, xs3] = runga_kutta_integrate(f, ts, x0);

% plot the results
hold on
title(sprintf('R0 = %1.2f', c.beta*c.tau))
plot(ts, xs(:, 1), 'b', ts2, xs2(:, 1), 'b--', ts3, xs3(:, 1), 'b.')  % S(t)
plot(ts, xs(:, 2), 'r', ts2, xs2(:, 2), 'r--', ts3, xs3(:, 2), 'r.')  % I(t)
plot(ts, xs(:, 3), 'g', ts2, xs2(:, 3), 'g--', ts3, xs3(:, 3), 'g.')  % R(t)
xlabel('Time [days]')
ylabel('Number of people')
legend('Susceptible (ode45)', 'Susceptible (Euler)', 'Susceptible (RK)', ...
       'Infected (ode45)', 'Infected (Euler)', 'Infected (RK)', ...
       'Recovered (ode45)', 'Recovered (Euler)', 'Recovered (RK)')
hold off
