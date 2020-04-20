//%attributes = {"invisible":true}
C_BOOLEAN:C305($b)
C_DATE:C307($d)
C_LONGINT:C283($l)
C_TEXT:C284($t)
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

If (False:C215)  // Zip
	
	
End if 

If (False:C215)  // File & Folder
	
	  // Constants
	
	  // Fk platform path = 1
	  // Fk posix path = 0
	
	  // Fk alias link = 0
	  // Fk symbolic link = 1
	
	  // Fk overwrite = 4
	
	  // Fk recursive = 1
	
	  // folder <- Folder ( path { ; pathType } )
	  // OR
	  // folder <- Folder ( pathConstant ; { * } )
	
	$d:=$o.creationDate  // Return the creation date
	$l:=$o.creationTime  // Return the creation time
	$d:=$o.modificationDate  // Return the modification date
	$l:=$o.modificationTime  // Return the modification time
	$t:=$o.fullname  // Final folder name of the specified path
	$t:=$o.name  // Final folder name of the specified path, without extension
	$t:=$o.extension  // Extension of the final file name. Always starts with ".". Empty string "" if no extension
	$t:=$o.platformPath  // Return the system path
	$t:=$o.path  // Return the posix path (including file system if any)
	$b:=$o.exists  // Returns TRUE if the folder exists.
	$b:=$o.isFile  // FALSE
	$b:=$o.isFolder  // TRUE
	$b:=$o.isPackage  // Returns TRUE if the folder is a package on macOS, return false on Windows. Folder must exist on disk.
	$b:=$o.hidden  // READ/WRITE - Return TRUE if the folder the flag system is set
	$b:=$o.isAlias  // FALSE
	$o:=$o.original  // Return the same folder object
	
	$o:=$o.parent  // Returns a parent folder object. If no parent, return a NULL object
	
	  // Create a sub folder object
	  // - Return a new folder object
	  //- $1: relative path in posix
	  // Returns Null if invalid
	  // SubFolder:=myFolder.folder( "relativePosixPath" )
	$o.folder()
	
	  // Create a sub file object
	  // - Return a new file object
	  //- $1: relative path in posix
	  // Returns Null if invalid
	  // SubFile:=myFolder.file( "relativePosixPath" )
	$o.file()
	
	  // Returns a collection of children folder object
	  //- $1: fk recursive or fk no recursive (By default fk no recursive)
	$o.folders()
	
	  // Returns a collection of children file object (Does not resolve aliases or
	  // Symbolic links)
	  //- $1: fk recursive or fk no recursive (By default fk no recursive)
	$o.files()
	
	  // Return the system image associated with the type scaled from the nearest
	  // Available size (On windows an icon max size is 256*256, Mac is variable and
	  // Depends on the app)
	  //- $1: size of the picture size in pixel
	$o.getIcon()
	
	  // Rename the folder
	  // - Return a new folder object with the new name
	  //- $1: new name (error if contains /)
	$o.rename()
	
	  // Makes a copy of the folder to another location
	  // - Return the new folder object
	  //- $1: destination folder object
	  //- $2 : new name (not mandatory, error if contains /)
	  //- $3: "fk overwrite" or "fk no overwrite" a existing document (not mandatory -
	  // By default "No overwrite"
	$o.copyTo()
	
	  // Move the file or the folder to another location
	  // - Return the new folder object
	  //- $1: destination folder object
	  //- $2 : new name (not mandatory, error if contains /)
	  // Error if move to another Volume
	$o.moveTo()
	
	  // Delete the folder on disk
	  //- $1 constant: Delete only if empty or Delete with contents. Same behavior as
	  // DELETE FOLDER (By default Delete only if empty)
	$o.delete()
	
	  // Create a new folder on disk - This function creates the folder hierarchy. If
	  // The folder already exists on the disk, no error is throw. Returns false if
	  // Folder already exists or an error occured
	$o.create()
	
	  // Creates an alias (mac) or symbolic link (mac) or shortcut (windows)
	  // - Return the alias object
	  //- $1: alias destination folder object
	  //- $2: alias name
	  //- $3 : Link Type: Alias (alias mac or shortcut windows) (by default) or Symbolic Link (mac only)
	  // MyAlias:=subfolder.createAlias( folder ; aliasName ; fk Alias ou fk SymLink)
	  // MyAlias.exists() -> true
	$o.createAlias()
	
	  // file <- File ( path { ; pathType } )
	  // OR
	  // file <- File ( constant get 4d file ; { * } )
	
	$d:=$o.creationDate  // Return the creation date
	$l:=$o.creationTime  // Return the creation time
	$d:=$o.modificationDate  // Return the modification date
	$l:=$o.modificationTime  // Return the modification time
	$t:=$o.fullname  // Final file name of the specified path
	$t:=$o.name  // Final folder name of the specified path, without extension
	$t:=$o.extension  // Extension of the final file name. Always starts with ".". Empty string "" if no extension
	$t:=$o.platformPath  // Return the system path
	$t:=$o.path  // Return the posix path (including file system if any)
	$b:=$o.exists  // Returns TRUE if the folder exists.
	$b:=$o.isFile  // TRUE
	$b:=$o.isFolder  // FALSE
	$b:=$o.hidden  // READ/WRITE - Return the system flag 'hidden'
	$b:=$o.isAlias  // Returns TRUE if the filename exists and is an alias or shortcut or symbolic link
	
	$t:=$o.original  // For an alias or symbolic link, return the original file or folder object. Otherwise return the same file object. No error if original desn't exist, just returns null
	
	$o:=$o.parent  // Returns a parent folder object. If no parent, return a NULL object.
	
	  // Return the system image associated with the type with the nearest size
	  //- $1: size of the picture
	$o.getIcon()
	
	  // Rename the file
	  // - Return a new file object with the new name
	  //- $1: new name
	$o.rename()
	
	  // Makes a copy of the file to another location
	  // - Return the new file object
	  //- $1: destination folder object
	  //- $2: new name (not mandatory)
	  //- $3: "fk overwrite" or "fk no overwrite" a existing document (not mandatory -
	  // By default "No overwrite"
	$o.copyTo()
	
	  // Move the file to another location
	  // - Return the new file object
	  //- $1: destination folder object
	  //- $2: new name (not mandatory)
	$o.moveTo()
	
	  // Delete the file on disk. Same behavior as DELETE DOCUMENT
	$o.delete()
	
	  // Create a new file on disk. If the file already exists on the disk, no error is
	  // Throw. Returns false if file was already existing or an error occured
	$o.create()
	
	  // Get all the content of a file.
	  // - Returns the content of the file in a blob
	$o.getContent()
	
	  // Set all the content of a file.
	  //- $1 content of the file
	$o.setContent()
	
	  // Retrieve the text of the file
	  //- $1 charset ; Not mandatory ; Default charset is UTF-8
	  //- $2 breakmode constant: Document unchanged ; Document with CR ; Document with
	  // CRLF ; Document with LF ; Document with native format (Not mandatory ; Default
	  // Breakmode is Document with native format)
	$o.getText()
	
	  // Write the text in the file
	  //- $1Text to store in the file
	  //- $2 charset ; Not mandatory ; Default charset is UTF-8
	  //- $2 breakmode constant: Document unchanged ; Document with CR ; Document with
	  // CRLF ; Document with LF ; Document with native format (Not mandatory ; Default
	  // Breakmode is Document with native format)
	$o.setText()
	
	  // Creates an alias or shortcut
	  // - Return the alias object
	  //- $1: alias folder object
	  //- $2: alias name
	  //- $3 : Link TypeAlias (alias mac or shortcut windows) (by default) or Symbolic Link (mac only)
	$o.createAlias()
	
	  // Returns TRUE if the filename exists and is writable. (Check on disk if 4D can Write)
	$o.isWritable()
	
End if 

If (False:C215)  // Collections
	$l:=$c.length
	
	$c.average()
	$c.clear()
	$c.combine()
	$c.concat()
	$c.copy()
	$c.count()
	$c.countValues()
	$c.distinct()
	$c.equal()
	$c.every()
	$c.extract()
	$c.fill()
	$c.filter()
	$c.find()
	$c.findIndex()
	$c.indexOf()
	$c.indices()
	$c.insert()
	$c.join()
	$c.lastIndexOf()
	$c.map()
	$c.max()
	$c.min()
	$c.orderBy()
	$c.orderByMethod()
	$c.pop()
	$c.push()
	$c.query()
	$c.reduce()
	$c.remove()
	$c.resize()
	$c.reverse()
	$c.shift()
	$c.slice()
	$c.some()
	$c.sort()
	$c.sum()
	$c.unshift()
End if 

If (False:C215)  // DataStore
	$o:=ds:C1482
	$o:=ds:C1482[""].getInfo()
End if 

If (False:C215)
	
	  // DataClass
	$o:=$o.all()
	$o:=$o.fromCollection()
	$o:=$o.get()
	$o:=$o.new()
	$o:=$o.newSelection()
	$o:=$o.query()
	
	  // DataClassAttribute
	$o.kind()
	$o.name()
End if 

If (False:C215)  // Entity
	$o.clone()
	$o.diff()
	$o.drop()
	$o.first()
	$o.fromObject()
	$o.getKey()
	$o.getStamp()
	$o.indexOf()
	$o.isNew()
	$o.last()
	$o.lock()
	$o.next()
	$o.previous()
	$o.reload()
	$o.save()
	$o.toObject()
	$o.touched()
	$o.touchedAttributes()
	$o.unlock()
End if 

If (False:C215)  // EntitySelection
	$o.queryPath()
	$o.queryPlan()
	$o.add()
	$o.and()
	$o.average()
	$o.contains()
	$o.count()
	$o.distinct()
	$o.drop()
	$o.first()
	$o.isOrdered()
	$o.last()
	$o.max()
	$o.min()
	$o.minus()
	$o.or()
	$o.orderBy()
	$o.query()
	$o.slice()
	$o.sum()
	$o.toCollection()
	
End if 