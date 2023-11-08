classdef gui_v5_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DefectDetectorUIFigure         matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        TrafficSignPanel               matlab.ui.container.Panel
        GridLayout4                    matlab.ui.container.GridLayout
        UIAxes                         matlab.ui.control.UIAxes
        Button                         matlab.ui.control.StateButton
        PredictButton                  matlab.ui.control.Button
        ImportImagePanel               matlab.ui.container.Panel
        GridLayout3                    matlab.ui.container.GridLayout
        BrowseButton                   matlab.ui.control.Button
        ChoosetheModelPanel            matlab.ui.container.Panel
        GridLayout2                    matlab.ui.container.GridLayout
        SelectedNetworkEditField       matlab.ui.control.EditField
        SelectedNetworkEditFieldLabel  matlab.ui.control.Label
        LoadNetworkButton              matlab.ui.control.Button
        TrafficSignDefectDetectionLabel  matlab.ui.control.Label
    end

    
    properties (Access = private)
        Network            % To store the loaded network data (matfile)
        LoadedNetworkName  % To store the name of the loaded network (string)
        SelectedImage      % To store the imported image (uint8 array)
        SelectedImagePath   % To store the full path of the selected image (string)
        PredictedLabel     % To store the predicted label from the network (string)
        ActualLabel        % To store the actual label of the image (string)
    end
    
    properties (Access = public)
        CurrentTheme = 'original'; % Track the current theme
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
            % Create and show the progress bar
            progressBar = waitbar(0.1, 'Loading Neural Network...', 'Name', 'Neural Network');
        
            try
                
                % Update progress bar
                waitbar(0.5, progressBar, 'Loading Neural Network...');  % Update to appropriate value
                
                
                % Load the network
                app.Network = matfile(fullfile(filepath, filename));
        
                % Update progress bar
                waitbar(1, progressBar, 'Loaded Neural Network...');  % Update to appropriate value
        
                % Get the network name and display in the text field
                app.LoadedNetworkName = filename;
                app.SelectedNetworkEditField.Value = app.LoadedNetworkName;
        
                % Close the progress bar
                close(progressBar);
            catch
                % Close the progress bar in case of an error
                close(progressBar);
                errordlg('Error loading network.', 'Error', 'modal');
            end
        end

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)

            % Display file selection dialog
            [filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png', 'Image files (*.jpg, *.jpeg, *.png)'}, 'Select an image');
            
            % Check if the user canceled the dialog
            if isequal(filename, 0) || isequal(filepath, 0)
                return;
            end
            
            % Create a waitbar for image import
            ImportingProgressBar = waitbar(0, 'Importing...');
            
            try
                % Update progress bar message
                waitbar(0.3, ImportingProgressBar, 'Importing...');
                
                % Read and display the selected image
                app.SelectedImage = imread(fullfile(filepath, filename));
                imshow(app.SelectedImage, 'Parent', app.UIAxes);
                
                % Update progress bar message
                waitbar(0.7, ImportingProgressBar, 'Processing...');
                
                % Store the selected image path
                app.SelectedImagePath = fullfile(filepath, filename);
                
                % Close the progress bar
                waitbar(1, ImportingProgressBar, 'Done');
                pause(0.5); % Add a slight pause for the user to see the progress completion
                delete(ImportingProgressBar);
                
            catch exception
                % Handle exceptions and display an error message
                errordlg(['An error occurred during image import: ', exception.message], 'Image Import Error', 'modal');
                % Close the progress bar in case of an error
                delete(ImportingProgressBar);
            end
            app.SelectedImagePath = fullfile(filepath, filename); % Store the full path
        end

        % Button pushed function: PredictButton
        function PredictButtonPushed(app, event)
            if isempty(app.Network) || isempty(app.SelectedImage)
                % Check if both network and image are loaded
                msgbox('Please load the network and import an image before predicting.', 'Error', 'error');
                return;
            end
            % Create a progress bar
            predictProgressBar = waitbar(0.2, 'Predicting...');
            % Load the network from the matfile
            net = app.Network.Network;
            inputLayer = net.Layers(1);
            insz = inputLayer.InputSize(1:2);
        
            % Resize and preprocess the image (assumed to be the same size required by the network)
            resizedImage = imresize(app.SelectedImage, insz);
        
            % updating the progress bar
            waitbar(0.4,predictProgressBar,'Predicting...');
        
            try
                waitbar(0.7,predictProgressBar,'Predicting...');
                % Perform prediction using the loaded network
                app.PredictedLabel = char(classify(net, resizedImage));
                waitbar(1,predictProgressBar,'Showing Results');
                % Get the actual label from the folder name of the selected image
                [~, actualLabel, ~] = fileparts(fileparts(app.SelectedImagePath));
        
                % Update the actual label
                app.ActualLabel = actualLabel;
        
                % Display the predicted and actual labels
                msgbox(sprintf('Predicted Label: %s\nActual Label: %s', app.PredictedLabel, app.ActualLabel), 'Prediction Results');
        
            catch exception
                % Close the progress bar
                delete(predictProgressBar);

                % Handle any exceptions and display an error message
                errordlg(['An error occurred during prediction: ', exception.message], 'Prediction Error', 'modal');
            end
        
            % Close the progress bar
            delete(predictProgressBar);
        end

        % Value changed function: Button
        function ButtonValueChanged(app, event)
            if strcmp(app.CurrentTheme, 'original')
                % Switch to dark theme
                setDarkTheme(app);
                app.CurrentTheme = 'dark';

            else
                % Switch to original theme
                setOriginalTheme(app);
                app.CurrentTheme = 'original';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create DefectDetectorUIFigure and hide until all components are created
            app.DefectDetectorUIFigure = uifigure('Visible', 'off');
            app.DefectDetectorUIFigure.NumberTitle = 'on';
            app.DefectDetectorUIFigure.Position = [100 100 640 480];
            app.DefectDetectorUIFigure.Name = 'Defect Detector';
            app.DefectDetectorUIFigure.Icon = fullfile(pathToMLAPP, 'assets', 'gui_v5_icon.png');
            app.DefectDetectorUIFigure.Pointer = 'hand';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.DefectDetectorUIFigure);
            app.GridLayout.ColumnWidth = {197, '2x', '1x'};
            app.GridLayout.RowHeight = {38, 171, '1.24x', 109, 23, 54, '1x'};
            app.GridLayout.ColumnSpacing = 4.6;
            app.GridLayout.Padding = [4.6 10 4.6 10];
            app.GridLayout.Tooltip = {''};
            app.GridLayout.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create TrafficSignDefectDetectionLabel
            app.TrafficSignDefectDetectionLabel = uilabel(app.GridLayout);
            app.TrafficSignDefectDetectionLabel.BackgroundColor = [0.8392 0.8902 0.902];
            app.TrafficSignDefectDetectionLabel.HorizontalAlignment = 'center';
            app.TrafficSignDefectDetectionLabel.FontName = 'Consolas';
            app.TrafficSignDefectDetectionLabel.FontSize = 18;
            app.TrafficSignDefectDetectionLabel.FontWeight = 'bold';
            app.TrafficSignDefectDetectionLabel.FontColor = [0.0392 0.0392 0.0392];
            app.TrafficSignDefectDetectionLabel.Layout.Row = 1;
            app.TrafficSignDefectDetectionLabel.Layout.Column = [1 3];
            app.TrafficSignDefectDetectionLabel.Text = 'Traffic Sign Defect Detection';

            % Create ChoosetheModelPanel
            app.ChoosetheModelPanel = uipanel(app.GridLayout);
            app.ChoosetheModelPanel.ForegroundColor = [0.0392 0.0392 0.0392];
            app.ChoosetheModelPanel.TitlePosition = 'centertop';
            app.ChoosetheModelPanel.Title = 'Choose the Model';
            app.ChoosetheModelPanel.BackgroundColor = [0.8392 0.8902 0.902];
            app.ChoosetheModelPanel.Layout.Row = 2;
            app.ChoosetheModelPanel.Layout.Column = 1;
            app.ChoosetheModelPanel.FontName = 'Consolas';
            app.ChoosetheModelPanel.FontWeight = 'bold';
            app.ChoosetheModelPanel.FontSize = 14;

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.ChoosetheModelPanel);
            app.GridLayout2.ColumnWidth = {'1x'};
            app.GridLayout2.RowHeight = {47.07, 22.03, 22.03};
            app.GridLayout2.RowSpacing = 14.5;
            app.GridLayout2.Padding = [10 14.5 10 14.5];
            app.GridLayout2.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create LoadNetworkButton
            app.LoadNetworkButton = uibutton(app.GridLayout2, 'push');
            app.LoadNetworkButton.ButtonPushedFcn = createCallbackFcn(app, @LoadNetworkButtonPushed, true);
            app.LoadNetworkButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.LoadNetworkButton.FontName = 'Consolas';
            app.LoadNetworkButton.FontSize = 14;
            app.LoadNetworkButton.FontWeight = 'bold';
            app.LoadNetworkButton.FontColor = [1 1 1];
            app.LoadNetworkButton.Layout.Row = 1;
            app.LoadNetworkButton.Layout.Column = 1;
            app.LoadNetworkButton.Text = 'Load Network';

            % Create SelectedNetworkEditFieldLabel
            app.SelectedNetworkEditFieldLabel = uilabel(app.GridLayout2);
            app.SelectedNetworkEditFieldLabel.BackgroundColor = [0.8392 0.8902 0.902];
            app.SelectedNetworkEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectedNetworkEditFieldLabel.FontName = 'Consolas';
            app.SelectedNetworkEditFieldLabel.FontWeight = 'bold';
            app.SelectedNetworkEditFieldLabel.FontColor = [0.0392 0.0392 0.0392];
            app.SelectedNetworkEditFieldLabel.Layout.Row = 2;
            app.SelectedNetworkEditFieldLabel.Layout.Column = 1;
            app.SelectedNetworkEditFieldLabel.Text = 'Selected Network';

            % Create SelectedNetworkEditField
            app.SelectedNetworkEditField = uieditfield(app.GridLayout2, 'text');
            app.SelectedNetworkEditField.Editable = 'off';
            app.SelectedNetworkEditField.HorizontalAlignment = 'center';
            app.SelectedNetworkEditField.FontName = 'Consolas';
            app.SelectedNetworkEditField.BackgroundColor = [0.8392 0.8902 0.902];
            app.SelectedNetworkEditField.Layout.Row = 3;
            app.SelectedNetworkEditField.Layout.Column = 1;

            % Create ImportImagePanel
            app.ImportImagePanel = uipanel(app.GridLayout);
            app.ImportImagePanel.ForegroundColor = [0.0392 0.0392 0.0392];
            app.ImportImagePanel.TitlePosition = 'centertop';
            app.ImportImagePanel.Title = 'Import Image';
            app.ImportImagePanel.BackgroundColor = [0.8392 0.8902 0.902];
            app.ImportImagePanel.Layout.Row = 4;
            app.ImportImagePanel.Layout.Column = 1;
            app.ImportImagePanel.FontName = 'Consolas';
            app.ImportImagePanel.FontWeight = 'bold';
            app.ImportImagePanel.FontSize = 14;

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.ImportImagePanel);
            app.GridLayout3.ColumnWidth = {'1x'};
            app.GridLayout3.RowHeight = {'1x', 49, '1x'};
            app.GridLayout3.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create BrowseButton
            app.BrowseButton = uibutton(app.GridLayout3, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.BrowseButton.FontSize = 14;
            app.BrowseButton.FontWeight = 'bold';
            app.BrowseButton.FontColor = [1 1 1];
            app.BrowseButton.Layout.Row = 2;
            app.BrowseButton.Layout.Column = 1;
            app.BrowseButton.Text = 'Browse';

            % Create PredictButton
            app.PredictButton = uibutton(app.GridLayout, 'push');
            app.PredictButton.ButtonPushedFcn = createCallbackFcn(app, @PredictButtonPushed, true);
            app.PredictButton.BackgroundColor = [0.9216 0.3882 0.251];
            app.PredictButton.FontName = 'Consolas';
            app.PredictButton.FontSize = 18;
            app.PredictButton.FontWeight = 'bold';
            app.PredictButton.FontColor = [1 1 1];
            app.PredictButton.Layout.Row = 6;
            app.PredictButton.Layout.Column = 2;
            app.PredictButton.Text = 'Predict';

            % Create Button
            app.Button = uibutton(app.GridLayout, 'state');
            app.Button.ValueChangedFcn = createCallbackFcn(app, @ButtonValueChanged, true);
            app.Button.Icon = fullfile(pathToMLAPP, 'assets', 'dark_icon.png');
            app.Button.IconAlignment = 'center';
            app.Button.Text = '';
            app.Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button.Layout.Row = 5;
            app.Button.Layout.Column = 2;

            % Create TrafficSignPanel
            app.TrafficSignPanel = uipanel(app.GridLayout);
            app.TrafficSignPanel.BorderColor = [0 0 0];
            app.TrafficSignPanel.ForegroundColor = [0.0392 0.0392 0.0392];
            app.TrafficSignPanel.TitlePosition = 'centertop';
            app.TrafficSignPanel.Title = 'Traffic Sign';
            app.TrafficSignPanel.BackgroundColor = [0.8392 0.8902 0.902];
            app.TrafficSignPanel.Layout.Row = [2 4];
            app.TrafficSignPanel.Layout.Column = [2 3];
            app.TrafficSignPanel.FontName = 'Consolas';
            app.TrafficSignPanel.FontWeight = 'bold';
            app.TrafficSignPanel.FontSize = 14;

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.TrafficSignPanel);
            app.GridLayout4.ColumnWidth = {'13.33x'};
            app.GridLayout4.RowHeight = {'1x'};
            app.GridLayout4.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout4);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.AmbientLightColor = 'none';
            app.UIAxes.XColor = 'none';
            app.UIAxes.YColor = 'none';
            app.UIAxes.ZColor = 'none';
            app.UIAxes.LineWidth = 0.1;
            app.UIAxes.Color = [0.902 0.902 0.902];
            app.UIAxes.ClippingStyle = 'rectangle';
            app.UIAxes.GridColor = 'none';
            app.UIAxes.MinorGridColor = 'none';
            app.UIAxes.Box = 'on';
            app.UIAxes.Clipping = 'off';
            app.UIAxes.Layout.Row = 1;
            app.UIAxes.Layout.Column = 1;

            % Show the figure after all components are created
            app.DefectDetectorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gui_v5_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DefectDetectorUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DefectDetectorUIFigure)
        end
    end
end