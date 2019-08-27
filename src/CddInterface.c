/*
 * CddInterface: Gap interface to Cdd package
 */

#include "src/compiled.h" /* GAP headers */
#include "../current_cddlib/lib-src/setoper.h"
#include "../current_cddlib/lib-src/cdd.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>

/**********************************************************
*
*    Auxiliary functions to be used inside C 
* 
* ********************************************************/
static long int result[dd_linelenmax];
static mytype value;

static void reset_global_variables(){
  memset(result, 0, 1 );
  dd_init( value );
}

extern void dd_SetLinearity(dd_MatrixPtr, char *);

// Old implementation
// Obj MPZ_TO_GAPOBJ(mpz_t x)
// {
//   //gmp_printf ("%s is an mpz %Zd\n", "here", x);
//   return INTOBJ_INT(mpz_get_si(x));
// }

// The following conversion has been taken from
// https://github.com/gap-packages/NormalizInterface/src
// Thanks to Sebastian Gutsche
static Obj MPZ_TO_GAPOBJ( const mpz_t x)
{
    Obj res;
    Int size = x->_mp_size;
    int sign;
    
    if (size == 0) {
        return INTOBJ_INT(0);
    } else if (size < 0) {
        size = -size;
        sign = -1;
    } else {
        sign = +1;
    }
    if (size == 1) {
        res = ObjInt_UInt(x->_mp_d[0]);
        if (sign < 0)
            res = AInvInt(res);
    } else {
        size = sizeof(mp_limb_t) * size;
        if (sign > 0)
            res = NewBag(T_INTPOS, size);
        else
            res = NewBag(T_INTNEG, size);
        memcpy(ADDR_INT(res), x->_mp_d, size);
    }
    return res;
}

static Obj MPQ_TO_GAPOBJ(const mpq_t x)
{
  mpz_t num, den;
  //gmp_printf ("a hex rational: %#40Qx\n", x);
  mpz_init(num);
  mpz_init(den);
  mpq_get_num(num, x);
  mpq_get_den(den, x);
  return QUO(MPZ_TO_GAPOBJ(num), MPZ_TO_GAPOBJ(den));
}

/**********************************************************
*
*    Converting functions
* 
* ********************************************************/


//
static dd_MatrixPtr ddG_PolyInput2Matrix(int k_rep, int k_numtype, int k_linearity, dd_rowrange k_rowrange,
                                  dd_colrange k_colrange, char k_linearity_arrayx[dd_linelenmax],
                                  char k_matrixx[], int k_LPobject, char k_rowvecx[dd_linelenmax])
{

  char numbtype[dd_linelenmax], k_value[dd_linelenmax];
  char *pch;
  int u;
  dd_MatrixPtr M = NULL;
  dd_RepresentationType rep;
  dd_NumberType NT;
  mytype rational_value;

  // // creating the matrix with these two dimesnions
  M = dd_CreateMatrix(k_rowrange, k_colrange);
  // controling if the given representation is H or V.
  if (k_rep == 2)
  {
    rep = dd_Generator;
  }
  else if (k_rep == 1)
  {
    rep = dd_Inequality;
  }
  else
  {
    rep = dd_Unspecified;
  }

  M->representation = rep;
  //
  // controling the numbertype in the matrix
  if (k_numtype == 3)
  {
    strcpy(numbtype, "integer");
  }
  else if (k_numtype == 2)
  {
    strcpy(numbtype, "rational");
  }
  else if (k_numtype == 1)
  {
    strcpy(numbtype, "real");
  }
  else
  {
    strcpy(numbtype, "unspecified");
  }

  NT = dd_GetNumberType(numbtype);
  //
  M->numbtype = NT;
  //
  //  controling the linearity of the given polygon.
  if (k_linearity == 1)
  {
    dd_SetLinearity(M, k_linearity_arrayx);
  }
  //
  // // filling the matrix with elements scanned from the string k_matrix
  //
  
  pch = strtok(k_matrixx, " ,.{}][");
  int uu,vv;
  
  for (uu = 0; uu < k_rowrange; uu++){
  for (vv = 0; vv < k_colrange; vv++){
  	//fprintf(stdout, "uu:%d: ", uu );
  	//fprintf(stdout, "vv:%d: ", vv );

    	strcpy(k_value, pch);
    	dd_init(rational_value);
    	dd_sread_rational_value(k_value, rational_value);
    	dd_set(value, rational_value);
    	dd_set(M->matrix[uu][vv], value);
    	dd_clear(rational_value);
    	pch = strtok(NULL, " ,.{}][");
  }
  } 

  if (k_LPobject == 0)
  {
    M->objective = dd_LPnone;
  }
  else if (k_LPobject == 1)
  {
    M->objective = dd_LPmax;
  }
  else
  {
    M->objective = dd_LPmin;
  }

  if (k_LPobject == 1 || k_LPobject == 2)
  {
    pch = strtok(k_rowvecx, " ,.{}][");
    for (u = 0; u < M->colsize; u++)
    {
      strcpy(k_value, pch);
      dd_init(rational_value);
      dd_sread_rational_value(k_value, rational_value);
      dd_set(value, rational_value);
      dd_clear(rational_value);
      dd_set(M->rowvec[u], value);
      pch = strtok(NULL, " ,.{}][");
    }
  }

  return M;
}

static dd_rowrange ddG_RowSize(dd_MatrixPtr M)
{
  return M->rowsize;
}

static dd_colrange ddG_ColSize(dd_MatrixPtr M)
{
  return M->colsize;
}

static dd_rowset ddG_RowSet(dd_MatrixPtr M)
{
  return M->linset;
}

static int ddG_LinearitySize(dd_MatrixPtr M)
{
  dd_rowrange r;
  dd_rowset s;
  int i, u;

  r = ddG_RowSize(M);
  s = ddG_RowSet(M);

  u = 0;
  for (i = 1; i <= r; i++)
    if (set_member(i, s))
    {
      u = u + 1;
    }

  return u;
}

static Obj ddG_LinearityPtr(dd_MatrixPtr M)
{
  dd_rowrange r;
  dd_rowset s;
  int i;

  r = ddG_RowSize(M);
  s = ddG_RowSet(M);

  Obj current = NEW_PLIST(T_PLIST, 16);
  for (i = 1; i <= r; i++)
    if (set_member(i, s))
      AddPlist(current, INTOBJ_INT(i));

  return current;
}



static long int *ddG_InteriorPoint(dd_MatrixPtr M)
{
  dd_rowset R, S;
  dd_rowset LL, ImL, RR, SS, Lbasis;
  dd_LPSolutionPtr lps = NULL;
  dd_ErrorType err;
  long int j, z1, z2, dim;
  mpz_t u, v;

  mpz_init(u);
  mpz_init(v);

  set_initialize(&R, M->rowsize);
  set_initialize(&S, M->rowsize);
  set_initialize(&LL, M->rowsize);
  set_initialize(&RR, M->rowsize);
  set_initialize(&SS, M->rowsize);
  set_copy(LL, M->linset); /* rememer the linset. */
  set_copy(RR, R);         /* copy of R. */
  set_copy(SS, S);         /* copy of S. */

  if (dd_ExistsRestrictedFace(M, R, S, &err))
  {
    set_uni(M->linset, M->linset, R);
    dd_FindRelativeInterior(M, &ImL, &Lbasis, &lps, &err);
    dim = M->colsize - set_card(Lbasis) - 1;
    set_uni(M->linset, M->linset, ImL);
    result[0] = dim;
    for (j = 1; j < (lps->d) - 1; j++)
    {

      mpq_get_num(u, lps->sol[j]);
      mpq_get_den(v, lps->sol[j]);
      z1 = mpz_get_si(u);
      z2 = mpz_get_si(v);

      result[2 * (j - 1) + 1] = z1;
      result[2 * (j - 1) + 2] = z2;
    }

    dd_FreeLPSolution(lps);
    set_free(ImL);
    set_free(Lbasis);
  }
  else
  {

    result[0] = -1;

    for (j = 1; j < 2 * ddG_ColSize(M) + 1; j++)
    {

      result[j] = 0;
    }
  }

  set_copy(M->linset, LL); /* restore the linset */
  set_free(LL);
  set_free(RR);
  set_free(SS);

  return result;
}

static int ddG_RepresentationType(dd_MatrixPtr M)
{
  return M->representation;
}

static int ddG_NumberType(dd_MatrixPtr M)
{
  return M->numbtype;
}

static Obj MatPtrToGapObj(dd_MatrixPtr M)
{
  Obj current, result;
  dd_Amatrix Ma;

  //dd_WriteMatrix(stdout, M);
  result = NEW_PLIST(T_PLIST_CYC, 7);

  // reading the representation of M
  current = INTOBJ_INT(ddG_RepresentationType(M));
  ASS_LIST(result, 1, current);

  // reading the number type
  current = INTOBJ_INT(ddG_NumberType(M));
  ASS_LIST(result, 2, current);

  if (ddG_LinearitySize(M) == 0)
    ASS_LIST(result, 3, INTOBJ_INT(0));
  else
    ASS_LIST(result, 3, INTOBJ_INT(1));

  current = INTOBJ_INT(ddG_RowSize(M));
  ASS_LIST(result, 4, current);

  current = INTOBJ_INT(ddG_ColSize(M));
  ASS_LIST(result, 5, current);

  int i, j, size;
  mpz_t u, v;

  ASS_LIST(result, 6, ddG_LinearityPtr(M));

  dd_rowrange r;
  dd_colrange s;

  r = ddG_RowSize(M);
  s = ddG_ColSize(M);

  Ma = M->matrix;

  size = 2 * s * r;

  current = NEW_PLIST(T_PLIST_CYC, size);

  mpz_init(u);
  mpz_init(v);

  for (i = 0; i < r; i++)
    for (j = 0; j < s; j++)
    {
      mpq_get_num(u, *(*(Ma + i) + j));
      mpq_get_den(v, *(*(Ma + i) + j));

      //gmp_printf ("%s is an mpz %Zd\n", " u = ", u);
      //gmp_printf ("%s is an mpz %Zd\n", " v = ", v);

      ASS_LIST(current, 2 * (i * s + j) + 1, MPZ_TO_GAPOBJ(u));
      ASS_LIST(current, 2 * (i * s + j) + 2, MPZ_TO_GAPOBJ(v));
    }

  ASS_LIST(result, 7, current);
  return result;
}

static dd_MatrixPtr GapInputToMatrixPtr(Obj input)
{

  int k_rep, k_numtype, k_linearity, k_rowrange, k_colrange, k_LPobject;
  char k_linearity_array[dd_linelenmax], k_rowvec[dd_linelenmax];

  // reset the global variable, before defining it again to be used in the current session.
  dd_set_global_constants();
  reset_global_variables( );

  k_rep = INT_INTOBJ(ELM_PLIST(input, 1));
  k_numtype = INT_INTOBJ(ELM_PLIST(input, 2));
  k_linearity = INT_INTOBJ(ELM_PLIST(input, 3));
  k_rowrange = INT_INTOBJ(ELM_PLIST(input, 4));
  k_colrange = INT_INTOBJ(ELM_PLIST(input, 5));
  k_LPobject = INT_INTOBJ(ELM_PLIST(input, 8));
  Obj string = ELM_PLIST(input, 7);
  if (k_colrange == 0)
  {
    ErrorMayQuit("This should not happen, please report this!", 0, 0);
  }

  int str_len = GET_LEN_STRING(string);
  //fprintf(stdout, "%d: ", str_len);
  //ErrorMayQuit( "j", 0, 0 );

  char k_matrix[str_len];
  strcpy(k_linearity_array, CSTR_STRING(ELM_PLIST(input, 6)));
  strcpy(k_matrix, CSTR_STRING(ELM_PLIST(input, 7)));
  strcpy(k_rowvec, CSTR_STRING(ELM_PLIST(input, 9)));

  return ddG_PolyInput2Matrix(k_rep, k_numtype, k_linearity, k_rowrange,
                              k_colrange, k_linearity_array, k_matrix, k_LPobject, k_rowvec);
}

static void FacesOfPolyhedron(dd_MatrixPtr M, dd_rowset R, dd_rowset S, dd_colrange mindim)
{
  dd_ErrorType err;
  dd_rowset LL, ImL, RR, SS, Lbasis;
  dd_rowrange i, iprev = 0;
  dd_colrange dim;
  dd_LPSolutionPtr lps = NULL;

  set_initialize(&LL, M->rowsize);
  set_initialize(&RR, M->rowsize);
  set_initialize(&SS, M->rowsize);
  set_copy(LL, M->linset); /* rememer the linset. */
  set_copy(RR, R);         /* copy of R. */
  set_copy(SS, S);         /* copy of S. */
  if (dd_ExistsRestrictedFace(M, R, S, &err))
  {
    set_uni(M->linset, M->linset, R);
    dd_FindRelativeInterior(M, &ImL, &Lbasis, &lps, &err);
    dim = M->colsize - set_card(Lbasis) - 1;
    set_uni(M->linset, M->linset, ImL);
    fprintf(stdout, "%ld: ", dim);
    set_fwrite(stdout, M->linset);

    if (dim > mindim)
    {
      for (i = 1; i <= M->rowsize; i++)
      {
        if (!set_member(i, M->linset) && !set_member(i, S))
        {
          set_addelem(RR, i);
          if (iprev)
          {
            set_delelem(RR, iprev);
            set_delelem(M->linset, iprev);
            set_addelem(SS, iprev);
          }
          iprev = i;
          FacesOfPolyhedron(M, RR, SS, mindim);
        }
      }
    }
  }
  else
    if (err != dd_NoError)
    {
      set_copy(M->linset, LL); /* restore the linset */
      set_free(LL);
      set_free(RR);
      set_free(SS);
    }
}

static Obj FaceWithDimAndInteriorPoint(dd_MatrixPtr N, dd_rowset R, dd_rowset S, dd_colrange mindim)
{
  dd_ErrorType err;
  dd_rowset LL, ImL, RR, SS, Lbasis;
  dd_rowrange iprev = 0;
  dd_colrange j, dim;
  dd_LPSolutionPtr lps = NULL;
  Obj result, current2, result_2;
  dd_MatrixPtr M;

  M = dd_CopyMatrix(N);

  set_initialize(&LL, M->rowsize);
  set_initialize(&RR, M->rowsize);
  set_initialize(&SS, M->rowsize);
  set_copy(LL, M->linset);
  set_copy(RR, R);
  set_copy(SS, S);

  if (dd_ExistsRestrictedFace(M, R, S, &err))
  {

    result = NEW_PLIST(T_PLIST_CYC, 3);

    set_uni(M->linset, M->linset, R);
    dd_FindRelativeInterior(M, &ImL, &Lbasis, &lps, &err);
    dim = M->colsize - set_card(Lbasis) - 1;
    set_uni(M->linset, M->linset, ImL);

    ASS_LIST(result, 1, INTOBJ_INT(dim));

    int i;
    Obj r;

    ASS_LIST(result, 2, ddG_LinearityPtr(M));

    size_t n;
    n = (lps->d) - 2;
    current2 = NEW_PLIST((n > 0) ? T_PLIST_CYC : T_PLIST, n);
    for (j = 1; j <= n; j++)
    {
      ASS_LIST(current2, j, MPQ_TO_GAPOBJ(lps->sol[j]));
    }

    ASS_LIST(result, 3, current2);

    dd_FreeLPSolution(lps);
    set_free(ImL);
    set_free(Lbasis);

    if (dim > mindim)
    {

      result_2 = NEW_PLIST(T_PLIST_CYC, 1 + M->rowsize);
      ASS_LIST(result_2, 1, result);

      for (i = 1; i <= M->rowsize; i++)
      {
        if (!set_member(i, M->linset) && !set_member(i, S))
        {
          set_addelem(RR, i);
          if (iprev)
          {
            set_delelem(RR, iprev);
            set_delelem(M->linset, iprev);
            set_addelem(SS, iprev);
          }
          iprev = i;
          r = FaceWithDimAndInteriorPoint(M, RR, SS, mindim);
          ASS_LIST(result_2, i + 1, r);
        }
        else
        {
          ASS_LIST(result_2, i + 1, INTOBJ_INT(2019));
        }
      }


      return result_2;
    }
    else
    {


      return result;
    }
  }
  else
  {
    set_copy(M->linset, LL);
    set_free(LL);
    set_free(RR);
    set_free(SS);

    return INTOBJ_INT(2019);
  }
}

/**********************************************************
*
*    functions to be called from Gap 
* 
* ********************************************************/

static Obj CddInterface_FourierElimination(Obj self, Obj main)
{
  dd_MatrixPtr M, A, G;
  dd_PolyhedraPtr poly;
  dd_ErrorType err;
  err = dd_NoError;
  dd_set_global_constants();

  M = GapInputToMatrixPtr(main);
  A = dd_FourierElimination(M, &err);
  poly = dd_DDMatrix2Poly(A, &err);
  G = dd_CopyInequalities(poly);
  return MatPtrToGapObj(G);
}

static Obj CddInterface_DimAndInteriorPoint(Obj self, Obj main)
{
  dd_MatrixPtr M;
  Obj result;

  long int *interior_point;
  int i, size;

  dd_PolyhedraPtr poly;
  dd_ErrorType err;
  err = dd_NoError;
  dd_set_global_constants();

  M = GapInputToMatrixPtr(main);
  //dd_WriteMatrix( stdout, M );
  poly = dd_DDMatrix2Poly(M, &err);
  M = dd_CopyInequalities(poly);
  //dd_WriteMatrix( stdout, M );

  interior_point = ddG_InteriorPoint(M);
  size = ddG_ColSize(M);

  result = NEW_PLIST((size > 0) ? T_PLIST_CYC : T_PLIST, size);

  ASS_LIST(result, 1, INTOBJ_INT(*(interior_point)));

  for (i = 1; i < size; i++)
  {
    ASS_LIST(result, i + 1, QUO(INTOBJ_INT(*(interior_point + 2 * i - 1)), INTOBJ_INT(*(interior_point + 2 * i))));
  }

  dd_free_global_constants();

  return result;
}

static Obj CddInterface_Canonicalize(Obj self, Obj main)
{
  dd_MatrixPtr M;
  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  dd_rowset impl_linset, redset;
  dd_rowindex newpos;
  dd_ErrorType err;
  dd_MatrixCanonicalize(&M, &impl_linset, &redset, &newpos, &err);
  dd_free_global_constants();
  return MatPtrToGapObj(M);
}

static Obj CddInterface_Compute_H_rep(Obj self, Obj main)
{
  dd_MatrixPtr M, A;
  dd_PolyhedraPtr poly;
  dd_ErrorType err;
  err = dd_NoError;
  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);

  poly = dd_DDMatrix2Poly(M, &err);
  A = dd_CopyInequalities(poly);
  dd_free_global_constants();
  return MatPtrToGapObj(A);
}

static Obj CddInterface_Compute_V_rep(Obj self, Obj main)
{
  dd_MatrixPtr M, A;
  dd_PolyhedraPtr poly;
  dd_ErrorType err;
  err = dd_NoError;
  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);

  poly = dd_DDMatrix2Poly(M, &err);
  A = dd_CopyGenerators(poly);
  dd_free_global_constants();

  return MatPtrToGapObj(A);
}

static Obj CddInterface_LpSolution(Obj self, Obj main)
{
  dd_MatrixPtr M;
  dd_ErrorType err;
  dd_LPPtr lp;
  dd_LPSolutionPtr lps;
  dd_LPSolverType solver;
  size_t n;
  dd_colrange j;
  dd_set_global_constants();
  solver = dd_DualSimplex;
  err = dd_NoError;
  Obj current, res;

  M = GapInputToMatrixPtr(main);
  lp = dd_Matrix2LP(M, &err);

  dd_LPSolve(lp, solver, &err);
  lps = dd_CopyLPSolution(lp);

  if (lps->LPS == dd_Optimal)
  {

    n = lps->d - 1;
    current = NEW_PLIST(T_PLIST_CYC, n);
    for (j = 1; j <= n; j++)
    {
      ASS_LIST(current, j, MPQ_TO_GAPOBJ(lps->sol[j]));
    }

    res = NEW_PLIST(T_PLIST_CYC, 2);
    ASS_LIST(res, 1, current);
    ASS_LIST(res, 2, MPQ_TO_GAPOBJ(lps->optvalue));

    return res;
  }

  else

    return Fail;
}

static Obj CddInterface_FacesWithDimensionAndInteriorPoints(Obj self, Obj main, Obj mindim)
{
  dd_MatrixPtr M;
  dd_rowset R, S;

  M = GapInputToMatrixPtr(main);

  set_initialize(&R, M->rowsize);
  set_initialize(&S, M->rowsize);

  return FaceWithDimAndInteriorPoint(M, R, S, INT_INTOBJ(mindim));
}

static Obj take_poly_and_give_it_back(Obj self, Obj main)
{
  dd_MatrixPtr M;
  dd_rowset R, S;

  M = GapInputToMatrixPtr(main);

  set_initialize(&R, M->rowsize);
  set_initialize(&S, M->rowsize);

  dd_WriteMatrix(stdout, M);

  FacesOfPolyhedron(M, R, S, 0);

  return INTOBJ_INT(0);
}
/******************************************************************/

typedef Obj (*GVarFunc)(/*arguments*/);

#define GVAR_FUNC_TABLE_ENTRY(srcfile, name, nparam, params) \
  {                                                          \
#name, nparam,                                           \
        params,                                              \
        (GVarFunc)name,                                      \
        srcfile ":Func" #name                                \
  }

// Table of functions to export
static StructGVarFunc GVarFuncs[] = {
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_Canonicalize, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_Compute_H_rep, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_Compute_V_rep, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_LpSolution, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_DimAndInteriorPoint, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_FourierElimination, 1, "main"),
    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", CddInterface_FacesWithDimensionAndInteriorPoints, 2, "main, mindim"),

    GVAR_FUNC_TABLE_ENTRY("CddInterface.c", take_poly_and_give_it_back, 1, "list"),

    {0} /* Finish with an empty entry */

};

/******************************************************************************
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel(StructInitInfo *module)
{
  /* init filters and functions                                          */
  InitHdlrFuncsFromTable(GVarFuncs);

  /* return success                                                      */
  return 0;
}

/******************************************************************************
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary(StructInitInfo *module)
{
  /* init filters and functions */
  InitGVarFuncsFromTable(GVarFuncs);

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
    /* postRestore = */ 0};

StructInitInfo *Init__Dynamic(void)
{
  return &module;
}
