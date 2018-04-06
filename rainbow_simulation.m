clear all;
clf;

t = 0;
animate = 0;
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

static = 0;

if static == 1
    bs = 1;
        
    for b = 0:0.01:1
        for i = 1:1
            n = refractive_indices(i);
            c = colors(i, :);
            [path, hit_y] = calculate_path(b, 1, n, c, 1, -2);
        end

        axis([-2, 2, -4, 2]);
        pause(0.1);
        axis([-2, 2, -4, 2]);
    end
elseif animate == 0
    cluster = parcluster('local');
    cluster.NumWorkers = 14;
    saveProfile(cluster);
    
    parfor ni = 1:length(refractive_indices)      
        n = refractive_indices(ni);
        c = colors(ni, :);

        i = 1;
        hits = [];
        for y = 0:0.00001:1
            [path, hit_y] = calculate_path(y, 1, n, c, 0, -2);

            if (hit_y ~= 0)
                hits(i) = hit_y;
                i = i + 1;
            end
        end
        hits_end_y(ni, :) = hits;
    end
    
    for ni = 1:length(refractive_indices)    
        histogram(hits_end_y(ni, :), 'NumBins', 100, 'FaceColor', colors(ni, :));
        hold on;
    end
else
    t = 0;
    while(true)
        t = t + 0.01;
        b = abs(cos(t));
        
        if b < 0.6 || b > 0.8 
            continue; 
        end
        clf;

        for i = 1:length(refractive_indices)
            n = refractive_indices(i);
            c = colors(i, :);
            [path, hit_y] = calculate_path(b, 1, n, c, 1, -2);
        end

        axis([-2, 2, -4, 2]);
        pause(0.1);
        axis([-2, 2, -4, 2]);
    end
end