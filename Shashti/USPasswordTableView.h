//
//  USPasswordTableView.h
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "USPassword.h"

@interface USPasswordTableView : NSTableView
@property (assign) IBOutlet NSArrayController *myArrayController;

-(IBAction)copy:(id)sender;
@end
