% Specify the path to the input video
videoFilePath = "C:\Users\Calm\Downloads\FYP\videoDataset\Parking\VID_20230816_185406.mp4";

% Specify the path to the output folder where images will be saved
outputFolderPath = "C:\Users\Calm\Downloads\FYP\videoDataset\Parking\ParkingImages" ;
if ~exist(outputFolderPath, 'dir')
    mkdir(outputFolderPath);
end

% Create a VideoReader object to read the video
videoObj = VideoReader(videoFilePath);

% Loop through each frame of the video and save as an image
frameNumber = 1;
while hasFrame(videoObj)
    frame = readFrame(videoObj);
    outputFilename = sprintf('frame_%04d.jpg', frameNumber); % Adjust the format as needed
    outputPath = fullfile(outputFolderPath, outputFilename);
    imwrite(frame, outputPath);
    frameNumber = frameNumber + 1;
end

disp('Video frames have been extracted and saved as images.');

% Clean up
delete(videoObj);
