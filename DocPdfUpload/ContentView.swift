//
//  ContentView.swift
//  DocPdfUpload
//
//  Created by Md. Zahidul Islam Mazumder on 19/12/20.
//

import SwiftUI
import Alamofire
import UniformTypeIdentifiers

struct ContentView: View {
    //let supportedTypes: [UTType] = [UTType.pdf,.png,.audiovisualContent]
    var body: some View {
        
        VStack{ //["public.item"]
            Text("Select Doc").onTapGesture {
                print("jjjk")
                
                let picker = DocumentPickerViewController(
                        supportedTypes: ["public.image", "public.jpeg", "public.png", "public.content"],
                        onPick: { url in
                            print("url : \(url)")
                        },
                        onDismiss: {
                            print("dismiss")
                        }
                    )
                    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true)

                
            }
            
            Button {
                let url = "http://dss.aws.simecsystem.com:10012/api/auth/file-upload"
                let filePath = Bundle.main.url(forResource: "ppt", withExtension: "ppt")?.path
                
                print("filePath",filePath)
                
                let httpHeaders: HTTPHeaders = [
                    "Accept" : "application/json",
                    "Content-Type": "application/json",
                    "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZGM1YTdlZGZhYmVjYTE2Y2VlNzU1NzE3Y2ZkNzliYjZjOTBiYTBmZjdlNjNmZWMzZGNhMTNmNTRiNjRiOWIzNWQ3MWQ5OGIwOWUwZTE5MDIiLCJpYXQiOjE2MDY3Mzc0MDcsIm5iZiI6MTYwNjczNzQwNywiZXhwIjoxNjM4MjczNDA3LCJzdWIiOiI4MSIsInNjb3BlcyI6W119.cRrLUsxsnbEASPf4hyHtL2Q5OJoO3R6anxcBaYs1EVfnl3we12HDPnD3qjEUBHaC4ZX32Dbv8XatvtNPjlhVtw"

                ]
                var dt = Data()
                
                do {
                     dt = try Data(contentsOf: URL(string: filePath!)! )
                    
                    } catch {
                        print("The file could not be loaded")
                    }
                
                

                if let data = NSData(contentsOfFile: filePath!) {
                    var bytes = [UInt8]()
                        var buffer = [UInt8](repeating: 0, count: data.length)
                        data.getBytes(&buffer, length: data.length)
                        bytes = buffer
                    
                    AF.upload(multipartFormData: { multiPart in
                       
                        
    //                    if let dt = try Data(contentsOf: URL(string: filePath!)! ) {
    //                        multiPart.append(dt, withName: "filenames[]", fileName: "file.jpg", mimeType: "image/jpg")
    //                    }
                        multiPart.append(Data(bytes), withName: "filenames[]", fileName: "doc")
                       
                    }, to: url, method: .post, headers: httpHeaders)
                        .responseJSON{ response  in
                            
                            
                            print("image response",response)
                            
                        switch response.result {
                        case .success(let resut):
                            print("upload success result: \(resut)")
                            
                            
                            
                            break
                            
                        case .failure(let err):
                            print("upload err: \(err)")
                        }
                    }
                    
                    }
            } label: {
                Text("Upload")
            }

        }
        
        
            .onAppear(){
                
                
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct LoginModel: Decodable {
    var data : LoginData?
    var message : String?
    var status : String?
}
struct LoginData: Decodable {
    
    var path : String?
    var mime_type : String?
    
}


class DocumentPickerViewController: UIDocumentPickerViewController {
    private let onDismiss: () -> Void
    private let onPick: (URL) -> ()

    init(supportedTypes: [String], onPick: @escaping (URL) -> Void, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
        self.onPick = onPick

        super.init(documentTypes: supportedTypes, in: .open)

        allowsMultipleSelection = false
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DocumentPickerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onPick(urls.first!)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onDismiss()
    }
}
