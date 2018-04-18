function [hit_y, incident_angle, deflection_angle, p_intensity_left, s_intensity_left] = calculate_path(start_height, max_internal_bounces, refractive_index, color, plot_result, x_target)
r = 1;
start_y = r*start_height;

if start_y > r
    hit_y = 0;
    return;
end

start_x = -2;
start = [start_x, start_y];
path_x = [];
path_y = [];
n = refractive_index;

if plot_result == 1
    viscircles([0, 0], r, 'Color', 'b', 'LineWidth', 0.1);
end

axis([-2, 2, -2, 2]);

i = 1;
function add_to_plot(point)
    if plot_result == 0
        return;
    end
    
    path_x(i) = point(1);
    path_y(i) = point(2);
    i = i + 1;
end

add_to_plot(start);

% angle from normal when we hit wall from outside
ext_angle = asin(start_y/r);
incident_angle = ext_angle;
% angle from normal after refracting into drop
int_angle = asin(start_y/(r*n));

p_intensity_left = 1*((sin(2*ext_angle)*sin(2*int_angle))/(sin(ext_angle+int_angle)^2*cos(ext_angle-int_angle)^2)) ...
                    *(tan(ext_angle-int_angle)/tan(ext_angle+int_angle))^(2*max_internal_bounces) ...
                    *((sin(2*int_angle)*sin(2*ext_angle))/(sin(int_angle+ext_angle)^2*cos(int_angle-ext_angle)^2));
                
s_intensity_left = 1*((sin(2*int_angle)*sin(2*ext_angle))/sin(ext_angle+int_angle)^2) ...
                    *(sin(ext_angle-int_angle)/sin(ext_angle+int_angle))^(2*max_internal_bounces) ...
                    *((sin(2*ext_angle)*sin(2*int_angle))/sin(int_angle+ext_angle)^2);

x_enter = -sqrt(r^2 - start_y^2);
internal_bounce_length = 2*sqrt(1-(start_y^2/n^2));
cur_pos = [x_enter, start_y];
add_to_plot(cur_pos);
enter_angle = -(ext_angle - int_angle);
dir = [cos(enter_angle), sin(enter_angle)];

for bounce = 1:max_internal_bounces
    cur_pos = cur_pos + dir*internal_bounce_length;
    add_to_plot(cur_pos);
    dir = bounce_inside(cur_pos, dir);
end

cur_pos = cur_pos + dir*internal_bounce_length;
add_to_plot(cur_pos);
deflection_angle = int_angle - ext_angle + atan2(dir(2), dir(1));
wanted_x = cur_pos(1) - x_target;
end_y = -(wanted_x * tan(pi - abs(deflection_angle)));

if deflection_angle > -pi/2 && deflection_angle < 0
    end_y = -end_y;
end

hit_y = cur_pos(2) + end_y;
add_to_plot([x_target, hit_y]);

if plot_result == 1
    hold on;
    plot(path_x, path_y, 'color', color);
end
end