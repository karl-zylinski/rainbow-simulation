clear all;
clf;

t = 0;
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

animate = 1;
static = 0;
cont_spec = 0;
hits_end_y = [];
hits_start_y = [];
hits_deflection_angles = [];
hits_incident_angles = [];

if static == 1
    bs = 1;
        
    for b = 0:0.01:1
        for i = 1:length(refractive_indices)
            n = refractive_indices(i);
            c = colors(i, :);
            calculate_path(-1, 2, n, c, 1, -2);
            calculate_path(0.88, 1, n, c, 1, -2);
        end

        axis([-2, 2, -4, 2]);
        pause(0.1);
        axis([-2, 2, -4, 2]);
    end
elseif cont_spec == 1
    cluster = parcluster('local');
    cluster.NumWorkers = 8;
    saveProfile(cluster);
    n_top = refractive_indices(1);
    n_bottom = refractive_indices(end);
    num_n = 100;
    cont_refractive_indices = linspace(n_bottom, n_top, num_n);
    
    parfor ni = 1:num_n
        n = cont_refractive_indices(ni);
        idx = 1;
        hits = [];
        start_ys = [];
        num_beams = 10000;
        for y = linspace(0, 1, num_beams)
            [path, hit_y] = calculate_path(y, 1, n, 0, 0, -2);

            if (hit_y ~= 0)
                hits(idx) = hit_y;
                start_ys(idx) = y;
                idx = idx + 1;
            end
        end
        disp(['index ', num2str(n), ' done']);
        hits_end_y(ni, :) = hits;
        hits_start_y(ni, :) = start_ys;
    end
    
    for ni = 1:num_n
        c_hsv = [(ni/num_n)*0.8, 1, 1];
        histogram(hits_end_y(ni, :), 'NumBins', 400, 'FaceColor', hsv2rgb(c_hsv));
        hold on;
    end
elseif animate == 0
    cluster = parcluster('local');
    cluster.NumWorkers = 14;
    saveProfile(cluster);
    
    parfor ni = 1:length(refractive_indices)
        n = refractive_indices(ni);
        disp(['starting index ', num2str(n)]);
        c = colors(ni, :);

        idx = 1;
        hits = [];
        deflection_angles = [];
        incident_angles = [];
        start_ys = [];
        last_5000 = 0;
        num_beams = 100000;
        num_bounces = 2;
        for y = linspace(-1, -0.75, num_beams)
            [path, hit_y, incident_angle, def_angle] = calculate_path(y, num_bounces, n, c, 0, -2);

            if (hit_y ~= 0)
                hits(idx) = hit_y;
                start_ys(idx) = y;
                deflection_angles(idx) = def_angle;
                incident_angles(idx) = incident_angle;
                idx = idx + 1;
                if idx > last_5000 + 5000
                    disp(['index ', num2str(n),': ', num2str((idx*100)/num_beams, 3), '%']);
                    last_5000 = last_5000 + 5000;
                end
            end
        end
        disp(['index ', num2str(n),' done']);
        hits_end_y(ni, :) = hits;
        hits_start_y(ni, :) = start_ys;
        hits_deflection_angles(ni, :) = deflection_angles;
        hits_incident_angles(ni, :) = incident_angles;
    end
    
    figure(1);
    for ni = 1:length(refractive_indices)    
        histogram(hits_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :));
        hold on;
    end
    ylabel('Hits at y position');
    xlabel('y position');
    title('Histograms of where beam hits y axis after 1 bounce in rain drop for different colors of light');
    
    figure(2);
    for ni = 1:length(refractive_indices)    
        plot(rad2deg(hits_incident_angles(ni, :)), -rad2deg(hits_deflection_angles(ni, :)), 'color', colors(ni, :));
        hold on;
    end
    ylabel('Deflection angle (degrees)');
    xlabel('Angle of incidence (degrees)');
    title('Angle of deflection vs angle of incidence after 1 bounce in rain drop');
else
    t = 0;
    while(true)
        t = t + 0.01;
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
end