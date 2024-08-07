function global_powers = calculateGlobalPower(EEG)
    % Epoch into 2-second non-overlapping windows
    total_seconds = EEG.pnts / EEG.srate;
    total_epochs = floor(total_seconds / 2);
    new_events = struct();

    % iterate throughout every epoch 
    for n = 1:total_epochs
        latency_in_points = (n - 1) * 2 * EEG.srate + 1;
        new_events(n).latency = latency_in_points;
        new_events(n).type = 'NewEpoch';
    end
  
    % update event structure in EEG dataset with new events 
    EEG.event = new_events;

    % update urevent structure with new events 
    EEG.urevent = new_events;

    EEG = eeg_checkset(EEG, 'eventconsistency');
    EEG = pop_epoch(EEG, {'NewEpoch'}, [0 2]);

    % Define frequency bands
    delta_band = [1 3];
    theta_band = [4 7];
    alpha_band = [8 12];
    beta_band = [13 24];

    % Initialize power accumulators for global analysis
    delta_power_accum = 0;
    theta_power_accum = 0;
    alpha_power_accum = 0;
    beta_power_accum = 0;

    % Frequency resolution and vector
    freq_res = EEG.srate / size(EEG.data, 2);
    freqs = linspace(0, EEG.srate/2, floor(size(EEG.data, 2)/2) + 1);

    % Iterate over each epoch
    for epoch = 1:size(EEG.data, 3)
        % FFT calculation for all channels in each epoch
        fft_data = fft(EEG.data(:, :, epoch), [], 2) / size(EEG.data, 2);
        psd_data = (abs(fft_data) .^ 2) * 2; % Multiply by 2 for single-sided spectrum

        % Average power in each band across all channels
        delta_power_accum = delta_power_accum + bandPower(psd_data, freqs, delta_band, freq_res);
        theta_power_accum = theta_power_accum + bandPower(psd_data, freqs, theta_band, freq_res);
        alpha_power_accum = alpha_power_accum + bandPower(psd_data, freqs, alpha_band, freq_res);
        beta_power_accum = beta_power_accum + bandPower(psd_data, freqs, beta_band, freq_res);
    end

    % Calculate average power across all epochs for each band
    num_epochs = size(EEG.data, 3);
    global_powers = struct('Delta', delta_power_accum / num_epochs, ...
                           'Theta', theta_power_accum / num_epochs, ...
                           'Alpha', alpha_power_accum / num_epochs, ...
                           'Beta', beta_power_accum / num_epochs);
end

