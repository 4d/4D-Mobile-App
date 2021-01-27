<!--

// Display the localized help file according to the browser lang
// Uncomment or add a "else if" clause

if (navigator.browserLanguage)
	var language = navigator.browserLanguage;
else
	var language = navigator.language;
		
if (language.indexOf('fr') > -1) document.location.href = 'https://developer.4d.com/4d-for-ios/fr/';
		
else if (language.indexOf('en') > -1) document.location.href = 'https://developer.4d.com/4d-for-ios/en/';
		
else if (language.indexOf('ja') > -1) document.location.href = 'https://developer.4d.com/4d-for-ios/ja/';
		
else if (language.indexOf('es') > -1) document.location.href = 'https://developer.4d.com/4d-for-ios/es/';
		
//	else if (language.indexOf('de') > -1) document.location.href = 'https://developer.4d.com/4d-for-ios/de/';
		
//	else if (language.indexOf('it') > -1) document.location.href = 'Resources/it.lproj/Help/Help.html';
		
// else
		
	document.location.href = 'https://developer.4d.com/4d-for-ios/en/';

// -->		