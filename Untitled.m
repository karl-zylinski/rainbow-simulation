clf;

for ni = 1:num_n
    c_hsv = [(ni/num_n)*0.8, 1, 1];
    histogram(hits_end_y(ni, :), 'NumBins', 3200, 'FaceColor', hsv2rgb(c_hsv));
    hold on;
end