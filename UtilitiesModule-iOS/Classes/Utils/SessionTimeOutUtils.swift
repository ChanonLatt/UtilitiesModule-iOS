//
//  SessionTimeOut.swift
//  GenieMobile
//
//  Created by Test on 17/11/22.
//

import Foundation
import UIKit

public class SessionTimeoutUtils {
    class func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(idleTimeLimitReached(_:)),
                                               name: .appTimeout,
                                               object: nil)
    }
    
    @objc public func idleTimeLimitReached(_ notification: Notification) {
    }
}

extension Notification.Name {

    static let appTimeout = Notification.Name("appTimeout")

}

public class TimerApplication: UIApplication {
    
    let value = UserDefaults.standard.value(forKey: "timeoutsec") as? Double
   
    private var timeoutInSeconds: TimeInterval {
        return value ?? 40
    }

    private var idleTimer: Timer?
    
    override init() {
        super.init()
        
        resetIdleTimer()
    }
    
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }

        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerApplication.timeHasExceeded),
                                         userInfo: nil,
                                         repeats: false
        )
    }

    @objc private func timeHasExceeded() {
        NotificationCenter.default.post(name: .appTimeout, object: nil)
    }

    public override func sendEvent(_ event: UIEvent) {

        super.sendEvent(event)

        if idleTimer != nil {
            self.resetIdleTimer()
        }

        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
    
    
    
}












//CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
//{   argv in
//    _ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(InterractionUIApplication.self), NSStringFromClass(AppDelegate.self))
//}

//extension NSNotification.Name {
//    public static let TimeOutUserInteraction: NSNotification.Name = NSNotification.Name(rawValue: "TimeOutUserInteraction")
//}
//
//
//class InterractionUIApplication: UIApplication {
//
//    static let ApplicationDidTimoutNotification = "AppTimout"
//
//  //  let timervalue = defaults.value(forKey: "timeoutsec") as? Double ?? 0
//    // The timeout in seconds for when to fire the idle timer.
//    let timeoutInSeconds: TimeInterval = defaults.value(forKey: "timeoutsec") as! TimeInterval//15 * 60
//
//    var idleTimer: Timer?
//
//    // Listen for any touch. If the screen receives a touch, the timer is reset.
//    override func sendEvent(_ event: UIEvent) {
//        super.sendEvent(event)
//        if idleTimer != nil {
//            self.resetIdleTimer()
//        }
//
//        if let touches = event.allTouches {
//            for touch in touches {
//                if touch.phase == UITouch.Phase.began {
//                    self.resetIdleTimer()
//                }
//            }
//        }
//    }
//    // Resent the timer because there was user interaction.
//    func resetIdleTimer() {
//        if let idleTimer = idleTimer {
//            idleTimer.invalidate()
//        }
//
//        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds, target: self, selector: #selector(self.idleTimerExceeded), userInfo: nil, repeats: false)
//    }
//
//    // If the timer reaches the limit as defined in timeoutInSeconds, post this notification.
//    @objc func idleTimerExceeded() {
//
//        NotificationCenter.default.post(name:Notification.Name.TimeOutUserInteraction, object: nil)
//
//        //Go Main page after 15 second
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: StoryBoardConstant.repeatpinController) as! repeatMainPinVC
//
//        appDelegate.window?.rootViewController = yourVC
//        appDelegate.window?.makeKeyAndVisible()
//
//
//    }
//}
