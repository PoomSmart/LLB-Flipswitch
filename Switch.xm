#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "Common.h"

@interface LLBSwitch : NSObject <FSSwitchDataSource>
@end

@implementation LLBSwitch

static void createPlistIfNeeded()
{
	NSMutableDictionary *pref = [[NSDictionary dictionaryWithContentsOfFile:LLBiPT5_PREF_PATH] mutableCopy];
	if (pref == nil) {
		pref = [NSMutableDictionary dictionary];
		[pref setObject:@(YES) forKey:LLBiPT5_key];
		[pref writeToFile:LLBiPT5_PREF_PATH atomically:YES];
	}
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	NSNumber *n = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:LLBiPT5_key inDomain:LLBiPT5_ident];
	BOOL enabled = n ? [n boolValue] : YES;
	return enabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	[[NSUserDefaults standardUserDefaults] setObject:@(newState == FSSwitchStateOn) forKey:LLBiPT5_key inDomain:LLBiPT5_ident];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), LLBiPT5_PreferencesNotification, NULL, NULL, YES);
}

@end

static void PreferencesChanged()
{
	[[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:LLBiPT5_FS_ident];
}

__attribute__((constructor)) static void init()
{
	createPlistIfNeeded();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, LLBiPT5_PreferencesNotification, NULL, CFNotificationSuspensionBehaviorCoalesce);
}