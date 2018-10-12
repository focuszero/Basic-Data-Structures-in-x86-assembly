#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>

#include "matriz_lista_string.h"
//34, 42, 13, 44, 58, 11, 92
void test_ejemplo(FILE *pfile){

	//* TESTS lista *//
	list_t* l;
	//creo lista vacia
	l = listNew();
	//agrego elementos en orden
	l = listAddFirst(l,intSet(intNew(),34));  
	l = listAddLast(l,intSet(intNew(),42));  
	l = listAddLast(l,intSet(intNew(),13));  
	l = listAddLast(l,intSet(intNew(),44)); 
	l = listAddLast(l,intSet(intNew(),58)); 
	l = listAddLast(l,intSet(intNew(),11)); 
	l = listAddLast(l,intSet(intNew(),92));  
	//imprimo lista
	listPrint(l,pfile);fprintf(pfile,"\n");	
	fprintf(pfile,"\n"); 
	//borro elementos 13 y 58
	integer_t* i;
	i = intSet(intNew(),13); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	i = intSet(intNew(),58); listRemove(l,(void*)i,(funcCmp_t*)&intCmp); intDelete(i);
	//imprimo lista
	listPrint(l,pfile); fprintf(pfile,"\n");
	fprintf(pfile,"\n");
	//borro lista
	listDelete(l);

	//* TESTS matriz *//
	matrix_t* m;
	// creo matriz de 5 filas y 4 columnas
	m = matrixNew(4,5);
	
	//asigno elementos a la matriz

	//fila 0
	m = matrixAdd(m,1,0,listAddLast(listAddLast(listAddLast(listNew(),intSet(intNew(),1)),intSet(intNew(),2)),intSet(intNew(),3)));
	m = matrixAdd(m,2,0,listAddLast(listAddLast(listAddLast(listNew(),strSet(strNew(),"SA")),strSet(strNew(),"RA")),strSet(strNew(),"SA")));
	
	//fila 1
	m = matrixAdd(m,1,1,listAddLast(listAddLast(listAddLast(listNew(),listNew()),intSet(intNew(),2)),intSet(intNew(),3)));
	m = matrixAdd(m,2,1,listAddLast(listAddLast(listAddLast(listNew(),strSet(strNew(),"SA")),strSet(strNew(),"RA")),strSet(strNew(),"SA")));
	
	//fila 2
	m = matrixAdd(m,1,2,listAddLast(listAddLast(listAddLast(listNew(),listNew()),listNew()),intSet(intNew(),3)));
	m = matrixAdd(m,2,2,listAddLast(listAddLast(listAddLast(listNew(),listAddLast(listNew(),strSet(strNew(),"SA"))),listAddLast(listNew(),strSet(strNew(),"RA"))),listAddLast(listNew(),strSet(strNew(),"SA"))));
	m = matrixAdd(m,3,2,intSet(intNew(),35));

	//fila 3
	m = matrixAdd(m,1,3,listAddLast(listAddLast(listAddLast(listNew(),listAddLast(listNew(),strSet(strNew(),"SA"))),listAddLast(listNew(),strSet(strNew(),"RA"))),listAddLast(listNew(),strSet(strNew(),"SA"))));
	m = matrixAdd(m,2,3,listAddLast(listAddLast(listAddLast(listNew(),intSet(intNew(),1)),listAddLast(listNew(),intSet(intNew(),2))),intSet(intNew(),3)));
	m = matrixAdd(m,3,3,intSet(intNew(),32));
	
	//fila 4
	m = matrixAdd(m,1,4,listAddLast(listAddLast(listNew(),listAddLast(listAddLast(listAddLast(listNew(),strSet(strNew(),"ra")),strSet(strNew(),"ra")),intSet(intNew(),33))),listAddLast(listAddLast(listAddLast(listNew(),strSet(strNew(),"ro")),strSet(strNew(),"ro")),intSet(intNew(),35))));
	m = matrixAdd(m,2,4,intSet(intNew(),8));
	m = matrixAdd(m,3,4,intSet(intNew(),31));

	//imprimo matriz
	matrixPrint(m,pfile);fprintf(pfile,"\n");

	//borro matriz
	matrixDelete(m);	 
}

int main (void){
	FILE *pfile = fopen("salida.casos.propios.txt","a");
	test_ejemplo(pfile);
	fclose(pfile);
	return 0;    
}


