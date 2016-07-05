#import "KeyboardInputMode.h"
#import <Cordova/CDVAvailability.h>

@implementation KeyboardInputMode

- (void)pluginInitialize {
    __weak KeyboardInputMode* weakSelf = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:UITextInputCurrentInputModeDidChangeNotification
        object:nil
        queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification *notification) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.commandDelegate evalJs:[NSString stringWithFormat:@"cordova.fireWindowEvent('native.keyboardInputModeChanged', { 'inputMode': '%@' }); ", [[[[UITextInputMode activeInputModes] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDisplayed = YES"]] lastObject] valueForKey:@"displayName"]]];
            });
        }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}

@end
