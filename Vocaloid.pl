% Queremos reflejar entonces que:
% megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y también canta la canción foreverYoung que dura 5 minutos.	
% hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
% gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
% seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.
% kaito no sabe cantar ninguna canción.

% Tener en cuenta que puede haber canciones con el mismo nombre pero con diferentes duraciones.

% canta(Vocaloid,cancion(Nombre,Duracion))

vocaloid(Cantante):-canta(Cantante,_).
vocaloid(kaito).
cancion(Cancion):-canta(_,cancion(Cancion,_)).

canta(megurineLuka,cancion(nightFever,4)).
canta(megurineLuka,cancion(foreverYoung,5)).
canta(hatsuneMiku,cancion(tellYourWorld,4)).
canta(gumi,cancion(foreverYoung,4)).
canta(gumi,cancion(tellYourWorld,5)).
canta(seeU,cancion(novemberRain,6)).
canta(seeU,cancion(nightFever,5)).

% Definir los siguientes predicados que sean totalmente inversibles, a menos que se indique lo contrario.

% Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, 
% por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones
% y el tiempo total que duran todas las canciones debería ser menor a 15.

tiempoTotalMenorA(Vocaloid,N):-
    findall(Duracion,canta(Vocaloid,cancion(_,Duracion)),Duraciones),
    sum_list(Duraciones, Total),
    Total < N.

tiempoTotalMayorA(Vocaloid,N):-
    findall(Duracion,canta(Vocaloid,cancion(_,Duracion)),Duraciones),
    sum_list(Duraciones, Total),
    Total > N.

esNovedoso(Vocaloid):-
    vocaloid(Vocaloid),
    canta(Vocaloid,cancion(_,_)),
    canta(Vocaloid,cancion(_,_)),
    tiempoTotalMenorA(Vocaloid,15).

% Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta,
% es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos.
% Resolver sin usar forall/2.

esAcelerado(Vocaloid):- 
    canta(Vocaloid,cancion(_,_)),
    not((canta(Vocaloid,cancion(_,Duracion)),Duracion > 4)).

% Además de los vocaloids, conocemos información acerca de varios conciertos que se darán en un futuro no muy lejano. 
% De cada concierto se sabe su nombre, el país donde se realizará, una cantidad de fama y el tipo de concierto.

% concierto(Nombre,Pais,Fama,Tipo).
% gigante(MinimoC,MayorA).
% mediano(MenorA).
% pequeño(MayorA).

% Hay tres tipos de conciertos:
% - gigante del cual se sabe la cantidad mínima de canciones que el cantante tiene que saber y 
%   además la duración total de todas las canciones tiene que ser mayor a una cantidad dada.
cantidadCanciones(Vocaloid,Cantidad):-
    vocaloid(Vocaloid),
    findall(Cancion,canta(Vocaloid,cancion(Cancion,_)),Canciones),
    length(Canciones,Cantidad).

cumpleCondiciones(Vocaloid,gigante(MinimoC,MayorA)):-
    vocaloid(Vocaloid),
    cantidadCanciones(Vocaloid,Cantidad),
    Cantidad >= MinimoC,
    tiempoTotalMayorA(Vocaloid,MayorA).

% - mediano sólo pide que la duración total de las canciones del cantante sea menor a una cantidad determinada.

cumpleCondiciones(Vocaloid,mediano(Maximo)):-
    vocaloid(Vocaloid),
    cantidadCanciones(Vocaloid,Cantidad),
    Cantidad < Maximo.
    
% - pequeño el único requisito es que alguna de las canciones dure más de una cantidad dada.

cumpleCondiciones(Vocaloid,pequenio(Minimo)):- 
    vocaloid(Vocaloid),
    canta(Vocaloid,cancion(_,Duracion)),
    Duracion >= Minimo.


% Miku Expo, es un concierto gigante que se va a realizar en Estados Unidos, 
% le brinda 2000 de fama al vocaloid que pueda participar en él y pide que el vocaloid sepa más de 2 canciones y el tiempo mínimo de 6 minutos.
concierto(mikuExpo, eeuu, 2000, gigante(2,6)).

% Magical Mirai, se realizará en Japón y también es gigante, pero da una fama de 3000 y 
% pide saber más de 3 canciones por cantante con un tiempo total mínimo de 10 minutos. 
concierto(magicalMirai, japon, 3000, gigante(3,10)).

% Vocalekt Visions, se realizará en Estados Unidos y es mediano brinda 
% 1000 de fama y exige un tiempo máximo total de 9 minutos.
concierto(vocalektVisions, eeuu, 1000, mediano(9)).

% Miku Fest, se hará en Argentina y es un concierto pequeño que solo da 100 de fama al vocaloid que participe en él, 
% con la condición de que sepa una o más canciones de más de 4 minutos.
concierto(mikuFest, argentina, 100, pequenio(4)).

pais(Pais):-concierto(_,Pais,_,_).
esConcierto(Nombre):-concierto(Nombre,_,_,_).

% Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. 
% También sabemos que Hatsune Miku puede participar en cualquier concierto.

puedeParticipar(Vocaloid,Nombre):-
    vocaloid(Vocaloid),
    concierto(Nombre, _, _, Tipo),
    cumpleCondiciones(Vocaloid,Tipo).

puedeParticipar(hatsuneMiku,_).