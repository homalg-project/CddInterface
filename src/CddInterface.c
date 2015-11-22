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

static long int* iwjeiwjojdowije( int n )
{
 static long int r[100];
  int i;
  
  for( i=0;i<n;i++)
    r[i]=i*2;
  return r;
}

/*
dd_MatrixPtr GapInputToMatrixPtr( Obj rep, Obj numtype, Obj linearity, Obj rowrange, Obj colrange,
                                  Obj linearity_array, Obj matrix, Obj LPobject, Obj rowvec )

{
  int k_rep,k_numtype,k_linearity, k_rowrange, k_colrange, k_LPobject;
  char k_linearity_array[100], k_matrix[100],k_rowvec[100];
  
  k_rep= INT_INTOBJ( rep );
  k_numtype= INT_INTOBJ( numtype );
  k_linearity= INT_INTOBJ( linearity );
  k_rowrange= INT_INTOBJ( rowrange );
  k_colrange= INT_INTOBJ( colrange );
  



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

Obj CLONGINTLISTPtr_TOGAPPLIST( long int *list, size_t n )
{
  size_t i;
  Obj M;
  long int r;
  M = NEW_PLIST(T_PLIST_CYC, n);
   SET_LEN_PLIST(M, n);
  for ( i = 0; i < n; i++) {
        SET_ELM_PLIST(M, i+1, INTOBJ_INT( *(list +i) ) );
        CHANGED_BAG( M );
    }
    
  return M;
}

static long int* GAPPLIST_TOLONGINTPtr( Obj list )
{
  static long int array[100];
  int i, len;
  Obj current_obj;
  if (! IS_PLIST( list ) ) {
    ErrorMayQuit( "not a plain list", 0,0 );
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
*    testing functions to be called from Gap 
* 
* ********************************************************/

Obj take_it_and_give_it_back( Obj self, Obj list )
{
  return CLONGINTLISTPtr_TOGAPPLIST( GAPPLIST_TOLONGINTPtr(list), LEN_PLIST( list)  );
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
  
//   long int array[100]={5,8,9,3,45,3};
//   size_t i=6;
  
//   static long int * r;
//   r= iwjeiwjojdowije(6);
 /* 
  
  for( i=0;i++;i<6 )
  {
     array[i]= 4;
  }
  */
//   return CLIST_TOGAPPLIST( array, i );
return CLONGINTLISTPtr_TOGAPPLIST( iwjeiwjojdowije( 3 ), 3 );
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
