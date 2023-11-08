% Get the current script directory
scriptDir = fileparts(mfilename("D:\college\FYP\TrafficSignsDataset\Stop-Defective\3.png"));

% Load the input image
inputImage = imread('input_image.jpg');

% Create labeled folders for augmented images
augmentationLabels = {'rotated', 'scaled', 'translated', 'flipped'};
for i = 1:length(augmentationLabels)
    folderPath = fullfile(scriptDir, augmentationLabels{i});
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);
    end
end

% Perform data augmentation and save the augmented images
numAugmentations = 5;   % Number of augmentations for each type

% Random Rotation
angleRange = [-15, 15]; % Rotation angle range in degrees
for i = 1:numAugmentations
    angle = randi(angleRange); % Random rotation angle
    augmentedImage = imrotate(inputImage, angle, 'bilinear', 'crop');
    imwrite(augmentedImage, fullfile(scriptDir, 'rotated', ['rotated_', num2str(i), '.jpg']));
end

% Random Scaling
scaleRange = [0.8, 1.2]; % Scaling factor range
for i = 1:numAugmentations
    scale = rand(1) * diff(scaleRange) + scaleRange(1); % Random scaling factor
    augmentedImage = imresize(inputImage, scale);
    imwrite(augmentedImage, fullfile(scriptDir, 'scaled', ['scaled_', num2str(i), '.jpg']));
end

% Random Translation
translationRange = [-30, 30]; % Translation range in pixels
for i = 1:numAugmentations
    tx = randi(translationRange); % Random translation in x-axis
    ty = randi(translationRange); % Random translation in y-axis
    tform = affine2d([1, 0, 0; 0, 1, 0; tx, ty, 1]);
    augmentedImage = imwarp(inputImage, tform, 'OutputView', imref2d(size(inputImage)));
    imwrite(augmentedImage, fullfile(scriptDir, 'translated', ['translated_', num2str(i), '.jpg']));
end

% Horizontal Flipping
for i = 1:numAugmentations
    augmentedImage = flip(inputImage, 2); % Horizontal flip
    imwrite(augmentedImage, fullfile(scriptDir, 'flipped', ['flipped_', num2str(i), '.jpg']));
end

disp('Data augmentation completed and saved in labeled folders.');
