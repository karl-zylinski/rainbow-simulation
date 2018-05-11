% Takes a bunch of refractive indices and calls the path tracing function calculate_path for each of them.
% The output variable hits_end_y describes where the rays end up.
function [hits_end_y, hits_start_y, hits_deflection_angles, hits_incident_angles, p_intensity_left, s_intensity_left] = calcuate_rainbow(num_beams, y_start, y_end, num_bounces, refractive_indices, colors)
    hits_end_y = [];
    hits_start_y = [];
    hits_deflection_angles = [];
    hits_incident_angles = [];
    p_intensity_left = [];
    s_intensity_left = [];
    
    % We use this to parallelize the computation.
    cluster = parcluster('local');
    cluster.NumWorkers = 14;
    saveProfile(cluster);

    % Change parfor to for to remove parallelization.
    parfor ni = 1:length(refractive_indices)
        n = refractive_indices(ni);
        disp(['starting index ', num2str(n)]);
        c = colors(ni, :);

        idx = 1;
        hits = [];
        deflection_angles = [];
        incident_angles = [];
        pi_lefts = [];
        si_lefts = [];
        start_ys = [];
        progress = 0;
        progress_step = num_beams / 20;
        
        % This loop probably goes from origin to radius = 1 (for primary rainbow) in lots of small steps
        for y = linspace(y_start, y_end, num_beams)
            [hit_y, incident_angle, def_angle, pi_left, si_left] = calculate_path(y, num_bounces, n, c, 0, -2);

            % We use hit_y == 0 as "something went wrong"
            if (hit_y ~= 0)
                hits(idx) = hit_y;
                start_ys(idx) = y;
                deflection_angles(idx) = def_angle;
                incident_angles(idx) = incident_angle;
                pi_lefts(idx) = pi_left;
                si_lefts(idx) = si_left;
                idx = idx + 1;
                
                % For showing calculation progress.
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
        p_intensity_left(ni, :) = pi_lefts;
        s_intensity_left(ni, :) = si_lefts;
    end
end