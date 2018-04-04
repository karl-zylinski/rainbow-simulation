clear all;
clf;

t = 0;
animate = 1;
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
    139 34 82;
    0 0 156; 
    0 0 156; 
    0 127 255;
    112 219 147; 
    124 252 0;
    173 255 47; 
    255 255 0;
    218 165 32; 
    255 69 0; 
    255 69 0;  
    255 69 0; 
    255 69 0;
]/255;

if animate == 0
    hits_start_y = [];
    hits_end_y = [];
    hits_n_i = [];

    for ni = 1:length(refractive_indices)      
        n = refractive_indices(ni);
        c = colors(ni, :);

        i = 1;
        for y = 0:0.0001:1
            [path, hit_y] = calculate_path(y, 1, n, c, 0, -2);

            if (hit_y ~= 0)
                hits_start_y(ni, i) = y;
                hits_end_y(ni, i) = hit_y;
                hits_n_i(ni, i) = ni;
                i = i + 1;
            end
        end
    end

    for ni = 1:length(refractive_indices)
        histogram(hits_end_y(ni, :), 'NumBins', 40, 'FaceColor', colors(ni, :));
        hold on;
    end
else
    t = 0;
    while(true)
        t = t + 0.1;
        b = abs(cos(t));
        clf;

        for i = 1:length(refractive_indices)
            n = refractive_indices(i);
            c = colors(i, :);
            [path, hit_y] = calculate_path(b, 1, n, c, 1, -2);
        end

        pause(0.1);
    end
end