//
//  PhotoPickerField.swift
//  Scoers
//

import SwiftUI
import PhotosUI
import UIKit

struct PhotoPickerField: View {
    @Binding var photoData: Data?
    var color: Color = Color.gray.opacity(0.3)

    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Photo")
                .font(.system(size: 16, weight: .medium))

            PhotosPicker(selection: $selectedItem, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(color)

                    if let data = photoData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera")
                                .font(.system(size: 22))
                                .foregroundColor(.primary)
                            Text("Add photo")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                            Text("Show exactly what needs to be done")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 140)
            }
        }
        .task(id: selectedItem) {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                photoData = data
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PhotoPickerField(photoData: .constant(nil))
}
