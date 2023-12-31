% Select the folder containing the images
inputFolder = uigetdir(pwd, 'Select the folder containing images');

% Create a folder for augmented images
outputFolder = fullfile(inputFolder, 'Augmented');
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get a list of image files in the input folder
imageFiles = dir(fullfile(inputFolder, '*.png'));

% Loop through each image and perform augmentations
for i = 1:numel(imageFiles)
    % Load the input image
    inputImage = imread(fullfile(inputFolder, imageFiles(i).name));
    
    % Check if the loaded file is an image
    if ~isempty(inputImage)
        % Random Reflection
        reflectedImage = flip(inputImage, randi(1)+1); % Randomly flip horizontally
        imwrite(reflectedImage, fullfile(outputFolder, [imageFiles(i).name(1:end-4) '_Reflected.jpg']));

        % Random Rotation
        angleRange = [-15, 15]; % Rotation angle range in degrees
        rotationAngle = randi(angleRange); % Random rotation angle
        rotatedImage = imrotate(inputImage, rotationAngle, 'bilinear', 'crop');
        imwrite(rotatedImage, fullfile(outputFolder, [imageFiles(i).name(1:end-4) '_Rotated.jpg']));

        % Random Rescaling
        scaleRange = [0.8, 1.2]; % Scaling factor range
        scaleFactor = rand(1) * diff(scaleRange) + scaleRange(1); % Random scaling factor
        rescaledImage = imresize(inputImage, scaleFactor);
        imwrite(rescaledImage, fullfile(outputFolder, [imageFiles(i).name(1:end-4) '_Rescaled.jpg']));

        % Random Horizontal Translation
        txRange = [-30, 30]; % Translation range in x-axis (pixels)
        tx = randi(txRange); % Random translation in x-axis
        translatedImageX = imtranslate(inputImage, [tx, 0]);
        imwrite(translatedImageX, fullfile(outputFolder, [imageFiles(i).name(1:end-4) '_H_Translated.jpg']));

        % Random Vertical Translation
        tyRange = [-30, 30]; % Translation range in y-axis (pixels)
        ty = randi(tyRange); % Random translation in y-axis
        translatedImageY = imtranslate(inputImage, [0, ty]);
        imwrite(translatedImageY, fullfile(outputFolder, [imageFiles(i).name(1:end-4) '_V_Translated.jpg']));
    end
    
    % Display progress
    fprintf('Processed image %d/%d\n', i, numel(imageFiles));
end

disp('Data augmentation completed and saved in the Augmented folder.');

