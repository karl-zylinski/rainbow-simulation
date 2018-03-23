function [path, hit_y] = calculate_path(start_height, max_internal_bounces, refractive_index, color, plot_result, x_target)

r = 1;
b = r*start_height;
start_y = b;
start_x = -5;
start = [start_x, start_y];
cur_pos = start;
dir = [1, 0];
step_size = 0.001;
path_x = [];
path_y = [];
n = refractive_index;

if plot_result == 1
    viscircles([0, 0], r, 'Color', 'b', 'LineWidth', 0.1);
end

axis([-2, 2, -2, 2]);

i = 2;
if plot_result == 1
    path_x(1) = start_x;
    path_y(1) = start_y;
end

num_internal_bounces = 0;
ext_angle = acos(sqrt(1-b^2));
int_angle = asin(b/n);

while (true)
    old_pos = cur_pos;
    new_pos = cur_pos + dir * step_size;
    x = cur_pos(1);
    y = cur_pos(2);
    
    % we've gone from outside to inside
    if norm(old_pos) > r && norm(new_pos) <= r
        new_angle = int_angle - ext_angle;
        dir = [cos(new_angle), sin(new_angle)];
        cur_pos = new_pos;

        path_x(i) = x;
        path_y(i) = y;
        i = i + 1;

    elseif norm(old_pos) < r && norm(new_pos) >= r
        if num_internal_bounces ~= max_internal_bounces
            num_internal_bounces = num_internal_bounces + 1;
            dir = bounce_inside(cur_pos, dir);
            cur_pos = old_pos;
        else
            angle = ext_angle - int_angle;
            a = atan2(dir(2), dir(1)) + angle;
            dir = [cos(a), sin(a)];
            cur_pos = new_pos;
        end
        
        path_x(i) = x;
        path_y(i) = y;
        i = i + 1;
    else
        cur_pos = new_pos;
    end
    
    if norm(old_pos) > r && num_internal_bounces > 0
        if dot(dir, [-1, 0]) < 0 % going wrong way
            path_x(i) = x;
            path_y(i) = y;

            i = i + 1;

            hit_y = 0;

            break;
        elseif old_pos(1) < x_target && new_pos(1) < x_target % missed before exiting
            path_x(i) = x;
            path_y(i) = y;

            hit_y = 0;

            i = i + 1;

            break;
        elseif old_pos(1) > x_target && new_pos(1) < x_target % hit target
            path_x(i) = x;
            path_y(i) = y;

            hit_y = y;

            i = i + 1;

            break;
        end
    end
end

if plot_result == 1
    hold on;
    plot(path_x, path_y, 'MarkerFaceColor', color);
end

path = [path_x, path_y];