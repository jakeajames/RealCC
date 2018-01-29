@interface CCUILabeledRoundButton
@property (nonatomic, copy, readwrite) NSString *title;
@end

@interface SBWiFiManager
-(id)sharedInstance;
-(void)setWiFiEnabled:(BOOL)enabled;
-(bool)wiFiEnabled;
@end

@interface BluetoothManager
-(id)sharedInstance;
-(void)setEnabled:(BOOL)enabled;
-(bool)enabled;

-(void)setPowered:(BOOL)powered;
-(bool)powered;

@end

static BOOL BTenabbled;


%hook CCUILabeledRoundButton
-(void)buttonTapped:(id)arg1 {

%orig;

if ([self.title isEqualToString:[[NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle"] localizedStringForKey:@"CONTROL_CENTER_STATUS_WLAN_NAME" value:@"CONTROL_CENTER_STATUS_WIFI_NAME" table:@"Localizable"]]) {
SBWiFiManager *wiFiManager = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
    BOOL enabled = [wiFiManager wiFiEnabled];

    if(enabled) {
        [wiFiManager setWiFiEnabled:NO];
    }
}

if ([self.title isEqualToString:[[NSBundle bundleWithPath:@"/System/Library/ControlCenter/Bundles/ConnectivityModule.bundle"] localizedStringForKey:@"CONTROL_CENTER_STATUS_BLUETOOTH_NAME" value:@"CONTROL_CENTER_STATUS_BLUETOOTH_NAME" table:@"Localizable"]]) {
    BluetoothManager *btoothManager = (BluetoothManager *)[%c(BluetoothManager) sharedInstance];
    BOOL enabled = [btoothManager enabled];

    if(enabled) {
        [btoothManager setEnabled:NO];
        [btoothManager setPowered:NO];

        BTenabbled = !enabled ;
    }

    if(!enabled) BTenabbled = YES;
  }
}

%end

%hook BluetoothManager


- (BOOL)setEnabled:(BOOL)arg1 {
   return %orig(BTenabbled);
}

- (BOOL)setPowered:(BOOL)arg1{
    return %orig(BTenabbled);
}

-(BOOL)enabled {
    BTenabbled = !%orig;
    return %orig;
}
%end
