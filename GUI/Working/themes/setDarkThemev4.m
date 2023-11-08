function setDarkThemev4(app)
    % Switch to dark theme
    app.CurrentTheme = 'dark';
    
    % Define color variables
    bgColor = [0.1216 0.1216 0.1216];
    labelBgColor = [0.0118 0.851 0.7686];
    labelFontColor = [0.2314 0.2314 0.2314];
    panelBorderColor = [0 0 0];
    panelForeColor = [0.9412 0.9412 0.9412];
    panelBgColor = [0.2314 0.2314 0.2314];
    buttonBgColor = [0.8706 0.8706 0.8706];
    buttonFontColor = [0.149 0.149 0.149];
    axesColor = [0.1216 0.1216 0.1216];
    importPanelBorderColor = [0 0 0];
    importPanelForeColor = [1 1 1];
    importPanelBgColor = [0.2314 0.2314 0.2314];
    
    % GridLayout
    app.GridLayout.BackgroundColor = bgColor;
    
    % TrafficSignDefectDetectionLabel
    app.TrafficSignDefectDetectionLabel.BackgroundColor = labelBgColor;
    app.TrafficSignDefectDetectionLabel.FontColor = labelFontColor;
    
    % ChooseNeuralNetworksPanel
    app.ChooseNeuralNetworksPanel.BorderColor = panelBorderColor;
    app.ChooseNeuralNetworksPanel.ForegroundColor = panelForeColor;
    app.ChooseNeuralNetworksPanel.BackgroundColor = panelBgColor;
    
    % GridLayout2
    app.GridLayout2.BackgroundColor = bgColor;
    
    % LoadClassifierButton
    app.LoadClassifierButton.BackgroundColor = buttonBgColor;
    app.LoadClassifierButton.FontColor = buttonFontColor;
    
    % LoadDetectorButton
    app.LoadDetectorButton.BackgroundColor = buttonBgColor;
    app.LoadDetectorButton.FontColor = buttonFontColor;
    
    % LocationButton
    app.LocationButton.BackgroundColor = buttonBgColor;
    app.LocationButton.FontColor = buttonFontColor;
    
    % TrafficSignPanel
    app.TrafficSignPanel.BorderColor = panelBorderColor;
    app.TrafficSignPanel.ForegroundColor = panelForeColor;
    app.TrafficSignPanel.BackgroundColor = panelBgColor;
    
    % GridLayout4
    app.GridLayout4.BackgroundColor = bgColor;
    
    % UIAxes
    app.UIAxes.Color = axesColor;
    
    % ImportImagePanel
    app.ImportImagePanel.BorderColor = importPanelBorderColor;
    app.ImportImagePanel.ForegroundColor = importPanelForeColor;
    app.ImportImagePanel.BackgroundColor = importPanelBgColor;
    
    % GridLayout3
    app.GridLayout3.BackgroundColor = bgColor;
    
    % BrowseButton
    app.BrowseButton.BackgroundColor = buttonBgColor;
    app.BrowseButton.FontColor = buttonFontColor;
    
    % ClassifyButton
    app.ClassifyButton.BackgroundColor = [0.8471 0.5725 0.0863]; % Use specific color
    app.ClassifyButton.FontColor = buttonFontColor;
    
    % DetectButton
    app.DetectButton.BackgroundColor = [0.8471 0.5725 0.0863]; % Use specific color
    app.DetectButton.FontColor = buttonFontColor;
    
    % Button
    app.Button.BackgroundColor = buttonBgColor;  
end