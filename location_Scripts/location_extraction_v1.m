% Read Image and Extract Metadata:
imageInfo = imfinfo("D:\college\FYP\Scripts\location\IMG_20230816_185525.jpg"); % Replace with your image's path

% Check for GPS Metadata:
if isfield(imageInfo, 'GPSInfo')
    gpsData = imageInfo.GPSInfo;
else
    error('GPS information not found in the image metadata.');
end

% Extract GPS Coordinates:
latitude = gpsData.GPSLatitude;
longitude = gpsData.GPSLongitude;

% Convert GPS Coordinates:
latDegrees = latitude(1) + latitude(2)/60 + latitude(3)/3600;
lonDegrees = longitude(1) + longitude(2)/60 + longitude(3)/3600;

% Generate Google Maps URL:
googleMapsURL = sprintf("https://www.google.com/maps/place/%f,%f", latDegrees, lonDegrees);
% disp("Google Maps URL: " + googleMapsURL);
disp(googleMapsURL);

% % Open URL in Default Browser
% stat = web(googleMapsURL,'-new','-notoolbar');

% data = webread(googleMapsURL);

% % Initialize Map:
% figure;
% worldmap([min(latitude), max(latitude)], [min(longitude), max(longitude)]);
% geobubble(latitude, longitude);

% % Add Map Details:
% title('Defective Traffic Signs Locations');
% land = shaperead('landareas', 'UseGeoCoords', true);
% geoplot(land.Lat, land.Lon, 'k'); % Add land boundaries
% geolimits([min(latitude), max(latitude)], [min(longitude), max(longitude)]); % Set map limits



% Save Map
% saveas(gcf, 'defective_signs_map.png');


