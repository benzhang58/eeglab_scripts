% NOTE!! : this is the equivalent of the CalculateGlobalPower script, however this one is intended for calculating regional values

function [region_powers] = epochAndCalculatePSD(EEG)
   
% Epoch into 2-second non-overlapping windows
    total_seconds = EEG.pnts / EEG.srate;
    total_epochs = floor(total_seconds / 2);
    new_events = struct();

% Iterate across all epochs 
    for n = 1:total_epochs
        latency_in_points = (n - 1) * 2 * EEG.srate + 1;
        new_events(n).latency = latency_in_points;
        new_events(n).type = 'NewEpoch';
    end

    EEG.event = new_events;
    EEG.urevent = new_events;
    EEG = eeg_checkset(EEG, 'eventconsistency');
    EEG = pop_epoch(EEG, {'NewEpoch'}, [0 2]);

    % Define channel groups for each region
    % CHANGE THESE TO THE INDICES FOR EACH CHANNEL ACCORDINGLY
    frontal_channels = [2, 3, 37, 36, 35, 7, 6, 5, 4, 38, 39, 40, 41, 42];

    central_channels = [9, 10, 11, 46, 45, 44, 14, 13, 12, 47, 48, 49, 50, 17, 18, 19, 32, 48, 49, 50];

    parietal_channels = [23, 22, 21, 20, 31, 56, 57, 58, 25, 26, 30, 61, 60];

    temporal_channels = [28, 8, 15, 16, 24, 33, 43, 51, 52, 59];

    frontal_l_channels = [2, 3, 7, 6, 5, 4];

    frontal_r_channels = [36, 35, 42, 41, 40, 39];

    central_l_channels = [11, 10, 9, 12, 13, 14, 19, 18, 17];

    central_r_channels = [46, 45, 44, 48, 49, 50, 55, 54, 53];

    parietal_l_channels = [23, 22, 21, 20, 25, 26];
    
    parietal_r_channels = [56, 57, 58, 61, 60];

    temporal_l_channels = [28, 8, 15, 16, 24];

    temporal_r_channels = [59, 61, 60, 43, 33];

    % Initialize region power struct
    region_powers = struct();

    % Define frequency bands
    delta_band = [1 3];
    theta_band = [4 7];
    alpha_band = [8 12];
    beta_band = [13 24];

    % Iterate over each region
    regions = {'FrontalL', 'FrontalR', 'CentralL', 'CentralR', 'ParietalL', 'ParietalR', 'TemporalL', 'TemporalR', 'Frontal', 'Central', 'Parietal', 'Temporal'};
    for r = 1:length(regions)
        region = regions{r};

        % Assign channels for the current region directly without using eval
        if strcmp(region, 'FrontalL')
            channel_labels = frontal_l_channels;
        elseif strcmp(region, 'FrontalR')
            channel_labels = frontal_r_channels;
        elseif strcmp(region, 'CentralL')
            channel_labels = central_l_channels;
        elseif strcmp(region, 'CentralR')
            channel_labels = central_r_channels;
        elseif strcmp(region, 'ParietalL')
            channel_labels = parietal_l_channels;
        elseif strcmp(region, 'ParietalR')
            channel_labels = parietal_r_channels;
        elseif strcmp(region, 'TemporalL')
            channel_labels = temporal_l_channels;
        elseif strcmp(region, 'TemporalR')
            channel_labels = temporal_r_channels;
        elseif strcmp(region, 'Frontal')
            channel_labels = frontal_channels;
        elseif strcmp(region, 'Central')
            channel_labels = central_channels;
        elseif strcmp(region, 'Parietal')
            channel_labels = parietal_channels;
        elseif strcmp(region, 'Temporal')
            channel_labels = temporal_channels;
        end

        % Debugging: Print channel labels
        disp(['Region: ', region]);
        disp('Channel labels:');
        disp(channel_labels);

        % Initialize power accumulators for the region
        delta_power_accum = 0;
        theta_power_accum = 0;
        alpha_power_accum = 0;
        beta_power_accum = 0;

        % Frequency resolution and vector
        freq_res = EEG.srate / size(EEG.data, 2);
        freqs = linspace(0, EEG.srate / 2, floor(size(EEG.data, 2) / 2) + 1);

        % Debugging: Print frequency vector
        disp('Frequency vector:');
        disp(freqs);

        % Iterate over each epoch
        for epoch = 1:size(EEG.data, 3)
            % FFT calculation for selected channels in each epoch
            fft_data = fft(EEG.data(channel_labels, :, epoch), [], 2) / size(EEG.data, 2);
            psd_data = (abs(fft_data) .^ 2) * 2; % Multiply by 2 for single-sided spectrum

            % Debugging: Print PSD data size and sample
            disp('PSD data size:');
            disp(size(psd_data));
            disp('Sample PSD data:');
            disp(psd_data(:, 1:10)); % Display a small sample of the PSD data

            % Average power in each band across all channels
            delta_power_accum = delta_power_accum + bandPower(psd_data, freqs, delta_band, freq_res);
            theta_power_accum = theta_power_accum + bandPower(psd_data, freqs, theta_band, freq_res);
            alpha_power_accum = alpha_power_accum + bandPower(psd_data, freqs, alpha_band, freq_res);
            beta_power_accum = beta_power_accum + bandPower(psd_data, freqs, beta_band, freq_res);
        end

        % Calculate average power across all epochs for the region
        num_epochs = size(EEG.data, 3);

        region_powers.(region) = struct('Delta', delta_power_accum / num_epochs, ...
                                        'Theta', theta_power_accum / num_epochs, ...
                                        'Alpha', alpha_power_accum / num_epochs, ...
                                        'Beta', beta_power_accum / num_epochs);

        % Debugging: Print region powers
        disp(['Region powers for ', region, ':']);
        disp(region_powers.(region));
    end
end

