int applicationDidFinishLaunching;

/**
 * Enable home gestures
 */
%hook BSPlatform
  - (NSInteger)homeButtonType {
    return 2;
  }
%end


/**
 *  Enable right status bar swipe down to show control center
 */
%hook _UIStatusBarVisualProvider_iOS
  + (Class)class {
    return NSClassFromString(@"_UIStatusBarVisualProvider_Split58"); 
  }
%end

%hook CCUIStatusBarStyleSnapshot
  // hide status bar snapshot in control center
  - (BOOL)isHidden {
    return YES;
  }
%end

%hook CCUIOverlayStatusBarPresentationProvider
  // hide status bar snapshot in control center
  - (void)_addHeaderContentTransformAnimationToBatch:(id)arg1 transitionState:(id)arg2 {
    return;
  }
%end

%hook CCUIModularControlCenterOverlayViewController
  // don't hide main status bar when showing control center
  - (void)setOverlayStatusBarHidden:(BOOL)arg1 {
    return;
  }
%end


/**
 * Hide home bar
 */
%hook SBDashBoardTeachableMomentsContainerView
  // Hide home bar on lock screen
  -(void)setHomeAffordanceContainerView:(UIView *)arg1{
    return;
  }
%end

%hook MTLumaDodgePillView
  // Hide home bar in applications
  - (id)initWithFrame:(struct CGRect)arg1 {
    return NULL;
  }
%end

/**
 * Hide Camera and Flashlight Button on Coversheet
 */
%hook SBDashBoardQuickActionsViewController  
  - (BOOL)hasFlashlight{
    return NO;
  }

  - (BOOL)hasCamera{
    return NO;
  }
%end


/**
 * Hide unlock hints (swipe up to unlock text)
 */
%hook SBDashBoardTeachableMomentsContainerViewController
- (void)_updateTextLabel {
  return;
}
%end

/**
 * Restore home button to invoke Siri (and screenshot capture)
 */
%hook SBLockHardwareButtonActions
  - (id)initWithHomeButtonType:(long long)arg1 proximitySensorManager:(id)arg2 {
    return %orig(1, arg2);
  }
%end

%hook SBHomeHardwareButtonActions
  - (id)initWitHomeButtonType:(long long)arg1 {
    return %orig(1);
  }
%end

%hook SpringBoard
  - (void)applicationDidFinishLaunching:(id)application {
    applicationDidFinishLaunching = 2;
    %orig;
  }
%end

%hook SBPressGestureRecognizer
  - (void)setAllowedPressTypes:(NSArray *)arg1 {
    NSArray * lockHome = @[@104, @101];
    NSArray * lockVol = @[@104, @102, @103];
    if ([arg1 isEqual:lockVol] && applicationDidFinishLaunching == 2) {
      %orig(lockHome);
      applicationDidFinishLaunching--;
      return;
    }
    %orig;
  }
%end

%hook SBClickGestureRecognizer
  - (void)addShortcutWithPressTypes:(id)arg1 {
    if (applicationDidFinishLaunching == 1) {
      applicationDidFinishLaunching--;
      return;
    }
    %orig;
  }
%end

%hook SBHomeHardwareButton
  - (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 buttonActions:(id)arg3 gestureRecognizerConfiguration:(id)arg4 {
    return %orig(arg1, 1, arg3, arg4);
  }
  - (id)initWithScreenshotGestureRecognizer:(id)arg1 homeButtonType:(long long)arg2 {
    return %orig(arg1, 1);
  }
%end

%hook SBLockHardwareButton
  - (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 proximitySensorManager:(id)arg3 homeHardwareButton:(id)arg4 volumeHardwareButton:(id)arg5 buttonActions:(id)arg6 homeButtonType:(long long)arg7 createGestures:(BOOL)arg8 {
    return %orig(arg1, arg2, arg3, arg4, arg5, arg6, 1, arg8);
  }

  - (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 proximitySensorManager:(id)arg3 homeHardwareButton:(id)arg4 volumeHardwareButton:(id)arg5 homeButtonType:(long long)arg6 {
    return %orig(arg1, arg2, arg3, arg4, arg5, 1);
  }
%end

%hook SBVolumeHardwareButton
  - (id)initWithScreenshotGestureRecognizer:(id)arg1 shutdownGestureRecognizer:(id)arg2 homeButtonType:(long long)arg3 {
    return %orig(arg1, arg2, 1);
  }
%end
