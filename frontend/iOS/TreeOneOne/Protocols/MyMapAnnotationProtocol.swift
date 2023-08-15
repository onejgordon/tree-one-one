//
//  MyMapAnnotationProtocol.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 7/1/23.
//

import Foundation
import MapKit
import SwiftUI

struct MyMapAnnotationProtocol: MapAnnotationProtocol {
  let _annotationData: _MapAnnotationData
  let value: Any

  init<WrappedType: MapAnnotationProtocol>(_ value: WrappedType) {
    self.value = value
    _annotationData = value._annotationData
  }
}
