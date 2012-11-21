//
//  USPasswordTableView.m
//  Shashti
//
//  Created by James Williams on 11/20/12.
//  Copyright (c) 2012 James Williams. All rights reserved.
//

#import "USPasswordTableView.h"

@implementation USPasswordTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

-(IBAction)copy:(id)sender
{
    if(self.myArrayController.selectedObjects.count > 0)
    {
        USPassword *p = [self.myArrayController.selectedObjects objectAtIndex:0];
     
        NSPasteboard *pb = [NSPasteboard generalPasteboard];
        [pb clearContents];
        [pb writeObjects:@[p.stringValue]];
    }
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    //This should only be the copy menu, I think
    return self.myArrayController.selectedObjects.count > 0;
}
@end
