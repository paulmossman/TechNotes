**<span style="font-size:3em;color:black">JavaScript</span>**
***

TODO: Copy over from old...

# Date

## Add days
```
let date = new Date()
date.setDate(date.getDate() + 1)
console.log(date.toISOString().split('T')[0])
```

## Print YYY-MM-DD
```
let date = new Date()
date.toISOString().split("T")[0]
```

# One-liner
```
node -e 'let date = new Date(); date.setDate(date.getDate() + 1); console.log(date.toISOString().split("T")[0])'
```

# Find in an array:

   let found = arrayofthings.find((element) => {
      return element.url == url;
   });

# Pretty-print JSON

   With newlines: JSON.stringify(data, null, 3); 
   
   Single line: JSON.stringify(data, 3);

   
# NextGen (ES6) JavaScript: 

    1. 'let' replaces 'var'   (scoping is slightly different)
    2. 'const' 
    3. "Arrow Functions"
         const myFunction = (one, two) => {
            return (
            'One: ' + one +
            ' Two: ' + two)
         }