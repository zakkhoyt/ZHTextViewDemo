This programming assignment had short but clear instructions:

Create a text area on iOS where if you type single asterisks around text it makes it italic, double makes it bold.

For this assignment I've implemented the logic in a ViewController which is triggered by a standard UITextView delegate. This logic could be moved into a UITextView subclass or any other location that would best fit a more defined scope.

As you type you will find that 'text' turns italic and ''text'' turns bold. I investigated a way to stack attributes so that you could apply bold and italic to the same piece of code, but didn't see that attribute stacking is a simple task (not impossible).

Another issue i experienced is that if the target text is at the end of the string (assume it's turning italic), that all text entered aftewards will also be italic. To remedy this I've appended a space to the end with normal text formatting.
