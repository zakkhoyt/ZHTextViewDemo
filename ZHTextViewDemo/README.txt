This programming assignment had the following instructions:
"Create a text area on iOS where if you type single asterisks around text it makes it italic, double makes it bold."

About:
For this simple assignment I've implemented the logic directly in the ViewController which is triggered by a standard UITextView delegate. This logic could be moved into a UITextView subclass, category, or a utility class.

Usage:
As you type you will find that *text* turns italic and **text* turns bold. I was able to set the cursor position correctly after the update as well. The cursor will continue on in bold or italic as the user continues typing as this case wasn't defined in the instructions.

Pitfalls:
* One case where it may not act as expected is if you type the ** at the back of a word first, then move to the front to complete it. It will instead italicise twice.
* This will only process text as it's typed. Pasting text will not process all symbols, only the first instance.

Improvements:
* This could be improved by stacking attributes. That is if you bolded a word then went back to italicise it, it would then be bold+italic. Or another command such as (***).
