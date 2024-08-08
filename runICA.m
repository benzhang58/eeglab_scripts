
pre_directory = '/Users/....';
post_directory = '/Users/....';

pre_output = '/Users/....';
post_output = '/Users/....';

participant_numbers = {'001', '002', '003', '004'....};

chanlocs_path = '/Users/....' ;

% Call EEGLab
eeglab

% Iterate across all participants 
for  i = 1:length(participant_numbers)
    
    try
   
    pre_path = fullfile(pre_directory,['VNS_' participant_numbers{i} '_run2_cl_f140_mrej.set']);
    post_path = fullfile(post_directory,['LifUP_' participant_numbers{i} '_run4_cl_F140_mrej.set']);

    % Load EEG data 
    EEG_pre = pop_loadset(pre_path);
    EEG_post = pop_loadset(post_path);

    % Load channel locations 
    EEG_pre.chanlocs = pop_chanedit(EEG_pre.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});
    EEG_post.chanlocs = pop_chanedit(EEG_post.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});

    % Run ICA decomposition
    EEG_pre = pop_runica(EEG_pre, 'icatype', 'runica');
    EEG_post = pop_runica(EEG_post, 'icatype', 'runica');

    % Recallibrate allEEG set, then put the channel location back on 
    [ALLEEG, EEG_pre, CURRENTSET] = eeg_store(ALLEEG, EEG_pre, CURRENTSET); % update ALLEEG, then reload channel locations
    [ALLEEG, EEG_post, CURRENTSET] = eeg_store(ALLEEG, EEG_post, CURRENTSET); % update ALLEEG, then reload channel locations

    EEG_pre.chanlocs = pop_chanedit(EEG_pre.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});
    EEG_post.chanlocs = pop_chanedit(EEG_post.chanlocs, 'load', {chanlocs_path, 'filetype', 'autodetect'});

    % Save dataset
    pop_saveset(EEG_pre, 'filename', ['___' participant_numbers{i} '___.set'], 'filepath', '/Users/..../');
    pop_saveset(EEG_post, 'filename', ['___' participant_numbers{i} '___.set'], 'filepath', 'Users/..../');
    
      catch ME
        fprintf('Failed to process participant %s: %s\n', participant_numbers{i}, ME.message);

      %  Optionally, log ME.message or take other actions
      % Skip to the next iteration of the loop
      continue; 
    
    end

end

