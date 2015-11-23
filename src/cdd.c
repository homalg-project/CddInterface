//gcc -g -I/usr/local/include -L/usr/local/lib -DGMPRATIONAL main.c -lcddgmp -lgmp

// gdb a.out
// run, help run, step, etc ...

#include "setoper.h"
#include "cdd.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>



char* A2String(int *n, int size)
{
        static char s1[dd_linelenmax],s[dd_linelenmax]= "";
        int i;
        strcat(s, " ");
        for( i=0;i<size;i++)
           {
           sprintf(s1, "%d", *(n+i) );
           strcat(s,s1);
           strcat(s, " ");
           } 
        return s;
}


dd_MatrixPtr ddG_CanonicalizeMatrix( dd_MatrixPtr M)
{
  dd_MatrixPtr N=M;
  dd_rowset impl_linset, redset;
  dd_rowindex newpos;
  dd_ErrorType err;
  dd_MatrixCanonicalize(&N, &impl_linset, &redset, &newpos, &err);
  
  return N;
}





dd_MatrixPtr ddG_PolyInput2Matrix (int k_rep, int k_numtype,int k_linearity, dd_rowrange k_rowrange, 
                         dd_colrange k_colrange,char k_linearity_array[100],char k_matrix[100],
                         int k_LPobject, char k_rowvec[100])
                                  
{
char numbtype[100], k_value[100], k_matrixx[100],k_linearity_arrayx[100], k_rowvecx[100];
dd_MatrixPtr M=NULL;
 dd_rowrange m_input,i;
 dd_colrange d_input,j;
 dd_RepresentationType rep;
 dd_boolean found=dd_FALSE, newformat=dd_FALSE, successful=dd_FALSE, linearity=dd_FALSE;
 dd_NumberType NT;
 dd_LPObjectiveType ob;
 mytype rational_value;
 static mytype value;
 char * pch;
 div_t z;
 int u;
 
 strcpy( k_matrixx, k_matrix);
 strcpy( k_linearity_arrayx, k_linearity_array );
 strcpy( k_rowvecx, k_rowvec );
// 
// #if !defined(GMPRATIONAL)
//   double rvalue;
// #endif
// 
// // creating the matrix with these two dimesnions
   M=dd_CreateMatrix(k_rowrange, k_colrange);
//   
// 
 // controling if the given representation is H or V.
   if( k_rep == 2 ) {
       rep=dd_Generator; newformat=dd_TRUE;
     } else if (k_rep == 1)
     {
       rep=dd_Inequality; newformat=dd_TRUE;
     } else 
     {
       rep=dd_Unspecified; newformat=dd_TRUE;
     }
 
   M->representation=rep;
//   
// controling the numbertype in the matrix
// this may seem silly, but it should be so for compatiblity with cdd.
   if (k_numtype==3) {  
   strcpy(numbtype, "integer");
   } else if (k_numtype==2) { 
     strcpy(numbtype, "rational");
   } else if (k_numtype==1) {
     strcpy(numbtype, "real");}
     else { strcpy(numbtype, "unspecified");}
 
   NT=dd_GetNumberType(numbtype);
//   
   M->numbtype=NT;
//   
//  controling the linearity of the given polygon.
   if (k_linearity==1) { 
     linearity= dd_TRUE;
     dd_SetLinearity(M,k_linearity_arrayx);
   }
//  
// // filling the matrix with elements scanned from the string k_matrix
    u=0;
    pch = strtok (k_matrixx," ,.{}][");
    while(pch != NULL) {
      
           strcpy( k_value, pch);
           dd_init( rational_value );
           dd_sread_rational_value (k_value, rational_value);
           dd_set(value,rational_value);
           dd_clear(rational_value);
           z= div(u, k_colrange );
           dd_set(M->matrix[z.quot][z.rem],value);
           u= u+1;
           pch = strtok (NULL, " ,.{}][");
       }
  successful=dd_TRUE;
  
  if (k_LPobject==0 ) { M->objective=dd_LPnone; } 
  else if ( k_LPobject == 1 ) { M->objective= dd_LPmax; } 
  else { M->objective = dd_LPmin; }
  
  
  if (k_LPobject==1 || k_LPobject==2 ) 
  {
  pch =strtok( k_rowvecx, " ,.{}][");
  for(u=0;u< M-> colsize; u++)
  {
    strcpy( k_value, pch );
    dd_init( rational_value );
    dd_sread_rational_value(k_value, rational_value );
    dd_set( value, rational_value );
    dd_clear( rational_value );
    dd_set( M->rowvec[u], value );
    pch= strtok( NULL, " ,.{}][" );
  }  
  }

  
  return M;
}





dd_LPSolutionPtr ddG_LPSolutionPtr( dd_MatrixPtr M )
{
  static dd_ErrorType err=dd_NoError;
  static dd_LPPtr lp;
  static dd_LPSolverType solver=dd_DualSimplex;
  static dd_LPSolutionPtr lps;
  
  lp=dd_Matrix2LP(M, &err);
  
  dd_LPSolve(lp, solver, &err);
  
  lps= dd_CopyLPSolution( lp );
  
  return  lps;
  
}


dd_rowrange ddG_RowSize( dd_MatrixPtr M)
{
  return M-> rowsize;
}

dd_colrange ddG_ColSize( dd_MatrixPtr M)
{
  return M-> colsize;
}

dd_rowset ddG_RowSet( dd_MatrixPtr M )
{
  return M->linset;
}



int ddG_LinearitySize( dd_MatrixPtr M )
{
  dd_rowrange r;
  dd_rowset s;
  int i,u;
  
  r= ddG_RowSize( M );
  s= ddG_RowSet( M );
  
  u=0;
  for(i=1;i<=r;i++)
    if (set_member(i, s) ) {
      u=u+1;
    }
    
    return u;
}
  

int * ddG_LinearityPtr(dd_MatrixPtr M )
{
  dd_rowrange r;
  dd_rowset s;
  int i,u;
  static int lin_array[100];
  
  r= ddG_RowSize( M );
  s= ddG_RowSet( M );
  
  u=0;
  for(i=1;i<=r;i++)
    if (set_member(i, s) ) {
      lin_array[u]=i;
      u=u+1;
    }
    
    return lin_array;
}



long int * ddG_RowVecPtr( dd_MatrixPtr M )
{
  static long int RowVec_array[100];
  static mpz_t u,v;
  int i,z1,z2;
  dd_Arow row_vector;
  mpz_init(u);mpz_init( v);
  
  row_vector=M->rowvec;
  
  for(i=0;i< M->colsize;i++)
  {
//          mpq_set(u, mpq_numref( *(row_vector+i) ) );
//          mpq_set(v, mpq_denref( *(row_vector+i) ) );
       mpq_get_num(u, *(row_vector+i) );
       mpq_get_den(v, *(row_vector+i) );
       z1=mpz_get_si( u );
       z2=mpz_get_si( v );
       RowVec_array[2*i]=z1;
       RowVec_array[2*i+1]=z2;
  }
  mpz_clear(u);mpz_clear(v);
  
  return RowVec_array;
} 







long int * ddG_AmatrixPtr( dd_MatrixPtr M )
{
  static long int Amatrix_array[100];
  dd_rowrange r;
  dd_colrange s;
  dd_Amatrix Ma;
  int r1,s1,k,i,j,z1,z2;
  mpz_t u,v;
  
  mpz_init(u);mpz_init(v);
  
  r= ddG_RowSize( M );
  s= ddG_ColSize( M );
  Ma = M->matrix;
  
   for(i=0;i<r;i++)
     for(j=0;j<s;j++)
     {
       mpq_get_num(u,  *(*(Ma+i)+j)  );
       mpq_get_den(v,  *(*(Ma+i)+j)  );
         z1=mpz_get_si( u );
         z2=mpz_get_si( v );
        Amatrix_array[2*(i*s+j)]=z1;
        Amatrix_array[2*(i*s+j)+1]=z2;
     }
 return Amatrix_array;
  
}






int ddG_RepresentationType( dd_MatrixPtr M )
{ 
  return M->representation;
}

int ddG_NumberType( dd_MatrixPtr M )
{ 
  return M->numbtype; 
}

dd_Amatrix ddG_Matrix( dd_MatrixPtr M )
{ 
  return M-> matrix;
}



int ddG_IsOptimal( dd_MatrixPtr M )
{
  static dd_LPSolutionPtr lps;
  lps = ddG_LPSolutionPtr( M );
  
  if (lps->LPS==dd_Optimal) return 1; 
    else return 0;
}

/*
long int * ddG_SolutionVector( dd_MatrixPtr M )
{
  
 static long int sol_vec[100];
 static dd_LPSolutionPtr lps;
 static mpz_t u,v;
 static dd_colrange j;
 int i, z1, z2;
 dd_Arow row_vector;
 
 lps = ddG_LPSolutionPtr( M );
  
 row_vector= lps 
}*/


  