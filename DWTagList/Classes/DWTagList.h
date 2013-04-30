//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWTagListDelegate <NSObject>

@required

- (void)didSelectTag:(NSString *)tagName;
- (void)didDeselectTag:(NSString *)tagName;

@end

@interface DWTagList : UIScrollView
{
    CGSize sizeFit;
}

@property (nonatomic, strong) id<DWTagListDelegate> tagDelegate;
@property (nonatomic) BOOL automaticResize;

- (void)setTags:(NSArray *)array;

- (void)setSelectedTags:(NSArray *)array;
- (NSArray *)selectedTags;

- (void)display;
- (CGSize)fittedSize;

@end
