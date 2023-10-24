//
//  ContentView.swift
//  FilevaultReboot
//
//  Created by Dieskim on 6/8/23.
//
import SwiftUI
import Foundation


func runScript(scriptAction: String, username: String,password: String) -> Bool{
    
    var delayminutes = 0
    
    if scriptAction == "shutdown" {
        delayminutes = -1
    } else if scriptAction == "restart" {
        delayminutes = 0
    }
    
    let rebootProcess = Process()
    rebootProcess.launchPath = "/usr/bin/expect"
    rebootProcess.arguments = ["-c", """
                        set timeout -1
                        spawn sudo fdesetup authrestart -delayminutes \(delayminutes)
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
                        spawn sudo shutdown -h now
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
    @State private var buttonsEnabled = true
    @State private var isRestartButtonHidden = false
    @State private var isShutdownButtonHidden = false
    @State var restartButtonTitle: String = "Restart"
    @State var shutdownButtonTitle: String = "Shut Down"
    
    var body: some View {
        VStack {
            Text("Enter your Admin Password to bypass the \ninitial FileVault unlock on the next boot")
                .fixedSize(horizontal: true, vertical: false)
                .multilineTextAlignment(.leading)
            //TextField("Username", text: $username)
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $password).modifier(Shake(animatableData: CGFloat(attempts)))//.onSubmit{rebootShutdown()}
            }
            HStack {
                if !isShutdownButtonHidden {
                    Button(shutdownButtonTitle, action: {
                            rebootShutdown(action: "shutdown")
                        })
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 10)
                        .disabled(!buttonsEnabled)
                }
                if !isRestartButtonHidden {
                    Button(restartButtonTitle, action: {
                        rebootShutdown(action: "restart")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
                    .disabled(!buttonsEnabled)
                }
            }
        }
        .padding()
    }
    
    func rebootShutdown(action: String) {
        if username != "" && password != "" {
            print("Got Username and Password")
            //print(username)
            //print(password)
            
            // disable buttons
            
            buttonsEnabled = false
            if action == "shutdown" {
                print("shutdown")
                isRestartButtonHidden = true
                shutdownButtonTitle = "Shutting Down..."
            } else if action == "restart" {
                print("restart")
                isShutdownButtonHidden = true
                restartButtonTitle = "Restarting..."
            }

            let scriptResult = runScript(scriptAction: action, username: username,password: password)
            
            // reboot failed resetting
            if scriptResult != true {
                password = ""
                isRestartButtonHidden = false
                isShutdownButtonHidden = false
                restartButtonTitle = "Restart"
                shutdownButtonTitle = "Shut Down"
                withAnimation(.default) {
                                    self.attempts += 1
                                }
                // re-enable buttons
                buttonsEnabled = true
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
