/*
 * CddInterface: Gap interface to Cdd package
 */

#include "src/compiled.h"          /* GAP headers */
#include "local/pkg/CddInterface/src/nothing.c"
#include "local/pkg/CddInterface/src/cdd.c"

/**********************************************************
*
*    Auxiliary functions to be used inside C 
* 
* ********************************************************/
static  int* iwjeiwjojdowije( int n )
{
 static  int r[100];
  int i;
  
  for( i=0;i<n;i++)
    r[i]=i*2;
  return r;
}

static int * kemo( int m )
{
  static int a[100];
  int i;
  
  for( i=0;i<m;i++)
    a[i]=i*i;
  
  return a;
}


static char * RATPLIST_STR( Obj list )
{
 static char s[dd_linelenmax];
 char s1[dd_linelenmax];
  int i,n,m, current;
  Obj current_num, current_den;
  
  strcpy( s, " " );
  
  if (!IS_PLIST( list ) ){
   ErrorMayQuit( "The argument is not a list", 0,0 );
   return NULL;
  }
  
  n= LEN_PLIST( list );
  m= n/2;
  
  for(i=0;i<m;i++)
  {
    current_num = ELM_PLIST( list, 2*i+1 );
    current_den = ELM_PLIST( list, 2*i+2 );
    
    if( !IS_INTOBJ( current_num ) || !IS_INTOBJ( current_den ) ) {
      ErrorMayQuit( "no integer entries", 0, 0 );
      return NULL;
    }
//     current= INT_INTOBJ( current_num );
    sprintf(s1, "%ld/%ld", INT_INTOBJ(current_num), INT_INTOBJ(current_den) );
    strcat(s,s1);
    strcat(s, " ");
  }
  
  return s;
}

static char * PLIST_STR( Obj list )
{
 static char s[dd_linelenmax];
 char s1[dd_linelenmax];
  int i,n, current;
  Obj current_obj;
  
  strcpy( s, " " );
  if (!IS_PLIST( list ) ){
   ErrorMayQuit( "not a plain list kemo", 0,0 );
   return NULL;
  }
  
  n= LEN_PLIST( list );
  
  for(i=0;i<n;i++)
  {
    current_obj= ELM_PLIST( list, i+1 );
    if( !IS_INTOBJ( current_obj ) ) {
      ErrorMayQuit( "no integer entries", 0, 0 );
      return NULL;
    }
    current= INT_INTOBJ( current_obj );
    sprintf(s1, "%d", current );
    strcat(s,s1);
    strcat(s, " ");
  }
  
  return s;
}


static Obj MatrixPtrToGapObj( dd_MatrixPtr M )
{
  Obj current, result;
  
  result= NEW_PLIST( T_PLIST_CYC, 7);
  SET_LEN_PLIST(result, 7);
  
  current= INTOBJ_INT( ddG_RepresentationType( M ) );
  SET_ELM_PLIST(result, 1, current  ); 
  CHANGED_BAG( result );
  
  current= INTOBJ_INT( ddG_NumberType( M ) );
  SET_ELM_PLIST(result, 2, current  );
  CHANGED_BAG( result );
  
  
  if ( ddG_LinearitySize( M ) == 0) SET_ELM_PLIST(result, 3, INTOBJ_INT( 0 )  );
  else SET_ELM_PLIST(result, 3, INTOBJ_INT( 1 )  );
  CHANGED_BAG( result );
  
  current= INTOBJ_INT( ddG_RowSize( M ) );
  SET_ELM_PLIST(result, 4, current  );
  CHANGED_BAG( result );
  
   
  
  current= INTOBJ_INT( ddG_ColSize( M ) );
  SET_ELM_PLIST(result, 5, current  );
  CHANGED_BAG( result );
  
//   ErrorMayQuit( A2String( ddG_LinearityPtr( M ), 2 ), 0, 0);
//   return NULL;
  
   size_t i1, size1;
   int i, size;
   int * lin;
   
   lin =  ddG_LinearityPtr( M );
   size = ddG_LinearitySize( M );
   size1=size;
   
   current= NEW_PLIST(T_PLIST_CYC, size1 );
   SET_LEN_PLIST( current, size1 );
 
   for(i=0;i<size;i++){
     i1=i;
     SET_ELM_PLIST( current, i1+1, INTOBJ_INT( *(lin +i ) ) );
     CHANGED_BAG( current );
   }
   
  SET_ELM_PLIST(result, 6, current  );
  CHANGED_BAG( result );
  
   long int *matrix;
  
   matrix= ddG_AmatrixPtr( M );
   size= 2*ddG_ColSize( M )*ddG_RowSize( M );
   size1= size;
  
   current= NEW_PLIST(T_PLIST_CYC, size1 );
   SET_LEN_PLIST( current, size1 );
 
   for(i=0;i<size;i++){
     i1=i;
     SET_ELM_PLIST( current, i1+1, INTOBJ_INT( *(matrix + i ) ) );
     CHANGED_BAG( current );
   }
   
  SET_ELM_PLIST(result, 7, current  );
  CHANGED_BAG( result );
  
   
  
//   current= NEW_PLIST(T_PLIST_CYC, size1 );
//   SET_LEN_PLIST( current, size1 );

   
  
  
  return result;
}

static dd_MatrixPtr GapInputToMatrixPtr( Obj input )

// Obj rep, Obj numtype, Obj linearity, Obj rowrange, Obj colrange, Obj linearity_array, Obj matrix, Obj LPobject, Obj rowvec )

{
  
  int k_rep,k_numtype,k_linearity, k_rowrange, k_colrange, k_LPobject;
   char k_linearity_array[100], k_matrix[100],k_rowvec[100];
  
  dd_set_global_constants();
  
   k_rep=       INT_INTOBJ( ELM_PLIST( input , 1 ) );
   k_numtype=   INT_INTOBJ( ELM_PLIST( input , 2 ) );
   k_linearity= INT_INTOBJ( ELM_PLIST( input , 3 ) );
   k_rowrange=  INT_INTOBJ( ELM_PLIST( input , 4 ) );
   k_colrange=  INT_INTOBJ( ELM_PLIST( input , 5 ) );
   k_LPobject=  INT_INTOBJ( ELM_PLIST( input , 8 ) );
  
  if (k_numtype==3) 
   strcpy( k_matrix,          PLIST_STR( ELM_PLIST( input , 7 ) ) );
  else 
   strcpy( k_matrix,          RATPLIST_STR( ELM_PLIST( input , 7 ) ) );
    
    strcpy( k_linearity_array, PLIST_STR( ELM_PLIST( input , 6 ) ) );
    strcpy( k_rowvec,          RATPLIST_STR( ELM_PLIST( input , 9 ) ) );
    
//     ErrorMayQuit( k_matrix, 0,0 );
//     return NULL;
//    return ddG_PolyInput2Matrix( k_rep,k_numtype,k_linearity, k_rowrange, k_colrange, 
//    k_linearity_array, k_matrix, k_LPobject , k_rowvec );
  

  return ddG_PolyInput2Matrix( k_rep , k_numtype, k_linearity, k_rowrange, k_colrange, k_linearity_array, k_matrix , k_LPobject, k_rowvec  );
}       


/**********************************************************
*
*    Converting functions
* 
* ********************************************************/


Obj MPZ_TO_GAPOBJ( mpz_t x )
{
  return INTOBJ_INT ( mpz_get_si( x ) );
}

Obj MPQ_TO_GAPOBJ( mpq_t x )
{
  mpz_t num, den;
  
  mpz_init(num);mpz_init( den );
  mpq_get_num( num, x );
  mpq_get_den( den, x );
  return QUO( MPZ_TO_GAPOBJ(num), MPZ_TO_GAPOBJ(den) );
}

Obj CINTLISTPtr_TOGAPPLIST(  int *list, int n1 )
{
  size_t i,n;
  Obj M;
   int r;
   n=n1;
  M = NEW_PLIST(T_PLIST_CYC, n);
   SET_LEN_PLIST(M, n);
  for ( i = 0; i < n; i++) {
        SET_ELM_PLIST(M, i+1, INTOBJ_INT( *(list +i) ) );
        CHANGED_BAG( M );
    }
    
  return M;
}

static  int* GAPPLIST_TOINTPtr( Obj list )
{
  static  int array[100];
  int i, len;
  Obj current_obj;
  if (! IS_PLIST( list ) ) {
    ErrorMayQuit( "not a plain list saleh", 0,0 );
    return NULL;
  }
  
  len = LEN_PLIST( list );
  
  for( i=0;i<len;i++){
    current_obj= ELM_PLIST( list, i+1 );
    if ( !IS_INTOBJ( current_obj ) ) {
      ErrorMayQuit( "not integer entries",0,0 );
      return NULL; 
      
    }
  array[i]=INT_INTOBJ( current_obj );  
  }
  
  return array;
}


/**********************************************************
*
*    functions to be called from Gap 
* 
* ********************************************************/

static Obj CddInterface_Canonicalize( Obj self,Obj main )
{
  static dd_MatrixPtr M,A;
  char d[100];
  Obj linearity_array;
//   dd_ErrorType err=dd_NoError;
//  dd_PolyhedraPtr poly;
  dd_set_global_constants();
//   M =ddG_PolyInput2Matrix(2, 3, 1, 3, 3, " 2 1 3 " , " 1 1 1 0 1 1 0 2 2 ", 1, " 4 7 8 " );
  M= GapInputToMatrixPtr( main );
  
  
  
  dd_rowset impl_linset, redset;
  dd_rowindex newpos;
  dd_ErrorType err;
  dd_MatrixCanonicalize(&M, &impl_linset, &redset, &newpos, &err);
  dd_free_global_constants();
//   return MatrixPtrToGapObj( M );
  
  
  
  
  return INTOBJ_INT( 3 );
//     M= GapInputToMatrixPtr( main );
//   M= ddG_CanonicalizeMatrix( M );
//   linearity_array = ELM_PLIST( main, 4 );
//   strcpy( d, PLIST_STR(linearity_array) );
  
}

Obj take_it_and_give_it_back( Obj self, Obj list )
{
  return CINTLISTPtr_TOGAPPLIST( GAPPLIST_TOINTPtr(list), LEN_PLIST( list)  );
}



Obj TestCommandWithParams(Obj self, Obj param, Obj param2)
{
    /* simply return the first parameter */
return param; 
  
}
 
Obj TestCommand_max( Obj self, Obj param1, Obj param2 )
{
  int a,b;
  a= INT_INTOBJ( param1 );
  b= INT_INTOBJ( param2 );
  
  return INTOBJ_INT( TestKemoSum( a,b ) );
//   if (a>b) return param1; else return param2;
}

Obj testkamalove( Obj self )
{
  
//    int array[100]={5,8,9,3,45,3};
//   size_t i=6;
  
//   static  int * r;
//   r= iwjeiwjojdowije(6);
 /* 
  
  for( i=0;i++;i<6 )
  {
     array[i]= 4;
  }
  */
//   return CLIST_TOGAPPLIST( array, i );
return CINTLISTPtr_TOGAPPLIST( iwjeiwjojdowije( 3 ), 3 );
}


  
/*   
static Obj MpqToGap( mpq_t x )
{
  mpz_t num, den;
  
  mpq_get_num(num, x);
  mpq_get_num(den, x);
  
  return QUO( MpzToGAP( num ), MpzToGAP( den ) );
}*/

/******************************************************************/

typedef Obj (* GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {#name, nparam, \
   params, \
   (GVarFunc)name, \
   srcfile ":Func" #name }

// Table of functions to export
static StructGVarFunc GVarFuncs [] = {
  
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", TestCommandWithParams, 2, "param, param2"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", TestCommand_max, 2, "param1, param2"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", testkamalove, 0, ""),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", take_it_and_give_it_back, 1, "list"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_Canonicalize, 1, "main"),

    
    { 0 } /* Finish with an empty entry */

};
 
/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel( StructInitInfo *module )
{
    /* init filters and functions                                          */
    InitHdlrFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary( StructInitInfo *module )
{
    /* init filters and functions */
    InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}

/******************************************************************************
*F  InitInfopl()  . . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
 /* type        = */ MODULE_DYNAMIC,
 /* name        = */ "CddInterface",
 /* revision_c  = */ 0,
 /* revision_h  = */ 0,
 /* version     = */ 0,
 /* crc         = */ 0,
 /* initKernel  = */ InitKernel,
 /* initLibrary = */ InitLibrary,
 /* checkInit   = */ 0,
 /* preSave     = */ 0,
 /* postSave    = */ 0,
 /* postRestore = */ 0
};

StructInitInfo *Init__Dynamic( void )
{
    return &module;
}
