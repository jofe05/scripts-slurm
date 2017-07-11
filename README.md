# README #

## Esta versión de los scripts upgraded, están modificados para: ##

## Para ejecuciones 1 instancia - Multithread##

* Tener en cuenta el tiempo de carga de los mappers.
* Resultados más estable con ficheros que son 5 veces el tamaño original. 
* Saber la fecha en la que entran en el sistema.


## Para ejecuciones multiples instancias - Multithread##

* Aislar posible interferencia del sistema de archivo, replicando los datos de entrada y el genoma. 
* Tener en cuenta el tiempo de carga de los mappers.
* Resultados más estable con ficheros que son 5 veces el tamaño original. 
* Saber la fecha en la que entran en el sistema.


### Mappers Used ###

* BWA
* Bowtie
* GEM
* Snap
* NovoAlign


### Test Performed ###

* Scalability
* Locality
* Interleave
* Partitioning
