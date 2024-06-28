esHombre(socrates).
esHombre(luchin).
/*
consultar si Existe algun hombre

esHombre(X).
X = socrates;
X = luchin.

con el ; se pide otro ejemplo que verifique que hay un X que es hombre
*/
esPersonajeFiccion(darthVader).

%si alguien es hombre entonces alguien es mortal
esMortal(Alguien) :- esHombre(Alguien).

%Ejemplo clima
clima(bsas,lluvia,10).
clima(cordoba,sol,23).
clima(mendoza,lluvia,100).

ubicacion(vereda,mendoza).
ubicacion(calle,bsas).

seRego(pasto).
seRego(vereda).

seMojo(Lugar) :- seRego(Lugar).

alAireLibre(pasto).
alAireLibre(vereda).
alAireLibre(calle).

seMojo(Lugar) :- alAireLibre(Lugar)

% para poder hacer && se utiliza la ,
% tambien, se está evaluando que la cantidad de lluvia sea mayor a 20
seMojo(Lugar) :- 
    alAireLibre(Lugar),
    ubicacion (Lugar,Ciudad),
    clima(Ciudad,lluvia,Cantidad),
    Cantidad > 20.
/* si consultamos si seMojo(vereda) el resultado será true
Esto se debe a que
    La vereda está al aire libre
    La ubicacion de la vereda es mendoza
    En mendoza llovio
    La cantidad de lluvia en mendoza fue > 20
*/


















