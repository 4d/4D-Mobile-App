<!-- let(->result; Formula( operation ); Formula($result): Bool) -->
# let

Simplify `Case of` complexity by removing one imbrication.

## Example

For instance we have somes cases
- first ones are prioritary (could be `If` or `Case of`)
- next one depend on one operation result, and we need the result
- last and default one in case of operation failure

```4d
var $result : Object

If (/* a first boolean condition */)
    $result:=New object("case"; "first")
Else
    $result:=MyOperation(..) // compute operation that could failed
    If ($result.success) // check operation result
        $result.case:="let"
    Else
        $result:=New object("case"; "else")
    End if
End if
```

### Bad solution

```4d
$result:=MyOperation(..) // compute operation that could failed
Case of
    : (/* a first boolean condition */)
        $result:=New object("case"; "first")
    : (result.success)  // check operation result
        $result.case:="let"
    Else
        $result:=New object("case"; "else")
End case
```

Why? because we execute `MyOperation`for nothing if the first condition return `True`.

### Solution with let

```4d
Case of
	: (/* a first boolean condition */)
		$result:=New object("case"; "first")
	: (let(->$result; Formula(MyOperation(..) /* compute operation that could failed */ ); Formula($1.success /* check operation result */)))
		$result.case:="let"
	Else
		$result:=New object("case"; "else")
End case
```
