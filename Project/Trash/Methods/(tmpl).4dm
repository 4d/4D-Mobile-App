//%attributes = {"invisible":true}
  //  // ----------------------------------------------------
  //  // Project method : tmpl
  //  // ID[A30BEBB8BD9C482882295DA611E27D28]
  //  // Created 10-12-2019 by Vincent de Lachaux
  //  // ----------------------------------------------------
  //  // Description:
  //  // 
  //  // ----------------------------------------------------
  //  // Declarations
  //C_OBJECT($0)
  //C_TEXT($1)
  //C_OBJECT($2)

  //C_TEXT($t)
  //C_OBJECT($o)

  //  // ----------------------------------------------------
  //If (This[""]=Null)  // Constructor

  //If (Count parameters>=1)

  //$t:=String($1)

  //End if 

  //$o:=New object(\
"";"tmpl";\
"name";$t\
"user";(Position("/";$t)=1)\
)



  //Else 

  //$o:=This

  //Case of 
  //  //______________________________________________________
  //: ($o=Null)

  //ASSERT(False;"OOPS, this method must be called from a member method")

  //  //______________________________________________________
  //: ($1="xxxxx")


  //  //______________________________________________________
  //Else 

  //ASSERT(False;"Unknown entry point: \""+$1+"\"")

  //  //______________________________________________________
  //End case 


  //End if 

  //  // ----------------------------------------------------
  //  // Return
  //$0:=$o

  //  // ----------------------------------------------------
  //// End