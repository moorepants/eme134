function animate_drone(ts, ys, p)
% ANIMATE_DRONE - Creates an animation of the drone flight given the output
% trajectories.
%
% Syntax: animate_drone(ts, ys, p)
%
% Inputs:
%   ts - Vector of time values, size 1x1000.
%   ys - Matrix of output values , size 1000x10
%        The outputs are, in order:
%        1: theta, pitch angle [rad]
%        2: z, altitude [m]
%        3: q, pitch rate [rad/s]
%        4: w, vertical velocity [m/s]
%        5: thetac, cumlative pitch error [rad]
%        6: zc, cumlative altitude error [rad]
%        7: Ff, Front rotor thrust [N]
%        8: Fr, Rear rotor thrust [N]
%        9: x, longitudinal position [m]
%        10: zd, desired altitude [m]
%   p - Constant parameter structure that includes at least a and b.

figure()
hold on
box on

extents = 2.0;  % meters

delt = ts(2) - ts(1);

thetas = ys(:, 1);
zs = ys(:, 2);
xs = ys(:, 9);
zds = ys(:, 10);

desired_path = plot(xs(1:2), zds(1:2), 'r');
actual_path = plot(xs(1:2), zs(1:2), 'b');

for i = 2:length(ts)
    theta = thetas(i);
    z = zs(i);
    x = xs(i);
    % update the desired path
    set(desired_path, 'XData', xs(1:i), 'YData', zds(1:i));
    % update the acutal path
    set(actual_path, 'XData', xs(1:i), 'YData', zs(1:i));
    % plot the "wings"
    plot([x - p.b*cos(theta), x + p.a*cos(theta)], ...
         [z + p.b*sin(theta), z - p.a*sin(theta)], 'k', 'linewidth', 2)
    % plot the mass center
    plot(x, z, 'ob', 'MarkerFaceColor', 'b')
    h = gca;
    set(h, 'YDir', 'reverse');
    xlim([x - extents, x + extents])
    ylim([z - extents, z + extents])
    xlabel('x [m]')
    ylabel('z [m]')
    t_str = sprintf('Time = %1.2f s', ts(i));
    title(t_str);
    pause(delt);
end

hold off

end
