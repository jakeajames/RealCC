// States
// Unavailable = 0,
// PowerOff = 1,
// Disconnected = 2,
// Associated / Connected = 3,
// PowerOn / Busy = 4

void toggle(completion) {
    if (airplaneMode) {
        if (currentState == 1) {
            bluetooth.setPowered(1);
            nextState = 3;
        } else {
            bluetooth.setPowered(0);
            nextState = 1;
        }
    } else {
        switch (currentState) {
            case 0:
                complain();
                break;
            case 1:
                bluetooth.setPowered(1);
                nextState = 3;
                break;
            case 2:
                bluetooth.setBlacklistEnabled(0);
                nextState = 3;
                break;
            case 3:
                bluetooth.setBlacklistEnabled(1);
                bluetooth.disconnectPhysicalLinks();
                nextState = 2; // it should be nextState = 1 plus bluetooth.setPowered(0);
                break;
            default:
                break;
        }
    }
    state = nextState;
    if (completion)
        completion();
}