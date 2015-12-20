#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#define USE_SERIAL Serial

#define BUTTON_PIN 0

void setup( )
{
    WiFi.mode( WIFI_STA );
    USE_SERIAL.begin( 115200 );
    delay( 10 );


    WiFi.begin( "PhotoBooth", "random321" );
    pinMode( BUTTON_PIN, INPUT );

    while( WiFi.status( ) != WL_CONNECTED )
    {
      delay(500);
      Serial.print( "." );
    }
  
    Serial.println( "" );
    Serial.println( "WiFi connected"  );  
    Serial.println( "IP address: " );
    Serial.println( WiFi.localIP( ) );
}

void loop()
{
    static unsigned long lastClick = 0;
    if( WiFi.status( ) == WL_CONNECTED )
    {
        if( !digitalRead( BUTTON_PIN ) && millis( ) > lastClick + 1000 )
        {
            USE_SERIAL.print( "[BUTTON] is down\n" );
            HTTPClient http;
    
            http.begin( "192.168.0.100", 4567, "/shoot" );
    
            int httpCode = http.GET( );
    
            if( httpCode )
                USE_SERIAL.printf( "[HTTP] GET... code: %d\n", httpCode );
            else
                USE_SERIAL.print( "[HTTP] GET... failed, no connection or no HTTP server\n" );
            
            lastClick = millis( );
        }
    }
    else
        USE_SERIAL.print( "[NOT CONNECTED]\n" );
}
