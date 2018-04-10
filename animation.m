clear all;
clf;

refractive_indices = [
    1.34451
    1.34235
    1.34055
    1.33903
    1.33772
    1.33659
    1.33560
    1.33472
    1.33393
    1.33322
    1.33257
    1.33197
    1.33141
];

colors = [
    188 40 200;
    120 50 199; 
    0 100 240; 
    0 180 255;
    112 219 147; 
    124 252 0;
    200 255 47; 
    255 255 0;
    255 200 0; 
    255 89 0; 
    255 0 0;  
    200 0 0; 
    175 0 0;
]/255;

t = 0;
time_step = 0.1
while(true)
    t = t + time_step;
    b = abs(cos(t));

    clf;

    for i = 1:length(refractive_indices)
        n = refractive_indices(i);
        c = colors(i, :);
        calculate_path(b, 1, n, c, 1, -2);
    end

    axis([-2, 2, -4, 2]);
    pause(0.1);
    axis([-2, 2, -4, 2]);
end