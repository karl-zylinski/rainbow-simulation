clf;

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

figure(1);
for ni = 1:length(refractive_indices)    
    histogram(hits_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :), 'FaceAlpha', 1);
    hold on;
end

axis([-3.02, -2.8, 0, 1000]);

figure(2);
%plot(hits_start_y(1,:), abs(hits_end_y(1,:)));
for ni = 1:length(refractive_indices)    
    plot(rad2deg(hits_incident_angles(ni, :)), -rad2deg(hits_deflection_angles(ni, :)), 'color', colors(ni, :));
    hold on;
end