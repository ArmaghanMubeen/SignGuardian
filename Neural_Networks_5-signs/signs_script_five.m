signds = imageDatastore("D:\college\FYP\TrafficSignsDataset","IncludeSubfolders",true,"LabelSource","foldernames");
signNames = signds.Labels;
[signTrain,signTest] = splitEachLabel(signds,0.6,"randomized");

% Augmentation
resizeTrainImgs = augmentedImageDatastore([224 224],signTrain);
resizeTestImgs = augmentedImageDatastore([224 224],signTest);

numClasses = numel(categories(signds.Labels));

% Setting Options
opts = trainingOptions("adam","InitialLearnRate",0.001,"MaxEpochs",1,"VerboseFrequency",2);

% Training the network
[signnet,info] = trainNetwork(resizeTrainImgs,ts_network,opts);

% Evaluating Performance
plot(info.TrainingLoss);


% Prediction
signPrediction = classify(signnet,resizeTestImgs);

signActual = signTest.Labels;

% Comparison
numCorrect = nnz(signPrediction == signActual);
fracCorrect = numCorrect/numel(signPrediction);

% Confusion Chart
confusionchart(signActual,signPrediction);

