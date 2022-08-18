function sololetras(string,op,tam){
	var out = '';
	switch(op){
		case 1://letras mayusculas, minusculas y espacio
			var filtro = 'abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ ';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		case 2://letras mayusculas, minusculas, numeros y espacio
			var filtro = '1234567890abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890 ';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		case 3://letras mayusculas y espacio
			var filtro = 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ ';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		case 4://letras minusculas y espacio
			var filtro = 'abcdefghijklmnñopqrstuvwxyz ';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		case 5://numeros y espacio
			var filtro = '0123456789 ';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		case 6://tipo correo
			var filtro = '_.@1234567890abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890';
			for (var i=0; i<tam; i++)
			if (filtro.indexOf(string.charAt(i)) != -1) 
			out += string.charAt(i);
			return out;
		default:
			var out = 'tipo de validacion no valido revise';
			return out;
	}
}