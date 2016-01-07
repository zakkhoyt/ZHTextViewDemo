This programming assignment had the following instructions:
"Create a text area on iOS where if you type single asterisks around text it makes it italic, double makes it bold."

About:
For this simple assignment I've implemented a category on UITextView with some helper enums. The functions from that category are called from the UITextViewDelegate in the ViewController. These calls could be more tightly integrated by subclassing UITextView or possibly observing NSNotifications for change events.

Usage:
As you type you will find that *text* turns italic and **text* turns bold. I was able to set the cursor position correctly after the update as well (at beginning or end of sequence). If at the end, a space is appended with no formatting so the user can continue typing this way. If at the front, bold/italic remains while typing.

Pitfalls:
* One case where it may not act as expected is if you type the ** at the back of a word first, then move to the front to complete it. It will instead italicise twice.

Improvements:
* This could be improved by stacking attributes. That is if you bolded a word then went back to italicise it, it would then be bold+italic. Or another command such as (***).



Hello *italic* **bold** *italic*