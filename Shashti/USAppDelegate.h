//
//  USAppDelegate.h
//  Shashti
//
//  Created by James Williams on 9/23/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "USRandom.h"
#import "USPassword.h"


@interface USAppDelegate : NSObject <NSApplicationDelegate>
{
    dispatch_queue_t passwordQueue;
    
    NSMutableArray *passwords;
    BOOL running;
    BOOL shouldCancel;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *label;

@property (assign) IBOutlet NSButton *generateButton;

@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSTextField *numberOfPasswords;
@property (assign) IBOutlet NSTextField *numberOfWordsPerPassword;
@property (assign) IBOutlet NSButton *useAdditionalEntropy;

@property (assign) IBOutlet NSButton *useTrueRandomness;

@property (assign) IBOutlet NSButton *useSpacesBetweenWords;

@property (assign) IBOutlet NSTableView *passwordView;
@property (assign) IBOutlet NSArrayController *passwordsController;

@property (assign) IBOutlet NSWindow *randomOrgHelpWindow;
@property (assign) IBOutlet WebView *randomOrgHelpWebView;

@property (assign) IBOutlet NSWindow *aboutWindow;
@property (assign) IBOutlet WebView *aboutWindowWebView;

-(IBAction)addSpacesBetweenWordsCheckChanged:(id)sender;

-(IBAction)generatePasswords:(id)sender;
-(IBAction)useTrueRandomnessCheckChanged:(id)sender;
-(IBAction)closeRandomOrgHelpWindow:(id)sender;

-(IBAction)about:(id)sender;
-(IBAction)closeAboutWindow:(id)sender;
@end
