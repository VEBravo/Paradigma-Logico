% Punto 1: El destino es así, lo se... (2 puntos)
% Sabemos que Dodain se va a Pehuenia, San Martín (de los Andes), Esquel, Sarmiento, Camarones y Playas Doradas. 
% Alf, en cambio, se va a Bariloche, San Martín de los Andes y El Bolsón. 
% Nico se va a Mar del Plata, como siempre. Y Vale se va para Calafate y El Bolsón.

% Además Martu se va donde vayan Nico y Alf. 
% Juan no sabe si va a ir a Villa Gesell o a Federación
% No sabe entonces no se pone en la base de conocimiento por no ser un hecho
% Carlos no se va a tomar vacaciones por ahora

% Se pide que defina los predicados correspondientes, y justifique sus decisiones en base a conceptos vistos en la cursada.
persona(Persona):-
    seVa(Persona,_).

persona(carlos).
persona(juan).

lugar(Lugar):-
    seVa(_,Lugar).

seVa(dodain, pehuenia).
seVa(dodain, sanMartin).
seVa(dodain, esquel).
seVa(dodain, sarmiento).
seVa(dodain, camarones).
seVa(dodain, playasDoradas).

seVa(alf, bariloche).
seVa(alf, sanMartin).
seVa(alf, bolson).

seVa(nico, marDel).

seVa(vale,calafate).
seVa(vale,bolson).

seVa(martu, Lugar):-
    seVa(nico, Lugar).

seVa(martu, Lugar):-
    seVa(alf, Lugar).

% Punto 2: Vacaciones copadas (4 puntos)
% Incorporamos ahora información sobre las atracciones de cada lugar. Las atracciones se dividen en
% un parque nacional, donde sabemos su nombre
% un cerro, sabemos su nombre y la altura
% un cuerpo de agua (cuerpoAgua, río, laguna, arroyo), sabemos si se puede pescar y la temperatura promedio del agua
% una playa: tenemos la diferencia promedio de marea baja y alta
% una excursión: sabemos su nombre

% parqueNacional(Nombre).
% cerro(Nombre,Altura).
% cuerpoAgua(Nombre,Pescar,Promedio).
% playa(Diferencia).
% excursion(Nombre).

% Agregue hechos a la base de conocimientos de ejemplo para dejar en claro cómo modelaría las atracciones. 
% Por ejemplo: 
%     Esquel tiene como atracciones un parque nacional (Los Alerces) y dos excursiones (Trochita y Trevelin). 
%     Villa Pehuenia tiene como atracciones un cerro (Batea Mahuida de 2.000 m) y dos cuerpos de agua 
%     (Moquehue, donde se puede pescar y tiene 14 grados de temperatura promedio y Aluminé, donde se puede pescar y tiene 19 grados de temperatura promedio).

tieneAtraccion(esquel,parqueNacional(losAlerces)).
tieneAtraccion(esquel,excursion(trochita)).
tieneAtraccion(esquel,excursion(trevelin)).

tieneAtraccion(pehuenia,cerro(bateaMahuida,2000)).
tieneAtraccion(pehuenia,cuerpoAgua(moquehue,pescar,14)).
tieneAtraccion(pehuenia,cuerpoAgua(alumine,pescar,19)).

tieneAtraccion(marDel,playa(4)).


% Queremos saber qué vacaciones fueron copadas para una persona. Esto ocurre cuando todos los lugares a visitar tienen por lo menos una atracción copada. 
% un cerro es copado si tiene más de 2000 metros

% un cuerpoAgua es copado si se puede pescar o la temperatura es mayor a 20
% una playa es copada si la diferencia de mareas es menor a 5
% una excursión que tenga más de 7 letras es copado
% cualquier parque nacional es copado
% El predicado debe ser inversible. 

esCopada(cerro(Nombre,Altura)):- tieneAtraccion(_,cerro(Nombre,Altura)), Altura > 2000.
esCopada(playa(Diferencia)):- tieneAtraccion(_,playa(Diferencia)), Diferencia < 5.
esCopada(excursion(Nombre)):- tieneAtraccion(_,excursion(Nombre)), atom_length(Nombre,Largo), Largo > 7.
esCopada(parqueNacional(Nombre)):- tieneAtraccion(_,parqueNacional(Nombre)).

tieneAtraccionCopada(Lugar):-
    distinct(Lugar,tieneAtraccion(Lugar,Atraccion)),
    esCopada(Atraccion).

vacacionesCopadas(Persona):-
    seVa(Persona,_),
    forall(seVa(Persona,Lugar),tieneAtraccionCopada(Lugar)).

% Punto 3: Ni se me cruzó por la cabeza (2 puntos)
% Cuando dos personas distintas no coinciden en ningún lugar como destino decimos que no se cruzaron. 
% Por ejemplo, Dodain no se cruzó con Nico ni con Vale (sí con Alf en San Martín de los Andes). 
% Vale no se cruzó con Dodain ni con Nico (sí con Alf en El Bolsón). 
% El predicado debe ser completamente inversible.

noCoinciden(Persona,Otra):-
    seVa(Persona,_),
    seVa(Otra,_),
    forall(seVa(Persona,Lugar),not(seVa(Otra,Lugar))).

% Punto 4: Vacaciones gasoleras (2 puntos)
% Incorporamos el costo de vida de cada destino:
% Queremos saber si unas vacaciones fueron gasoleras para una persona. 
% Esto ocurre si todos los destinos son gasoleros, es decir, tienen un costo de vida menor a 160. Alf, Nico y Martu hicieron vacaciones gasoleras.
% El predicado debe ser inversible.

costoVida(sarmiento,100).
costoVida(esquel,150).
costoVida(pehuenia,180).
costoVida(sanMartin,150).
costoVida(camarones,135).
costoVida(playasDoradas,170).
costoVida(bariloche,140).
costoVida(calafate,240).
costoVida(bolson,145).
costoVida(marDel,140).

esGasolero(Lugar):-
    seVa(_,Lugar),
    costoVida(Lugar,Costo),
    Costo < 160.

vacacionesGasoleras(Persona):-
    distinct(Persona,seVa(Persona,_)),
    forall(seVa(Persona,Lugar),esGasolero(Lugar)).

% Punto 5: Itinerarios posibles (3 puntos)
% Queremos conocer todas las formas de armar el itinerario de un viaje para una persona sin importar el recorrido. 
% Para eso todos los destinos tienen que aparecer en la solución (no pueden quedar destinos sin visitar).

permutacion([],[]).
permutacion([_|Posibles],Lugares):-
    permutacion(Posibles,Lugares).
permutacion([Posible|Posibles],[Posible|Lugares]):-
    permutacion(Posibles,Lugares).

formasDeViajar(Persona,Itinerario):-
    seVa(Persona,_),
    findall(Lugar,seVa(Persona,Lugar),Opciones),
    permutacion(Opciones,Itinerario).

% Por ejemplo, para Alf las opciones son
% [bariloche, sanMartin, elBolson]
% [bariloche, elBolson, sanMartin]
% [sanMartin, bariloche, elBolson]
% [sanMartin, elBolson, bariloche]
% [elBolson, bariloche, sanMartin]
% [elBolson, sanMartin, bariloche]

% (claramente no es lo mismo ir primero a El Bolsón y después a Bariloche que primero a Bariloche y luego a El Bolsón, 
% pero el itinerario tiene que incluir los 3 destinos a los que quiere ir Alf).

