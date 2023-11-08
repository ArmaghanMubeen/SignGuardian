
load Neural_Networks\1-sign\resnet_18\no-parking\Network.mat
signds = imageDatastore("D:\college\FYP\test_images\output","IncludeSubfolders",true,"LabelSource","foldernames");
signNames = signds.Labels;

% Augmentation

resizeImgs = augmentedImageDatastore([224 224],signds);


% Prediction
signPrediction = classify(achaBacha,resizeImgs);

signActual = signds.Labels;

% Comparison
numCorrect = nnz(signPrediction == signActual);
fracCorrect = numCorrect/numel(signPrediction);

% Confusion Chart
confusionchart(signActual,signPrediction);

