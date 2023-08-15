//
//  MapView.swift
//  TreeOneOne
//
//  Created by Jeremy Gordon on 6/4/23.
//

import Foundation
import SwiftUI
import MapKit


struct MapView: View {
    var onFocusChange: (_ tree: Tree) -> Void
    private var focusTreeId: Int?
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var nycData: NYDataService
    
    init(onFocusChange: @escaping (_ tree: Tree) -> Void, viewModel: MapViewModel, nycData: NYDataService, focusTreeId: Int?) {
        self.onFocusChange = onFocusChange
        self.focusTreeId = focusTreeId
        self.viewModel = viewModel
        self.nycData = nycData
        print("Initialize map with \(nycData.trees.count) trees.")
    }
    
    var body: some View {
        Map(coordinateRegion: $viewModel.coordinateRegion, showsUserLocation: true,
            annotationItems: nycData.trees) { tree in
            MyMapAnnotationProtocol(MapAnnotation(coordinate: tree.getCoordinate()) {
                            HStack {
                                Image("tree_icon")
                                    .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .overlay(Circle()
                                            .stroke(focusTreeId == tree.id ? Color.orange : Color.green, lineWidth: 4)
                                        )
                            }
                            .onTapGesture {
                                print("Tapped: \(tree.id)")
                                self.onFocusChange(tree)
                            }
                        })

        }
    }
}

//}
