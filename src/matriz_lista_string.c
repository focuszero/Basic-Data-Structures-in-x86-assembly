#include "matriz_lista_string.h"

matrix_t* matrixNew(uint32_t m, uint32_t n){

	matrix_t* matriz = malloc(40);

	matriz->m = m;
	matriz->n = n;
	funcPrint_t* pf = (funcPrint_t*)matrixPrint;
	matriz->print = pf;
	funcDelete_t* rmv = (funcDelete_t*)matrixDelete;
	matriz->remove = rmv;
	matriz->dataType = MATRIX;

	int tam_mat = m*n;
	matriz->data = malloc(tam_mat*8); 
	uint32_t tamFila = matriz->m;
	for(uint32_t i = 0; i < matriz->n; i++){
      for(uint32_t j = 0; j < matriz->m; j++){
      	 matriz->data[j + i*tamFila] = NULL;
      }
	}
	return matriz;
}

void matrixPrint(matrix_t* m, FILE *pFile) {

    uint32_t tamFila = m->m;
	for(uint32_t i = 0; i < m->n; i++){
		for(uint32_t j = 0; j < m->m; j++){
			fprintf(pFile, "%s", "|");
            element_t* d = m->data[j + i*tamFila];
            if(d == NULL){
                fprintf(pFile,"NULL");
            }else{
                d->print(d,pFile);
            }
		}
		fprintf(pFile, "%s","|\n");	
	}
}




