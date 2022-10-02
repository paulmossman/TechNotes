# Jasmine

## Cheatsheet

   https://devhints.io/jasmine

## Pretty print expected vs. actual, WITH highlighting of 'undefined'

   const undefinedReplacer = (key, value) =>
      typeof value === 'undefined' ? null : value;
   jasmine.pp = function(obj) {
      return JSON.stringify(obj, undefinedReplacer, 2);
   };
   
   Note: "undefinedReplacer" replaces undefined with 'null', which isn't the input value, but it at least prevents the difference from not being shown.
   
## expect(_).toHaveBeenCalledWith(_) fails, but Json is the same

   One has a key that's undefined, which doesn't print.
   
## Run only one suite of tests, ignore others.

   Change "describe(.." to "fdescribe(.."
   
## Checkmark Pass vs. X Fail

   ✓ vs. ✗

 

