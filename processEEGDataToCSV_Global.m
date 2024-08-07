% output_csv_path = '/Users/......' ;
% participant_numbers = {'01', '02', '03',  '04', '05'........};


% NOTE!! : If you add anything above the function that isn't a comment, it will cause issues with the run 

% This is the main function you run / call in the MATLAB command window 


function processEEGDataToCSV_Global(participant_numbers, output_csv_path)

    % add path to EEGLab
    addpath('/Users/benzhang/Desktop/Casa Colina/EEGLab/');

    % add path to location of all the scripts 
    addpath('/Users/benzhang/Desktop/Casa Colina/Studies/LIFUP/EEG Matlab Code /');

    % Prepare CSV Data with expanded headers for each region and band
    bands = {'Delta', 'Theta', 'Alpha', 'Beta'};
    headers = {'Participant'};

    % Iterate across all electrodes
    for b = bands
    headers{end+1} = [b{1} '_Power'];
    end

    % Initialize a cell array to store CSV data
    csvData = cell(length(participant_numbers) + 1, length(headers));

    % Assign the headers to the first row of the CSV data array
    csvData(1,:) = headers;

    % Process each participant
    for i = 1:length(participant_numbers)
       disp(['Processing participant number: ', participant_numbers{i}]);

    % Ensure participant numbers are zero-padded to match the file naming convention
    participant_id_str = sprintf('%03d', str2double(participant_numbers{i}));  % Pads with zeros up to 3 digits
    search_pattern = fullfile('/Users/benzhang/Desktop/Casa Colina/Studies/VNS', ['vns_' participant_id_str '_run2_cl_f140_mrej_ICA_c*.set']);


    % Get a list of files that match the specified search pattern
    files_check = dir(search_pattern);

    % Check if files are found and load the first one
       if ~isempty(files_check)
       EEG = pop_loadset('filename', fullfile(files_check(1).folder, files_check(1).name));

    % Call function calculateGlobalPower 
    global_powers = calculateGlobalPower(EEG);
  
    % Extract and format the PSD data for CSV
    psd_data = {participant_numbers{i}, global_powers.Delta, global_powers.Theta, global_powers.Alpha, global_powers.Beta};


    % Append participant data to CSV data
        csvData(i + 1,:) = psd_data;
    end

    disp(csvData)
    
    % Write to CSV file
    writecell(csvData, fullfile(output_csv_path, 'VNS_new_Powers.csv'));
    end
end
