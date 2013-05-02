//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS                7.0f
#define LABEL_MARGIN                 5.0f
#define BOTTOM_MARGIN                5.0f
#define FONT_SIZE                    15.0f
#define HORIZONTAL_PADDING           7.0f
#define VERTICAL_PADDING             7.0f

#define BACKGROUND_COLOR_SELECTED    [UIColor colorWithRed:209.0 / 255.0 green:59.0 / 255.0 blue:66.0 / 255.0 alpha:1.00]
#define TEXT_COLOR_SELECTED          [UIColor whiteColor]
#define TEXT_SHADOW_COLOR_SELECTED   [UIColor blackColor]
#define BORDER_COLOR_SELECTED        [UIColor colorWithRed:189.0 / 255.0 green:29.0 / 255.0 blue:46.0 / 255.0 alpha:1.00].CGColor

#define BACKGROUND_COLOR             [UIColor lightGrayColor]
#define TEXT_COLOR                   [UIColor blackColor]
#define TEXT_SHADOW_COLOR            [UIColor whiteColor]
#define BORDER_COLOR                 [UIColor grayColor].CGColor

#define TEXT_SHADOW_OFFSET           CGSizeMake(0.0f, 1.0f)
#define BORDER_WIDTH                 1.0f
#define HIGHLIGHTED_BACKGROUND_COLOR [UIColor colorWithRed:209.0 / 255.0 green:59.0 / 255.0 blue:66.0 / 255.0 alpha:1.00]
#define DEFAULT_AUTOMATIC_RESIZE     NO

#pragma mark - Array additions

@implementation NSMutableArray (Additions)

- (BOOL)hasTag:(NSString *)string
{
    for (NSString *str in self)
    {
        if ([str isEqualToString:string])
        {
            return true;
        }
    }

    return false;
}

- (BOOL)removeTag:(NSString *)string
{
    for (NSString *str in self)
    {
        if ([str isEqualToString:string])
        {
            [self removeObject:str];

            return true;
        }
    }

    return false;
}

@end

#pragma mark - Private methods

@interface DWTagList ()

- (void)touchedTag:(id)sender;

@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSMutableArray *selectedTagsArray;

@end

#pragma mark - Implementation

@implementation DWTagList

#pragma mark - Actions

- (void)setTags:(NSArray *)array
{
    self.tagsArray = [array copy];

    [self display];

    if (_automaticResize)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeFit.width, sizeFit.height);
    }
}

- (void)setSelectedTags:(NSArray *)array
{
    self.selectedTagsArray = [array mutableCopy];

    [self display];

    if (_automaticResize)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeFit.width, sizeFit.height);
    }
}

- (NSArray *)selectedTags
{
    return self.selectedTagsArray;
}

- (void)touchedTag:(id)sender
{
    UITapGestureRecognizer *tagGesture = (UITapGestureRecognizer *)sender;
    
    UILabel *label = (UILabel *)tagGesture.view;
    
    if (_selectedTagsArray == nil)
    {
        self.selectedTagsArray = NSMutableArray.new;
    }

    if ([_selectedTagsArray hasTag:label.text])
    {
        [_selectedTagsArray removeTag:label.text];

        if (label && self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(didDeselectTag:)])
        {
            [self.tagDelegate didDeselectTag:label.text];
        }
    }
    else
    {
        [_selectedTagsArray addObject:label.text];
        
        if (label && self.tagDelegate && [self.tagDelegate respondsToSelector:@selector(didSelectTag:)])
        {
            [self.tagDelegate didSelectTag:label.text];
        }
    }
        
    [self display];
}

#pragma mark - View actions

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self display];
}

- (void)display
{
    for (UILabel *subview in [self subviews])
    {
        [subview removeFromSuperview];
    }

    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;

    for (NSString *text in _tagsArray)
    {
        UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
        CGSize size = CGSizeMake(self.frame.size.width, FONT_SIZE);
        CGSize textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
        textSize.width += HORIZONTAL_PADDING * 2;
        textSize.height += VERTICAL_PADDING * 2;
        UILabel *label = nil;

        if (!gotPreviousFrame)
        {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        }
        else
        {
            CGRect newRect = CGRectZero;

            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width)
            {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            }
            else
            {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }

            newRect.size = textSize;
            label = [[UILabel alloc] initWithFrame:newRect];
        }

        previousFrame = label.frame;
        gotPreviousFrame = YES;
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];

        [label setBackgroundColor:BACKGROUND_COLOR];

        CGRect lRect = label.frame;
        lRect.size.width = MIN(label.frame.size.width, self.frame.size.width);
        
        [label setFrame:lRect];
        [label setText:text];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderWidth:BORDER_WIDTH];

        if ([_selectedTagsArray hasTag:text])
        {
            [label setTextColor:TEXT_COLOR_SELECTED];
            [label setShadowColor:TEXT_SHADOW_COLOR_SELECTED];
            [label setBackgroundColor:BACKGROUND_COLOR_SELECTED];
            [label.layer setBorderColor:BORDER_COLOR_SELECTED];
        }
        else
        {
            [label setTextColor:TEXT_COLOR];
            [label setShadowColor:TEXT_SHADOW_COLOR];
            [label setBackgroundColor:BACKGROUND_COLOR];
            [label.layer setBorderColor:BORDER_COLOR];
        }

        if (self.tagDelegate)
        {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedTag:)];
            [label setUserInteractionEnabled:YES];
            [label addGestureRecognizer:gesture];
        }

        [self addSubview:label];
    }

    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
    
    self.contentSize = sizeFit;
}

- (CGSize)fittedSize
{
    return sizeFit;
}

@end
