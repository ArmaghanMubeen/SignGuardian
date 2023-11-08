% Ask user to select a video
[filename, filepath] = uigetfile({'*.mp4', 'Video files (*.mp4)'}, 'Select a video');
if isequal(filename, 0) || isequal(filepath, 0)
    disp('No video selected. Exiting.');
    return;
end

% Create a VideoReader object
videoPath = fullfile(filepath, filename);
videoReader = VideoReader(videoPath);

% Get the total number of frames in the video
totalFrames = floor(videoReader.Duration * videoReader.FrameRate);

% Create a VideoWriter object to save the processed video
outputVideoPath = fullfile(filepath, 'processed_traffic_sign_video.mp4');
outputVideo = VideoWriter(outputVideoPath, 'MPEG-4');
open(outputVideo);

% Create a figure for displaying the live video
figure;

% Process each frame of the video
for frameIndex = 1:totalFrames
    % Read the current frame
    frame = readFrame(videoReader);
    
    % Convert the frame to the LAB color space
    labFrame = rgb2lab(frame);
    
    % Extract the "a" channel which represents color differences
    aChannel = labFrame(:, :, 2);
    
    % Thresholding to segment potential traffic sign regions
    binaryImage = aChannel > 10; % Adjust threshold as needed
    
    % Remove small noise regions
    binaryImage = bwareaopen(binaryImage, 200);
    
    % Perform morphological operations to enhance the regions
    se = strel('disk', 5);
    binaryImage = imclose(binaryImage, se);
    
    % Identify and label connected components
    cc = bwconncomp(binaryImage);
    labeledImage = labelmatrix(cc);
    
    % Calculate the area of each connected component
    area = regionprops(cc, 'Area');
    areaArray = [area.Area];
    
    % Find the largest connected component (assumed to be the traffic sign)
    [~, idx] = max(areaArray);
    
    % Create a mask of the detected traffic sign
    trafficSignMask = labeledImage == idx;
    
    % Get the bounding box of the detected traffic sign
    boundingBox = regionprops(trafficSignMask, 'BoundingBox');
    bb = boundingBox.BoundingBox;
    
    % Add a margin around the bounding box
    margin = 20; % Adjust the margin size as needed
    expandedBoundingBox = [bb(1) - margin, bb(2) - margin, bb(3) + 2*margin, bb(4) + 2*margin];
    
    % Calculate the bounding box of the detected traffic sign
    boundingBox = round(expandedBoundingBox); % Rounded to integers
    
    % Draw a red bounding box around the traffic sign
    frameWithBoundingBox = insertShape(frame, 'Rectangle', boundingBox, 'LineWidth', 2, 'Color', 'red');
    
    % Display the frame with bounding box
    imshow(frameWithBoundingBox);
    
    % Print progress
    fprintf('Processing frame %d/%d\n', frameIndex, totalFrames);
    
    % Write the frame with bounding box to the output video
    % writeVideo(outputVideo, frameWithBoundingBox);

    % Pause to show the frame (optional)
    pause(0.1);
end
% Close the output video
close(outputVideo);

disp(['Processed video saved at: ' outputVideoPath]);
disp('Video processing complete.');

% Close the figure
close(gcf);

