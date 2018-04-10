function [hits_end_y, hits_start_y, hits_deflection_angles, hits_incident_angles] = calcuate_rainbow(num_beams, y_start, y_end, num_bounces, refractive_indices, colors)
    hits_end_y = [];
    hits_start_y = [];
    hits_deflection_angles = [];
    hits_incident_angles = [];

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
        progress = 0;
        progress_step = num_beams / 20;
        for y = linspace(y_start, y_end, num_beams)
            [hit_y, incident_angle, def_angle] = calculate_path(y, num_bounces, n, c, 0, -2);

            if (hit_y ~= 0)
                hits(idx) = hit_y;
                start_ys(idx) = y;
                deflection_angles(idx) = def_angle;
                incident_angles(idx) = incident_angle;
                idx = idx + 1;
                if idx > progress + progress_step
                    disp(['index ', num2str(n),': ', num2str(round((idx*100)/num_beams)), '%']);
                    progress = progress + progress_step;
                end
            end
        end
        disp(['index ', num2str(n),' done']);
        hits_end_y(ni, :) = hits;
        hits_start_y(ni, :) = start_ys;
        hits_deflection_angles(ni, :) = deflection_angles;
        hits_incident_angles(ni, :) = incident_angles;
    end
end