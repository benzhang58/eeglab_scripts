function power = bandPower(psd_data, freqs, band, freq_res)
    % Find indices of frequencies within the band
    band_indices = freqs >= band(1) & freqs <= band(2);

    % Sum the PSD values within the frequency band and multiply by the frequency resolution
    band_power = sum(psd_data(:, band_indices), 2) * freq_res;
    power = mean(band_power, 1); % Average across channels
end
