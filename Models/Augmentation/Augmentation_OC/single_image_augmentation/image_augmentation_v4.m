% Load the input image
inputImage = imread("D:\college\FYP\TrafficSignsDataset\Stop-Defective\3.png");

% Create a folder for Augmentation
augmentationDir = 'Augmentation';
if ~exist(augmentationDir, 'dir')
    mkdir(augmentationDir);
end

% Random Reflection
reflectedImage = flip(inputImage, randi(2)+1); % Randomly flip horizontally
imwrite(reflectedImage, fullfile(augmentationDir, 'Random_Reflection.jpg'));

% Random Rotation
angleRange = [-15, 15]; % Rotation angle range in degrees
rotationAngle = randi(angleRange); % Random rotation angle
rotatedImage = imrotate(inputImage, rotationAngle, 'bilinear', 'crop');
imwrite(rotatedImage, fullfile(augmentationDir, 'Random_Rotation.jpg'));

% Random Rescaling
scaleRange = [0.8, 1.2]; % Scaling factor range
scaleFactor = rand(1) * diff(scaleRange) + scaleRange(1); % Random scaling factor
rescaledImage = imresize(inputImage, scaleFactor);
imwrite(rescaledImage, fullfile(augmentationDir, 'Random_Rescaling.jpg'));

% Random Horizontal Translation
txRange = [-30, 30]; % Translation range in x-axis (pixels)
tx = randi(txRange); % Random translation in x-axis
translatedImageX = imtranslate(inputImage, [tx, 0]);
imwrite(translatedImageX, fullfile(augmentationDir, 'Random_Horizontal_Translation.jpg'));

% Random Vertical Translation
tyRange = [-30, 30]; % Translation range in y-axis (pixels)
ty = randi(tyRange); % Random translation in y-axis
translatedImageY = imtranslate(inputImage, [0, ty]);
imwrite(translatedImageY, fullfile(augmentationDir, 'Random_Vertical_Translation.jpg'));

disp('Data augmentation completed and saved in the Augmentation folder.');
