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

static BOOL BTenabbled= NO;


%hook CCUILabeledRoundButton
-(void)buttonTapped:(id)arg1 {

%orig;

if ([self.title isEqualToString:@"Wi-Fi"]) {
SBWiFiManager *wiFiManager = (SBWiFiManager *)[%c(SBWiFiManager) sharedInstance];
    BOOL enabled = [wiFiManager wiFiEnabled];

    if(enabled) {
        [wiFiManager setWiFiEnabled:NO];
    }
}




if ([self.title isEqualToString:@"Bluetooth"]) {


	BluetoothManager *btoothManager = (BluetoothManager *)[%c(BluetoothManager) sharedInstance];
    BOOL enabled = [btoothManager enabled];

    if(enabled) {
        [btoothManager setEnabled:NO];
        [btoothManager setPowered:NO];

        BTenabbled = !enabled ;
    }

    if(!enabled) {

    	BTenabbled = !enabled ;
    }


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



%end
