# WordSuggester
Framework that generates a list of completed words based on what your user types.
It uses statistical language model to suggest the most probable words. Moreover, the user can type a misspelled words.
<br />
<br />

![Output sample](https://github.com/yakovlevvl/WordSuggester/blob/master/example1.jpg)
![Output sample](https://github.com/yakovlevvl/WordSuggester/blob/master/example2.jpg)

## Usage

```swift
import WordSuggester

class ViewController: UIViewController {

    var suggester: WordSuggester!

    override func viewDidLoad() {
        super.viewDidLoad()

        suggester = WordSuggester(for: .English) {
            let words = self.suggester.getWords(with: "sugjes")
        }
    }
}
```
