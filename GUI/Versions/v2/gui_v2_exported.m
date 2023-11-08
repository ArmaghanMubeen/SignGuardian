classdef gui_v2_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TrafficSignDefectDetectionLabel  matlab.ui.control.Label
        TrafficSignPanel               matlab.ui.container.Panel
        UIAxes                         matlab.ui.control.UIAxes
        ChoosetheDetectionModelPanel   matlab.ui.container.Panel
        SelectedNetworkEditField       matlab.ui.control.EditField
        SelectedNetworkEditFieldLabel  matlab.ui.control.Label
        LoadNetworkButton              matlab.ui.control.Button
        ImportImagePanel               matlab.ui.container.Panel
        BrowseButton                   matlab.ui.control.Button
        PredictButton                  matlab.ui.control.Button
    end

    
    properties (Access = private)
        Network            % To store the loaded network data (matfile)
        LoadedNetworkName  % To store the name of the loaded network (string)
        SelectedImage      % To store the imported image (uint8 array)
        SelectedImagePath   % To store the full path of the selected image (string)
        PredictedLabel     % To store the predicted label from the network (string)
        ActualLabel        % To store the actual label of the image (string)
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
             % Initialize properties
            app.Network = [];
            app.LoadedNetworkName = "No network loaded.";
            app.SelectedImage = [];
            app.SelectedImagePath = ""; % Initialize SelectedImagePath
            app.PredictedLabel = "";
            app.ActualLabel = "";
        end

        % Button pushed function: LoadNetworkButton
        function LoadNetworkButtonPushed(app, event)
            [filename, filepath] = uigetfile('*.mat', 'Select Network.mat file');
            if isequal(filename, 0) || isequal(filepath, 0)
                % User canceled or closed the file selection dialog
                return;
            end

            % Load the network
            app.Network = matfile(fullfile(filepath, filename));

            % Get the network name and display in the text field
            app.LoadedNetworkName = filename;
            app.SelectedNetworkEditField.Value = app.LoadedNetworkName;
        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            [filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png', 'Image files (*.jpg, *.jpeg, *.png)'; '*.*', 'All files'}, 'Select an image');
            if isequal(filename, 0) || isequal(filepath, 0)
                % User canceled or closed the file selection dialog
                return;
            end

            % Read and display the selected image
            app.SelectedImage = imread(fullfile(filepath, filename));
            imshow(app.SelectedImage, 'Parent', app.UIAxes);

            app.SelectedImagePath = fullfile(filepath, filename); % Store the full path
        end

        % Button pushed function: PredictButton
        function PredictButtonPushed(app, event)
            if isempty(app.Network) || isempty(app.SelectedImage)
                % Check if both network and image are loaded
                msgbox('Please load the network and import an image before predicting.', 'Error', 'error');
                return;
            end

            % Resize and preprocess the image (assumed to be the same size required by the network)
            resizedImage = imresize(app.SelectedImage, [224, 224]);

            % Load the network from the matfile
            net = app.Network.Network;

            % Perform prediction using the loaded network
            app.PredictedLabel = char(classify(net, resizedImage));

            % Get the actual label from the folder name of the selected image
            [~, actualLabel, ~] = fileparts(fileparts(app.SelectedImagePath));

            % Update the actual label
            app.ActualLabel = actualLabel;
            

            % Display the predicted and actual labels
            msgbox(sprintf('Predicted Label: %s\nActual Label: %s', app.PredictedLabel, app.ActualLabel), 'Prediction Results');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create PredictButton
            app.PredictButton = uibutton(app.UIFigure, 'push');
            app.PredictButton.ButtonPushedFcn = createCallbackFcn(app, @PredictButtonPushed, true);
            app.PredictButton.BackgroundColor = [0.9216 0.3882 0.251];
            app.PredictButton.FontName = 'ZapfDingbats';
            app.PredictButton.FontSize = 24;
            app.PredictButton.FontWeight = 'bold';
            app.PredictButton.FontColor = [1 1 1];
            app.PredictButton.Position = [208 20 226 54];
            app.PredictButton.Text = 'Predict';

            % Create ImportImagePanel
            app.ImportImagePanel = uipanel(app.UIFigure);
            app.ImportImagePanel.TitlePosition = 'centertop';
            app.ImportImagePanel.Title = 'Import Image';
            app.ImportImagePanel.Position = [13 123 288 109];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.ImportImagePanel, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.BrowseButton.FontSize = 14;
            app.BrowseButton.FontWeight = 'bold';
            app.BrowseButton.FontColor = [1 1 1];
            app.BrowseButton.Position = [37 21 214 49];
            app.BrowseButton.Text = 'Browse';

            % Create ChoosetheDetectionModelPanel
            app.ChoosetheDetectionModelPanel = uipanel(app.UIFigure);
            app.ChoosetheDetectionModelPanel.TitlePosition = 'centertop';
            app.ChoosetheDetectionModelPanel.Title = 'Choose the Detection Model';
            app.ChoosetheDetectionModelPanel.Position = [13 253 288 171];

            % Create LoadNetworkButton
            app.LoadNetworkButton = uibutton(app.ChoosetheDetectionModelPanel, 'push');
            app.LoadNetworkButton.ButtonPushedFcn = createCallbackFcn(app, @LoadNetworkButtonPushed, true);
            app.LoadNetworkButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.LoadNetworkButton.FontSize = 14;
            app.LoadNetworkButton.FontWeight = 'bold';
            app.LoadNetworkButton.FontColor = [1 1 1];
            app.LoadNetworkButton.Position = [42 85 204 47];
            app.LoadNetworkButton.Text = 'Load Network';

            % Create SelectedNetworkEditFieldLabel
            app.SelectedNetworkEditFieldLabel = uilabel(app.ChoosetheDetectionModelPanel);
            app.SelectedNetworkEditFieldLabel.HorizontalAlignment = 'right';
            app.SelectedNetworkEditFieldLabel.Position = [37 29 99 22];
            app.SelectedNetworkEditFieldLabel.Text = 'Selected Network';

            % Create SelectedNetworkEditField
            app.SelectedNetworkEditField = uieditfield(app.ChoosetheDetectionModelPanel, 'text');
            app.SelectedNetworkEditField.Position = [151 29 100 22];

            % Create TrafficSignPanel
            app.TrafficSignPanel = uipanel(app.UIFigure);
            app.TrafficSignPanel.TitlePosition = 'centertop';
            app.TrafficSignPanel.Title = 'Traffic Sign';
            app.TrafficSignPanel.Position = [312 123 316 301];

            % Create UIAxes
            app.UIAxes = uiaxes(app.TrafficSignPanel);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XColor = 'none';
            app.UIAxes.YColor = 'none';
            app.UIAxes.ZColor = 'none';
            app.UIAxes.Position = [1 0 315 278];

            % Create TrafficSignDefectDetectionLabel
            app.TrafficSignDefectDetectionLabel = uilabel(app.UIFigure);
            app.TrafficSignDefectDetectionLabel.BackgroundColor = [0.8392 0.8902 0.902];
            app.TrafficSignDefectDetectionLabel.HorizontalAlignment = 'center';
            app.TrafficSignDefectDetectionLabel.FontName = 'Consolas';
            app.TrafficSignDefectDetectionLabel.FontSize = 18;
            app.TrafficSignDefectDetectionLabel.FontWeight = 'bold';
            app.TrafficSignDefectDetectionLabel.Position = [1 443 640 38];
            app.TrafficSignDefectDetectionLabel.Text = 'Traffic Sign Defect Detection';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui_v2_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end