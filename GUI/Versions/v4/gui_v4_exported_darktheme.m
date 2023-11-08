classdef gui_v4_exported_darktheme < gui_v4_exported
    methods
        % Constructor for the dark theme GUI
        function app = gui_v4_exported_darktheme
            % Call the superclass constructor
            app@gui_v4_exported();
            % Update theme-specific properties
            app.DefectDetectorUIFigure.Color = [0.1 0.1 0.1];
            app.TrafficSignDefectDetectionLabel.BackgroundColor = [0.2 0.2 0.2];
            app.TrafficSignDefectDetectionLabel.FontColor = [1 1 1];
            app.ChoosetheModelPanel.BackgroundColor = [0.2 0.2 0.2];
            app.LoadNetworkButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.SelectedNetworkEditFieldLabel.BackgroundColor = [0.2 0.2 0.2];
            app.SelectedNetworkEditFieldLabel.FontColor = [1 1 1];
            app.SelectedNetworkEditField.BackgroundColor = [0.2 0.2 0.2];
            app.TrafficSignPanel.BackgroundColor = [0.2 0.2 0.2];
            app.ImportImagePanel.BackgroundColor = [0.2 0.2 0.2];
            app.BrowseButton.BackgroundColor = [0.3608 0.5686 0.702];
            app.PredictButton.BackgroundColor = [0.9216 0.3882 0.251];
            app.PredictButton.FontColor = [1 1 1];
            app.GridLayout.BackgroundColor = [0.1 0.1 0.1];
            app.GridLayout3.BackgroundColor = [0.1 0.1 0.1];
            app.GridLayout4.BackgroundColor = [0.1 0.1 0.1];
        end
    end
end
