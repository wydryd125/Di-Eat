//
//  Extension+UIControl.swift
//  Di-Eat
//
//  Created by wjdyukyung on 12/30/24.
//

import UIKit
import Combine

extension UIControl {
    // Subscription을 담당하는 클래스
    final class GestureSubscription<S: Subscriber, Control: UIControl>: Subscription
    where S.Input == Control {
        private var subscriber: S?
        private let control: Control
        
        init(subscriber: S, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            // 기본적인 구독 요청 처리
        }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc func eventHandler() {
            _ = subscriber?.receive(control)
        }
    }
    
    // Publisher를 정의
    final class GesturePublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never
        
        private let control: Control
        private let controlEvent: Control.Event
        
        init(control: Control, controlEvent: Control.Event) {
            self.control = control
            self.controlEvent = controlEvent
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
            let subscription = GestureSubscription(subscriber: subscriber,
                                                   control: control,
                                                   event: controlEvent)
            subscriber.receive(subscription: subscription)
        }
    }
    
    // tap 이벤트를 다루는 메서드
    func throttleTapPublisher() -> AnyPublisher<UIControl, Never> {
        return GesturePublisher(control: self, controlEvent: .touchUpInside)
            .map { _ in self } // self를 반환, self는 UIButton입니다.
            .throttle(for: .seconds(0.5),
                      scheduler: RunLoop.main,
                      latest: false)
            .eraseToAnyPublisher()
    }
}
