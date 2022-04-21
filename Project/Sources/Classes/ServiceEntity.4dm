Class extends Entity

exposed Alias aka_Bureaux employees.employee_return  //-> EmployesOffices
exposed Alias aka_Responsable manager  //-> Employes
exposed Alias aka_ManagerName manager.Name
exposed Alias aka_Nom Name

exposed Function get calc_serviceIdentification() : Text
	return (String:C10(This:C1470.ID)+" - "+This:C1470.Name)