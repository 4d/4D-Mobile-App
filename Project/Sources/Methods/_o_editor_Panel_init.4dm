//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : editor_Panel_init
// ID[F59AB4219B794E8E94DDB5849F25D76D]
// Created 21-12-2017 by Vincent de Lachaux
// ----------------------------------------------------
// Defines, if necessary, the context of the panel and returns it
// ----------------------------------------------------
#DECLARE($form : Text) : Object

$form:=$form || Current form name:C1298

Form:C1466.$dialog:=Form:C1466.$dialog || New object:C1471
Form:C1466.$dialog[$form]:=Form:C1466.$dialog[$form] || New object:C1471

return (Form:C1466.$dialog[$form])