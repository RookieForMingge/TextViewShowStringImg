//
//  ViewController.m
//  TextViewShowStringImg
//
//  Created by Hosel on 2017/11/30.
//  Copyright © 2017年 Hosel. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height

@interface ViewController()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITextView *contentTV;//内容
@property(nonatomic,strong)UIImage *pictureImg;//图片

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UITextView显示文字图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _contentTV= [[UITextView alloc]init];
    _contentTV.delegate = self;
    _contentTV.alpha = 0.8;
    _contentTV.text = @"下面还可以继续添加图片哦！";
    _contentTV.font = [UIFont systemFontOfSize:14];
    _contentTV.scrollEnabled = NO;
    _contentTV.textAlignment = NSTextAlignmentLeft;
    _contentTV.layoutManager.allowsNonContiguousLayout = NO;
    _contentTV.backgroundColor = [UIColor lightGrayColor];
    _contentTV.frame = CGRectMake(0, 64, ScreenWidth, Screenheight);
    [self.view addSubview:_contentTV];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)add{
    [self addPicture];
}

//选择图片
- (void)addPicture{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:@"添加图片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *phone = [UIAlertAction actionWithTitle:@"手机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImage:UIImagePickerControllerSourceTypeCamera andPrompt:@"相机"];
    }];
    UIAlertAction *systemAlbum = [UIAlertAction actionWithTitle:@"从系统相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImage:UIImagePickerControllerSourceTypePhotoLibrary andPrompt:@"相册"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertVc addAction:phone];
    [alertVc addAction:systemAlbum];
    [alertVc addAction:cancelAction];
    //如果是二次弹窗用这个不会警告
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:alertVc animated:YES completion:^{
    }];
}

- (void)selectImage:(UIImagePickerControllerSourceType )type andPrompt:(NSString *) prompt{
    if([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *pickerVc = [[UIImagePickerController alloc]init];
        pickerVc.delegate = self;
        pickerVc.allowsEditing = YES;
        pickerVc.sourceType = type;
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:pickerVc animated:YES completion:^{
        }];
    }else{
        NSString *str = [NSString stringWithFormat:@"请在iPhone的\"设置->隐私->%@\"选项中,允许\"xxxxx\"访问您的%@.",prompt,prompt];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"权限受限" message:str delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获得需要展示的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image ) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    self.pictureImg = image;
    
    //富文本添加文字、图片
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTV.attributedText];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, self.contentTV.text.length)];
    
    //添加图片附件
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = image;
    //大小需要根据图片去相应适配缩放比例；位置需要根据文字自适应高度
    attch.bounds = CGRectMake(0, -5, ScreenWidth - 10,200);
    
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    self.contentTV.attributedText = attri;

    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
