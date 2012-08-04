//
//  HelloWorldLayer.h
//  HelloCocos2D
//
//  Created by pucpr on 02/06/12.
//  Copyright PUCPR 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor {
	CGSize window_size;
	NSMutableArray *horde;
	
	CCLabelTTF *label;
	CCLabelTTF *timerLabel;
	int score;
	float timer;
	BOOL gameOver;
    
    //sprites
    CCSprite *background;
    CCSprite *back1;
    CCSprite *back2;
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;




@end
