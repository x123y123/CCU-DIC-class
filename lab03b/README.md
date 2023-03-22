# Lab03b

## Purpose
To implement `trapezoid` formula: $output = \frac{(a+b) \times c}{2}$
```html
input  [7:0]a, b, c;
output [15:0] output;
```
* constraint: using `gate-level` to implement
## Method
We can spit the lab for three part:
1. $a + b$
> In this step, we just need to use `8-bits adder` to add a and b.
2. $(a + b) \times c$
> * In this step we need to use the output from first step to implement `9-bits and 8-bits multiplication`.
> * In following picture, we can use the `4-bits * 4-bits` to understand how to do `9-bits * 8-bits` multiplication.
This following picture is a simple multiplication formula.
![](https://github.com/x123y123/CCU-DIC-class/blob/main/lab03b/image/formula.png)
Then we can see the block diagram:
![](https://github.com/x123y123/CCU-DIC-class/blob/main/lab03b/image/gate-level.png)
3. $output = \frac{(a+b) \times c}{2}$
> In the final step, we just need to use `mux` to implement `shift` and we can divide by two.
![](https://github.com/x123y123/CCU-DIC-class/blob/main/lab03b/image/shift.png)


