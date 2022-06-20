# JavaScript

TODO: Copy over from old...

## Find in an array:

   let found = arrayofthings.find((element) => {
      return element.url == url;
   });

## Pretty-print JSON

   With newlines: JSON.stringify(data, null, 3); 
   
   Single line: JSON.stringify(data, 3);

   
## NextGen (ES6) JavaScript: 

    1. 'let' replaces 'var'   (scoping is slightly different)
    2. 'const' 
    3. "Arrow Functions"
         const myFunction = (one, two) => {
            return (
            'One: ' + one +
            ' Two: ' + two)
         }