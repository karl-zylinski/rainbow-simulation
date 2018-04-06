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

hits_start_y = [];

for ni = 1:length(refractive_indices)      
    n = refractive_indices(ni);

    i = 1;
    for y = 0:0.00001:1
        if i == 100001
            break;
        end
        hits_start_y(ni, i) = y;
        i = i + 1;
    end
end

figure(1);
plot(hits_start_y(2, :), abs(hits_end_y(2, :)));

figure(2);

for ni = 1:length(refractive_indices)    
    histogram(hits_end_y(ni, :), 'NumBins', 4000, 'FaceColor', colors(ni, :));
    hold on;
end