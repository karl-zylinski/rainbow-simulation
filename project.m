clear all;
close all;

global enable_image_saving;
enable_image_saving = 1;
load_old_data = 1;

% Used for simulating colors of different light.
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

% Each of these colors map the the corresponding refractive index above.
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

% We can use old, previously calculated data if we just want to experiment with the plotting.
if load_old_data == 1
    load('project_data.mat');
else
    num_beams = 100000;
    [primary_end_y, primary_start_y, primary_deflection_angles, primary_incident_angles, primary_p_intensity_left, primary_s_intensity_left] = calcuate_rainbow(num_beams, 0, 1, 1, refractive_indices, colors);
    [secondary_end_y, secondary_start_y, secondary_deflection_angles, secondary_incident_angles, secondary_p_itensity_left, secondary_s_intensity_left] = calcuate_rainbow(num_beams, -1, -0.75, 2, refractive_indices, colors);
end

% Histogram from primary rainbow
figure(1);
for ni = 1:length(refractive_indices)    
    histogram(primary_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :), 'LineStyle', 'none', 'FaceAlpha', 1);
    hold on;
end
ylabel('Number of rays');
xlabel('Final ray y position');
title('Histograms of where beam hits line x = -2 after 1 bounce in rain drop for different colors of light');

% Plot of deflection angle against angle of incidence for primary rainbow
figure(2);
for ni = 1:length(refractive_indices)    
    plot(rad2deg(primary_incident_angles(ni, :)), -rad2deg(primary_deflection_angles(ni, :)), 'color', colors(ni, :));
    hold on;
end
ylabel('Deflection angle (degrees)');
xlabel('Angle of incidence (degrees)');
title('Angle of deflection vs angle of incidence after 1 bounce in rain drop');
save_image('primary_def_angle');

% Plot intensity left for s polarised light for primary rainbow
figure(3);
for ni = 1:length(refractive_indices)    
    plot(primary_start_y(ni, :), primary_s_intensity_left(ni, :), 'color', colors(ni, :));
    hold on;
end
ylabel('Fraction of intensity left');
xlabel('Initial y position');
title('Intensity left for primary rainbow, s-polarised light (after 1 bounce)');
save_image('primary_s_inten_left');

% Plot intensity left for p polarised light for primary rainbow
figure(4);
for ni = 1:length(refractive_indices)    
    plot(primary_start_y(ni, :), primary_p_intensity_left(ni, :), 'color', colors(ni, :));
    hold on;
end
ylabel('Fraction of intensity left');
xlabel('Initial y position');
title('Intensity left for primary rainbow, p-polarised light (after 1 bounce)');
save_image('primary_p_inten_left');

% Histogram for secondary rainbow
figure(5);
for ni = 1:length(refractive_indices)    
    histogram(secondary_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :), 'LineStyle', 'none', 'FaceAlpha', 1);
    hold on;
end
ylabel('Number of rays');
xlabel('Final ray y position');
title('Histograms of where beam hits y axis after 2 bounces in rain drop for different colors of light');

% Plot of deflection angle against angle of incidence for secondary rainbow
figure(6);
for ni = 1:length(refractive_indices)    
    plot(rad2deg(secondary_incident_angles(ni, :)), -rad2deg(secondary_deflection_angles(ni, :)), 'color', colors(ni, :));
    hold on;
end
ylabel('Deflection angle (degrees)');
xlabel('Angle of incidence (degrees)');
title('Angle of deflection vs angle of incidence after 2 bounces in rain drop');
save_image('secondary_def_angle');

% Plot intensity left for s polarised light for secondary rainbow
figure(7);
for ni = 1:length(refractive_indices)    
    plot(secondary_start_y(ni, :), secondary_s_intensity_left(ni, :), 'color', colors(ni, :));
    hold on;
end
ylabel('Fraction of intensity left');
xlabel('Initial y position');
title('Intensity left for secondary rainbow, s-polarised light (after 2 bounces)');
save_image('secondary_s_inten_left');

% Plot intensity left for p polarised light for secondary rainbow
figure(8);
for ni = 1:length(refractive_indices)    
    plot(secondary_start_y(ni, :), secondary_p_intensity_left(ni, :), 'color', colors(ni, :));
    hold on;
end
ylabel('Fraction of intensity left');
xlabel('Initial y position');
title('Intensity left for secondary rainbow, p-polarised light (after 2 bounces)');
save_image('secondary_p_inten_left');

function save_image(name)
    global enable_image_saving;
    if enable_image_saving == 0
        return;
    end
    print(name, '-dpng');
end
