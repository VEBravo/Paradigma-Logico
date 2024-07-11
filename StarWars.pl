%apareceEn( Personaje, Episodio, Lado de la luz).
apareceEn( luke, elImperioContrataca, luminoso).
apareceEn( luke, unaNuevaEsperanza, luminoso).
apareceEn( vader, unaNuevaEsperanza, oscuro).
apareceEn( vader, laVenganzaDeLosSith, luminoso).
apareceEn( vader, laAmenazaFantasma, luminoso).
apareceEn( c3po, laAmenazaFantasma, luminoso).
apareceEn( c3po, unaNuevaEsperanza, luminoso).
apareceEn( c3po, elImperioContrataca, luminoso).
apareceEn( chewbacca, elImperioContrataca, luminoso).
apareceEn( yoda, elAtaqueDeLosClones, luminoso).
apareceEn( yoda, laAmenazaFantasma, luminoso).

%Maestro(Personaje)
maestro(luke).
maestro(leia).
maestro(vader).
maestro(yoda).
maestro(rey).
maestro(duku).

%caracterizacion(Personaje,Aspecto).
%aspectos:
% ser(Especie,Tamaño)
% humano
% robot(Forma)
caracterizacion(chewbacca,ser(wookiee,10)).
caracterizacion(luke,humano).
caracterizacion(vader,humano).
caracterizacion(yoda,ser(desconocido,5)).
caracterizacion(jabba,ser(hutt,20)).
caracterizacion(c3po,robot(humanoide)).
caracterizacion(bb8,robot(esfera)).
caracterizacion(r2d2,robot(secarropas)).

%elementosPresentes(Episodio, Dispositivos)
elementosPresentes(laAmenazaFantasma, [sableLaser]).
elementosPresentes(elAtaqueDeLosClones, [sableLaser, clon]).
elementosPresentes(laVenganzaDeLosSith, [sableLaser, mascara, estrellaMuerte]).
elementosPresentes(unaNuevaEsperanza, [estrellaMuerte, sableLaser, halconMilenario]).
elementosPresentes(elImperioContrataca, [mapaEstelar, estrellaMuerte] ).

% El orden de los episodios se representa de la siguiente manera:
%precede(EpisodioAnterior,EpisodioSiguiente)
precedeA(laAmenazaFantasma,elAtaqueDeLosClones).
precedeA(elAtaqueDeLosClones,laVenganzaDeLosSith).
precedeA(laVenganzaDeLosSith,unaNuevaEsperanza).
precedeA(unaNuevaEsperanza,elImperioContrataca).

/*
En particular, se busca definir un predicado 
que permita relacionar a un personaje que sea el héroe del episodio con su correspondiente villano,
junto con un personaje extra que le aporta mística y un dispositivo especial que resulta importante para la trama.
*/

% Las condiciones que deben cumplirse simultáneamente son las siguientes:
% No se quiere innovar tanto, los personajes deben haber aparecido en alguno de los episodios anteriores y obviamente ser diferentes.
% Para mantener el espíritu clásico, el héroe tiene que ser un jedi (un maestro que estuvo alguna vez en el lado luminoso) que nunca se haya pasado al lado oscuro. 
% El villano debe haber estado en más de un episodio y tiene que mantener algún rasgo de ambigüedad, 
% por lo que se debe garantizar que haya aparecido del lado luminoso en algún episodio y del lado oscuro en el mismo episodio o en un episodio posterior.  
% El extra tiene que ser un personaje de aspecto exótico para mantener la estética de la saga. Tiene que tener un vínculo estrecho con los protagonistas, 
% que consiste en que haya estado junto al heroe o al villano en todos los episodios en los que dicho extra apareció. 
% Se considera exótico a los robots que no tengan forma de esfera y a los seres de gran tamaño (mayor a 15) o de especie desconocida.
% El dispositivo tiene que ser reconocible por el público, por lo que tiene que ser un elemento que haya estado presente en muchos episodios (3 o más)

epAnterior(Ep1,Ep2):-precedeA(Ep1,Ep2).
epAnterior(Ep1,Ep2):-precedeA(Ep1,Aux), epAnterior(Aux,Ep2).

aparecioEpAnterior(Heroe,Villano,Extra):-
    apareceEn(Heroe,_,_),
    apareceEn(Villano,_,_),
    apareceEn(Extra,_,_).

sonDiferentes(Heroe,Villano,Extra):-
    Heroe \= Villano,
    Villano \= Extra,
    Extra \= Heroe.

esJedi(Heroe):-
    maestro(Heroe),
    apareceEn(Heroe,_,luminoso),
    not(apareceEn(Heroe,_,oscuro)).

estuvoEnMasDeUnEp(Villano):-
    apareceEn(Villano,Ep1,_),
    apareceEn(Villano,Ep2,_),
    Ep1 \= Ep2.

tieneRasgoAmbiguedad(Villano):-
    apareceEn(Villano,Ep1,luminoso),
    apareceEn(Villano,Ep2,oscuro),
    epAnterior(Ep1,Ep2).

tieneRasgoAmbiguedad(Villano):-
    apareceEn(Villano,Ep,luminoso),
    apareceEn(Villano,Ep,oscuro).

aspectoExotico(Extra):-
    caracterizacion(Extra,robot(Forma)),
    Forma \= esfera.

aspectoExotico(Extra):-
    caracterizacion(Extra,ser(_,Tam)),
    Tam > 15.

aspectoExotico(Extra):-
    caracterizacion(Extra,ser(desconocido,_)).

apareceConAlguno(Extra,Episodio,Heroe,_):- apareceEn(Extra,Episodio,_),apareceEn(Heroe,Episodio,_).
apareceConAlguno(Extra,Episodio,_,Villano):- apareceEn(Extra,Episodio,_),apareceEn(Villano,Episodio,_).

tieneVinculoEstrecho(Extra,Heroe,Villano):-
    forall(apareceEn(Extra,Episodio,_),apareceConAlguno(Extra,Episodio,Heroe,Villano)).

perteneceAEpisodio(Dispositivo,Episodio):-
    elementosPresentes(Episodio,ElementosEp),
    member(Dispositivo,ElementosEp).

dispositivoReconocible(Dispositivo):-
    elementosPresentes(_,Elementos),
    member(Dispositivo,Elementos),
    findall(Episodio,(perteneceAEpisodio(Dispositivo,Episodio)),Episodios),
    length(Episodios,L),
    L >= 3.

nuevoEpisodio(Heroe, Villano, Extra, Dispositivo):-
    aparecioEpAnterior(Heroe, Villano, Extra),
    sonDiferentes(Heroe, Villano, Extra),
    esJedi(Heroe),%un maestro que estuvo alguna vez en el lado luminoso que nunca se haya pasado al lado oscuro
    estuvoEnMasDeUnEp(Villano),
    tieneRasgoAmbiguedad(Villano),%por lo que se debe garantizar que haya aparecido del lado luminoso en algún episodio y del lado oscuro en el mismo episodio o en un episodio posterior.  
    aspectoExotico(Extra),% Se considera exótico a los robots que no tengan forma de esfera y a los seres de gran tamaño (mayor a 15) o de especie desconocida.
    tieneVinculoEstrecho(Extra,Heroe,Villano),% que consiste en que haya estado junto al heroe o al villano en todos los episodios en los que dicho extra apareció. 
    dispositivoReconocible(Dispositivo).% El dispositivo tiene que ser reconocible por el público, por lo que tiene que ser un elemento que haya estado presente en muchos episodios (3 o más)