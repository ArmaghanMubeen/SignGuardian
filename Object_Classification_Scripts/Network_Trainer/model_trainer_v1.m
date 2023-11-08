load Neural_Networks\1-sign\resnet_18\resnet.mat
signds = imageDatastore("D:\college\FYP\Dataset\Experimenting\test\no-parking","IncludeSubfolders",true,"LabelSource","foldernames");
signNames = signds.Labels;
[signTrain,signTest] = splitEachLabel(signds,0.8,"randomized");

% Augmentation
resizeTrainImgs = augmentedImageDatastore([224 224],signTrain);
resizeTestImgs = augmentedImageDatastore([224 224],signTest);

numClasses = numel(categories(signds.Labels));

% Setting Options
opts = trainingOptions("sgdm","InitialLearnRate",0.001,"MaxEpochs",5,"VerboseFrequency",2);

% Training the network
[Network1,info] = trainNetwork(resizeTrainImgs,resnet,opts);

% Evaluating Performance
plot(info.TrainingLoss);


% Prediction
signPrediction = classify(Network1,resizeTestImgs);

signActual = signTest.Labels;

% Comparison
numCorrect = nnz(signPrediction == signActual);
fracCorrect = numCorrect/numel(signPrediction);

% Confusion Chart
confusionchart(signActual,signPrediction);

