//
//  NewNoteViewController.h
//  NoteBook
//
//  Created by hyb on 14/12/20.
//  Copyright (c) 2014年 hyb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *noteContentTextView;

- (IBAction)saveNote:(id)sender;

@end
