//
//  SettingsEditImageView.swift
//  AdoptMe
//
//  Created by Seoa Han on 12/29/20.
//

import SwiftUI

struct SettingsEditImageView: View {
    
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage // Image shown on this screen
    @Binding var profileImage: UIImage // Image shown on the profile
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    @State var showImagePicker: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @State var showSuccessAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text(description)
                Spacer(minLength: 0)
            }
            
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Import".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
            })

            Button(action: {
                saveImage()
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.yellowColor)
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            return Alert(title: Text("Success! 🥳"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    
    // MARK: FUNCTIONS
    func saveImage() {
        
        guard let userID = currentUserID else { return }
        
        // Update the UI of the profile
        self.profileImage = selectedImage
        
        // Update profile image in database
        ImageManager.instance.uploadProfileImage(userID: userID, image: selectedImage)
        
        self.showSuccessAlert.toggle()
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(title: "Title", description: "Desciption", selectedImage: UIImage(named: "dog1")!, profileImage: $image)
        }
    }
}
