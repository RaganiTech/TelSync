import Flutter
import UIKit

public class SinkPhonebookPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        let api = ContactsHostApiImpl()
        ContactsHostApiSetup.setUp(binaryMessenger: messenger, api: api)
    }
}
