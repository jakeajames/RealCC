@interface CCUIRoundButton : UIControl
@end

@interface CCUILabeledRoundButton : UIView
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic,retain) CCUIRoundButton *buttonView;
@end

@interface SBWiFiManager
- (id)sharedInstance;
- (void)setWiFiEnabled:(BOOL)enabled;
- (bool)wiFiEnabled;
@end

@interface BluetoothManager
- (id)sharedInstance;
- (void)setEnabled:(BOOL)enabled;
- (bool)enabled;
- (void)setPowered:(BOOL)powered;
- (bool)powered;
@end

static BOOL BTenabbled;

%hook CCUILabeledRoundButton
- (void)buttonTapped:(id)arg1
{
    %orig;
    
    if ([self.title isEqualToString:[[NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle"] localizedStringForKey:@"CONTROL_CENTER_STATUS_WIFI_NAME" value:@"CONTROL_CENTER_STATUS_WIFI_NAME" table:@"Localizable"]] || [self.title isEqualToString:[[NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle"] localizedStringForKey:@"CONTROL_CENTER_STATUS_WLAN_NAME" value:@"CONTROL_CENTER_STATUS_WLAN_NAME" table:@"Localizable"]]) {
        
        SBWiFiManager *wiFiManager = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
        BOOL enabled = [wiFiManager wiFiEnabled];
        
        if (enabled) {
            [wiFiManager setWiFiEnabled:NO];
        }
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(wifiLongPressGesture:)];
        
        longPressGesture.minimumPressDuration = 0.5f;
        
        [self.buttonView addGestureRecognizer:longPressGesture];
    }
    
    if ([self.title isEqualToString:[[NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle"] localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_NAME" value:@"CONTROL_CENTER_STATUS_BLUETOOTH_NAME" table:@"Localizable"]]) {
        
        BluetoothManager *btoothManager = (BluetoothManager *)[%c(BluetoothManager) sharedInstance];
        BOOL enabled = [btoothManager enabled];
        
        if (enabled) {
            [btoothManager setEnabled:NO];
            [btoothManager setPowered:NO];
            
            BTenabbled = !enabled ;
        }
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(btLongPressGesture:)];
        
        longPressGesture.minimumPressDuration = 0.5f;
        
        [self.buttonView addGestureRecognizer:longPressGesture];
        
        if(!enabled) BTenabbled = YES;
    }
}

%new
- (void)wifiLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}

%new
- (void)btLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
}

%end

%hook BluetoothManager

- (BOOL)setEnabled:(BOOL)arg1 {
    return %orig(BTenabbled);
}

- (BOOL)setPowered:(BOOL)arg1{
    return %orig(BTenabbled);
}

- (BOOL)enabled {
    BTenabbled = !%orig;
    return %orig;
}
%end
