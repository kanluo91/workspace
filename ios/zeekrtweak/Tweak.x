#include <substrate.h>
#include <objc/runtime.h>
#include <stdlib.h>
#include <stdio.h>
#include <Foundation/Foundation.h>


void *(*sys_exit)(int d);
void tweak_exit(int d){
    printf("\n--------------hook 到了 mycustomexit方法-----------\n");
}

%ctor
{

    @autoreleasepool {
        printf("\n--------------hook 到了 构造方法-----------\n");
        NSString *binaryFilepath = [[NSBundle mainBundle] executablePath];
        MSImageRef image = MSGetImageByName([binaryFilepath UTF8String]);
         if (image) {
            // 一定要加一个下划线
            void *hgPrint = MSFindSymbol(image,"_mycustomexit");
            if (hgPrint) {
                MSHookFunction(hgPrint,tweak_exit,(void**)&sys_exit);
            } else {
                    printf("\n没找到函数 _mycustomexit\n");
            }
        } else {
            printf("\nno found image\n");
        }

    }

}


%hook ViewController

-(void)btnClick:(id)sender{
    printf("\n拦截了[ViewController][btnClick：]\n");
    %orig;
}

%end
