function [path, hit_y] = calculate_path(start_height, max_internal_bounces, refractive_index, color, plot_result, x_target)

r = 1;
b = r*start_height;
start_y = b;
start_x = -1.1;
start = [start_x, start_y];
cur_pos = start;
dir = [1, 0];
step_size = 0.0001;
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
num_internal_bounces = 0;

% angle from normal when we hit wall from outside
ext_angle = asin(b/r);
% angle from normal after refracting into drop
int_angle = asin(b/(r*n));

while (true)
    old_pos = cur_pos;
    new_pos = cur_pos + dir * step_size;
    avg_pos = (cur_pos + old_pos)./2;
    
    % we've gone from outside to inside
    if norm(old_pos) > r && norm(new_pos) <= r
        new_angle = -(ext_angle - int_angle); % angle between x-axis and direction of light
        dir = [cos(new_angle), sin(new_angle)];
        cur_pos = new_pos;
        add_to_plot(avg_pos);
    elseif norm(old_pos) < r && norm(new_pos) >= r % we hit wall from inside
        if num_internal_bounces ~= max_internal_bounces
            num_internal_bounces = num_internal_bounces + 1;
            dir = bounce_inside(cur_pos, dir);
            cur_pos = old_pos;
            add_to_plot(avg_pos);
        else
            add_to_plot(avg_pos);
            a = int_angle - ext_angle + atan2(dir(2), dir(1));
            
            if (a > (-pi/2) && a < (pi/2))
                hit_y = 0;
                break;
            end

            wanted_x = abs(avg_pos(1)) + abs(x_target);
            end_y = -(wanted_x * tan(pi - abs(a)));
            hit_y = avg_pos(2) + end_y;
            add_to_plot([x_target, hit_y]);
            break;
        end
    else
        cur_pos = new_pos;
    end
end

if plot_result == 1
    hold on;
    plot(path_x, path_y, 'MarkerFaceColor', color);
end

path = [path_x, path_y];
end