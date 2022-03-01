<!--

// Display the localized help file according to the browser lang
// Uncomment or add a "else if" clause

if (navigator.browserLanguage)
	var language = navigator.browserLanguage;
else
	var language = navigator.language;
		
if (language.indexOf('fr') > -1) document.location.href = 'https://developer.4d.com/go-mobile/fr/';	
else if (language.indexOf('es') > -1) document.location.href = 'https://developer.4d.com/go-mobile/es/';
else if (language.indexOf('ja') > -1) document.location.href = 'https://developer.4d.com/go-mobile/ja/';
else if (language.indexOf('pt') > -1) document.location.href = 'https://developer.4d.com/go-mobile/pt/';
//	else if (language.indexOf('de') > -1) document.location.href = 'https://developer.4d.com/go-mobile/de/';
//	else if (language.indexOf('cs') > -1) document.location.href = 'https://developer.4d.com/go-mobile/cs/';
	document.location.href = 'https://developer.4d.com/go-mobile/';
	
// -->		