typedef NS_ENUM (NSUInteger, BluetoothState) {
    BluetoothStateUnavailable = 0,
    BluetoothStatePowerOff = 1,
    BluetoothStateDisconnected = 2,
    BluetoothStateAssociated = 3, // Connected
    BluetoothStatePowerOn = 4 // Busy
};

typedef NS_ENUM (NSInteger, WiFiState) {
    WiFiStateUnavailable = 0,
    WiFiStatePowerOff = 1,
    WiFiStateUserDisconnected = 2,
    WiFiStatePowerOn = 3,
    WiFiStateAssociated = 4,
    WiFiStateInternetSharing = 5
};