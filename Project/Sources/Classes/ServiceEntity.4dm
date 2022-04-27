Class extends Entity

// Alias scalaires
exposed Alias aka_Nom Name
exposed Alias aka_ManagerName manager.Name
exposed Alias aka_BigBossName manager.manager.Name
//exposed Alias aka_ManagerNom manager.aka_Nom // Some time compile, sometime not...

// Alias non-scalars
exposed Alias aka_Bureaux employees.employee_return  // -> EmployesOffices
exposed Alias aka_Responsable manager  // -> Employes

// Calculated Scalars
exposed Function get calc_serviceIdentifier() : Text
	return (String:C10(This:C1470.ID)+" - "+This:C1470.Name)