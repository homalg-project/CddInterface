/*
 * CddInterface: Gap interface to Cdd package
 */

#include "src/compiled.h" /* GAP headers */

#include "setoper.h"
#include "cdd.h"

#include "gmp.h"

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

extern void dd_SetLinearity(dd_MatrixPtr, char *);

// The following conversion has been taken from
// https://github.com/gap-packages/NormalizInterface
// Thanks to Max Horn
static Obj MPZ_TO_GAPOBJ(const mpz_t x)
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
  Obj num = MPZ_TO_GAPOBJ(mpq_numref(x));
  Obj den = MPZ_TO_GAPOBJ(mpq_denref(x));
  return QUO(num, den);
}

static void GAPOBJ_TO_MPZ(mpz_t out, Obj x)
{
    if (IS_INTOBJ(x)) {
        mpz_set_si(out, INT_INTOBJ(x));
    }
    else if (TNUM_OBJ(x) == T_INTPOS || TNUM_OBJ(x) == T_INTNEG) {
        UInt    size = SIZE_INT(x);
        mpz_realloc2(out, size * GMP_NUMB_BITS);
        memcpy(out->_mp_d, ADDR_INT(x), sizeof(mp_limb_t) * size);
        out->_mp_size = (TNUM_OBJ(x) == T_INTPOS) ? (Int)size : -(Int)size;
    }
    else {
        ErrorMayQuit("expected a GAP integer object", 0, 0);
    }
}

static void GAPOBJ_TO_MPQ(mpq_t out, Obj x)
{
    if (IS_INTOBJ(x)) {
        mpq_set_si(out, INT_INTOBJ(x), 1);
    }
    else if (TNUM_OBJ(x) == T_INTPOS || TNUM_OBJ(x) == T_INTNEG) {
        GAPOBJ_TO_MPZ(mpq_numref(out), x);
        mpz_set_si(mpq_denref(out), 1);
    }
    else if (TNUM_OBJ(x) == T_RAT) {
        GAPOBJ_TO_MPZ(mpq_numref(out), NUM_RAT(x));
        GAPOBJ_TO_MPZ(mpq_denref(out), DEN_RAT(x));
    }
    else {
        ErrorMayQuit("expected a GAP integer or rational object", 0, 0);
    }
}

/**********************************************************
*
*    Converting functions
* 
* ********************************************************/

static Obj ddG_LinearityPtr(dd_MatrixPtr M)
{
  dd_rowrange r;
  dd_rowset s;
  int i;

  r = M->rowsize;
  s = M->linset;

  Obj current = NEW_PLIST(T_PLIST, 16);
  for (i = 1; i <= r; i++)
    if (set_member(i, s))
      AddPlist(current, INTOBJ_INT(i));

  return current;
}

static Obj ddG_InteriorPoint(dd_MatrixPtr M)
{
  dd_rowset R, S;
  dd_rowset LL, ImL, RR, SS, Lbasis;
  dd_LPSolutionPtr lps = NULL;
  dd_ErrorType err;
  long int j, dim;

  set_initialize(&R, M->rowsize);
  set_initialize(&S, M->rowsize);
  set_initialize(&LL, M->rowsize);
  set_initialize(&RR, M->rowsize);
  set_initialize(&SS, M->rowsize);
  set_copy(LL, M->linset); /* rememer the linset. */
  set_copy(RR, R);         /* copy of R. */
  set_copy(SS, S);         /* copy of S. */

  Obj result;

  if (dd_ExistsRestrictedFace(M, R, S, &err))
  {
    set_uni(M->linset, M->linset, R);
    dd_FindRelativeInterior(M, &ImL, &Lbasis, &lps, &err);
    dim = M->colsize - set_card(Lbasis) - 1;
    set_uni(M->linset, M->linset, ImL);

    result = NEW_PLIST(T_PLIST_EMPTY, lps->d);
    ASS_LIST(result, 1, INTOBJ_INT(dim));
    for (j = 1; j < (lps->d) - 1; j++)
    {
      ASS_LIST(result, j + 1, MPQ_TO_GAPOBJ(lps->sol[j]));
    }

    dd_FreeLPSolution(lps);
    set_free(ImL);
    set_free(Lbasis);
  }
  else
  {
    result = NEW_PLIST(T_PLIST_EMPTY, 1);
    ASS_LIST(result, 1, INTOBJ_INT(-1));
  }

  set_copy(M->linset, LL); /* restore the linset */
  set_free(LL);
  set_free(RR);
  set_free(SS);

  return result;
}

static Obj MatPtrToGapObj(dd_MatrixPtr M)
{
  Obj current, result;
  dd_Amatrix Ma;
  dd_rowrange nrRows = M->rowsize;
  dd_colrange nrCols = M->colsize;

  result = NEW_PLIST(T_PLIST_CYC, 7);

  ASS_LIST(result, 1, INTOBJ_INT(M->representation));
  ASS_LIST(result, 2, INTOBJ_INT(nrRows));
  ASS_LIST(result, 3, INTOBJ_INT(nrCols));
  ASS_LIST(result, 4, ddG_LinearityPtr(M));

  Ma = M->matrix;

  
  if (nrRows == 0)
    current = NEW_PLIST(T_PLIST_EMPTY, 0);
  else
    current = NEW_PLIST(T_PLIST_CYC, nrRows);
  
  for (int i = 0; i < nrRows; i++)
  {
    Obj row = NEW_PLIST(T_PLIST_CYC, nrCols);
    ASS_LIST(current, i+1, row);
    for (int j = 0; j < nrCols; j++)
    {
      ASS_LIST(row, j+1, MPQ_TO_GAPOBJ(Ma[i][j]));
    }
  }

  ASS_LIST(result, 5, current);
  return result;
}

static dd_MatrixPtr GapInputToMatrixPtr(Obj input)
{
  int k_rep, k_rowrange, k_colrange, k_LPobject;
  Obj k_linearity_array, k_rowvec, k_matrix;

  // reset the global variable, before defining it again to be used in the current session.
  dd_set_global_constants();

  k_rep = INT_INTOBJ(ELM_PLIST(input, 1));
  k_rowrange = INT_INTOBJ(ELM_PLIST(input, 2));
  k_colrange = INT_INTOBJ(ELM_PLIST(input, 3));
  k_linearity_array = ELM_PLIST(input, 4);
  k_matrix = ELM_PLIST(input, 5);
  k_LPobject = INT_INTOBJ(ELM_PLIST(input, 6));
  k_rowvec = ELM_PLIST(input, 7);

  if (k_colrange == 0)
    ErrorMayQuit("k_colrange == 0 should not happen, please report this!", 0, 0);

  dd_MatrixPtr M = NULL;

  // creating the matrix with the given dimensions
  M = dd_CreateMatrix(k_rowrange, k_colrange);

  // check whether the given representation is H or V
  if (k_rep == 2)
    M->representation = dd_Generator;
  else if (k_rep == 1)
    M->representation = dd_Inequality;
  else
    M->representation = dd_Unspecified;

  // set the numbertype of the matrix
  M->numbtype = dd_Rational;

  // set the linearity of the given polygon
  const Int len = LEN_LIST(k_linearity_array);
  for (int i = 1; i <= len; i++)
  {
    Obj val = ELM_LIST(k_linearity_array, i);
    set_addelem(M->linset, INT_INTOBJ(val));
  }

  // fill the matrix with elements scanned from the GAP matrix k_matrix
  for (int uu = 0; uu < k_rowrange; uu++){
    Obj row = ELM_LIST(k_matrix, uu + 1);
    for (int vv = 0; vv < k_colrange; vv++){
      Obj val = ELM_LIST(row, vv + 1);
      GAPOBJ_TO_MPQ(M->matrix[uu][vv], val);
    }
  }

  if (k_LPobject == 0)
    M->objective = dd_LPnone;
  else if (k_LPobject == 1)
    M->objective = dd_LPmax;
  else
    M->objective = dd_LPmin;

  if (M->objective == dd_LPmax || M->objective == dd_LPmin)
  {
    for (int u = 0; u < M->colsize; u++)
    {
      Obj val = ELM_LIST(k_rowvec, u + 1);
      GAPOBJ_TO_MPQ(M->rowvec[u], val);
    }
  }

  return M;
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
  dd_ErrorType err = dd_NoError;

  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  A = dd_FourierElimination(M, &err);
  poly = dd_DDMatrix2Poly(A, &err);
  G = dd_CopyInequalities(poly);
  dd_free_global_constants();
  return MatPtrToGapObj(G);
}

static Obj CddInterface_DimAndInteriorPoint(Obj self, Obj main)
{
  dd_MatrixPtr M;
  Obj result;
  dd_PolyhedraPtr poly;
  dd_ErrorType err = dd_NoError;

  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  poly = dd_DDMatrix2Poly(M, &err);
  M = dd_CopyInequalities(poly);
  result = ddG_InteriorPoint(M);
  dd_free_global_constants();
  return result;
}

static Obj CddInterface_Canonicalize(Obj self, Obj main)
{
  dd_MatrixPtr M;
  dd_rowset impl_linset, redset;
  dd_rowindex newpos;
  dd_ErrorType err = dd_NoError;

  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  dd_MatrixCanonicalize(&M, &impl_linset, &redset, &newpos, &err);
  dd_free_global_constants();
  return MatPtrToGapObj(M);
}

static Obj CddInterface_Compute_H_rep(Obj self, Obj main)
{
  dd_MatrixPtr M, A;
  dd_PolyhedraPtr poly;
  dd_ErrorType err = dd_NoError;

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
  dd_ErrorType err = dd_NoError;

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
  dd_ErrorType err = dd_NoError;
  dd_LPPtr lp;
  dd_LPSolutionPtr lps;
  dd_LPSolverType solver = dd_DualSimplex;
  size_t n;
  dd_colrange j;
  Obj current, res;

  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  lp = dd_Matrix2LP(M, &err);
  dd_LPSolve(lp, solver, &err);
  lps = dd_CopyLPSolution(lp);
  dd_free_global_constants();

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
  }
  else
    res = Fail;


  return res;
}

static Obj CddInterface_FacesWithDimensionAndInteriorPoints(Obj self, Obj main, Obj mindim)
{
  dd_MatrixPtr M;
  dd_rowset R, S;
  Obj result;

  dd_set_global_constants();
  M = GapInputToMatrixPtr(main);
  set_initialize(&R, M->rowsize);
  set_initialize(&S, M->rowsize);
  result = FaceWithDimAndInteriorPoint(M, R, S, INT_INTOBJ(mindim));
  dd_free_global_constants();
  return result;
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
