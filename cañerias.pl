/*
En un juego de "construya su cañería", hay piezas de distintos tipos: codos, caños y canillas.
De los codos me interesa el color, p.ej. un codo rojo.
De los caños me interesan color y longitud, p.ej. un caño rojo de 3 metros.
De las canillas me interesan: tipo (de la pieza que se gira para abrir/cerrar), color y ancho (de la boca).
P.ej. una canilla triangular roja de 4 cm de ancho.
Definir un predicado que relacione una cañería con su precio. Una cañería es una lista de piezas. Los precios son:
codos: $5.
caños: $3 el metro.
canillas: las triangularces $20, del resto $12 hasta 5 cm de ancho, $15 si son de más de 5 cm.
*/
% codo(Color)
% canio(Color,Longitud)
% canilla(Forma,Color,Ancho)

precioPieza(codo(_),5).
precioPieza(canio(_,Longitud),Precio):- Precio is Longitud * 3.
precioPieza(canilla(triangular,_,_),20).
precioPieza(canilla(_,_,Longitud),12):- Longitud =< 5.
precioPieza(canilla(_,_,_),15).

precioCanieria([], 0).
precioCanieria([Pieza|Resto], PrecioTotal) :-
    precioPieza(Pieza, PrecioPieza),
    precioCanieria(Resto, PrecioResto),
    PrecioTotal is PrecioPieza + PrecioResto.
    
/*
Definir el predicado puedoEnchufar/2, tal que puedoEnchufar(P1,P2) se verifique si puedo enchufar P1 a la izquierda de P2. 
Puedo enchufar dos piezas si son del mismo color, o si son de colores enchufables. 
Las piezas azules pueden enchufarse a la izquierda de las rojas, y las rojas pueden enchufarse a la izquierda de las negras. 
Las azules no se pueden enchufar a la izquierda de las negras, tiene que haber una roja en el medio. P.ej.
sí puedo enchufar (codo rojo, caño negro de 3 m).
sí puedo enchufar (codo rojo, caño rojo de 3 m) (mismo color).
no puedo enchufar (caño negro de 3 m, codo rojo) (el rojo tiene que estar a la izquierda del negro).
no puedo enchufar (codo azul, caño negro de 3 m) (tiene que haber uno rojo en el medio).
*/
esCanieria([]).
esCanieria([_|_]).

esPieza(codo(_)).
esPieza(canio(_,_)).
esPieza(canilla(_,_,_)).

ultimaPieza([Ultima],Ultima).
ultimaPieza([_|T],Ultima):- ultimaPieza(T,Ultima).

primeraPieza([Primera],Primera).
primeraPieza([Primera|_],Primera).

color(codo(Color),Color).
color(canio(Color,_),Color).
color(canilla(_,Color,_),Color).

colorIzq(Pieza,Color):- color(Pieza,Color).

colorIzq(esCanieria(Canieria),Color):-
    ultimaPieza(Canieria,Pieza),
    esPieza(Pieza),
    colorIzq(Pieza,Color).

colorDer(esCanieria(Canieria),Color):-
    primeraPieza(Canieria,Pieza),
    esPieza(Pieza),
    colorDer(Pieza,Color).

colorDer(Pieza,Color):- color(Pieza,Color).

coloresEnchufables(Color,Color).
coloresEnchufables(azul,rojo).
coloresEnchufables(rojo,negro).

% Una estructura puede ser una pieza o una cañeria
puedoEnchufar(Estructura1,Estructura2):-
    colorIzq(Estructura1,C1),
    colorDer(Estructura2,C2),
    coloresEnchufables(C1,C2).

/*
Modificar el predicado puedoEnchufar/2 de forma tal que pueda preguntar por elementos sueltos o por cañerías ya armadas. 
P.ej. una cañería (codo azul, canilla roja) la puedo enchufar a la izquierda de un codo rojo (o negro), y a la derecha de un caño azul. 
Ayuda: si tengo una cañería a la izquierda, ¿qué color tengo que mirar? Idem si tengo una cañería a la derecha.
*/



