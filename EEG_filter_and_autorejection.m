
% Designate output directory 
output_directory = '/Users/.....";


% participant_numbers = {'01','02','03', '04', '05'....};


% Path to channel locations file 
chanlocs_path = '/Users/.......' ;

% call EEGLab
eeglab

% Iterate across participants 
for  i = 1:length(participant_numbers)

    participant_folder = ['.......' participant_numbers{i}]; % Folder name for the participant
    participant_path = fullfile(base_directory, participant_folder); % Full path to the participant's folder


    % Load EEG data 
    EEG_pre = pop_loadbv(participant_path, ['..........' participant_numbers{i} '____.vhdr']);
    EEG_post = pop_loadbv(participant_path, ['..........' participant_numbers{i} '____.vhdr']);

    %Load channel locations 
    EEG_pre.chanlocs = pop_chanedit(EEG_pre.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});
    EEG_post.chanlocs = pop_chanedit(EEG_post.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'}); 


     % High-pass filter
    EEG_pre = pop_eegfiltnew(EEG_pre, 'locutoff', 1);
    EEG_post = pop_eegfiltnew(EEG_post, 'locutoff', 1);

     % Low-pass filter, 40 hz
     EEG_pre = pop_eegfiltnew(EEG_pre, 'hicutoff', 40);  
     EEG_post = pop_eegfiltnew(EEG_post, 'hicutoff', 40);  
      


    % Notch filter
    EEG_pre = pop_firws(EEG_pre, 'fcutoff', [59 61], 'ftype', 'bandstop', 'wtype', 'hamming', 'forder', 3000);
    EEG_post = pop_firws(EEG_post, 'fcutoff', [59 61], 'ftype', 'bandstop', 'wtype', 'hamming', 'forder', 3000);

  
  
    % Rereference to any electrode needed 
    EEG_pre = pop_reref(EEG_pre, 48);
    EEG_post = pop_reref(EEG_post, 48);



    % Add channel locations file 
    EEG_pre.chanlocs = pop_chanedit(EEG_pre.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});
    EEG_post.chanlocs = pop_chanedit(EEG_post.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});


    % Set artifact rejection parameters for automatic artifact rejection, if you choose to use that 
    options = {'elecrange', [1:EEG.nbchan], 'freqlimit', [1 40], 'threshold', 8, 'epochlength', 0.25, 'contiguous', 4, 'addlength', 0.25, 'taper', 'hamming'};
    options_post = {'elecrange', [1:EEG_post.nbchan], 'freqlimit', [1 40], 'threshold', 8, 'epochlength', 0.25, 'contiguous', 4, 'addlength', 0.25, 'taper', 'hamming'};
    
    % Reject artifacts 
   % EEG = pop_rejcont(EEG, options{:});
   % EEG_post = pop_rejcont(EEG_post, options_post{:});


    % Save dataset
    pop_saveset(EEG_pre, 'filename', ['____' participant_numbers{i} '____.set'], 'filepath', output_directory);
    pop_saveset(EEG_post, 'filename', ['____' participant_numbers{i} '____.set'], 'filepath', output_directory);

end

