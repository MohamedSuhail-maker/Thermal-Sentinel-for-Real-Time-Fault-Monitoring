%% MATLAB Script for Real-Time Thermal Monitoring Output to Website and Email

% Set ESP32 IP and Port
esp32_ip = '192.168.000';  
esp32_port = 1234;

% Create TCP Client
tcpObj = tcpclient(esp32_ip, esp32_port, "Timeout", 5);
pause(2);  % Allow time for connection setup

% Define parameters
newSize = [64, 64]; % Upscaled resolution
extremeThreshold = 45; % Temperature threshold for marking
removeTime = 5; % Seconds before removing bounding box
boxTimestamps = []; % Store detected bounding box timestamps

% Define server URL (replace with your server endpoint)
serverURL = 'https://your-server-endpoint.com';

% Email Notification Variables
emailSentTime = 0;  % Store last email sent time
emailCooldown = 300; % 5 minutes cooldown (300 seconds)

% SMTP Server Configuration
mail = 'yourid@gmail.com';
password = 'dfmz diwa xatj gbyn';  % Use App Password for Gmail

setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable','true');
props.setProperty('mail.smtp.port','587');

% Initialize Heatmap Figure
figure;
colormap(jet);
colorbar;
h = imagesc(zeros(newSize));  % Heatmap handle
axis off; % Hide axes
hold on; % Allow overlaying bounding boxes

% Frame rate control (20 FPS)
frameDelay = 1 / 20; % 50 ms delay for ~20 FPS
boxHandles = []; % Store drawn bounding boxes

while true
    try
        % Check if data is available
        if tcpObj.BytesAvailable > 0
            rawData = readline(tcpObj);  % Read data from ESP32
            thermalData = str2num(rawData);  % Convert to numeric array

            if numel(thermalData) == 64
                % Reshape 8x8 thermal data
                heatmapMatrix = reshape(thermalData, [8, 8]);

                % Upscale using Bicubic Interpolation for 64x64 visualization
                refinedHeatmap = imresize(heatmapMatrix, newSize, 'bicubic');

                % Apply Gaussian smoothing
                refinedHeatmap = smoothdata(refinedHeatmap, 'gaussian', 10);

                % Update heatmap
                set(h, 'CData', refinedHeatmap);
                caxis([25 50]); % Adjust color range
                drawnow;

                % Identify overheated regions
                binaryMask = refinedHeatmap >= extremeThreshold;
                stats = regionprops(binaryMask, 'BoundingBox'); % Get bounding boxes

                % Remove outdated bounding boxes
                currentTime = now * 86400; % Convert to seconds
                for i = length(boxTimestamps):-1:1
                    if (currentTime - boxTimestamps(i)) > removeTime
                        boxTimestamps(i) = [];
                        delete(boxHandles(i));
                        boxHandles(i) = [];
                    end
                end

                % Draw new bounding boxes
                faultDetected = false;
                for i = 1:length(stats)
                    bbox = stats(i).BoundingBox;
                    boxTimestamps = [boxTimestamps, currentTime]; % Save timestamp
                    boxHandles = [boxHandles, rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2)];
                    faultDetected = true;
                end

                % Send Data to Server
                frameBase64 = matlab.net.base64encode(im2uint8(refinedHeatmap));
                data = struct('frame', frameBase64, 'maxTemp', max(refinedHeatmap(:)));
                try
                    response = webwrite(serverURL, data);
                    disp('Data sent successfully');
                catch ME
                    disp(['Failed to send data: ', ME.message]);
                end

                % Send Website Notification if fault is detected
                if faultDetected
                    notificationData = struct('message', 'High temperature detected!', 'temperature', max(refinedHeatmap(:)));
                    try
                        webwrite([serverURL '/notify'], notificationData);
                        disp(' Website Notification Sent!');
                    catch ME
                        disp(['Failed to send notification: ', ME.message]);
                    end

                    % Send Email Alert if cooldown time has passed
                    if (currentTime - emailSentTime > emailCooldown)
                        sendmail('recipient_email@example.com', '⚠ Fault Detected! HIGH TEMPERATURE', ...
                            ['High-temperature hotspot detected. Maximum temperature: ', num2str(max(refinedHeatmap(:))), '°C']);
                        disp(" Email Alert Sent!");
                        emailSentTime = currentTime;  % Update last sent time
                    end
                end

                % Frame rate delay
                pause(frameDelay);
            else
                disp("Skipping frame: Incorrect data size.");
            end
        end
    catch ME
        warning("Error: " + ME.message);
        break;
    end
end

clear tcpObj;