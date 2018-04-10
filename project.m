clear all;
clf;

load_old_data = 1;

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

if load_old_data == 1
    load('project_data.mat');
else
    [primary_end_y, primary_start_y, primary_deflection_angles, primary_incident_angles] = calcuate_rainbow(100000, 0, 1, 1, refractive_indices, colors);
    [secondary_end_y, secondary_start_y, secondary_deflection_angles, secondary_incident_angles] = calcuate_rainbow(100000, -1, -0.75, 2, refractive_indices, colors);
end

% Histogram from primary rainbow
figure(1);
for ni = 1:length(refractive_indices)    
    histogram(primary_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :));
    hold on;
end
ylabel('Hits at y position');
xlabel('y position');
title('Histograms of where beam hits y axis after 1 bounce in rain drop for different colors of light');

% Plot of deflection angle against angle of incidence for primary rainbow
figure(2);
for ni = 1:length(refractive_indices)    
    plot(rad2deg(primary_incident_angles(ni, :)), -rad2deg(primary_deflection_angles(ni, :)), 'color', colors(ni, :));
    hold on;
end
ylabel('Deflection angle (degrees)');
xlabel('Angle of incidence (degrees)');
title('Angle of deflection vs angle of incidence after 1 bounce in rain drop');

% Histogram for secondary rainbow
figure(3);
for ni = 1:length(refractive_indices)    
    histogram(secondary_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :));
    hold on;
end
ylabel('Hits at y position');
xlabel('y position');
title('Histograms of where beam hits y axis after 2 bounces in rain drop for different colors of light');

% Plot of deflection angle against angle of incidence for secondary rainbow
figure(4);
for ni = 1:length(refractive_indices)    
    plot(rad2deg(secondary_incident_angles(ni, :)), -rad2deg(secondary_deflection_angles(ni, :)), 'color', colors(ni, :));
    hold on;
end
ylabel('Deflection angle (degrees)');
xlabel('Angle of incidence (degrees)');
title('Angle of deflection vs angle of incidence after 2 bounces in rain drop');
