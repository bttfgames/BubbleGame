//
//  HelloCocos2DAppDelegate.h
//  HelloCocos2D
//
//  Created by pucpr on 02/06/12.
//  Copyright PUCPR 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface HelloCocos2DAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
