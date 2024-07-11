% Las Casas de Hogwarts
% En Hogwarts, el colegio de magia y hechicería, hay 4 casas en las cuales los nuevos alumnos se distribuyen ni bien ingresan. 
% Cada año estas casas compiten entre ellas para consagrarse la ganadora de la copa.

% Parte 1 - Sombrero Seleccionador
% Para determinar en qué casa queda una mago cuando ingresa a Hogwarts, el Sombrero Seleccionador tiene en cuenta el carácter de la mago, 
% lo que prefiere y en algunos casos su status de sangre.

% Tenemos que registrar en nuestra base de conocimientos qué características tienen los distintos magos que ingresaron a Hogwarts, 
% el status de sangre que tiene cada mago y en qué casa odiaría quedar. Actualmente sabemos que:

% Harry es sangre mestiza, y se caracteriza por ser corajudo, amistoso, orgulloso e inteligente. Odiaría que el sombrero lo mande a Slytherin.
% Draco es sangre pura, y se caracteriza por ser inteligente y orgulloso, pero no es corajudo ni amistoso. Odiaría que el sombrero lo mande a Hufflepuff.
% Hermione es sangre impura, y se caracteriza por ser inteligente, orgullosa y responsable. No hay ninguna casa a la que odiaría ir.

mago(harry).
mago(draco).
mago(hermione).
mago(ron).
mago(luna).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

sangre(harry,mestiza).
sangre(draco,pura).
sangre(ron,pura).
sangre(hermione,impura).
sangre(luna,pura).

caracteriza(harry,coraje).
caracteriza(harry,amistad).
caracteriza(harry,orgullo).
caracteriza(harry,inteligencia).

caracteriza(ron,coraje).
caracteriza(ron,amistad).

caracteriza(draco,inteligencia).
caracteriza(draco,orgullo).

caracteriza(hermione,inteligencia).
caracteriza(hermione,orgullo).
caracteriza(hermione,responsabilidad).

caracteriza(luna,inteligencia).
caracteriza(luna,responsabilidad).

odiariaIrA(harry,slytherin).
odiariaIrA(ron,slytherin).
odiariaIrA(draco,hufflepuff).

% Además nos interesa saber cuáles son las características principales que el sombrero tiene en cuenta
% para elegir la casa más apropiada:
% Para Gryffindor, lo más importante es tener coraje.
% Para Slytherin, lo más importante es el orgullo y la inteligencia.
% Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
% Para Hufflepuff, lo más importante es ser amistoso.

loMasImportante(gryffindor,coraje).

loMasImportante(slytherin,orgullo).
loMasImportante(slytherin,inteligencia).

loMasImportante(ravenclaw,responsabilidad).
loMasImportante(ravenclaw,inteligencia).

loMasImportante(hufflepuff,amistad).

% Se pide:

% Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin,
% que no permite entrar a magos de sangre impura.

permiteEntrar(slytherin,Mago):- mago(Mago), not(sangre(Mago,impura)).
permiteEntrar(gryffindor,Mago):- mago(Mago).
permiteEntrar(ravenclaw,Mago):- mago(Mago).
permiteEntrar(hufflepuff,Mago):- mago(Mago).

% Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características 
% incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.

caracterApropiado(Mago,Casa):-
    mago(Mago),
    casa(Casa),
    forall(loMasImportante(Casa,Caracteristica),caracteriza(Mago,Caracteristica)).

% Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, 
% la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada en Gryffindor, 
% porque al parecer encontró una forma de hackear al sombrero.

podriaQuedar(Mago,Casa):-
    mago(Mago),
    casa(Casa),
    caracterApropiado(Mago,Casa),
    permiteEntrar(Casa,Mago),
    not(odiariaIrA(Mago,Casa)).

podriaQuedar(hermione,gryffindor).

% Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos 
% y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual.

primerElemento([H|_],H).

cadenaDeAmistades([H]):- caracteriza(H,amistad).
cadenaDeAmistades([H|T]):-
    caracteriza(H,amistad),
    podriaQuedar(H,Casa),
    primerElemento(T,Siguiente),
    podriaQuedar(Siguiente,Casa),
    cadenaDeAmistades(T).

% A lo largo del año los alumnos pueden ganar o perder puntos para su casa en base a las buenas y malas acciones realizadas,
% y cuando termina el año se anuncia el ganador de la copa. Sobre las acciones que impactan al puntaje actualmente tenemos la siguiente información:

% Lugares prohibidos:
% El bosque, que resta 50 puntos.
% La sección restringida de la biblioteca, que resta 10 puntos.
% El tercer piso, que resta 75 puntos.

lugar(bosque).
lugar(seccionRestringida).
lugar(tercerPiso).
lugar(mazmorras).

prohibido(bosque,-50).
prohibido(seccionRestringida,-10).
prohibido(tercerPiso,-75).

% Malas acciones: son andar de noche fuera de la cama (que resta 50 puntos) o ir a lugares prohibidos. 
% La cantidad de puntos que se resta por ir a un lugar prohibido se indicará para cada lugar. Ir a un lugar que no está prohibido no afecta al puntaje.
% Buenas acciones: son reconocidas por los profesores y prefectos individualmente y el puntaje se indicará para cada acción premiada.

accion(harry,fueraDeCama).
accion(hermione,tercerPiso).
accion(hermione,seccionRestringida).
accion(harry,bosque).
accion(harry,tercerPiso).
accion(draco,mazmorras).
accion(luna,mazmorras).
accion(ron,ganarAjedrez).
accion(hermione,salvarAmigos).
accion(harry,ganarAVoldemort).

puntos(accion(Mago,fueraDeCama),50):- mago(Mago).
puntos(accion(Mago,Lugar),Puntos):- mago(Mago), lugar(Lugar), prohibido(Lugar,Puntos).
puntos(accion(Mago,Lugar),0):- mago(Mago), lugar(Lugar).
puntos(accion(ron,ganarAjedrez),50).
puntos(accion(hermione,salvarAmigos),50).
puntos(accion(harry,ganarAVoldemort),60).

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% Se pide incorporar a la base de conocimiento la información sobre las acciones realizadas y agregar la siguiente lógica a nuestro programa:

% Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción 
% (que son aquellas que provocan un puntaje negativo).

esBuenAlumno(Mago):-
    mago(Mago),
    forall(puntos(accion(Mago,_),Puntos),Puntos >= 0).

% Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción.
accionRecurrente(Accion):-
    accion(Mago1,Accion),
    accion(Mago2,Accion).

% Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros.
puntajeTotal(Casa,Puntaje):-
    findall(Puntos, (esDe(Mago,Casa), puntos(accion(Mago,_),Puntos)), PuntosXAccion),
    sumlist(PuntosXAccion, Puntaje).    








