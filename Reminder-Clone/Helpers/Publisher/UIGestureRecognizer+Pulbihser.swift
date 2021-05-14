//
//  UIGestureRecognizer+Pulbihser.swift
//  Reminder-Clone
//
//  Created by JK on 2021/05/14.
//

import UIKit
import Combine

extension UIView: CombineCompatible { }
extension CombineCompatible where Self: UIView {
  func publisher(_ gestureType: GestureType) -> GesturePublisher<UIView> {
    GesturePublisher(view: self, gestureType: gestureType)
  }
}

struct GesturePublisher<View: UIView>: Publisher {
  typealias Output = View
  typealias Failure = Never

  fileprivate let view: View
  fileprivate let gestureType: GestureType

  func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, S.Input == GesturePublisher.Output {
    let subscription = GestureSubscription(subscriber: subscriber, view: view, gestureType: gestureType)
    subscriber.receive(subscription: subscription)
  }

}

enum GestureType {
  case tap
  case swipe
  case pan
  case longPress
  case pinch
  case edge

  var get: UIGestureRecognizer {
    switch self {
    case .tap:
      return UITapGestureRecognizer()
    case .swipe:
      return UISwipeGestureRecognizer()
    case .longPress:
      return UILongPressGestureRecognizer()
    case .pan:
      return UIPanGestureRecognizer()
    case .pinch:
      return UIPinchGestureRecognizer()
    case .edge:
      return UIScreenEdgePanGestureRecognizer()
    }
  }
}

class GestureSubscription<S: Subscriber, View: UIView>: Subscription where S.Input == View, S.Failure == Never {
  private var subscriber: S?
  private var gestureType: GestureType
  private var view: View

  init(subscriber: S, view: View, gestureType: GestureType) {
    self.subscriber = subscriber
    self.view = view
    self.gestureType = gestureType

    config(gesture: gestureType)
  }

  func config(gesture type: GestureType) {
    let gesture = type.get

    gesture.addTarget(self, action: #selector(handler))
    view.addGestureRecognizer(gesture)
  }

  func request(_ demand: Subscribers.Demand) { }

  func cancel() {
    subscriber = nil
  }

  @objc
  private func handler() {
    _ = subscriber?.receive(view)
  }

}
