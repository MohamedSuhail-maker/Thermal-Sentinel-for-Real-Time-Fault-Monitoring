#include <WiFi.h>
#include <WiFiClient.h>
#include <Adafruit_AMG88xx.h>

// WiFi credentials
const char* ssid = "Galaxy";          // Replace with your WiFi SSID
const char* password = "0123";  // Replace with your WiFi password

// TCP Server Setup
WiFiServer server(1234);  // Listening on port 1234
WiFiClient client;

// AMG8833 Sensor
Adafruit_AMG88xx amg;

void setup() {
    Serial.begin(115200);
    
    // Connect to WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
    }
    Serial.println("\nWiFi connected!");
    Serial.print("ESP32 IP: ");
    Serial.println(WiFi.localIP());  // Print IP for MATLAB connection

    // Start TCP server-
    server.begin();
    Serial.println("TCP Server Started...");

    // Initialize AMG8833
    if (!amg.begin()) {
        Serial.println("AMG8833 not detected. Check wiring!");
        while (1);
    }
}

void loop() {
    client = server.available();  // Check for new clients
    if (client) {
        Serial.println("Client Connected!");
        while (client.connected()) {
            float pixels[64];
            amg.readPixels(pixels);  // Read thermal data

            // Format data as comma-separated values
            String data = "";
            for (int i = 0; i < 64; i++) {
                data += String(pixels[i], 1);  // Convert to 1 decimal place
                if (i < 63) data += ",";
            }

            client.println(data);  // Send data to MATLAB
            Serial.println(data);  // Debug print

            delay(100);  // Adjust delay for smoother streaming
        }
        client.stop();
        Serial.println("Client Disconnected!");
    }
}

