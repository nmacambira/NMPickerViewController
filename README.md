# NMPickerViewController
NMPickerViewController allow users to show, on top of the actual view controller, a customized UIPickerView with a Title label, Select and Cancel buttons. Configure the PickerView the way you want. Change the title, selectButon and cancelButton texts.

You can customize NMPickerViewController to use blur effect.

## Screenshots

 ![Default background](https://github.com/nmacambira/NMPickerViewController/blob/master/Images/NMPickerViewController1.png)  ![Blur background](https://github.com/nmacambira/NMPickerViewController/blob/master/Images/NMPickerViewController2.png)

## Usage 

1. Add "NMPickerViewController.swift” to your project

2. Make sure you add the protocol 'NMPickerViewDelegate' to the class where you want to call NMPickerViewController or you will not be able to call the delegated methods: 

    func pickerViewSelectButtonAction(titleSelected: String) 
    func pickerViewCancelButtonAction()

```swift
class ViewController: UIViewController, NMPickerViewDelegate { 

   //Some code...
} 
```

3. Instatiate NMPickerViewController with its Delegate 

```swift
class ViewController: UIViewController, NMPickerViewDelegate { 

    //Some code...

    func callPickerView(){
        let pickerViewController = NMPickerViewController(delegate: self)
    }
} 
```

4. Set PickerView titles

```swift
class ViewController: UIViewController, NMPickerViewDelegate { 

    //Some code...

    func callPickerView(){
        let pickerViewController = NMPickerViewController(delegate: self)

        pickerViewController.pickerViewTitles = ["Apple", "Banana", "Grape", "Kiwi", "Orange", "Pear", "Pineapple"]
    }
} 
```

5. Call the delegated methods to get 'cancelButton' and 'selectButton' actions

```swift
    func pickerViewCancelButtonAction() {
        print("PickerView cancel button was pressed")
    }

    func pickerViewSelectButtonAction(titleSelected: String) {
        self.selectedPickerViewLabel.text = titleSelected
    }
```

6. [Optional] - Configure PickerView row height

```swift
    // rowHeight default: 36.0
    pickerViewController.pickerViewRowHeight = 44.0
```

7. [Optional] - Configure PickerView to iniciate with a preselected title

```swift
    pickerViewController.pickerViewSelectedTitle = "Kiwi"
```

8. [Optional] - Hide 'titleLabel'

```swift
    pickerViewController.titleLabel.isHidden = true
```

9. [Optional] - Change 'titleLabel', 'selectButon' and 'cancelButton' text.

```swift
    // titleLabel default text: "Please choose a title and press 'Select' or 'Cancel'"
    pickerViewController.titleLabel.text = "Please choose a fruit and press 'Ok' or 'Dismiss'"

    // cancelButton default text: "Cancel"
    pickerViewController.cancelButton.setTitle("Dismiss", for: .normal)

    //selectButton default text: "Select"
    pickerViewController.selectButton.setTitle("Ok", for: .normal)

```

10. [Optional] - Customize NMPickerViewController to use blur effect

```swift
    pickerViewController.blurEffect = true

    // blurEffectStyle default: UIBlurEffectStyle.light
    pickerViewController.blurEffectStyle = .dark
```

11. Check out the Demo Project 'NMPickerViewControllerDemo' for more insights


## License

[MIT License](https://github.com/nmacambira/NMPickerViewController/blob/master/LICENSE)

## Info

- Swift 4.1 

