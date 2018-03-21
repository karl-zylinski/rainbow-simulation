clear all;
clf;

t = 0;
animate = 0;

if animate == 1
    while(true)
        t = t + 0.1;
        b = abs(cos(t));
        clf;
        calculate_path(b, 1, 1);
        calculate_path(b, 2, 1);
        pause(0.000001);
    end
else
    calculate_path(0.9, 1, 1);
end