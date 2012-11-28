//
//  USAppDelegate.m
//  Shashti
//
//  Created by James Williams on 9/23/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import "USAppDelegate.h"

@implementation USAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    passwordQueue = dispatch_queue_create("com.ungroundedsoftware.shashti.passwordQueue", DISPATCH_QUEUE_SERIAL);
    passwords = [[NSMutableArray alloc] init];
    
    running = NO;
}

-(void)beginWait
{
    [self.progressIndicator setDoubleValue:0];
    [self.numberOfPasswords setEnabled:NO];
    [self.numberOfWordsPerPassword setEnabled:NO];
    [self.useAdditionalEntropy setEnabled:NO];
    [self.useTrueRandomness setEnabled:NO];
    [self.passwordView setEnabled:NO];
    [self.useSpacesBetweenWords setEnabled:NO];
    
    running = YES;
    [self.generateButton setTitle:@"Cancel"];
}

-(void)endWait
{
    [self.progressIndicator setDoubleValue:0];
    [self.numberOfPasswords setEnabled:YES];
    [self.numberOfWordsPerPassword setEnabled:YES];
    [self.useAdditionalEntropy setEnabled:YES];
    [self.useTrueRandomness setEnabled:YES];
    [self.passwordView setEnabled:YES];
    [self.useSpacesBetweenWords setEnabled:YES];
    
    running = NO;
    [self.generateButton setTitle:@"Generate"];
}

-(void)reportProgress:(NSUInteger)progress forGoal:(NSUInteger)goal
{
    [self.progressIndicator setMaxValue:goal];
    [self.progressIndicator setDoubleValue:progress];
}

-(void)cancelGenerate
{
    @synchronized(self)
    {
        shouldCancel = YES;
    }
}

-(void)doGenerate
{
    @synchronized(self)
    {
        shouldCancel = NO;
    }
    
    NSUInteger numberOfPasswords = self.numberOfPasswords.integerValue;
    NSUInteger wordsPerPassword = self.numberOfWordsPerPassword.integerValue;
    BOOL additionalEntropy = [self.useAdditionalEntropy state] == NSOnState;
    BOOL useTrueRandomness = [self.useTrueRandomness state] == NSOnState;
    BOOL addSpacesBetweenWords = [self.useSpacesBetweenWords state] == NSOnState;
    
    [self beginWait];
    [self reportProgress:0 forGoal:numberOfPasswords];
    
    [self.passwordsController removeObjects:[self.passwordsController arrangedObjects]];
    
    dispatch_async(passwordQueue, ^{
        dispatch_queue_t main = dispatch_get_main_queue();
        
        for(NSUInteger i = 0; i < numberOfPasswords; i++)
        {
            NSError *error = NULL;
            
            @synchronized(self)
            {
                if(shouldCancel)
                    break;
            }
            
            USPassword *p = [[USPassword alloc] initWithNumberOfWords:wordsPerPassword
                                                 andAdditionalEntropy:additionalEntropy
                                                   withTrueRandomness:useTrueRandomness
                                                                error:&error];

            if(error)
            {
                dispatch_sync(main, ^{
                    NSAlert *alert = [NSAlert alertWithError:error];
                    [alert beginSheetModalForWindow:self.window
                                      modalDelegate:self
                                     didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
                                        contextInfo:NULL];
                    
                    [self endWait];
                });
                
                break;
            }
            else
            {
                p.addSpacesBetweenWords = addSpacesBetweenWords;
                
                dispatch_sync(main, ^{
                    [self.passwordsController addObject:p];
                    [self reportProgress:i forGoal:numberOfPasswords];
                    
                });
            }
            //Make it take a while so it seems like it's accomplishing something. ;)
            [NSThread sleepForTimeInterval:.10];
        }
        
        dispatch_async(main, ^{
            [self endWait];
        });
    });
}

-(IBAction)addSpacesBetweenWordsCheckChanged:(id)sender
{
    BOOL addSpacesBetweenWords = [self.useSpacesBetweenWords state] == NSOnState;
 
    for(USPassword *p in passwords)
    {
        p.addSpacesBetweenWords = addSpacesBetweenWords;
    }
}

-(IBAction)generatePasswords:(id)sender
{
    if(running)
    {
        [self cancelGenerate];
    }
    else
    {
        [self doGenerate];
    }
}

-(IBAction)closeRandomOrgHelpWindow:(id)sender
{
    [NSApp endSheet:self.randomOrgHelpWindow returnCode:0];
}

-(void)didEndSheet:(NSWindow*)sheet returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if(sheet == self.randomOrgHelpWindow)
    {
        [self.randomOrgHelpWindow orderOut:self];
    }
    else if(sheet == self.aboutWindow)
    {
        [self.aboutWindow orderOut:self];
    }
}

-(IBAction)useTrueRandomnessCheckChanged:(id)sender
{
    if(self.useTrueRandomness.state == NSOnState)
    {
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"RandomOrgHelp" withExtension:@"html"];
        [[self.randomOrgHelpWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:path]];
        
        [NSApp beginSheet:self.randomOrgHelpWindow
           modalForWindow:self.window
            modalDelegate:self
           didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:NULL];
    }
}

-(void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSString *host = [[request URL] host];
    if (host) {
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    } else {
        [listener use];
    }
}

-(IBAction)about:(id)sender
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
    [[self.aboutWindowWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:path]];
    
    [NSApp beginSheet:self.aboutWindow
       modalForWindow:self.window
        modalDelegate:self
       didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
          contextInfo:NULL];
}

-(IBAction)closeAboutWindow:(id)sender
{
    [NSApp endSheet:self.aboutWindow returnCode:0];
}
@end
