% Load the ONNX model
model = importONNXNetwork("D:\0 - Downloads\Chrome\Matlab\resnet50_model.onnx");

% Load and preprocess the image (replace 'path_to_image.jpg' with the actual image path)
img = imread("D:\college\FYP\Dataset\Experimenting\test\stopping\Stop\17.png");
img = imresize(img, [224, 224]);
img = double(img) / 255.0;

% Perform inference
preds = predict(model, img);

% Display predictions (assuming you have two classes: Healthy and Damaged)
if preds(1) > preds(2)
    disp('Predicted class: Healthy');
else
    disp('Predicted class: Damaged');
end