import UIKit

enum InputToolbarBuilder {
    
    static func makeToolbar(
        target: Any?,
        cancelAction: Selector,
        doneAction: Selector
    ) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelAction)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneAction)
        
        toolbar.setItems([cancel, flexible, done], animated: false)
        return toolbar
    }
}
