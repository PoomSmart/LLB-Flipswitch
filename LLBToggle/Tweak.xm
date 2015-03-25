#import "../Common.h"

static BOOL LLB()
{
	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:LLBiPT5_PREF_PATH];
	CFPreferencesAppSynchronize(LLBiPT5_ident);
	BOOL enabled = prefs[@"LLB"] ? [prefs[@"LLB"] boolValue] : YES;
	return enabled;
}

%group Group1

%hook AVCaptureDevice

- (BOOL)automaticallyEnablesLowLightBoostWhenAvailable
{
	return LLB();
}

- (BOOL)isLowLightBoostSupported
{
	return LLB();
}

%end

%hook AVCaptureDeviceFormat

- (BOOL)supportsLowLightBoost
{
	return LLB();
}

%end

%hook AVCaptureFigVideoDevice

- (BOOL)isLowLightBoostSupported
{
	return LLB();
}

%end

%end

%group Group2

%hook AVCaptureDeviceFormat_FigRecorder

- (BOOL)supportsLowLightBoost
{
	return LLB();
}

%end

%hook AVCaptureFigVideoDevice_FigRecorder

- (BOOL)isLowLightBoostSupported
{
	return LLB();
}

%end

%hook FigCaptureSourceFormat

- (BOOL)isVideoLowLightBinningSwitchSupported
{
	return LLB();
}

%end

%end

%ctor
{
	if (isiOS8Up) {
		%init(Group2);
	}
	%init(Group1);
}
