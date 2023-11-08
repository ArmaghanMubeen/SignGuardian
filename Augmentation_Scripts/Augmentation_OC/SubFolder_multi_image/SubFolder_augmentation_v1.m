% Ask the user to select a folder containing the images
inputFolder = uigetdir(pwd, 'Select the folder containing images');

% Create a datastore from the selected folder
imds = imageDatastore(inputFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Initialize the waitbar
progressBar = waitbar(0, 'Performing augmentations...', 'Name', 'Augmentation Progress');

% Reset the input datastore to start from the beginning
reset(imds);

% Specify augmentation factors
augmentationFactors = {'a1', 'a2', 'a3', 'a4', 'a5'};

while hasdata(imds)
    % Read the next image and its label from the datastore
    [img, info] = read(imds);
    
    % Get the filename for saving
    filename = info.Filename;
    label = info.Label;
    
    % Perform augmentations and save images in the same subfolder
    for i = 1:length(augmentationFactors)
        % Append the augmentation factor to the image filename
        [~, name, ext] = fileparts(filename);
        augmentedFilename = [name, '_', augmentationFactors{i}, ext];
        
        % Apply augmentation
        augmentedImage = img;  % Default is no augmentation
        
        if i == 1
            % 90 degree rotation
            augmentedImage = imrotate(img, 90);
        elseif i == 2
            % 180 degree rotation
            augmentedImage = imrotate(img, 180);
        elseif i == 3
            % 270 degree rotation
            augmentedImage = imrotate(img, 270);
        elseif i == 4
            % Horizontal flip
            augmentedImage = flip(img, 2);
        elseif i == 5
            % Vertical flip
            augmentedImage = flip(img, 1);
        end
        
        % Save the augmented image in the same subfolder
        outputFilename = fullfile(inputFolder, char(label), augmentedFilename);
        imwrite(augmentedImage, outputFilename);
    end
    
    % Update the waitbar
    currentImage = find(strcmp(imds.Files, filename));
    progress = currentImage / numel(imds.Files);
    waitbar(progress, progressBar, sprintf('Processed %d/%d images', currentImage, numel(imds.Files)));
end

% Close the waitbar
close(progressBar);
disp('Augmentation completed and saved in respective subfolders.');

