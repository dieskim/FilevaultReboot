//
//  ContentView.swift
//  FilevaultReboot
//
//  Created by Dieskim on 6/8/23.
//
import SwiftUI
import Foundation


func runScript(username: String,password: String) -> Bool{
       
    let rebootProcess = Process()
    rebootProcess.launchPath = "/usr/bin/expect"
    rebootProcess.arguments = ["-c", """
                        set timeout -1
                        spawn sudo fdesetup authrestart
                        expect \"Password:\"
                        send \"\(password)\r\"
                        expect {
                            \"Enter the user name:\" {
                                send \"\(username)\r"
                            }
                            \"Sorry, try again.\" {
                                exit 0
                            }
                        }
                        expect \"Enter the password for user '\(username)':\"
                        send \"\(password)\r\"
                        expect eof
                    """]
    
    //let rebootProcessIn = Pipe()
    let rebootProcessOut = Pipe()
    //rebootProcess.standardOutput = sudoOut
    //rebootProcess.standardError = sudoOut
    //rebootProcess.standardInput = sudoIn
    rebootProcess.launch()

    // Show the output as it is produced
    rebootProcessOut.fileHandleForReading.readabilityHandler = { fileHandle in
        let data = fileHandle.availableData
        if (data.count == 0) { return }
        print("read \(data.count)")
        print("\(String(bytes: data, encoding: .utf8) ?? "<UTF8 conversion failed>")")

    }
    // Write the password as
    //rebootProcessIn.fileHandleForWriting.write(passwordWithNewline.data(using: .utf8)!)

    // Close the file handle after writing the password; avoids a
    // hang for incorrect password.
    //try? rebootProcessIn.fileHandleForWriting.close()

    // Make sure we don't disappear while output is still being produced.
    rebootProcess.waitUntilExit()
    print("Process did exit")
    return false
}

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    @State private var username = NSUserName()
    @State private var password = ""
    @State var attempts: Int = 0
    @State var buttonTitle: String = "Restart"
    
    var body: some View {
        VStack {
            Text("Enter admin credentials for FileVault restart")
            //TextField("Username", text: $username)
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $password).modifier(Shake(animatableData: CGFloat(attempts))).onSubmit{reboot()}
            }
            Button(buttonTitle, action: reboot).buttonStyle(.borderedProminent).padding(.top, 10)
        }
        .padding()
    }
    
    func reboot() {
        if username != "" && password != "" {
            print("Got Username and Password")
            //print(username)
            //print(password)
            
            // start reboot attempt
            buttonTitle = "Restarting"
            let scriptResult = runScript(username: username,password: password)
            
            // reboot failed resetting
            if scriptResult != true {
                password = ""
                buttonTitle = "Restart"
                withAnimation(.default) {
                                    self.attempts += 1
                                }
            }
            
        } else {
            print("no password entered")
            withAnimation(.default) {
                                self.attempts += 1
                            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
