//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project method : net
// ID[0FBB3AA4E66B4F849409DB936B205D9D]
// Created 17-10-2018 by Vincent de Lachaux
// ----------------------------------------------------
// Description:
//
// ----------------------------------------------------
// Declarations
var $0 : Object
var $1 : Object

If (False:C215)
	C_OBJECT:C1216(net; $0)
	C_OBJECT:C1216(net; $1)
End if 

var $Txt_cmd; $Txt_error; $Txt_in; $Txt_out; $Txt_outWithError : Text
var $Obj_in; $Obj_out; $Obj_result : Object
var $rgx : cs:C1710.regex

// ----------------------------------------------------
// Initialisations
If (Asserted:C1132(Count parameters:C259>=1; "Missing parameter"))
	
	// Required parameters
	$Obj_in:=$1
	
	// Default values
	
	// Optional parameters
	If (Count parameters:C259>=2)
		
		// <NONE>
		
	End if 
	
	$Obj_out:=New object:C1471(\
		"success"; False:C215)
	
Else 
	
	ABORT:C156
	
End if 

// ----------------------------------------------------
Case of 
		
		//______________________________________________________
	: ($Obj_in.action=Null:C1517)
		
		TRACE:C157
		
		//______________________________________________________
	: ($Obj_in.url=Null:C1517)
		
		TRACE:C157
		
		//______________________________________________________
	: ($Obj_in.action="ping")
		
		If (Is macOS:C1572)\
			 & ($Obj_in.url="@localhost@")
			
			// On macOS, localhost is not resolve
			$Obj_in.url:="127.0.0.1"
			
		End if 
		
		$rgx:=cs:C1710.regex.new($Obj_in.url; "(?mi-s)^(:?https?://)?+(:?www\\.)?+([^:]*)(:?[^\\n$]*)$").match()
		
		If ($rgx.success)
			
			$Obj_in.url:=$rgx.matches[3].data
			
		End if 
		
		If (Is macOS:C1572)
			
			$Txt_cmd:="ping -c 1 "+$Obj_in.url
			$Txt_outWithError:=""
			
		Else 
			
			$Txt_cmd:="ping -n 1 "+$Obj_in.url
			$Txt_outWithError:="Ping request could not find host@"
			
		End if 
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "True")
		LAUNCH EXTERNAL PROCESS:C811($Txt_cmd; $Txt_in; $Txt_out; $Txt_error)
		
		$Obj_out.success:=($Txt_out#$Txt_outWithError)
		
		If ($Obj_out.success)
			
			$Obj_out.response:=$Txt_out
			
		Else 
			
			$Obj_out.error:=$Txt_error
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="localhost")
		
		If ($Obj_in.url="@localhost@")
			
			$Obj_out.url:="127.0.0.1"
			$Obj_out.success:=True:C214
			
		End if 
		
		//______________________________________________________
	: ($Obj_in.action="resolve")
		
		$Obj_out.ip:=""
		
		If (Is macOS:C1572)
			
			// On macOS, localhost is not resolve
			$Obj_in.action:="localhost"
			$Obj_result:=net($Obj_in)
			
			$Obj_out.success:=$Obj_result.success
			
		End if 
		
		If ($Obj_out.success)
			
			$Obj_out.ip:=$Obj_result.url
			
		Else 
			
			$Obj_in.action:="ping"
			$Obj_result:=net($Obj_in)
			
			If ($Obj_result.success)
				
				If (Is macOS:C1572)
					
					//PING dyna.wikimedia.org (91.198.174.192): 56 data bytes\n64 bytes from 
					//91.198.174.192: icmp_seq=0 ttl=53 time=16.989 ms\n\n--- dyna.wikimedia.org ping 
					//statistics ---\n1 packets transmitted, 1 packets received, 0.0% packet 
					//loss\nround-trip min/avg/max/stddev = 16.989/16.989/16.989/0.000 ms\n
					
					$rgx:=cs:C1710.regex.new($Obj_result.response; "(?m-si)PING\\s[^(]*\\(([^)]*)").match()
					
					$Obj_out.success:=$rgx.success
					
					If ($Obj_out.success)
						
						$Obj_out.ip:=$rgx.matches[1].data
						
					End if 
					
				Else 
					
					// \r\n
					// Envoi d'une requˆte 'ping' sur fr.wikipedia.org [91.198.174.192] avec 32 octets de donn‚esÿ:\r\n
					// R‚ponse de 91.198.174.192ÿ: octets=32 temps=12 ms TTL=58\r\n\r\n
					// Statistiques Ping pour 91.198.174.192:\r\n
					//    Paquetsÿ: envoy‚s = 1, re‡us = 1, perdus = 0 (perte 0%),\r\n
					// Dur‚e approximative des boucles en millisecondes :\r\n
					//    Minimum = 12ms, Maximum = 12ms, Moyenne = 12ms\r\n
					
					$rgx:=cs:C1710.regex.new($Obj_result.response; "(?i-ms)[^[]*\\[([^\\]]*)\\]").match()
					
					$Obj_out.success:=$rgx.success
					
					If ($Obj_out.success)
						
						$Obj_out.ip:=$rgx.matches[1].data
						
					End if 
				End if 
			End if 
		End if 
		
		//______________________________________________________
	Else 
		
		//______________________________________________________
End case 

// ----------------------------------------------------
// Return
$0:=$Obj_out

// ----------------------------------------------------
// End