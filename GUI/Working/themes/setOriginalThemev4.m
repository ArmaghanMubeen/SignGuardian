function setOriginalThemev4(app)
    % Switch to original theme
    app.CurrentTheme = 'original';
    
    % Define color variables
    bgColor = [0.9412 0.9412 0.9412];
    panelColor = [0.8392 0.8902 0.902];
    textColor = [0.0392 0.0392 0.0392];
    buttonColor = [0.3608 0.5686 0.702];
    accentColor = [0.9216 0.3882 0.251];
    borderColor = [0.776 0.776 0.776];
    grayColor = [0.902 0.902 0.902];
    
    % GridLayout
    app.GridLayout.BackgroundColor = bgColor;
    
    % TrafficSignDefectDetectionLabel
    app.TrafficSignDefectDetectionLabel.BackgroundColor = panelColor;
    app.TrafficSignDefectDetectionLabel.FontColor = textColor;
    
    % ChooseNeuralNetworksPanel
    app.ChooseNeuralNetworksPanel.ForegroundColor = textColor;
    app.ChooseNeuralNetworksPanel.BackgroundColor = panelColor;
    
    % GridLayout2
    app.GridLayout2.BackgroundColor = bgColor;
    
    % LoadClassifierButton
    app.LoadClassifierButton.BackgroundColor = buttonColor;
    app.LoadClassifierButton.FontColor = [1 1 1]; % White
    
    % LoadDetectorButton
    app.LoadDetectorButton.BackgroundColor = buttonColor;
    app.LoadDetectorButton.FontColor = [1 1 1]; % White
    
    % LocationButton
    app.LocationButton.BackgroundColor = buttonColor;
    app.LocationButton.FontColor = [1 1 1]; % White
    
    % ImportImagePanel
    app.ImportImagePanel.ForegroundColor = textColor;
    app.ImportImagePanel.BackgroundColor = panelColor;
    
    % GridLayout3
    app.GridLayout3.BackgroundColor = bgColor;
    
    % BrowseButton
    app.BrowseButton.BackgroundColor = buttonColor;
    app.BrowseButton.FontColor = [1 1 1]; % White
    
    % ClassifyButton
    app.ClassifyButton.BackgroundColor = accentColor;
    app.ClassifyButton.FontColor = [1 1 1]; % White
    
    % DetectButton
    app.DetectButton.BackgroundColor = accentColor;
    app.DetectButton.FontColor = [1 1 1]; % White
    
    % Button
    app.Button.BackgroundColor = bgColor;
    
    % TrafficSignPanel
    app.TrafficSignPanel.BorderColor = borderColor;
    app.TrafficSignPanel.ForegroundColor = textColor;
    app.TrafficSignPanel.BackgroundColor = panelColor;
    
    % GridLayout4
    app.GridLayout4.BackgroundColor = bgColor;
    
    % UIAxes
    app.UIAxes.Color = grayColor;
end
