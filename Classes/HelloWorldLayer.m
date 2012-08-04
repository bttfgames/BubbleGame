//
//  HelloWorldLayer.m
//  HelloCocos2D
//
//  Created by pucpr on 02/06/12.
//  Copyright PUCPR 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(245, 188, 211, 255)])) {
		gameOver = NO;
		window_size = [[CCDirector sharedDirector] winSize];
		
		[self schedule:@selector(updateEnemies:) interval:0.5];

		
		self.isTouchEnabled = YES;
		
		horde = [[NSMutableArray alloc] init];
		//carrega som
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.wav"];
        
        
		//score
		int margin = 10;
		score = 0;
		label = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana" fontSize:30.0f];
		label.anchorPoint = ccp(1, 0);
		label.position = ccp(margin + 160, margin + 7);
		label.color = ccc3(0, 0, 0);
		
		//timer
		timer = 60.0f;
		timerLabel = [CCLabelTTF labelWithString:@"60.0" fontName:@"Verdana" fontSize:25.0f];
		timerLabel.position = ccp(window_size.width/2 + 40, window_size.height - 27);
		timerLabel.color = ccc3(0, 0, 0);
		
        //sprites
        background = [CCSprite spriteWithFile:@"back.png"];
        back1 = [CCSprite spriteWithFile:@"bubbles.png"];
        back2 = [CCSprite spriteWithFile:@"bubbles.png"];
        background.position = ccp(window_size.width/2,window_size.height/2);
        back1.position = ccp(window_size.width/2,window_size.height/2);
        back2.position = ccp(window_size.width+ back1.position.x,window_size.height/2);
        
        [self addChild:background];
        [self addChild:back1];
        [self addChild:back2];
        
        
        
        
		
		[self addChild:label];
		[self addChild:timerLabel];
		
        
        [self schedule:@selector(updateBackground:) interval:1/60.0f];
		[self schedule:@selector(update:) interval:1.0];

	}
	return self;
}


-(void) createExplosion: (float) x y: (float) y{
    CCParticleSystemQuad *myEmitter;
    
    NSLog(@"entrou explosao");
    myEmitter = [[CCParticleSystemQuad alloc] initWithTotalParticles:20];
    myEmitter.emitterMode = kCCParticleModeGravity;

    myEmitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"explosion.png"];
    myEmitter.position = ccp(x,y);
    
    myEmitter.life =1.0;
    myEmitter.duration = 1.0;
    myEmitter.scale = 0.5;
    myEmitter.speed = 100;
    myEmitter.gravity = ccp(x,y);
    [self addChild: myEmitter];
    //For not showing color
    //myEmitter.blendAdditive = NO;
    myEmitter.autoRemoveOnFinish = YES;

}


- (void) updateBackground:(ccTime) deltaT{
    float vel = 4.0f;
    window_size = [[CCDirector sharedDirector] winSize];
    back1.position = ccp(back1.position.x - vel, back1.position.y);
    back2.position = ccp(back2.position.x - vel , back2.position.y);
    
    if (back1.position.x < -window_size.width/2){
        back1.position = ccp(back1.position.x + window_size.width * 2,window_size.height/2);
    }
    
    if (back2.position.x < -window_size.width/2){
        back2.position = ccp(back2.position.x + window_size.width * 2,window_size.height/2);
    }
    
}


- (void) checkCollision:(CGPoint) pos{
	
	//checar colisao
	
	
	NSMutableArray *deleted = [[NSMutableArray alloc] init];
	CGRect player_rect = CGRectMake(pos.x, pos.y, 8, 8);
	for (CCSprite *obj in horde){
		CGRect orect = CGRectMake(obj.position.x, obj.position.y, obj.contentSize.width, obj.contentSize.height);
		if (CGRectIntersectsRect(player_rect, orect)){
            //[self createExplosion:obj.position.x y:obj.position.y];
            //toca som
            [[SimpleAudioEngine sharedEngine] playEffect:@"hit.wav"]; //play a sound
            [[SimpleAudioEngine sharedEngine] stopEffect:0];
            
			//score
			score+= 10;
			[label setString:[NSString stringWithFormat:@"%d", score]];
			[deleted addObject: obj];
		}
	}
	
	
	//destroi elementos
	for (CCSprite *obj in deleted){
		[horde removeObject:obj];
		[self removeChild:obj cleanup:YES];
	}
	
	[deleted release];	
	
}


- (void) ccTouchesEnded: (NSSet *)touches withEvent:(UIEvent*) event{
	UITouch *touch = [touches anyObject];
	
	CGPoint pos = [touch locationInView:[touch view]];
	
	pos = [[CCDirector sharedDirector] convertToGL:pos];
	if (timer != 0){
		[self checkCollision:pos];
	}

}


-(void)resizeSprite:(CCSprite*)sprite toWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}


- (void) enemies {
	CCSprite *bug = [CCSprite spriteWithFile:@"bubble.png"
										rect:CGRectMake(0, 0, 150, 150)];
	
	float randSize = (float)(arc4random() % 150) + 1; 
	
	[self resizeSprite:bug toWidth:randSize toHeight:randSize];
	
	int y = (arc4random() % (int) (window_size.height-bug.contentSize.height)) + (int)bug.contentSize.height/2;
	//int y = (arc4random() % (int) (tam_janela.height-inimigo.contentSize.height))+inimigo.contentSize.height/2;
	
	bug.position = ccp(window_size.width + bug.contentSize.width,y);
	[self addChild:bug];
	int time = (arc4random() % 2) + 1;
	
	id move = [CCMoveTo actionWithDuration:time position:ccp(-bug.contentSize.width,y)  ];
	id end_move = [CCCallFuncN actionWithTarget:self selector:@selector(destroy:)];
	[bug runAction:[CCSequence actions:move,end_move,nil]];
	
	
	[horde addObject:bug];
}


- (void) updateEnemies:(ccTime) deltat {
	[self enemies];
	if (timer == 0){
		[self removeChild:label cleanup:YES];
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CCLabelTTF *goLabel = [CCLabelTTF labelWithString:@"" fontName:@"Verdana" fontSize:20.0];
		goLabel.position = ccp(winSize.width/2, winSize.height/2);
		goLabel.scale = 0.1;
		[goLabel setString:[NSString stringWithFormat:@"Parabéns, seu score foi %d",score]];
		[self addChild:goLabel z:10];                
		[goLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
		//[self removeChild:goLabel cleanup:YES];
		//[[CCDirector sharedDirector] pause ];
	}
}


-(void) update:(ccTime)deltat{	
	timer--;
	if (timer <= 0) {
		timer = 0;
	}
	[timerLabel setString:[NSString stringWithFormat:@"%5.1f",timer]];
}







- (void) destroy:(id) sender{
	CCSprite *sprite = (CCSprite*) sender;
	[horde removeObject: sprite];
	[self removeChild:sprite cleanup:YES];
	
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[horde release];
	horde = nil;
    
    [[SimpleAudioEngine sharedEngine] dealloc];
    
	// don't forget to call "super dealloc"
	[super dealloc];
	
}
@end
