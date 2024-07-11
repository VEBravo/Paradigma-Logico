necesidad(respiracion,fisiologico).
necesidad(alimentacion,fisiologico).
necesidad(descanso,fisiologico).
necesidad(reproduccion,fisiologico).
necesidad(limpiarCabeza,fisiologico).

necesidad(integridad,seguridad).
necesidad(empleo,seguridad).
necesidad(salud,seguridad).

necesidad(amistad,social).
necesidad(afecto,social).
necesidad(intimidad,social).
necesidad(liberacion,social).
necesidad(emparche,social).

necesidad(confianza,reconocimiento).
necesidad(respeto,reconocimiento).
necesidad(exito,reconocimiento).

necesidad(dinero,autorrealizacion).
necesidad(jugarFutbol,autorrealizacion).
necesidad(jugarPlay,autorrealizacion).

nivelSuperior(autorrealizacion,reconocimiento).
nivelSuperior(reconocimiento,social).
nivelSuperior(social,seguridad).
nivelSuperior(seguridad,fisiologico).

separacionEntreNiveles(N,N,0).
separacionEntreNiveles(NB,NA,Separacion):-
    nivelSuperior(NB,NC),
    separacionEntreNiveles(NC,NA,Aux),
    Separacion is Aux + 1.

separacionEntreNiveles(NA,NB,Separacion):-
    nivelSuperior(NB,NC),
    separacionEntreNiveles(NC,NA,Aux),
    Separacion is Aux + 1.

separacion(Necesidad1,Necesidad2,Separacion):-
    necesidad(Necesidad1,NA),
    necesidad(Necesidad2,NB),
    separacionEntreNiveles(NA,NB,Separacion).

necesita(carla,alimentacion).
necesita(carla,descanso).
necesita(carla,empleo).

necesita(juan,respeto).
necesita(juan,exito).

necesita(roberto,amigos(1000000)).
necesita(manuel,objeto(bandera,liberacion)).
necesita(charly,emparche).
necesita(charly,limpiarCabeza).

queNecesita(Persona,Necesidad):-
    necesita(Persona,Necesidad),
    necesidad(Necesidad,_).

queNecesita(Persona,amistad):-
    necesita(Persona,amigos(_)).

queNecesita(Persona,Necesidad):-
    necesita(Persona,objeto(_,Necesidad)).

% PRO GENERADOR DE
persona(Persona):-
    necesita(Persona,_).

nivel(Nivel):-
    necesidad(_,Nivel).

jerarquiaNivel(Nivel,Jerarquia):-
    separacionEntreNiveles(Nivel,fisiologico,Jerarquia).

necesidadMayorJerarquia(Persona,NecesidadMayor):-
    queNecesita(Persona,NecesidadMayor),
    necesidad(NecesidadMayor,NivelMayor),
    jerarquiaNivel(NivelMayor,JerarquiaMayor),
    forall((necesita(Persona,OtraNecesidad),necesidad(OtraNecesidad,OtroNivel),jerarquiaNivel(OtroNivel,OtraJerarquia),
            OtraNecesidad \= NecesidadMayor),JerarquiaMayor > OtraJerarquia).

pudoSatisfacer(Persona,Nivel):-
    persona(Persona),
    nivel(Nivel),
    forall(queNecesita(Persona,Necesidad),not(necesidad(Necesidad,Nivel))).

seCumpleMaslow(Persona):-
    persona(Persona),
    forall(queNecesita(Persona,Necesidad),(necesidad(Necesidad,NivelSup),nivelSuperior(NivelSup,NivelInf),pudoSatisfacer(Persona,NivelInf))).

seCumpleTodos :- forall(persona(Persona),seCumpleMaslow).

laMayoriaCumpleMaslow():-
    mayoria(Mayoria),
    findall(Cumple,seCumpleMaslow(Cumple),Cumplidores),
    length(Cumplidores,CantCumplen),
    CantCumplen >= Mayoria.

mayoria(Mayoria):-
    findall(Persona,persona(Persona),PersonasRepe),
    list_to_set(PersonasRepe,Personas),
    length(Personas,Cant),
    Mayoria is (Cant//2) + 1.

%7
% La riqueza no consiste en tener muchas posesiones, sino en tener pocas carencias

El polimorfismo me permite modelar mejor los hechos, hacerlos mas expresivos. Como consecuencia de trabajar un mismo predicado con distintos
   functores, debo recurrir a predicados auxiliares en los que utilizo pattern matching para poder discriminar por functor. Tambien, gracias a esto,
   si en un futuro quiero agregar mas functores para representar distintas cosas, se puede construir sobre el codigo. No deberia ser necesaria modificar
   caloriasTotales/2.