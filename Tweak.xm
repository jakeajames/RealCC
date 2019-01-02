@interface BluetoothManager : NSObject
@end

@interface BluetoothManager (Addition)
@property(assign) BOOL ignoreAirplaneModeCheck;
@end

// By default, when we turn bluetooth off: 3 -> 2
// What we want: 3 -> 1 and power off bluetooth
// By ensuring airplane mode turned on, we already satisfy the requirement above so...

%hook BluetoothManager

%property(assign) BOOL ignoreAirplaneModeCheck;

- (void)_updateAirplaneModeStatus {
    if (self.ignoreAirplaneModeCheck)
        return;
    %orig;
}

- (void)bluetoothStateActionWithCompletion:(void *)completion {
    bool airplaneMode = MSHookIvar<bool>(self, "_airplaneMode");
    MSHookIvar<bool>(self, "_airplaneMode") = YES;
    self.ignoreAirplaneModeCheck = YES;
    %orig;
    MSHookIvar<bool>(self, "_airplaneMode") = airplaneMode;
    self.ignoreAirplaneModeCheck = NO;
}

%end

@interface WFWiFiStateMonitor : NSObject
@end

@interface WFControlCenterStateMonitor : WFWiFiStateMonitor
@end

@interface WFControlCenterStateMonitor (Addition)
@property(assign) BOOL forceAirplaneMode;
@end

// For Wi-Fi though, WiFiKit.framework isn't available in x86_64 so it's a bit difficult to know what's going on as we toggle it.
// However, using the same trick as we did for bluetooth seems to also work here.

%hook WFControlCenterStateMonitor

%property(assign) BOOL forceAirplaneMode;

- (BOOL)_airplaneModeEnabled {
    return self.forceAirplaneMode ? YES : %orig;
}

- (void)performAction:(void *)completion {
    self.forceAirplaneMode = YES; // Do we always force airplane mode?
    %orig;
    self.forceAirplaneMode = NO;
}

%end

%ctor {
    dlopen("/System/Library/PrivateFrameworks/BluetoothManager.framework/BluetoothManager", RTLD_LAZY);
    dlopen("/System/Library/PrivateFrameworks/WiFiKit.framework/WiFiKit", RTLD_LAZY);
    %init;
}