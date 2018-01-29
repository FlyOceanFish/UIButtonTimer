//
//  UIButton+Timer.swift
//
//  Created by FlyOceanFish on 2018/1/26.
//

import Foundation
import UIKit

private var keyTimer = "UIBUTTON+TIMER"
private var keyCount = "UIBUTTON+COUNT"
private var keyBack = "UIBUTTON+Back"

typealias TimerCallBack = (_ button:UIButton,_ count:Int)->Void

extension UIButton{
    var timerCallBack:TimerCallBack?{
        get{
            return objc_getAssociatedObject(self, &keyBack) as? TimerCallBack
        }
        set(newValue){
            objc_setAssociatedObject(self, &keyBack, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    var timer:DispatchSourceTimer?{
        get{
            return objc_getAssociatedObject(self, &keyTimer) as? DispatchSourceTimer
        }
        set(newValue){
            objc_setAssociatedObject(self, &keyTimer, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    var count:Int{
        get{
            return objc_getAssociatedObject(self, &keyCount) as? Int ?? 0
        }
        set(newValue){
            objc_setAssociatedObject(self, &keyCount, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    func fof_startTimer(time aTime:Int) {
        assert(aTime>0, "时间必须大于0")
        if (self.timer != nil) {
            self.timer?.cancel()
        }
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main);//timer一定要是全局变量，局部变量不会调用
        self.count = aTime;
        self.timer?.schedule(deadline: .now(), repeating: 1)
        self.timer!.setEventHandler {
            if self.count>=0{
                self.timerCallBack?(self,self.count)
            }
            if self.count<=0{
                self.fof_cancelTimer()
            }
            self.count = self.count-1
        }
        self.timer!.resume();
    }
    func fof_cancelTimer() {
        if (self.timer != nil) {
            self.timer!.cancel();
            self.timer = nil;
        }
    }
    func fof_timerCallBack(block:@escaping (_ button:UIButton,_ count:Int)->Void){
        self.timerCallBack = block;
    }
}
