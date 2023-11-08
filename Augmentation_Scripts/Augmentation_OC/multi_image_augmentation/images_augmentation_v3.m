% Ask the user to select a folder containing the images
inputFolder = uigetdir(pwd, 'Select the folder containing images');

% Create a datastore from the selected folder
imds = imageDatastore(inputFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Ask the user to select a folder to save the augmented images
saveFolder = uigetdir(pwd, 'Select a folder to save the augmented images');

% Create folders to save the augmented images
augmentationFolders = {'au1', 'au2', 'au3', 'au4', 'au5'};
for i = 1:length(augmentationFolders)
    folderPath = fullfile(saveFolder, augmentationFolders{i});
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
end

% Get the total number of images in the datastore
totalImages = numel(imds.Files);

% Initialize the waitbar
progressBar = waitbar(0, 'Performing augmentations...', 'Name', 'Augmentation Progress');

% Reset the input datastore to start from the beginning
reset(imds);

while hasdata(imds)
    % Read the next image and its label from the datastore
    [img, info] = read(imds);

    % Get the filename for saving
    filename = info.Filename;
    label = info.Label;

    % Perform augmentations and save images to respective folders
    for i = 1:length(augmentationFolders)
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

        % Get the filename without extension for saving
        [~, name, ext] = fileparts(filename);

        % Create a subfolder for the label if it doesn't exist
        labelFolder = fullfile(saveFolder, augmentationFolders{i}, char(label));
        if ~exist(labelFolder, 'dir')
            mkdir(labelFolder);
        end

        % Save the augmented image in the respective subfolder
        outputFilename = fullfile(labelFolder, [name, ext]);
        imwrite(augmentedImage, outputFilename);
    end

    % Update the waitbar
    currentImage = find(strcmp(imds.Files, filename));
    progress = currentImage / totalImages;
    waitbar(progress, progressBar, sprintf('Processed %d/%d images', currentImage, totalImages));
end

% Close the waitbar
close(progressBar);

disp('Augmentation completed and saved in respective folders (au1, au2, au3, au4, au5).');

