//
//  ViewController.m
//  DWTagList
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didSelectTag:(NSString *)tagName
{
    NSLog(@"didSelectTag: %@", tagName);
    NSLog(@"\n\nselectedTags: %@", [tagList selectedTags]);
}

- (void)didDeselectTag:(NSString *)tagName
{
    NSLog(@"didDeselectTag: %@", tagName);
    NSLog(@"\n\nselectedTags: %@", [tagList selectedTags]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tagList = [[DWTagList alloc] initWithFrame:CGRectMake(20.0f, 70.0f, 180.0f, 50.0f)];
    [tagList setAutomaticResize:NO];
    NSArray *array = [[NSArray alloc] initWithObjects:@"Foo", @"Tag Label 1", @"Tag Label 2", @"Tag Label 3", @"Tag Label 4", @"Long long long long long long Tag", nil];
    [tagList setTags:array];
    [tagList setTagDelegate:self];
    [self.view addSubview:tagList];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
