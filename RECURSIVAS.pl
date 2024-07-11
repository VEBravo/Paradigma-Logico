combinatoria([],[]).
combinatoria([_|Posibles],Personas):-
    combinatoria(Posibles,Personas).
combinatoria([Posible|Posibles],[Posible|Personas]):-
    combinatoria(Posibles,Personas).

desarolloDependencias(J,T) :- sindependencia(T), !.
desarolloDependencias(J,T) :- depende(T,T2), desarrollo(J,T2), desarolloDependencias(J,T2).
puedeDesarrollar(J,T) :- juega(J,_), tecnologia(T), not(desarrollo(J,T)), desarolloDependencias(J,T).

epAnterior(Ep1,Ep2):-precedeA(Ep1,Ep2).
epAnterior(Ep1,Ep2):-precedeA(Ep1,Aux), epAnterior(Aux,Ep2).

% Caso base: la permutación de una lista vacía es una lista vacía.
permutacion([], []).
% Caso recursivo: selecciona un elemento E de la lista [E|Es], permuta el resto de la lista,
% y luego inserta E en todas las posiciones posibles de cada permutación.
permutacion(L, [E|PermutacionResto]):-
    seleccionar(E, L, Resto),
    permutacion(Resto, PermutacionResto),
    insertar(E, PermutacionResto, L).

% Selecciona un elemento de la lista, devolviendo el elemento seleccionado, y el resto de la lista sin ese elemento.
seleccionar(E, [E|Es], Es).
seleccionar(E, [X|Xs], [X|Ys]) :- seleccionar(E, Xs, Ys).

% v---------------------------------------

El polimorfismo me permite modelar mejor los hechos, hacerlos mas expresivos. Como consecuencia de trabajar un mismo predicado con distintos
functores, debo recurrir a predicados auxiliares en los que utilizo pattern matching para poder discriminar por functor. Tambien, gracias a esto,
si en un futuro quiero agregar mas functores para representar distintas cosas, se puede construir sobre el codigo. No deberia ser necesaria modificar
caloriasTotales/2.

por principio de universo cerrado, no agregamos a la base de conocimiento aquello que no tiene sentido agregar. por principio de universo cerrado, lo desconocido se presume falso