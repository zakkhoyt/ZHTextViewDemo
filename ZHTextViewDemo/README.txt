This programming assignment had the following instructions:

"Create a text area on iOS where if you type single asterisks around text it makes it italic, double makes it bold."

For this assignment I've implemented the logic directly in the ViewController which is triggered by a standard UITextView delegate. This logic could be moved into a UITextView subclass or category.

As you type you will find that 'text' turns italic and ''text'' turns bold. I was able to set the cursor position correctly after the update as well.

One case where it may not act as expected is if you type the double ticks at the back of a word first, then move to the front to complete it. It will instead double italicise.

This could be improved by stacking attributes. That is if you bolded a word then went back to italicise it, it would then be bold-ital. Or a triple tick (''') command.