% Load the input image
inputImage = imread("D:\college\FYP\TrafficSignsDataset\Stop-Defective\3.png");

% Create labeled folders for augmented images
augmentationLabels = {'rotated', 'flipped'};
for i = 1:length(augmentationLabels)
    if ~exist(augmentationLabels{i}, 'dir')
        mkdir(augmentationLabels{i});
    end
end

% Perform data augmentation and save the augmented images
angleRange = [-15, 15]; % Rotation angle range in degrees
numAugmentations = 5;   % Number of augmentations for each type

% Random Rotation
for i = 1:numAugmentations
    angle = randi(angleRange); % Random rotation angle
    augmentedImage = imrotate(inputImage, angle, 'bilinear', 'crop');
    imwrite(augmentedImage, fullfile('rotated', ['rotated_', num2str(i), '.jpg']));
end

% Horizontal Flipping
for i = 1:numAugmentations
    augmentedImage = flip(inputImage, 2); % Horizontal flip
    imwrite(augmentedImage, fullfile('flipped', ['flipped_', num2str(i), '.jpg']));
end

disp('Data augmentation completed and saved in labeled folders.');
