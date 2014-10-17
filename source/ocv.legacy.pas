(*
  *************************************************************************************************
  Project Delphi-OpenCV
  **************************************************************************************************
  Contributor:
  Laentir Valetov
  email:laex@bk.ru
  Mikhail Grigorev
  email:sleuthound@gmail.com
  **************************************************************************************************
  You may retrieve the latest version of this file at the GitHub,
  located at git://github.com/Laex/Delphi-OpenCV.git
  **************************************************************************************************
  License:
  The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
  you may not use this file except in compliance with the License. You may obtain a copy of the
  License at http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
  ANY KIND, either express or implied. See the License for the specific language governing rights
  and limitations under the License.

  Alternatively, the contents of this file may be used under the terms of the
  GNU Lesser General Public License (the  "LGPL License"), in which case the
  provisions of the LGPL License are applicable instead of those above.
  If you wish to allow use of your version of this file only under the terms
  of the LGPL License and not to allow others to use your version of this file
  under the MPL, indicate your decision by deleting  the provisions above and
  replace  them with the notice and other provisions required by the LGPL
  License.  If you do not delete the provisions above, a recipient may use
  your version of this file under either the MPL or the LGPL License.

  For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html
  **************************************************************************************************
  Warning: Using Delphi XE3 syntax!
  **************************************************************************************************
  The Initial Developer of the Original Code:
  OpenCV: open source computer vision library
  Homepage:    http://ocv.org
  Online docs: http://docs.ocv.org
  Q&A forum:   http://answers.ocv.org
  Dev zone:    http://code.ocv.org
  **************************************************************************************************
  Original file:
  opencv\modules\legacy\include\opencv2\legacy.hpp
  ************************************************************************************************* *)

//
{$I OpenCV.inc}
//
{$IFDEF DEBUG}
{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O-,P+,Q+,R+,S-,T-,U-,V+,W+,X+,Y+,Z1}
{$ELSE}
{$A8,B-,C-,D-,E-,F-,G+,H+,I+,J-,K-,L-,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y-,Z1}
{$ENDIF}
{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$IFDEF DELPHI2009_UP}
{$POINTERMATH ON}
{$ENDIF}
unit ocv.legacy;

interface

uses
  Windows,
  ocv.core.types_c,
  ocv.imgproc.types_c,
  ocv.compat;

(*
  CVAPI(CvSeq* cvSegmentImage( const CvArr* srcarr, CvArr* dstarr,
  double canny_threshold,
  double ffill_threshold,
  CvMemStorage* storage );
*)

{$EXTERNALSYM cvSegmentImage}
function cvSegmentImage(const srcarr: pCvArr; dstarr: pCvArr; canny_threshold: double; ffill_threshold: double;
  storage: pCvMemStorage): pCvSeq; cdecl;

{ ****************************************************************************************
  *                                  Eigen objects                                       *
  **************************************************************************************** }

Type
  (* typedef int (CV_CDECL * CvCallback)(int index, void* buffer, void* user_data); *)
  TCvCallback = function(index: Integer; buffer: pointer; user_data: pointer): Integer; cdecl;

  (*
    typedef union
    {
    CvCallback callback;
    void* data;
    }
    CvInput;
  *)
  TCvInput = record
    case boolean of
      True:
        (callback: TCvCallback);
      False:
        (data: pointer);
  end;

const
  CV_EIGOBJ_NO_CALLBACK     = 0;
  CV_EIGOBJ_INPUT_CALLBACK  = 1;
  CV_EIGOBJ_OUTPUT_CALLBACK = 2;
  CV_EIGOBJ_BOTH_CALLBACK   = 3;

  (* Calculates covariation matrix of a set of arrays

    CVAPI(void)  cvCalcCovarMatrixEx( int nObjects, void* input, int ioFlags,
    int ioBufSize, uchar* buffer, void* userData,
    IplImage* avg, float* covarMatrix );
  *)
{$EXTERNALSYM cvCalcCovarMatrixEx}
procedure cvCalcCovarMatrixEx(nObjects: Integer; input: pointer; ioFlags: Integer; ioBufSize: Integer; buffer: pByte;
  userData: pointer; avg: pIplImage; var covarMatrix: Single); cdecl;

(* Calculates eigen values and vectors of covariation matrix of a set of arrays

  CVAPI(void)  cvCalcEigenObjects( int nObjects, void* input, void* output,
  int ioFlags, int ioBufSize, void* userData,
  CvTermCriteria* calcLimit, IplImage* avg,
  float* eigVals );
*)
{$EXTERNALSYM cvCalcEigenObjects}
procedure cvCalcEigenObjects(nObjects: Integer; input: pointer; output: pointer; ioFlags: Integer; ioBufSize: Integer;
  userData: pointer; calcLimit: pCvTermCriteria; avg: pIplImage; eigVals: pFloat); cdecl;

(* Calculates dot product (obj - avg) * eigObj (i.e. projects image to eigen vector)

  CVAPI(double)  cvCalcDecompCoeff( IplImage* obj, IplImage* eigObj, IplImage* avg );
*)
{$EXTERNALSYM cvCalcDecompCoeff}
function cvCalcDecompCoeff(obj: pIplImage; eigObj: pIplImage; avg: pIplImage): double; cdecl;

(* Projects image to eigen space (finds all decomposion coefficients

  CVAPI(void)  cvEigenDecomposite( IplImage* obj, int nEigObjs, void* eigInput,
  int ioFlags, void* userData, IplImage* avg,
  float* coeffs );
*)
{$EXTERNALSYM cvEigenDecomposite}
procedure cvEigenDecomposite(obj: pIplImage; nEigObjs: Integer; eigInput: pointer; ioFlags: Integer; userData: pointer;
  avg: pIplImage; coeffs: pFloat); cdecl;

(* Projects original objects used to calculate eigen space basis to that space

  CVAPI(void)  cvEigenProjection( void* eigInput, int nEigObjs, int ioFlags,
  void* userData, float* coeffs, IplImage* avg,
  IplImage* proj );
*)
{$EXTERNALSYM cvEigenProjection}
procedure cvEigenProjection(eigInput: pointer; nEigObjs: Integer; ioFlags: Integer; userData: pointer; coeffs: PSingle;
  avg: pIplImage; proj: pIplImage); cdecl;
//
{ ****************************************************************************************
  *                                       1D/2D HMM                                      *
  **************************************************************************************** }

Type
  // typedef struct CvImgObsInfo
  // {
  // int obs_x;
  // int obs_y;
  // int obs_size;
  // float* obs;//consequtive observations
  //
  // int* state;(* arr of pairs superstate/state to which observation belong *)
  // int* mix;  (* number of mixture to which observation belong *)
  //
  // } CvImgObsInfo;(*struct for 1 image*)

  pCvImgObsInfo = ^TCvImgObsInfo;

  (* struct for 1 image *)
  TCvImgObsInfo = record
    obs_x: Integer;
    obs_y: Integer;
    obs_size: Integer;
    obs: PSingle; // consequtive observations
    state: PInteger; (* arr of pairs superstate/state to which observation belong *)
    mix: PInteger; (* number of mixture to which observation belong *)
  end;

  // typedef CvImgObsInfo Cv1DObsInfo;
  TCv1DObsInfo = TCvImgObsInfo;
  pCv1DObsInfo = pCvImgObsInfo;

  // typedef struct CvEHMMState
  // {
  // int num_mix;        (*number of mixtures in this state*)
  // float* mu;          (*mean vectors corresponding to each mixture*)
  // float* inv_var;     (* square root of inversed variances corresp. to each mixture*)
  // float* log_var_val; (* sum of 0.5 (LN2PI + ln(variance[i]) ) for i=1,n *)
  // float* weight;      (*array of mixture weights. Summ of all weights in state is 1. *)
  //
  // } CvEHMMState;

  pCvEHMMState = ^TCvEHMMState;

  TCvEHMMState = record
    num_mix: Integer; (* number of mixtures in this state *)
    mu: PSingle; (* mean vectors corresponding to each mixture *)
    inv_var: PSingle; (* square root of inversed variances corresp. to each mixture *)
    log_var_val: PSingle; (* sum of 0.5 (LN2PI + ln(variance[i]) ) for i=1,n *)
    weight: PSingle; (* array of mixture weights. Summ of all weights in state is 1. *)
  end;

  // typedef struct CvEHMM
  // {
  // int level; (* 0 - lowest(i.e its states are real states), ..... *)
  // int num_states; (* number of HMM states *)
  // float*  transP;(*transition probab. matrices for states *)
  // float** obsProb; (* if level == 0 - array of brob matrices corresponding to hmm
  // if level == 1 - martix of matrices *)
  // union
  // {
  // CvEHMMState* state; (* if level == 0 points to real states array,
  // if not - points to embedded hmms *)
  // struct CvEHMM* ehmm; (* pointer to an embedded model or NULL, if it is a leaf *)
  // } u;
  //
  // } CvEHMM;

  pCvEHMM = ^TCvEHMM;

  TObsProb = array [0 .. 0] of PSingle;
  pObsProb = ^TObsProb;

  TCvEHMM = record
    level: Integer; (* 0 - lowest(i.e its states are real states), ..... *)
    num_states: Integer; (* number of HMM states *)
    transP: PSingle; (* transition probab. matrices for states *)
    obsProb: pObsProb; (* if level == 0 - array of brob matrices corresponding to hmm
      if level == 1 - martix of matrices *)
    case u: byte of
      0:
        (state: pCvEHMMState); (* if level == 0 points to real states array,
        if not - points to embedded hmms *)
      1:
        (ehmm: pCvEHMM); (* pointer to an embedded model or NULL, if it is a leaf *)
  end;

  (* CVAPI(int)  icvCreate1DHMM( CvEHMM** this_hmm, int state_number, int* num_mix, int obs_size ); *)
{$EXTERNALSYM icvCreate1DHMM}

function icvCreate1DHMM(var this_hmm: pCvEHMM; state_number: Integer; Var num_mix: Integer; obs_size: Integer)
  : Integer; cdecl;

(* CVAPI(int)  icvRelease1DHMM( CvEHMM** phmm ); *)
{$EXTERNALSYM icvRelease1DHMM}
function icvRelease1DHMM(var phmm: pCvEHMM): Integer; cdecl;

(* CVAPI(int)  icvUniform1DSegm( Cv1DObsInfo* obs_info, CvEHMM* hmm ); *)
{$EXTERNALSYM icvUniform1DSegm}
function icvUniform1DSegm(var obs_info: TCv1DObsInfo; var hmm: TCvEHMM): Integer; cdecl;

(* CVAPI(int)  icvInit1DMixSegm( Cv1DObsInfo** obs_info_array, int num_img, CvEHMM* hmm); *)
{$EXTERNALSYM icvInit1DMixSegm}
function icvInit1DMixSegm(var obs_info_array: pCv1DObsInfo; num_img: Integer; var hmm: TCvEHMM): Integer; cdecl;

(* CVAPI(int)  icvEstimate1DHMMStateParams( CvImgObsInfo** obs_info_array, int num_img, CvEHMM* hmm); *)
{$EXTERNALSYM icvEstimate1DHMMStateParams}
function icvEstimate1DHMMStateParams(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM)
  : Integer; cdecl;

(* CVAPI(int)  icvEstimate1DObsProb( CvImgObsInfo* obs_info, CvEHMM* hmm ); *)
{$EXTERNALSYM icvEstimate1DObsProb}
function icvEstimate1DObsProb(var obs_info: TCvImgObsInfo; var hmm: TCvEHMM): Integer; cdecl;

(* CVAPI(int)  icvEstimate1DTransProb( Cv1DObsInfo** obs_info_array,  int num_seq,    CvEHMM* hmm ); *)
{$EXTERNALSYM icvEstimate1DTransProb}
function icvEstimate1DTransProb(var obs_info_array: pCv1DObsInfo; num_seq: Integer; var hmm: TCvEHMM): Integer; cdecl;

(* CVAPI(float)  icvViterbi( Cv1DObsInfo* obs_info, CvEHMM* hmm); *)
{$EXTERNALSYM icvViterbi}
function icvViterbi(var obs_info: TCv1DObsInfo; var hmm: TCvEHMM): Single; cdecl;

(* CVAPI(int)  icv1DMixSegmL2( CvImgObsInfo** obs_info_array, int num_img, CvEHMM* hmm ); *)
{$EXTERNALSYM icv1DMixSegmL2}
function icv1DMixSegmL2(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM): Integer; cdecl;

(* ********************************** Embedded HMMs ************************************ *)
//
(* Creates 2D HMM
  CVAPI(CvEHMM* )  cvCreate2DHMM( int* stateNumber, int* numMix, int obsSize );
*)
{$EXTERNALSYM cvCreate2DHMM}
function cvCreate2DHMM(Var stateNumber: Integer; Var numMix: Integer; obsSize: Integer): pCvEHMM; cdecl;

(* Releases HMM
  CVAPI(void)  cvRelease2DHMM( CvEHMM** hmm );
*)
{$EXTERNALSYM cvRelease2DHMM}
procedure cvRelease2DHMM(var hmm: pCvEHMM); cdecl;

(*
  #define CV_COUNT_OBS(roi, win, delta, numObs )                                    \
  {                                                                                 \
  (numObs)->width  =((roi)->width  -(win)->width  +(delta)->width)/(delta)->width;  \
  (numObs)->height =((roi)->height -(win)->height +(delta)->height)/(delta)->height;\
  }
*)

(* Creates storage for observation vectors
  CVAPI(CvImgObsInfo* )  cvCreateObsInfo( CvSize numObs, int obsSize );
*)
{$EXTERNALSYM cvCreateObsInfo}
function cvCreateObsInfo(numObs: TCvSize; obsSize: Integer): pCvImgObsInfo; cdecl;

(* Releases storage for observation vectors
  CVAPI(void)  cvReleaseObsInfo( CvImgObsInfo** obs_info );
*)
{$EXTERNALSYM cvReleaseObsInfo}
procedure cvReleaseObsInfo(var obs_info: pCvImgObsInfo); cdecl;

(* The function takes an image on input and and returns the sequnce of observations
  to be used with an embedded HMM; Each observation is top-left block of DCT
  coefficient matrix
  CVAPI(void)  cvImgToObs_DCT( const CvArr* arr, float* obs, CvSize dctSize,
  CvSize obsSize, CvSize delta );
*)
{$EXTERNALSYM cvImgToObs_DCT}
procedure cvImgToObs_DCT(const arr: pCvArr; var obs: Single; dctSize: TCvSize; obsSize: TCvSize; delta: TCvSize); cdecl;

(* Uniformly segments all observation vectors extracted from image
  CVAPI(void)  cvUniformImgSegm( CvImgObsInfo* obs_info, CvEHMM* ehmm );
*)
{$EXTERNALSYM cvUniformImgSegm}
procedure cvUniformImgSegm(var obs_info: TCvImgObsInfo; var ehmm: TCvEHMM); cdecl;

(* Does mixture segmentation of the states of embedded HMM
  CVAPI(void)  cvInitMixSegm( CvImgObsInfo** obs_info_array,
  int num_img, CvEHMM* hmm );
*)
{$EXTERNALSYM cvInitMixSegm}
procedure cvInitMixSegm(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM); cdecl;

(* Function calculates means, variances, weights of every Gaussian mixture
  of every low-level state of embedded HMM

  CVAPI(void)  cvEstimateHMMStateParams( CvImgObsInfo** obs_info_array,
  int num_img, CvEHMM* hmm );
*)
{$EXTERNALSYM cvEstimateHMMStateParams}
procedure cvEstimateHMMStateParams(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM); cdecl;

(* Function computes transition probability matrices of embedded HMM
  given observations segmentation

  CVAPI(void)  cvEstimateTransProb( CvImgObsInfo** obs_info_array,
  int num_img, CvEHMM* hmm );
*)
{$EXTERNALSYM cvEstimateTransProb}
procedure cvEstimateTransProb(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM); cdecl;

(* Function computes probabilities of appearing observations at any state
  (i.e. computes P(obs|state) for every pair(obs,state))

  CVAPI(void)  cvEstimateObsProb( CvImgObsInfo* obs_info,
  CvEHMM* hmm );
*)
{$EXTERNALSYM cvEstimateObsProb}
procedure cvEstimateObsProb(var obs_info: TCvImgObsInfo; var hmm: TCvEHMM); cdecl;

(* Runs Viterbi algorithm for embedded HMM
  CVAPI(float)  cvEViterbi( CvImgObsInfo* obs_info, CvEHMM* hmm );
*)
{$EXTERNALSYM cvEViterbi}
function cvEViterbi(var obs_info: TCvImgObsInfo; var hmm: TCvEHMM): Single; cdecl;

(* Function clusters observation vectors from several images
  given observations segmentation.
  Euclidean distance used for clustering vectors.
  Centers of clusters are given means of every mixture

  CVAPI(void)  cvMixSegmL2( CvImgObsInfo** obs_info_array,
  int num_img, CvEHMM* hmm );
*)
{$EXTERNALSYM cvMixSegmL2}
procedure cvMixSegmL2(var obs_info_array: pCvImgObsInfo; num_img: Integer; var hmm: TCvEHMM); cdecl;

{ ***************************************************************************************
  *               A few functions from old stereo gesture recognition demosions         *
  *************************************************************************************** }

(* Creates hand mask image given several points on the hand
  CVAPI(void)  cvCreateHandMask( CvSeq* hand_points,
  IplImage *img_mask, CvRect *roi);
*)
{$EXTERNALSYM cvCreateHandMask}
procedure cvCreateHandMask(var hand_points: TCvSeq; var img_mask: TIplImage; var roi: TCvRect); cdecl;

(* Finds hand region in range image data

  CVAPI(void)  cvFindHandRegion (CvPoint3D32f* points, int count,
  CvSeq* indexs,
  float* line, CvSize2D32f size, int flag,
  CvPoint3D32f* center,
  CvMemStorage* storage, CvSeq **numbers);
*)
{$EXTERNALSYM cvFindHandRegion}
procedure cvFindHandRegion(var points: TCvPoint3D32f; count: Integer; var indexs: TCvSeq; var line: Single;
  size: TCvSize2D32f; flag: Integer; var center: TCvPoint3D32f; var storage: TCvMemStorage; var numbers: pCvSeq); cdecl;

(* Finds hand region in range image data (advanced version)

  CVAPI(void)  cvFindHandRegionA( CvPoint3D32f* points, int count,
  CvSeq* indexs,
  float* line, CvSize2D32f size, int jc,
  CvPoint3D32f* center,
  CvMemStorage* storage, CvSeq **numbers);
*)
{$EXTERNALSYM cvFindHandRegionA}
procedure cvFindHandRegionA(var points: TCvPoint3D32f; count: Integer; var indexs: TCvSeq; var line: Single;
  size: TCvSize2D32f; jc: Integer; var center: TCvPoint3D32f; var storage: TCvMemStorage; var numbers: pCvSeq); cdecl;

(* Calculates the cooficients of the homography matrix

  CVAPI(void)  cvCalcImageHomography( float* line, CvPoint3D32f* center,
  float* intrinsic, float* homography );
*)
{$EXTERNALSYM cvCalcImageHomography}
procedure cvCalcImageHomography(var line: Single; var center: TCvPoint3D32f; var intrinsic: Single;
  var homography: Single); cdecl;

{ ***************************************************************************************
  *                           More operations on sequences                              *
  *************************************************************************************** }

(* *************************************************************************************** *)

// #define CV_CURRENT_INT( reader ) (*((int *)(reader).ptr))
// #define CV_PREV_INT( reader ) (*((int *)(reader).prev_elem))
//
// #define  CV_GRAPH_WEIGHTED_VERTEX_FIELDS() CV_GRAPH_VERTEX_FIELDS()\
// float weight;
//
// #define  CV_GRAPH_WEIGHTED_EDGE_FIELDS() CV_GRAPH_EDGE_FIELDS()
//
// typedef struct CvGraphWeightedVtx
// {
// CV_GRAPH_WEIGHTED_VERTEX_FIELDS()
// } CvGraphWeightedVtx;
//
// typedef struct CvGraphWeightedEdge
// {
// CV_GRAPH_WEIGHTED_EDGE_FIELDS()
// } CvGraphWeightedEdge;
//
// typedef enum CvGraphWeightType
// {
// CV_NOT_WEIGHTED,
// CV_WEIGHTED_VTX,
// CV_WEIGHTED_EDGE,
// CV_WEIGHTED_ALL
// } CvGraphWeightType;
//
//
(* Calculates histogram of a contour

  CVAPI(void)  cvCalcPGH( const CvSeq* contour, CvHistogram* hist );
*)
{$EXTERNALSYM cvCalcPGH}
procedure cvCalcPGH(const contour: pCvSeq; var hist: TCvHistogram); cdecl;

const
  CV_DOMINANT_IPAN = 1;

  (* Finds high-curvature points of the contour

    CVAPI(CvSeq* ) cvFindDominantPoints( CvSeq* contour, CvMemStorage* storage,
    int method CV_DEFAULT(CV_DOMINANT_IPAN),
    double parameter1 CV_DEFAULT(0),
    double parameter2 CV_DEFAULT(0),
    double parameter3 CV_DEFAULT(0),
    double parameter4 CV_DEFAULT(0));
  *)

function cvFindDominantPoints(contour: pCvSeq; storage: pCvMemStorage; method: Integer = CV_DOMINANT_IPAN;
  parameter1: double = 0; parameter2: double = 0; parameter3: double = 0; parameter4: double = 0): pCvSeq; cdecl;

(* *************************************************************************************** *)
//
//
(* ******************************Stereo correspondence************************************ *)
//
// typedef struct CvCliqueFinder
// {
// CvGraph* graph;
// int**    adj_matr;
// int N; //graph size
//
// // stacks, counters etc/
// int k; //stack size
// int* current_comp;
// int** All;
//
// int* ne;
// int* ce;
// int* fixp; //node with minimal disconnections
// int* nod;
// int* s; //for selected candidate
// int status;
// int best_score;
// int weighted;
// int weighted_edges;
// float best_weight;
// float* edge_weights;
// float* vertex_weights;
// float* cur_weight;
// float* cand_weight;
//
// } CvCliqueFinder;
//
// #define CLIQUE_TIME_OFF 2
// #define CLIQUE_FOUND 1
// #define CLIQUE_END   0
//
(* CVAPI(void) cvStartFindCliques( CvGraph* graph, CvCliqueFinder* finder, int reverse,
  // int weighted CV_DEFAULT(0),  int weighted_edges CV_DEFAULT(0));
  // CVAPI(int) cvFindNextMaximalClique( CvCliqueFinder* finder, int* clock_rest CV_DEFAULT(0) );
  // CVAPI(void) cvEndFindCliques( CvCliqueFinder* finder );
  //
  // CVAPI(void) cvBronKerbosch( CvGraph* graph ); *)
//
//
(* F///////////////////////////////////////////////////////////////////////////////////////
  /// /
  /// /    Name:    cvSubgraphWeight
  /// /    Purpose: finds weight of subgraph in a graph
  /// /    Context:
  /// /    Parameters:
  /// /      graph - input graph.
  /// /      subgraph - sequence of pairwise different ints.  These are indices of vertices of subgraph.
  /// /      weight_type - describes the way we measure weight.
  /// /            one of the following:
  /// /            CV_NOT_WEIGHTED - weight of a clique is simply its size
  /// /            CV_WEIGHTED_VTX - weight of a clique is the sum of weights of its vertices
  /// /            CV_WEIGHTED_EDGE - the same but edges
  /// /            CV_WEIGHTED_ALL - the same but both edges and vertices
  /// /      weight_vtx - optional vector of floats, with size = graph->total.
  /// /            If weight_type is either CV_WEIGHTED_VTX or CV_WEIGHTED_ALL
  /// /            weights of vertices must be provided.  If weight_vtx not zero
  /// /            these weights considered to be here, otherwise function assumes
  /// /            that vertices of graph are inherited from CvGraphWeightedVtx.
  /// /      weight_edge - optional matrix of floats, of width and height = graph->total.
  /// /            If weight_type is either CV_WEIGHTED_EDGE or CV_WEIGHTED_ALL
  /// /            weights of edges ought to be supplied.  If weight_edge is not zero
  /// /            function finds them here, otherwise function expects
  /// /            edges of graph to be inherited from CvGraphWeightedEdge.
  /// /            If this parameter is not zero structure of the graph is determined from matrix
  /// /            rather than from CvGraphEdge's.  In particular, elements corresponding to
  /// /            absent edges should be zero.
  /// /    Returns:
  /// /      weight of subgraph.
  /// /    Notes:
  /// /F *)
(* CVAPI(float) cvSubgraphWeight( CvGraph *graph, CvSeq *subgraph,
  // CvGraphWeightType weight_type CV_DEFAULT(CV_NOT_WEIGHTED),
  // CvVect32f weight_vtx CV_DEFAULT(0),
  // CvMatr32f weight_edge CV_DEFAULT(0) ); *)
//
//
(* F///////////////////////////////////////////////////////////////////////////////////////
  /// /
  /// /    Name:    cvFindCliqueEx
  /// /    Purpose: tries to find clique with maximum possible weight in a graph
  /// /    Context:
  /// /    Parameters:
  /// /      graph - input graph.
  /// /      storage - memory storage to be used by the result.
  /// /      is_complementary - optional flag showing whether function should seek for clique
  /// /            in complementary graph.
  /// /      weight_type - describes our notion about weight.
  /// /            one of the following:
  /// /            CV_NOT_WEIGHTED - weight of a clique is simply its size
  /// /            CV_WEIGHTED_VTX - weight of a clique is the sum of weights of its vertices
  /// /            CV_WEIGHTED_EDGE - the same but edges
  /// /            CV_WEIGHTED_ALL - the same but both edges and vertices
  /// /      weight_vtx - optional vector of floats, with size = graph->total.
  /// /            If weight_type is either CV_WEIGHTED_VTX or CV_WEIGHTED_ALL
  /// /            weights of vertices must be provided.  If weight_vtx not zero
  /// /            these weights considered to be here, otherwise function assumes
  /// /            that vertices of graph are inherited from CvGraphWeightedVtx.
  /// /      weight_edge - optional matrix of floats, of width and height = graph->total.
  /// /            If weight_type is either CV_WEIGHTED_EDGE or CV_WEIGHTED_ALL
  /// /            weights of edges ought to be supplied.  If weight_edge is not zero
  /// /            function finds them here, otherwise function expects
  /// /            edges of graph to be inherited from CvGraphWeightedEdge.
  /// /            Note that in case of CV_WEIGHTED_EDGE or CV_WEIGHTED_ALL
  /// /            nonzero is_complementary implies nonzero weight_edge.
  /// /      start_clique - optional sequence of pairwise different ints.  They are indices of
  /// /            vertices that shall be present in the output clique.
  /// /      subgraph_of_ban - optional sequence of (maybe equal) ints.  They are indices of
  /// /            vertices that shall not be present in the output clique.
  /// /      clique_weight_ptr - optional output parameter.  Weight of found clique stored here.
  /// /      num_generations - optional number of generations in evolutionary part of algorithm,
  /// /            zero forces to return first found clique.
  /// /      quality - optional parameter determining degree of required quality/speed tradeoff.
  /// /            Must be in the range from 0 to 9.
  /// /            0 is fast and dirty, 9 is slow but hopefully yields good clique.
  /// /    Returns:
  /// /      sequence of pairwise different ints.
  /// /      These are indices of vertices that form found clique.
  /// /    Notes:
  /// /      in cases of CV_WEIGHTED_EDGE and CV_WEIGHTED_ALL weights should be nonnegative.
  /// /      start_clique has a priority over subgraph_of_ban.
  /// /F *)
(* CVAPI(CvSeq* ) cvFindCliqueEx(CvGraph * graph, CvMemStorage * storage,
  // int is_complementary CV_DEFAULT(0),
  // CvGraphWeightType weight_type CV_DEFAULT(CV_NOT_WEIGHTED),
  // CvVect32f weight_vtx CV_DEFAULT(0),
  // CvMatr32f weight_edge CV_DEFAULT(0),
  // CvSeq *start_clique CV_DEFAULT(0),
  // CvSeq *subgraph_of_ban CV_DEFAULT(0),
  // float *clique_weight_ptr CV_DEFAULT(0),
  // int num_generations CV_DEFAULT(3),
  // int quality CV_DEFAULT(2) ); *)
//
//
// #define CV_UNDEF_SC_PARAM         12345 //default value of parameters
//
// #define CV_IDP_BIRCHFIELD_PARAM1  25
// #define CV_IDP_BIRCHFIELD_PARAM2  5
// #define CV_IDP_BIRCHFIELD_PARAM3  12
// #define CV_IDP_BIRCHFIELD_PARAM4  15
// #define CV_IDP_BIRCHFIELD_PARAM5  25
//
//
// #define  CV_DISPARITY_BIRCHFIELD  0
//
//
(* F///////////////////////////////////////////////////////////////////////////
  /// /
  /// /    Name:    cvFindStereoCorrespondence
  /// /    Purpose: find stereo correspondence on stereo-pair
  /// /    Context:
  /// /    Parameters:
  /// /      leftImage - left image of stereo-pair (format 8uC1).
  /// /      rightImage - right image of stereo-pair (format 8uC1).
  /// /   mode - mode of correspondence retrieval (now CV_DISPARITY_BIRCHFIELD only)
  /// /      dispImage - destination disparity image
  /// /      maxDisparity - maximal disparity
  /// /      param1, param2, param3, param4, param5 - parameters of algorithm
  /// /    Returns:
  /// /    Notes:
  /// /      Images must be rectified.
  /// /      All images must have format 8uC1.
  /// /F *)
// CVAPI(void)
// cvFindStereoCorrespondence(
// const  CvArr* leftImage, const  CvArr* rightImage,
// int     mode,
// CvArr*  dispImage,
// int     maxDisparity,
// double  param1 CV_DEFAULT(CV_UNDEF_SC_PARAM),
// double  param2 CV_DEFAULT(CV_UNDEF_SC_PARAM),
// double  param3 CV_DEFAULT(CV_UNDEF_SC_PARAM),
// double  param4 CV_DEFAULT(CV_UNDEF_SC_PARAM),
// double  param5 CV_DEFAULT(CV_UNDEF_SC_PARAM) );
//
(* *************************************************************************************** *)
(* *********** Epiline functions ****************** *)
Type
  (*
    typedef struct CvStereoLineCoeff
    {
    double Xcoef;
    double XcoefA;
    double XcoefB;
    double XcoefAB;

    double Ycoef;
    double YcoefA;
    double YcoefB;
    double YcoefAB;

    double Zcoef;
    double ZcoefA;
    double ZcoefB;
    double ZcoefAB;
    }CvStereoLineCoeff;
  *)

  pCvStereoLineCoeff = ^TCvStereoLineCoeff;

  TCvStereoLineCoeff = record
    Xcoef: double;
    XcoefA: double;
    XcoefB: double;
    XcoefAB: double;

    Ycoef: double;
    YcoefA: double;
    YcoefB: double;
    YcoefAB: double;

    Zcoef: double;
    ZcoefA: double;
    ZcoefB: double;
    ZcoefAB: double;
  end;

  (*
    typedef struct CvCamera
    {
    float   imgSize[2]; ( * size of the camera view, used during calibration * )
    float   matrix[9]; ( * intinsic camera parameters:  [ fx 0 cx; 0 fy cy; 0 0 1 ] * )
    float   distortion[4]; ( * distortion coefficients - two coefficients for radial distortion
    and another two for tangential: [ k1 k2 p1 p2 ] * )
    float   rotMatr[9];
    float   transVect[3]; ( * rotation matrix and transition vector relatively
    to some reference point in the space. * )
    } CvCamera;
  *)
  pCvCamera = ^TCvCamera;

  TCvCamera = record
    imgSize: array [0 .. 1] of Single;
    (* size of the camera view, used during calibration *)
    matrix: array [0 .. 8] of Single; (* intinsic camera parameters:  [ fx 0 cx; 0 fy cy; 0 0 1 ] *)
    distortion: array [0 .. 3] of Single; (* distortion coefficients - two coefficients for radial distortion
      and another two for tangential: [ k1 k2 p1 p2 ] *)
    rotMatr: array [0 .. 8] of Single;
    transVect: array [0 .. 2] of Single;
    (* rotation matrix and transition vector relatively
      to some reference point in the space. *)
  end;

  (*
    typedef struct CvStereoCamera
    {
    CvCamera* camera[2]; ( * two individual camera parameters * )
    float fundMatr[9]; ( * fundamental matrix * )

    ( * New part for stereo * )
    CvPoint3D32f epipole[2];
    CvPoint2D32f quad[2][4]; ( * coordinates of destination quadrangle after
    epipolar geometry rectification * )
    double coeffs[2][3][3];( * coefficients for transformation * )
    CvPoint2D32f border[2][4];
    CvSize warpSize;
    CvStereoLineCoeff* lineCoeffs;
    int needSwapCameras;( * flag set to 1 if need to swap cameras for good reconstruction * )
    float rotMatrix[9];
    float transVector[3];
    } CvStereoCamera;
  *)

  pCvStereoCamera = ^TCvStereoCamera;

  TCvStereoCamera = record
    camera: array [0 .. 1] of pCvCamera; (* two individual camera parameters *)
    fundMatr: array [0 .. 8] of Single; (* fundamental matrix *)
    (* New part for stereo *)
    epipole: array [0 .. 1] of TCvPoint3D32f;
    quad: array [0 .. 1, 0 .. 3] of TCvPoint2D32f; (* coordinates of destination quadrangle after
      epipolar geometry rectification *)
    coeffs: array [0 .. 1, 0 .. 2, 0 .. 2] of double; (* coefficients for transformation *)
    border: array [0 .. 1, 0 .. 3] of TCvPoint2D32f;
    warpSize: TCvSize;
    lineCoeffs: pCvStereoLineCoeff;
    needSwapCameras: Integer; (* flag set to 1 if need to swap cameras for good reconstruction *)
    rotMatrix: array [0 .. 8] of Single;
    transVector: array [0 .. 2] of Single;
  end;

  (*
    // typedef struct CvContourOrientation
    // {
    // float egvals[2];
    // float egvects[4];
    //
    // float max, min; // minimum and maximum projections
    // int imax, imin;
    // } CvContourOrientation;
  *)

  pCvContourOrientation = ^TCvContourOrientation;

  TCvContourOrientation = record
    egvals: array [0 .. 1] of Single;
    egvects: array [0 .. 3] of Single;
    max, min: Single; // minimum and maximum projections
    imax, imin: Integer;
  end;

const
  CV_CAMERA_TO_WARP = 1;
  CV_WARP_TO_CAMERA = 2;

  // CVAPI(int) icvConvertWarpCoordinates(double coeffs[3][3],
  // CvPoint2D32f* cameraPoint,
  // CvPoint2D32f* warpPoint,
  // int direction);
  //
  // CVAPI(int) icvGetSymPoint3D(  CvPoint3D64f pointCorner,
  // CvPoint3D64f point1,
  // CvPoint3D64f point2,
  // CvPoint3D64f *pointSym2);
  //
  // CVAPI(void) icvGetPieceLength3D(CvPoint3D64f point1,CvPoint3D64f point2,double* dist);
  //
  // CVAPI(int) icvCompute3DPoint(    double alpha,double betta,
  // CvStereoLineCoeff* coeffs,
  // CvPoint3D64f* point);
  //
  // CVAPI(int) icvCreateConvertMatrVect( double*     rotMatr1,
  // double*     transVect1,
  // double*     rotMatr2,
  // double*     transVect2,
  // double*     convRotMatr,
  // double*     convTransVect);
  //
  // CVAPI(int) icvConvertPointSystem(CvPoint3D64f  M2,
  // CvPoint3D64f* M1,
  // double*     rotMatr,
  // double*     transVect
  // );
  //
  // CVAPI(int) icvComputeCoeffForStereo(  CvStereoCamera* stereoCamera);
  //
  // CVAPI(int) icvGetCrossPieceVector(CvPoint2D32f p1_start,CvPoint2D32f p1_end,CvPoint2D32f v2_start,CvPoint2D32f v2_end,CvPoint2D32f *cross);
  // CVAPI(int) icvGetCrossLineDirect(CvPoint2D32f p1,CvPoint2D32f p2,float a,float b,float c,CvPoint2D32f* cross);
  // CVAPI(float) icvDefinePointPosition(CvPoint2D32f point1,CvPoint2D32f point2,CvPoint2D32f point);
  // CVAPI(int) icvStereoCalibration( int numImages,
  // int* nums,
  // CvSize imageSize,
  // CvPoint2D32f* imagePoints1,
  // CvPoint2D32f* imagePoints2,
  // CvPoint3D32f* objectPoints,
  // CvStereoCamera* stereoparams
  // );
  //
  //
  // CVAPI(int) icvComputeRestStereoParams(CvStereoCamera *stereoparams);
  //
  // CVAPI(void) cvComputePerspectiveMap( const double coeffs[3][3], CvArr* rectMapX, CvArr* rectMapY );
  //
  // CVAPI(int) icvComCoeffForLine(   CvPoint2D64f point1,
  // CvPoint2D64f point2,
  // CvPoint2D64f point3,
  // CvPoint2D64f point4,
  // double*    camMatr1,
  // double*    rotMatr1,
  // double*    transVect1,
  // double*    camMatr2,
  // double*    rotMatr2,
  // double*    transVect2,
  // CvStereoLineCoeff*    coeffs,
  // int* needSwapCameras);
  //
  // CVAPI(int) icvGetDirectionForPoint(  CvPoint2D64f point,
  // double* camMatr,
  // CvPoint3D64f* direct);
  //
  // CVAPI(int) icvGetCrossLines(CvPoint3D64f point11,CvPoint3D64f point12,
  // CvPoint3D64f point21,CvPoint3D64f point22,
  // CvPoint3D64f* midPoint);
  //
  // CVAPI(int) icvComputeStereoLineCoeffs(   CvPoint3D64f pointA,
  // CvPoint3D64f pointB,
  // CvPoint3D64f pointCam1,
  // double gamma,
  // CvStereoLineCoeff*    coeffs);
  //
  (* CVAPI(int) icvComputeFundMatrEpipoles ( double* camMatr1,
    // double*     rotMatr1,
    // double*     transVect1,
    // double*     camMatr2,
    // double*     rotMatr2,
    // double*     transVect2,
    // CvPoint2D64f* epipole1,
    // CvPoint2D64f* epipole2,
    // double*     fundMatr); *)
  //
  // CVAPI(int) icvGetAngleLine( CvPoint2D64f startPoint, CvSize imageSize,CvPoint2D64f *point1,CvPoint2D64f *point2);
  //
  // CVAPI(void) icvGetCoefForPiece(   CvPoint2D64f p_start,CvPoint2D64f p_end,
  // double *a,double *b,double *c,
  // int* result);
  //
  (* CVAPI(void) icvGetCommonArea( CvSize imageSize,
    // CvPoint2D64f epipole1,CvPoint2D64f epipole2,
    // double* fundMatr,
    // double* coeff11,double* coeff12,
    // double* coeff21,double* coeff22,
    // int* result); *)
  //
  // CVAPI(void) icvComputeeInfiniteProject1(double*    rotMatr,
  // double*    camMatr1,
  // double*    camMatr2,
  // CvPoint2D32f point1,
  // CvPoint2D32f *point2);
  //
  // CVAPI(void) icvComputeeInfiniteProject2(double*    rotMatr,
  // double*    camMatr1,
  // double*    camMatr2,
  // CvPoint2D32f* point1,
  // CvPoint2D32f point2);
  //
  // CVAPI(void) icvGetCrossDirectDirect(  double* direct1,double* direct2,
  // CvPoint2D64f *cross,int* result);
  //
  // CVAPI(void) icvGetCrossPieceDirect(   CvPoint2D64f p_start,CvPoint2D64f p_end,
  // double a,double b,double c,
  // CvPoint2D64f *cross,int* result);
  //
  // CVAPI(void) icvGetCrossPiecePiece( CvPoint2D64f p1_start,CvPoint2D64f p1_end,
  // CvPoint2D64f p2_start,CvPoint2D64f p2_end,
  // CvPoint2D64f* cross,
  // int* result);
  //
  // CVAPI(void) icvGetPieceLength(CvPoint2D64f point1,CvPoint2D64f point2,double* dist);
  //
  // CVAPI(void) icvGetCrossRectDirect(    CvSize imageSize,
  // double a,double b,double c,
  // CvPoint2D64f *start,CvPoint2D64f *end,
  // int* result);
  //
  // CVAPI(void) icvProjectPointToImage(   CvPoint3D64f point,
  // double* camMatr,double* rotMatr,double* transVect,
  // CvPoint2D64f* projPoint);
  //
  // CVAPI(void) icvGetQuadsTransform( CvSize        imageSize,
  // double*     camMatr1,
  // double*     rotMatr1,
  // double*     transVect1,
  // double*     camMatr2,
  // double*     rotMatr2,
  // double*     transVect2,
  // CvSize*       warpSize,
  // double quad1[4][2],
  // double quad2[4][2],
  // double*     fundMatr,
  // CvPoint3D64f* epipole1,
  // CvPoint3D64f* epipole2
  // );
  //
  // CVAPI(void) icvGetQuadsTransformStruct(  CvStereoCamera* stereoCamera);
  //
  // CVAPI(void) icvComputeStereoParamsForCameras(CvStereoCamera* stereoCamera);
  //
  // CVAPI(void) icvGetCutPiece(   double* areaLineCoef1,double* areaLineCoef2,
  // CvPoint2D64f epipole,
  // CvSize imageSize,
  // CvPoint2D64f* point11,CvPoint2D64f* point12,
  // CvPoint2D64f* point21,CvPoint2D64f* point22,
  // int* result);
  //
  // CVAPI(void) icvGetMiddleAnglePoint(   CvPoint2D64f basePoint,
  // CvPoint2D64f point1,CvPoint2D64f point2,
  // CvPoint2D64f* midPoint);
  //
  // CVAPI(void) icvGetNormalDirect(double* direct,CvPoint2D64f point,double* normDirect);
  //
  // CVAPI(double) icvGetVect(CvPoint2D64f basePoint,CvPoint2D64f point1,CvPoint2D64f point2);
  //
  // CVAPI(void) icvProjectPointToDirect(  CvPoint2D64f point,double* lineCoeff,
  // CvPoint2D64f* projectPoint);
  //
  // CVAPI(void) icvGetDistanceFromPointToDirect( CvPoint2D64f point,double* lineCoef,double*dist);
  //
  // CVAPI(IplImage*) icvCreateIsometricImage( IplImage* src, IplImage* dst,
  // int desired_depth, int desired_num_channels );
  //
  // CVAPI(void) cvDeInterlace( const CvArr* frame, CvArr* fieldEven, CvArr* fieldOdd );
  //
  (* CVAPI(int) icvSelectBestRt(           int           numImages,
    // int*          numPoints,
    // CvSize        imageSize,
    // CvPoint2D32f* imagePoints1,
    // CvPoint2D32f* imagePoints2,
    // CvPoint3D32f* objectPoints,
    //
    // CvMatr32f     cameraMatrix1,
    // CvVect32f     distortion1,
    // CvMatr32f     rotMatrs1,
    // CvVect32f     transVects1,
    //
    // CvMatr32f     cameraMatrix2,
    // CvVect32f     distortion2,
    // CvMatr32f     rotMatrs2,
    // CvVect32f     transVects2,
    //
    // CvMatr32f     bestRotMatr,
    // CvVect32f     bestTransVect
    // ); *)
  //
  //
  (* ***************************************************************************************\
    // *                                     Contour Tree                                       *
    // \*************************************************************************************** *)
type
  (* Contour tree header *)
  // typedef struct CvContourTree
  // {
  // CV_SEQUENCE_FIELDS()
  // CvPoint p1;            (* the first point of the binary tree root segment *)
  // CvPoint p2;            (* the last point of the binary tree root segment *)
  // } CvContourTree;

  pCvContourTree = ^TCvContourTree;

  TCvContourTree = record
    CV_SEQUENCE_FIELDS: TCV_SEQUENCE_FIELDS;
    p1: TCvPoint; (* the first point of the binary tree root segment *)
    p2: TCvPoint; (* the last point of the binary tree root segment *)
  end;

  (* Builds hierarhical representation of a contour *)
  // CVAPI(CvContourTree*)  cvCreateContourTree( const CvSeq* contour,
  // CvMemStorage* storage,
  // double threshold );
  //
  (* Reconstruct (completelly or partially) contour a from contour tree *)
  // CVAPI(CvSeq*)  cvContourFromContourTree( const CvContourTree* tree,
  // CvMemStorage* storage,
  // CvTermCriteria criteria );
  //
  (* Compares two contour trees *)
  // enum { CV_CONTOUR_TREES_MATCH_I1 = 1 };
  //
  // CVAPI(double)  cvMatchContourTrees( const CvContourTree* tree1,
  // const CvContourTree* tree2,
  // int method, double threshold );
  //
  (* ***************************************************************************************\
    // *                                   Contour Morphing                                     *
    // \*************************************************************************************** *)
  //
  (* finds correspondence between two contours *)
  // CvSeq* cvCalcContoursCorrespondence( const CvSeq* contour1,
  // const CvSeq* contour2,
  // CvMemStorage* storage);
  //
  (* morphs contours using the pre-calculated correspondence:
    // alpha=0 ~ contour1, alpha=1 ~ contour2 *)
  // CvSeq* cvMorphContours( const CvSeq* contour1, const CvSeq* contour2,
  // CvSeq* corr, double alpha,
  // CvMemStorage* storage );
  //

  // ****************************************************************************************
  // *                                   Active Contours                                    *
  // ****************************************************************************************

const
  CV_VALUE = 1;
  CV_ARRAY = 2;

  {
    (* Updates active contour in order to minimize its cummulative
    (internal and external) energy. *)
    CVAPI(void)  cvSnakeImage( const IplImage* image, CvPoint* points,
    int  length, float* alpha,
    float* beta, float* gamma,
    int coeff_usage, CvSize  win,
    CvTermCriteria criteria, int calc_gradient CV_DEFAULT(1));
  }
procedure cvSnakeImage(const image: pIplImage; points: pCvPointArray; length: Integer; alpha: PSingle; beta: PSingle;
  gamma: PSingle; coeff_usage: Integer; win: TCvSize; criteria: TCvTermCriteria; calc_gradient: Integer = 1); cdecl;

(* ***************************************************************************************\
  // *                                    Texture Descriptors                                 *
  // \*************************************************************************************** *)
const
  CV_GLCM_OPTIMIZATION_NONE      = -2;
  CV_GLCM_OPTIMIZATION_LUT       = -1;
  CV_GLCM_OPTIMIZATION_HISTOGRAM = 0;

  CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST = 10;
  CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST = 11;
  CV_GLCMDESC_OPTIMIZATION_HISTOGRAM       = 4;

  CV_GLCMDESC_ENTROPY            = 0;
  CV_GLCMDESC_ENERGY             = 1;
  CV_GLCMDESC_HOMOGENITY         = 2;
  CV_GLCMDESC_CONTRAST           = 3;
  CV_GLCMDESC_CLUSTERTENDENCY    = 4;
  CV_GLCMDESC_CLUSTERSHADE       = 5;
  CV_GLCMDESC_CORRELATION        = 6;
  CV_GLCMDESC_CORRELATIONINFO1   = 7;
  CV_GLCMDESC_CORRELATIONINFO2   = 8;
  CV_GLCMDESC_MAXIMUMPROBABILITY = 9;

  CV_GLCM_ALL  = 0;
  CV_GLCM_GLCM = 1;
  CV_GLCM_DESC = 2;

Type
  // typedef struct CvGLCM CvGLCM;
  pCvGLCM = ^TCvGLCM;

  TCvGLCM = record

  end;

  // CVAPI(CvGLCM*) cvCreateGLCM( const IplImage* srcImage,
  // int stepMagnitude,
  // const int* stepDirections CV_DEFAULT(0),
  // int numStepDirections CV_DEFAULT(0),
  // int optimizationType CV_DEFAULT(CV_GLCM_OPTIMIZATION_NONE));
  //
  // CVAPI(void) cvReleaseGLCM( CvGLCM** GLCM, int flag CV_DEFAULT(CV_GLCM_ALL));
  //
  // CVAPI(void) cvCreateGLCMDescriptors( CvGLCM* destGLCM,
  // int descriptorOptimizationType
  // CV_DEFAULT(CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST));
  //
  // CVAPI(double) cvGetGLCMDescriptor( CvGLCM* GLCM, int step, int descriptor );
  //
  // CVAPI(void) cvGetGLCMDescriptorStatistics( CvGLCM* GLCM, int descriptor,
  // double* average, double* standardDeviation );
  //
  // CVAPI(IplImage*) cvCreateGLCMImage( CvGLCM* GLCM, int step );
  //
  (* ***************************************************************************************\
    // *                                  Face eyes&mouth tracking                              *
    // \*************************************************************************************** *)
  //
  //
  // typedef struct CvFaceTracker CvFaceTracker;
  //
  // #define CV_NUM_FACE_ELEMENTS    3
  // enum CV_FACE_ELEMENTS
  // {
  // CV_FACE_MOUTH = 0,
  // CV_FACE_LEFT_EYE = 1,
  // CV_FACE_RIGHT_EYE = 2
  // };
  //
  // CVAPI(CvFaceTracker*) cvInitFaceTracker(CvFaceTracker* pFaceTracking, const IplImage* imgGray,
  // CvRect* pRects, int nRects);
  // CVAPI(int) cvTrackFace( CvFaceTracker* pFaceTracker, IplImage* imgGray,
  // CvRect* pRects, int nRects,
  // CvPoint* ptRotate, double* dbAngleRotate);
  // CVAPI(void) cvReleaseFaceTracker(CvFaceTracker** ppFaceTracker);
  //
  //
  // typedef struct CvFace
  // {
  // CvRect MouthRect;
  // CvRect LeftEyeRect;
  // CvRect RightEyeRect;
  // } CvFaceData;
  //
  // CvSeq * cvFindFace(IplImage * Image,CvMemStorage* storage);
  // CvSeq * cvPostBoostingFindFace(IplImage * Image,CvMemStorage* storage);
  //
  //
  (* ***************************************************************************************\
    // *                                         3D Tracker                                     *
    // \*************************************************************************************** *)
  //
  // typedef unsigned char CvBool;
  //
  // typedef struct Cv3dTracker2dTrackedObject
  // {
  // int id;
  // CvPoint2D32f p; // pgruebele: So we do not loose precision, this needs to be float
  // } Cv3dTracker2dTrackedObject;
  //
  // CV_INLINE Cv3dTracker2dTrackedObject cv3dTracker2dTrackedObject(int id, CvPoint2D32f p)
  // {
  // Cv3dTracker2dTrackedObject r;
  // r.id = id;
  // r.p = p;
  // return r;
  // }
  //
  // typedef struct Cv3dTrackerTrackedObject
  // {
  // int id;
  // CvPoint3D32f p;             // location of the tracked object
  // } Cv3dTrackerTrackedObject;
  //
  // CV_INLINE Cv3dTrackerTrackedObject cv3dTrackerTrackedObject(int id, CvPoint3D32f p)
  // {
  // Cv3dTrackerTrackedObject r;
  // r.id = id;
  // r.p = p;
  // return r;
  // }
  //
  // typedef struct Cv3dTrackerCameraInfo
  // {
  // CvBool valid;
  // float mat[4][4];              (* maps camera coordinates to world coordinates *)
  // CvPoint2D32f principal_point; (* copied from intrinsics so this structure *)
  // (* has all the info we need *)
  // } Cv3dTrackerCameraInfo;
  //
  // typedef struct Cv3dTrackerCameraIntrinsics
  // {
  // CvPoint2D32f principal_point;
  // float focal_length[2];
  // float distortion[4];
  // } Cv3dTrackerCameraIntrinsics;
  //
  // CVAPI(CvBool) cv3dTrackerCalibrateCameras(int num_cameras,
  // const Cv3dTrackerCameraIntrinsics camera_intrinsics[], (* size is num_cameras *)
  // CvSize etalon_size,
  // float square_size,
  // IplImage *samples[],                                   (* size is num_cameras *)
  // Cv3dTrackerCameraInfo camera_info[]);                  (* size is num_cameras *)
  //
  // CVAPI(int)  cv3dTrackerLocateObjects(int num_cameras, int num_objects,
  // const Cv3dTrackerCameraInfo camera_info[],        (* size is num_cameras *)
  // const Cv3dTracker2dTrackedObject tracking_info[], (* size is num_objects*num_cameras *)
  // Cv3dTrackerTrackedObject tracked_objects[]);      (* size is num_objects *)
  (* ***************************************************************************************
    // tracking_info is a rectangular array; one row per camera, num_objects elements per row.
    // The id field of any unused slots must be -1. Ids need not be ordered or consecutive. On
    // completion, the return value is the number of objects located; i.e., the number of objects
    // visible by more than one camera. The id field of any unused slots in tracked objects is
    // set to -1.
    // *************************************************************************************** *)
  //
  //
  (* ***************************************************************************************\
    // *                           Skeletons and Linear-Contour Models                          *
    // \*************************************************************************************** *)
  //
  // typedef enum CvLeeParameters
  // {
  // CV_LEE_INT = 0,
  // CV_LEE_FLOAT = 1,
  // CV_LEE_DOUBLE = 2,
  // CV_LEE_AUTO = -1,
  // CV_LEE_ERODE = 0,
  // CV_LEE_ZOOM = 1,
  // CV_LEE_NON = 2
  // } CvLeeParameters;
  //
  // #define CV_NEXT_VORONOISITE2D( SITE ) ((SITE)->edge[0]->site[((SITE)->edge[0]->site[0] == (SITE))])
  // #define CV_PREV_VORONOISITE2D( SITE ) ((SITE)->edge[1]->site[((SITE)->edge[1]->site[0] == (SITE))])
  // #define CV_FIRST_VORONOIEDGE2D( SITE ) ((SITE)->edge[0])
  // #define CV_LAST_VORONOIEDGE2D( SITE ) ((SITE)->edge[1])
  // #define CV_NEXT_VORONOIEDGE2D( EDGE, SITE ) ((EDGE)->next[(EDGE)->site[0] != (SITE)])
  // #define CV_PREV_VORONOIEDGE2D( EDGE, SITE ) ((EDGE)->next[2 + ((EDGE)->site[0] != (SITE))])
  // #define CV_VORONOIEDGE2D_BEGINNODE( EDGE, SITE ) ((EDGE)->node[((EDGE)->site[0] != (SITE))])
  // #define CV_VORONOIEDGE2D_ENDNODE( EDGE, SITE ) ((EDGE)->node[((EDGE)->site[0] == (SITE))])
  // #define CV_TWIN_VORONOISITE2D( SITE, EDGE ) ( (EDGE)->site[((EDGE)->site[0] == (SITE))])
  //
  // #define CV_VORONOISITE2D_FIELDS()    \
  // struct CvVoronoiNode2D *node[2]; \
  // struct CvVoronoiEdge2D *edge[2];
  //
  // typedef struct CvVoronoiSite2D
  // {
  // CV_VORONOISITE2D_FIELDS()
  // struct CvVoronoiSite2D *next[2];
  // } CvVoronoiSite2D;
  //
  // #define CV_VORONOIEDGE2D_FIELDS()    \
  // struct CvVoronoiNode2D *node[2]; \
  // struct CvVoronoiSite2D *site[2]; \
  // struct CvVoronoiEdge2D *next[4];
  //
  // typedef struct CvVoronoiEdge2D
  // {
  // CV_VORONOIEDGE2D_FIELDS()
  // } CvVoronoiEdge2D;
  //
  // #define CV_VORONOINODE2D_FIELDS()       \
  // CV_SET_ELEM_FIELDS(CvVoronoiNode2D) \
  // CvPoint2D32f pt;                    \
  // float radius;
  //
  // typedef struct CvVoronoiNode2D
  // {
  // CV_VORONOINODE2D_FIELDS()
  // } CvVoronoiNode2D;
  //
  // #define CV_VORONOIDIAGRAM2D_FIELDS() \
  // CV_GRAPH_FIELDS()                \
  // CvSet *sites;
  //
  // typedef struct CvVoronoiDiagram2D
  // {
  // CV_VORONOIDIAGRAM2D_FIELDS()
  // } CvVoronoiDiagram2D;
  //
  (* Computes Voronoi Diagram for given polygons with holes *)
  // CVAPI(int)  cvVoronoiDiagramFromContour(CvSeq* ContourSeq,
  // CvVoronoiDiagram2D** VoronoiDiagram,
  // CvMemStorage* VoronoiStorage,
  // CvLeeParameters contour_type CV_DEFAULT(CV_LEE_INT),
  // int contour_orientation CV_DEFAULT(-1),
  // int attempt_number CV_DEFAULT(10));
  //
  (* Computes Voronoi Diagram for domains in given image *)
  // CVAPI(int)  cvVoronoiDiagramFromImage(IplImage* pImage,
  // CvSeq** ContourSeq,
  // CvVoronoiDiagram2D** VoronoiDiagram,
  // CvMemStorage* VoronoiStorage,
  // CvLeeParameters regularization_method CV_DEFAULT(CV_LEE_NON),
  // float approx_precision CV_DEFAULT(CV_LEE_AUTO));
  //
  (* Deallocates the storage *)
  // CVAPI(void) cvReleaseVoronoiStorage(CvVoronoiDiagram2D* VoronoiDiagram,
  // CvMemStorage** pVoronoiStorage);
  //
  (* ********************** Linear-Contour Model *************************** *)
  //
  // struct CvLCMEdge;
  // struct CvLCMNode;
  //
  // typedef struct CvLCMEdge
  // {
  // CV_GRAPH_EDGE_FIELDS()
  // CvSeq* chain;
  // float width;
  // int index1;
  // int index2;
  // } CvLCMEdge;
  //
  // typedef struct CvLCMNode
  // {
  // CV_GRAPH_VERTEX_FIELDS()
  // CvContour* contour;
  // } CvLCMNode;
  //
  //
  (* Computes hybrid model from Voronoi Diagram *)
  // CVAPI(CvGraph*) cvLinearContorModelFromVoronoiDiagram(CvVoronoiDiagram2D* VoronoiDiagram,
  // float maxWidth);
  //
  (* Releases hybrid model storage *)
  // CVAPI(int) cvReleaseLinearContorModelStorage(CvGraph** Graph);
  //
  //
  (* two stereo-related functions *)
  //
  // CVAPI(void) cvInitPerspectiveTransform( CvSize size, const CvPoint2D32f vertex[4], double matrix[3][3],
  // CvArr* rectMap );
  //
  (* CVAPI(void) cvInitStereoRectification( CvStereoCamera* params,
    // CvArr* rectMap1, CvArr* rectMap2,
    // int do_undistortion ); *)
  //
  (* ************************** View Morphing Functions *********************** *)
  //
  // typedef struct CvMatrix3
  // {
  // float m[3][3];
  // } CvMatrix3;
  //
  (* The order of the function corresponds to the order they should appear in
    // the view morphing pipeline *)
  //
  (* Finds ending points of scanlines on left and right images of stereo-pair *)
  // CVAPI(void)  cvMakeScanlines( const CvMatrix3* matrix, CvSize  img_size,
  // int*  scanlines1, int*  scanlines2,
  // int*  lengths1, int*  lengths2,
  // int*  line_count );
  //
  (* Grab pixel values from scanlines and stores them sequentially
    // (some sort of perspective image transform) *)
  // CVAPI(void)  cvPreWarpImage( int       line_count,
  // IplImage* img,
  // uchar*    dst,
  // int*      dst_nums,
  // int*      scanlines);
  //
  (* Approximate each grabbed scanline by a sequence of runs
    // (lossy run-length compression) *)
  // CVAPI(void)  cvFindRuns( int    line_count,
  // uchar* prewarp1,
  // uchar* prewarp2,
  // int*   line_lengths1,
  // int*   line_lengths2,
  // int*   runs1,
  // int*   runs2,
  // int*   num_runs1,
  // int*   num_runs2);
  //
  (* Compares two sets of compressed scanlines *)
  // CVAPI(void)  cvDynamicCorrespondMulti( int  line_count,
  // int* first,
  // int* first_runs,
  // int* second,
  // int* second_runs,
  // int* first_corr,
  // int* second_corr);
  //
  (* Finds scanline ending coordinates for some intermediate "virtual" camera position *)
  // CVAPI(void)  cvMakeAlphaScanlines( int*  scanlines1,
  // int*  scanlines2,
  // int*  scanlinesA,
  // int*  lengths,
  // int   line_count,
  // float alpha);
  //
  (* Blends data of the left and right image scanlines to get
    // pixel values of "virtual" image scanlines *)
  // CVAPI(void)  cvMorphEpilinesMulti( int    line_count,
  // uchar* first_pix,
  // int*   first_num,
  // uchar* second_pix,
  // int*   second_num,
  // uchar* dst_pix,
  // int*   dst_num,
  // float  alpha,
  // int*   first,
  // int*   first_runs,
  // int*   second,
  // int*   second_runs,
  // int*   first_corr,
  // int*   second_corr);
  //
  (* Does reverse warping of the morphing result to make
    // it fill the destination image rectangle *)
  // CVAPI(void)  cvPostWarpImage( int       line_count,
  // uchar*    src,
  // int*      src_nums,
  // IplImage* img,
  // int*      scanlines);
  //
  (* Deletes Moire (missed pixels that appear due to discretization) *)
  // CVAPI(void)  cvDeleteMoire( IplImage*  img );
  //
  //
  // typedef struct CvConDensation
  // {
  // int MP;
  // int DP;
  // float* DynamMatr;       (* Matrix of the linear Dynamics system  *)
  // float* State;           (* Vector of State                       *)
  // int SamplesNum;         (* Number of the Samples                 *)
  // float** flSamples;      (* arr of the Sample Vectors             *)
  // float** flNewSamples;   (* temporary array of the Sample Vectors *)
  // float* flConfidence;    (* Confidence for each Sample            *)
  // float* flCumulative;    (* Cumulative confidence                 *)
  // float* Temp;            (* Temporary vector                      *)
  // float* RandomSample;    (* RandomVector to update sample set     *)
  // struct CvRandState* RandS; (* Array of structures to generate random vectors *)
  // } CvConDensation;
  //
  (* Creates ConDensation filter state *)
  // CVAPI(CvConDensation*)  cvCreateConDensation( int dynam_params,
  // int measure_params,
  // int sample_count );
  //
  (* Releases ConDensation filter state *)
  // CVAPI(void)  cvReleaseConDensation( CvConDensation** condens );
  //
  (* Updates ConDensation filter by time (predict future state of the system) *)
  // CVAPI(void)  cvConDensUpdateByTime( CvConDensation* condens);
  //
  (* Initializes ConDensation filter samples *)
  // CVAPI(void)  cvConDensInitSampleSet( CvConDensation* condens, CvMat* lower_bound, CvMat* upper_bound );
  //
  // CV_INLINE int iplWidth( const IplImage* img )
  // {
  // return !img ? 0 : !img->roi ? img->width : img->roi->width;
  // }
  //
  // CV_INLINE int iplHeight( const IplImage* img )
  // {
  // return !img ? 0 : !img->roi ? img->height : img->roi->height;
  // }
  //
  // #ifdef __cplusplus
  // }
  // #endif
  //
  // #ifdef __cplusplus
  //
  (* ***************************************************************************************\
    // *                                   Calibration engine                                   *
    // \*************************************************************************************** *)
  //
  // typedef enum CvCalibEtalonType
  // {
  // CV_CALIB_ETALON_USER = -1,
  // CV_CALIB_ETALON_CHESSBOARD = 0,
  // CV_CALIB_ETALON_CHECKERBOARD = CV_CALIB_ETALON_CHESSBOARD
  // }
  // CvCalibEtalonType;
  //
  // class CV_EXPORTS CvCalibFilter
  // {
  // public:
  // (* Constructor & destructor *)
  // CvCalibFilter();
  // virtual ~CvCalibFilter();
  //
  // (* Sets etalon type - one for all cameras.
  // etalonParams is used in case of pre-defined etalons (such as chessboard).
  // Number of elements in etalonParams is determined by etalonType.
  // E.g., if etalon type is CV_ETALON_TYPE_CHESSBOARD then:
  // etalonParams[0] is number of squares per one side of etalon
  // etalonParams[1] is number of squares per another side of etalon
  // etalonParams[2] is linear size of squares in the board in arbitrary units.
  // pointCount & points are used in case of
  // CV_CALIB_ETALON_USER (user-defined) etalon. *)
  // virtual bool
  // SetEtalon( CvCalibEtalonType etalonType, double* etalonParams,
  // int pointCount = 0, CvPoint2D32f* points = 0 );
  //
  // (* Retrieves etalon parameters/or and points *)
  // virtual CvCalibEtalonType
  // GetEtalon( int* paramCount = 0, const double** etalonParams = 0,
  // int* pointCount = 0, const CvPoint2D32f** etalonPoints = 0 ) const;
  //
  // (* Sets number of cameras calibrated simultaneously. It is equal to 1 initially *)
  // virtual void SetCameraCount( int cameraCount );
  //
  // (* Retrieves number of cameras *)
  // int GetCameraCount() const { return cameraCount; }
  //
  // (* Starts cameras calibration *)
  // virtual bool SetFrames( int totalFrames );
  //
  // (* Stops cameras calibration *)
  // virtual void Stop( bool calibrate = false );
  //
  // (* Retrieves number of cameras *)
  // bool IsCalibrated() const { return isCalibrated; }
  //
  // (* Feeds another serie of snapshots (one per each camera) to filter.
  // Etalon points on these images are found automatically.
  // If the function can't locate points, it returns false *)
  // virtual bool FindEtalon( IplImage** imgs );
  //
  // (* The same but takes matrices *)
  // virtual bool FindEtalon( CvMat** imgs );
  //
  // (* Lower-level function for feeding filter with already found etalon points.
  // Array of point arrays for each camera is passed. *)
  // virtual bool Push( const CvPoint2D32f** points = 0 );
  //
  // (* Returns total number of accepted frames and, optionally,
  // total number of frames to collect *)
  // virtual int GetFrameCount( int* framesTotal = 0 ) const;
  //
  // (* Retrieves camera parameters for specified camera.
  // If camera is not calibrated the function returns 0 *)
  // virtual const CvCamera* GetCameraParams( int idx = 0 ) const;
  //
  // virtual const CvStereoCamera* GetStereoParams() const;
  //
  // (* Sets camera parameters for all cameras *)
  // virtual bool SetCameraParams( CvCamera* params );
  //
  // (* Saves all camera parameters to file *)
  // virtual bool SaveCameraParams( const char* filename );
  //
  // (* Loads all camera parameters from file *)
  // virtual bool LoadCameraParams( const char* filename );
  //
  // (* Undistorts images using camera parameters. Some of src pointers can be NULL. *)
  // virtual bool Undistort( IplImage** src, IplImage** dst );
  //
  // (* Undistorts images using camera parameters. Some of src pointers can be NULL. *)
  // virtual bool Undistort( CvMat** src, CvMat** dst );
  //
  // (* Returns array of etalon points detected/partally detected
  // on the latest frame for idx-th camera *)
  // virtual bool GetLatestPoints( int idx, CvPoint2D32f** pts,
  // int* count, bool* found );
  //
  // (* Draw the latest detected/partially detected etalon *)
  // virtual void DrawPoints( IplImage** dst );
  //
  // (* Draw the latest detected/partially detected etalon *)
  // virtual void DrawPoints( CvMat** dst );
  //
  // virtual bool Rectify( IplImage** srcarr, IplImage** dstarr );
  // virtual bool Rectify( CvMat** srcarr, CvMat** dstarr );
  //
  // protected:
  //
  // enum { MAX_CAMERAS = 3 };
  //
  // (* etalon data *)
  // CvCalibEtalonType  etalonType;
  // int     etalonParamCount;
  // double* etalonParams;
  // int     etalonPointCount;
  // CvPoint2D32f* etalonPoints;
  // CvSize  imgSize;
  // CvMat*  grayImg;
  // CvMat*  tempImg;
  // CvMemStorage* storage;
  //
  // (* camera data *)
  // int     cameraCount;
  // CvCamera cameraParams[MAX_CAMERAS];
  // CvStereoCamera stereo;
  // CvPoint2D32f* points[MAX_CAMERAS];
  // CvMat*  undistMap[MAX_CAMERAS][2];
  // CvMat*  undistImg;
  // int     latestCounts[MAX_CAMERAS];
  // CvPoint2D32f* latestPoints[MAX_CAMERAS];
  // CvMat*  rectMap[MAX_CAMERAS][2];
  //
  // (* Added by Valery *)
  // //CvStereoCamera stereoParams;
  //
  // int     maxPoints;
  // int     framesTotal;
  // int     framesAccepted;
  // bool    isCalibrated;
  // };
  //
  // #include <iosfwd>
  // #include <limits>
  //
  // class CV_EXPORTS CvImage
  // {
  // public:
  // CvImage() : image(0), refcount(0) {}
  // CvImage( CvSize _size, int _depth, int _channels )
  // {
  // image = cvCreateImage( _size, _depth, _channels );
  // refcount = image ? new int(1) : 0;
  // }
  //
  // CvImage( IplImage* img ) : image(img)
  // {
  // refcount = image ? new int(1) : 0;
  // }
  //
  // CvImage( const CvImage& img ) : image(img.image), refcount(img.refcount)
  // {
  // if( refcount ) ++(*refcount);
  // }
  //
  // CvImage( const char* filename, const char* imgname=0, int color=-1 ) : image(0), refcount(0)
  // { load( filename, imgname, color ); }
  //
  // CvImage( CvFileStorage* fs, const char* mapname, const char* imgname ) : image(0), refcount(0)
  // { read( fs, mapname, imgname ); }
  //
  // CvImage( CvFileStorage* fs, const char* seqname, int idx ) : image(0), refcount(0)
  // { read( fs, seqname, idx ); }
  //
  // ~CvImage()
  // {
  // if( refcount && !(--*refcount) )
  // {
  // cvReleaseImage( &image );
  // delete refcount;
  // }
  // }
  //
  // CvImage clone() { return CvImage(image ? cvCloneImage(image) : 0); }
  //
  // void create( CvSize _size, int _depth, int _channels )
  // {
  // if( !image || !refcount ||
  // image->width != _size.width || image->height != _size.height ||
  // image->depth != _depth || image->nChannels != _channels )
  // attach( cvCreateImage( _size, _depth, _channels ));
  // }
  //
  // void release() { detach(); }
  // void clear() { detach(); }
  //
  // void attach( IplImage* img, bool use_refcount=true )
  // {
  // if( refcount && --*refcount == 0 )
  // {
  // cvReleaseImage( &image );
  // delete refcount;
  // }
  // image = img;
  // refcount = use_refcount && image ? new int(1) : 0;
  // }
  //
  // void detach()
  // {
  // if( refcount && --*refcount == 0 )
  // {
  // cvReleaseImage( &image );
  // delete refcount;
  // }
  // image = 0;
  // refcount = 0;
  // }
  //
  // bool load( const char* filename, const char* imgname=0, int color=-1 );
  // bool read( CvFileStorage* fs, const char* mapname, const char* imgname );
  // bool read( CvFileStorage* fs, const char* seqname, int idx );
  // void save( const char* filename, const char* imgname, const int* params=0 );
  // void write( CvFileStorage* fs, const char* imgname );
  //
  // void show( const char* window_name );
  // bool is_valid() { return image != 0; }
  //
  // int width() const { return image ? image->width : 0; }
  // int height() const { return image ? image->height : 0; }
  //
  // CvSize size() const { return image ? cvSize(image->width, image->height) : cvSize(0,0); }
  //
  // CvSize roi_size() const
  // {
  // return !image ? cvSize(0,0) :
  // !image->roi ? cvSize(image->width,image->height) :
  // cvSize(image->roi->width, image->roi->height);
  // }
  //
  // CvRect roi() const
  // {
  // return !image ? cvRect(0,0,0,0) :
  // !image->roi ? cvRect(0,0,image->width,image->height) :
  // cvRect(image->roi->xOffset,image->roi->yOffset,
  // image->roi->width,image->roi->height);
  // }
  //
  // int coi() const { return !image || !image->roi ? 0 : image->roi->coi; }
  //
  // void set_roi(CvRect _roi) { cvSetImageROI(image,_roi); }
  // void reset_roi() { cvResetImageROI(image); }
  // void set_coi(int _coi) { cvSetImageCOI(image,_coi); }
  // int depth() const { return image ? image->depth : 0; }
  // int channels() const { return image ? image->nChannels : 0; }
  // int pix_size() const { return image ? ((image->depth & 255)>>3)*image->nChannels : 0; }
  //
  // uchar* data() { return image ? (uchar*)image->imageData : 0; }
  // const uchar* data() const { return image ? (const uchar*)image->imageData : 0; }
  // int step() const { return image ? image->widthStep : 0; }
  // int origin() const { return image ? image->origin : 0; }
  //
  // uchar* roi_row(int y)
  // {
  // assert(0<=y);
  // assert(!image ?
  // 1 : image->roi ?
  // y<image->roi->height : y<image->height);
  //
  // return !image ? 0 :
  // !image->roi ?
  // (uchar*)(image->imageData + y*image->widthStep) :
  // (uchar*)(image->imageData + (y+image->roi->yOffset)*image->widthStep +
  // image->roi->xOffset*((image->depth & 255)>>3)*image->nChannels);
  // }
  //
  // const uchar* roi_row(int y) const
  // {
  // assert(0<=y);
  // assert(!image ?
  // 1 : image->roi ?
  // y<image->roi->height : y<image->height);
  //
  // return !image ? 0 :
  // !image->roi ?
  // (const uchar*)(image->imageData + y*image->widthStep) :
  // (const uchar*)(image->imageData + (y+image->roi->yOffset)*image->widthStep +
  // image->roi->xOffset*((image->depth & 255)>>3)*image->nChannels);
  // }
  //
  // operator const IplImage* () const { return image; }
  // operator IplImage* () { return image; }
  //
  // CvImage& operator = (const CvImage& img)
  // {
  // if( img.refcount )
  // ++*img.refcount;
  // if( refcount && !(--*refcount) )
  // cvReleaseImage( &image );
  // image=img.image;
  // refcount=img.refcount;
  // return *this;
  // }
  //
  // protected:
  // IplImage* image;
  // int* refcount;
  // };
  //
  //
  // class CV_EXPORTS CvMatrix
  // {
  // public:
  // CvMatrix() : matrix(0) {}
  // CvMatrix( int _rows, int _cols, int _type )
  // { matrix = cvCreateMat( _rows, _cols, _type ); }
  //
  // CvMatrix( int _rows, int _cols, int _type, CvMat* hdr,
  // void* _data=0, int _step=CV_AUTOSTEP )
  // { matrix = cvInitMatHeader( hdr, _rows, _cols, _type, _data, _step ); }
  //
  // CvMatrix( int rows, int cols, int type, CvMemStorage* storage, bool alloc_data=true );
  //
  // CvMatrix( int _rows, int _cols, int _type, void* _data, int _step=CV_AUTOSTEP )
  // { matrix = cvCreateMatHeader( _rows, _cols, _type );
  // cvSetData( matrix, _data, _step ); }
  //
  // CvMatrix( CvMat* m )
  // { matrix = m; }
  //
  // CvMatrix( const CvMatrix& m )
  // {
  // matrix = m.matrix;
  // addref();
  // }
  //
  // CvMatrix( const char* filename, const char* matname=0, int color=-1 ) : matrix(0)
  // {  load( filename, matname, color ); }
  //
  // CvMatrix( CvFileStorage* fs, const char* mapname, const char* matname ) : matrix(0)
  // {  read( fs, mapname, matname ); }
  //
  // CvMatrix( CvFileStorage* fs, const char* seqname, int idx ) : matrix(0)
  // {  read( fs, seqname, idx ); }
  //
  // ~CvMatrix()
  // {
  // release();
  // }
  //
  // CvMatrix clone() { return CvMatrix(matrix ? cvCloneMat(matrix) : 0); }
  //
  // void set( CvMat* m, bool add_ref )
  // {
  // release();
  // matrix = m;
  // if( add_ref )
  // addref();
  // }
  //
  // void create( int _rows, int _cols, int _type )
  // {
  // if( !matrix || !matrix->refcount ||
  // matrix->rows != _rows || matrix->cols != _cols ||
  // CV_MAT_TYPE(matrix->type) != _type )
  // set( cvCreateMat( _rows, _cols, _type ), false );
  // }
  //
  // void addref() const
  // {
  // if( matrix )
  // {
  // if( matrix->hdr_refcount )
  // ++matrix->hdr_refcount;
  // else if( matrix->refcount )
  // ++*matrix->refcount;
  // }
  // }
  //
  // void release()
  // {
  // if( matrix )
  // {
  // if( matrix->hdr_refcount )
  // {
  // if( --matrix->hdr_refcount == 0 )
  // cvReleaseMat( &matrix );
  // }
  // else if( matrix->refcount )
  // {
  // if( --*matrix->refcount == 0 )
  // cvFree( &matrix->refcount );
  // }
  // matrix = 0;
  // }
  // }
  //
  // void clear()
  // {
  // release();
  // }
  //
  // bool load( const char* filename, const char* matname=0, int color=-1 );
  // bool read( CvFileStorage* fs, const char* mapname, const char* matname );
  // bool read( CvFileStorage* fs, const char* seqname, int idx );
  // void save( const char* filename, const char* matname, const int* params=0 );
  // void write( CvFileStorage* fs, const char* matname );
  //
  // void show( const char* window_name );
  //
  // bool is_valid() { return matrix != 0; }
  //
  // int rows() const { return matrix ? matrix->rows : 0; }
  // int cols() const { return matrix ? matrix->cols : 0; }
  //
  // CvSize size() const
  // {
  // return !matrix ? cvSize(0,0) : cvSize(matrix->rows,matrix->cols);
  // }
  //
  // int type() const { return matrix ? CV_MAT_TYPE(matrix->type) : 0; }
  // int depth() const { return matrix ? CV_MAT_DEPTH(matrix->type) : 0; }
  // int channels() const { return matrix ? CV_MAT_CN(matrix->type) : 0; }
  // int pix_size() const { return matrix ? CV_ELEM_SIZE(matrix->type) : 0; }
  //
  // uchar* data() { return matrix ? matrix->data.ptr : 0; }
  // const uchar* data() const { return matrix ? matrix->data.ptr : 0; }
  // int step() const { return matrix ? matrix->step : 0; }
  //
  // void set_data( void* _data, int _step=CV_AUTOSTEP )
  // { cvSetData( matrix, _data, _step ); }
  //
  // uchar* row(int i) { return !matrix ? 0 : matrix->data.ptr + i*matrix->step; }
  // const uchar* row(int i) const
  // { return !matrix ? 0 : matrix->data.ptr + i*matrix->step; }
  //
  // operator const CvMat* () const { return matrix; }
  // operator CvMat* () { return matrix; }
  //
  // CvMatrix& operator = (const CvMatrix& _m)
  // {
  // _m.addref();
  // release();
  // matrix = _m.matrix;
  // return *this;
  // }
  //
  // protected:
  // CvMat* matrix;
  // };
  //
  (* ***************************************************************************************\
    // *                                       CamShiftTracker                                  *
    // \*************************************************************************************** *)
  //
  // class CV_EXPORTS CvCamShiftTracker
  // {
  // public:
  //
  // CvCamShiftTracker();
  // virtual ~CvCamShiftTracker();
  //
  // (**** Characteristics of the object that are calculated by track_object method *****)
  // float   get_orientation() const // orientation of the object in degrees
  // { return m_box.angle; }
  // float   get_length() const // the larger linear size of the object
  // { return m_box.size.height; }
  // float   get_width() const // the smaller linear size of the object
  // { return m_box.size.width; }
  // CvPoint2D32f get_center() const // center of the object
  // { return m_box.center; }
  // CvRect get_window() const // bounding rectangle for the object
  // { return m_comp.rect; }
  //
  // (*********************** Tracking parameters ************************)
  // int     get_threshold() const // thresholding value that applied to back project
  // { return m_threshold; }
  //
  // int     get_hist_dims( int* dims = 0 ) const // returns number of histogram dimensions and sets
  // { return m_hist ? cvGetDims( m_hist->bins, dims ) : 0; }
  //
  // int     get_min_ch_val( int channel ) const // get the minimum allowed value of the specified channel
  // { return m_min_ch_val[channel]; }
  //
  // int     get_max_ch_val( int channel ) const // get the maximum allowed value of the specified channel
  // { return m_max_ch_val[channel]; }
  //
  // // set initial object rectangle (must be called before initial calculation of the histogram)
  // bool    set_window( CvRect window)
  // { m_comp.rect = window; return true; }
  //
  // bool    set_threshold( int threshold ) // threshold applied to the histogram bins
  // { m_threshold = threshold; return true; }
  //
  // bool    set_hist_bin_range( int dim, int min_val, int max_val );
  //
  // bool    set_hist_dims( int c_dims, int* dims );// set the histogram parameters
  //
  // bool    set_min_ch_val( int channel, int val ) // set the minimum allowed value of the specified channel
  // { m_min_ch_val[channel] = val; return true; }
  // bool    set_max_ch_val( int channel, int val ) // set the maximum allowed value of the specified channel
  // { m_max_ch_val[channel] = val; return true; }
  //
  // (************************ The processing methods *********************************)
  // // update object position
  // virtual bool  track_object( const IplImage* cur_frame );
  //
  // // update object histogram
  // virtual bool  update_histogram( const IplImage* cur_frame );
  //
  // // reset histogram
  // virtual void  reset_histogram();
  //
  // (************************ Retrieving internal data *******************************)
  // // get back project image
  // virtual IplImage* get_back_project()
  // { return m_back_project; }
  //
  // float query( int* bin ) const
  // { return m_hist ? (float)cvGetRealND(m_hist->bins, bin) : 0.f; }
  //
  // protected:
  //
  // // internal method for color conversion: fills m_color_planes group
  // virtual void color_transform( const IplImage* img );
  //
  // CvHistogram* m_hist;
  //
  // CvBox2D    m_box;
  // CvConnectedComp m_comp;
  //
  // float      m_hist_ranges_data[CV_MAX_DIM][2];
  // float*     m_hist_ranges[CV_MAX_DIM];
  //
  // int        m_min_ch_val[CV_MAX_DIM];
  // int        m_max_ch_val[CV_MAX_DIM];
  // int        m_threshold;
  //
  // IplImage*  m_color_planes[CV_MAX_DIM];
  // IplImage*  m_back_project;
  // IplImage*  m_temp;
  // IplImage*  m_mask;
  // };
  //
  (* ***************************************************************************************\
    // *                              Expectation - Maximization                                *
    // \*************************************************************************************** *)
  // struct CV_EXPORTS_W_MAP CvEMParams
  // {
  // CvEMParams();
  // CvEMParams( int nclusters, int cov_mat_type=cv::EM::COV_MAT_DIAGONAL,
  // int start_step=cv::EM::START_AUTO_STEP,
  // CvTermCriteria term_crit=cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 100, FLT_EPSILON),
  // const CvMat* probs=0, const CvMat* weights=0, const CvMat* means=0, const CvMat** covs=0 );
  //
  // CV_PROP_RW int nclusters;
  // CV_PROP_RW int cov_mat_type;
  // CV_PROP_RW int start_step;
  // const CvMat* probs;
  // const CvMat* weights;
  // const CvMat* means;
  // const CvMat** covs;
  // CV_PROP_RW CvTermCriteria term_crit;
  // };
  //
  //
  // class CV_EXPORTS_W CvEM : public CvStatModel
  // {
  // public:
  // // Type of covariation matrices
  // enum { COV_MAT_SPHERICAL=cv::EM::COV_MAT_SPHERICAL,
  // COV_MAT_DIAGONAL =cv::EM::COV_MAT_DIAGONAL,
  // COV_MAT_GENERIC  =cv::EM::COV_MAT_GENERIC };
  //
  // // The initial step
  // enum { START_E_STEP=cv::EM::START_E_STEP,
  // START_M_STEP=cv::EM::START_M_STEP,
  // START_AUTO_STEP=cv::EM::START_AUTO_STEP };
  //
  // CV_WRAP CvEM();
  // CvEM( const CvMat* samples, const CvMat* sampleIdx=0,
  // CvEMParams params=CvEMParams(), CvMat* labels=0 );
  //
  // virtual ~CvEM();
  //
  // virtual bool train( const CvMat* samples, const CvMat* sampleIdx=0,
  // CvEMParams params=CvEMParams(), CvMat* labels=0 );
  //
  // virtual float predict( const CvMat* sample, CV_OUT CvMat* probs ) const;
  //
  // CV_WRAP CvEM( const cv::Mat& samples, const cv::Mat& sampleIdx=cv::Mat(),
  // CvEMParams params=CvEMParams() );
  //
  // CV_WRAP virtual bool train( const cv::Mat& samples,
  // const cv::Mat& sampleIdx=cv::Mat(),
  // CvEMParams params=CvEMParams(),
  // CV_OUT cv::Mat* labels=0 );
  //
  // CV_WRAP virtual float predict( const cv::Mat& sample, CV_OUT cv::Mat* probs=0 ) const;
  // CV_WRAP virtual double calcLikelihood( const cv::Mat &sample ) const;
  //
  // CV_WRAP int getNClusters() const;
  // CV_WRAP cv::Mat getMeans() const;
  // CV_WRAP void getCovs(CV_OUT std::vector<cv::Mat>& covs) const;
  // CV_WRAP cv::Mat getWeights() const;
  // CV_WRAP cv::Mat getProbs() const;
  //
  // CV_WRAP inline double getLikelihood() const { return emObj.isTrained() ? logLikelihood : DBL_MAX; }
  //
  // CV_WRAP virtual void clear();
  //
  // int get_nclusters() const;
  // const CvMat* get_means() const;
  // const CvMat** get_covs() const;
  // const CvMat* get_weights() const;
  // const CvMat* get_probs() const;
  //
  // inline double get_log_likelihood() const { return getLikelihood(); }
  //
  // virtual void read( CvFileStorage* fs, CvFileNode* node );
  // virtual void write( CvFileStorage* fs, const char* name ) const;
  //
  // protected:
  // void set_mat_hdrs();
  //
  // cv::EM emObj;
  // cv::Mat probs;
  // double logLikelihood;
  //
  // CvMat meansHdr;
  // std::vector<CvMat> covsHdrs;
  // std::vector<CvMat*> covsPtrs;
  // CvMat weightsHdr;
  // CvMat probsHdr;
  // };
  //
  // namespace cv
  // {
  //
  // typedef CvEMParams EMParams;
  // typedef CvEM ExpectationMaximization;
  //
  (* !
    // The Patch Generator class
    // *)
  // class CV_EXPORTS PatchGenerator
  // {
  // public:
  // PatchGenerator();
  // PatchGenerator(double _backgroundMin, double _backgroundMax,
  // double _noiseRange, bool _randomBlur=true,
  // double _lambdaMin=0.6, double _lambdaMax=1.5,
  // double _thetaMin=-CV_PI, double _thetaMax=CV_PI,
  // double _phiMin=-CV_PI, double _phiMax=CV_PI );
  // void operator()(const Mat& image, Point2f pt, Mat& patch, Size patchSize, RNG& rng) const;
  // void operator()(const Mat& image, const Mat& transform, Mat& patch,
  // Size patchSize, RNG& rng) const;
  // void warpWholeImage(const Mat& image, Mat& matT, Mat& buf,
  // CV_OUT Mat& warped, int border, RNG& rng) const;
  // void generateRandomTransform(Point2f srcCenter, Point2f dstCenter,
  // CV_OUT Mat& transform, RNG& rng,
  // bool inverse=false) const;
  // void setAffineParam(double lambda, double theta, double phi);
  //
  // double backgroundMin, backgroundMax;
  // double noiseRange;
  // bool randomBlur;
  // double lambdaMin, lambdaMax;
  // double thetaMin, thetaMax;
  // double phiMin, phiMax;
  // };
  //
  //
  // class CV_EXPORTS LDetector
  // {
  // public:
  // LDetector();
  // LDetector(int _radius, int _threshold, int _nOctaves,
  // int _nViews, double _baseFeatureSize, double _clusteringDistance);
  // void operator()(const Mat& image,
  // CV_OUT std::vector<KeyPoint>& keypoints,
  // int maxCount=0, bool scaleCoords=true) const;
  // void operator()(const std::vector<Mat>& pyr,
  // CV_OUT std::vector<KeyPoint>& keypoints,
  // int maxCount=0, bool scaleCoords=true) const;
  // void getMostStable2D(const Mat& image, CV_OUT std::vector<KeyPoint>& keypoints,
  // int maxCount, const PatchGenerator& patchGenerator) const;
  // void setVerbose(bool verbose);
  //
  // void read(const FileNode& node);
  // void write(FileStorage& fs, const String& name=String()) const;
  //
  // int radius;
  // int threshold;
  // int nOctaves;
  // int nViews;
  // bool verbose;
  //
  // double baseFeatureSize;
  // double clusteringDistance;
  // };
  //
  // typedef LDetector YAPE;
  //
  // class CV_EXPORTS FernClassifier
  // {
  // public:
  // FernClassifier();
  // FernClassifier(const FileNode& node);
  // FernClassifier(const std::vector<std::vector<Point2f> >& points,
  // const std::vector<Mat>& refimgs,
  // const std::vector<std::vector<int> >& labels=std::vector<std::vector<int> >(),
  // int _nclasses=0, int _patchSize=PATCH_SIZE,
  // int _signatureSize=DEFAULT_SIGNATURE_SIZE,
  // int _nstructs=DEFAULT_STRUCTS,
  // int _structSize=DEFAULT_STRUCT_SIZE,
  // int _nviews=DEFAULT_VIEWS,
  // int _compressionMethod=COMPRESSION_NONE,
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // virtual ~FernClassifier();
  // virtual void read(const FileNode& n);
  // virtual void write(FileStorage& fs, const String& name=String()) const;
  // virtual void trainFromSingleView(const Mat& image,
  // const std::vector<KeyPoint>& keypoints,
  // int _patchSize=PATCH_SIZE,
  // int _signatureSize=DEFAULT_SIGNATURE_SIZE,
  // int _nstructs=DEFAULT_STRUCTS,
  // int _structSize=DEFAULT_STRUCT_SIZE,
  // int _nviews=DEFAULT_VIEWS,
  // int _compressionMethod=COMPRESSION_NONE,
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // virtual void train(const std::vector<std::vector<Point2f> >& points,
  // const std::vector<Mat>& refimgs,
  // const std::vector<std::vector<int> >& labels=std::vector<std::vector<int> >(),
  // int _nclasses=0, int _patchSize=PATCH_SIZE,
  // int _signatureSize=DEFAULT_SIGNATURE_SIZE,
  // int _nstructs=DEFAULT_STRUCTS,
  // int _structSize=DEFAULT_STRUCT_SIZE,
  // int _nviews=DEFAULT_VIEWS,
  // int _compressionMethod=COMPRESSION_NONE,
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // virtual int operator()(const Mat& img, Point2f kpt, std::vector<float>& signature) const;
  // virtual int operator()(const Mat& patch, std::vector<float>& signature) const;
  // virtual void clear();
  // virtual bool empty() const;
  // void setVerbose(bool verbose);
  //
  // int getClassCount() const;
  // int getStructCount() const;
  // int getStructSize() const;
  // int getSignatureSize() const;
  // int getCompressionMethod() const;
  // Size getPatchSize() const;
  //
  // struct Feature
  // {
  // uchar x1, y1, x2, y2;
  // Feature() : x1(0), y1(0), x2(0), y2(0) {}
  // Feature(int _x1, int _y1, int _x2, int _y2)
  // : x1((uchar)_x1), y1((uchar)_y1), x2((uchar)_x2), y2((uchar)_y2)
  // {}
  // template<typename _Tp> bool operator ()(const Mat_<_Tp>& patch) const
  // { return patch(y1,x1) > patch(y2, x2); }
  // };
  //
  // enum
  // {
  // PATCH_SIZE = 31,
  // DEFAULT_STRUCTS = 50,
  // DEFAULT_STRUCT_SIZE = 9,
  // DEFAULT_VIEWS = 5000,
  // DEFAULT_SIGNATURE_SIZE = 176,
  // COMPRESSION_NONE = 0,
  // COMPRESSION_RANDOM_PROJ = 1,
  // COMPRESSION_PCA = 2,
  // DEFAULT_COMPRESSION_METHOD = COMPRESSION_NONE
  // };
  //
  // protected:
  // virtual void prepare(int _nclasses, int _patchSize, int _signatureSize,
  // int _nstructs, int _structSize,
  // int _nviews, int _compressionMethod);
  // virtual void finalize(RNG& rng);
  // virtual int getLeaf(int fidx, const Mat& patch) const;
  //
  // bool verbose;
  // int nstructs;
  // int structSize;
  // int nclasses;
  // int signatureSize;
  // int compressionMethod;
  // int leavesPerStruct;
  // Size patchSize;
  // std::vector<Feature> features;
  // std::vector<int> classCounters;
  // std::vector<float> posteriors;
  // };
  //
  //
  (* ***************************************************************************************\
    // *                                 Calonder Classifier                                    *
    // \*************************************************************************************** *)
  //
  // struct RTreeNode;
  //
  // struct CV_EXPORTS BaseKeypoint
  // {
  // int x;
  // int y;
  // IplImage* image;
  //
  // BaseKeypoint()
  // : x(0), y(0), image(NULL)
  // {}
  //
  // BaseKeypoint(int _x, int _y, IplImage* _image)
  // : x(_x), y(_y), image(_image)
  // {}
  // };
  //
  // class CV_EXPORTS RandomizedTree
  // {
  // public:
  // friend class RTreeClassifier;
  //
  // static const uchar PATCH_SIZE = 32;
  // static const int DEFAULT_DEPTH = 9;
  // static const int DEFAULT_VIEWS = 5000;
  // static const size_t DEFAULT_REDUCED_NUM_DIM = 176;
  // static float GET_LOWER_QUANT_PERC() { return .03f; }
  // static float GET_UPPER_QUANT_PERC() { return .92f; }
  //
  // RandomizedTree();
  // ~RandomizedTree();
  //
  // void train(std::vector<BaseKeypoint> const& base_set, RNG &rng,
  // int depth, int views, size_t reduced_num_dim, int num_quant_bits);
  // void train(std::vector<BaseKeypoint> const& base_set, RNG &rng,
  // PatchGenerator &make_patch, int depth, int views, size_t reduced_num_dim,
  // int num_quant_bits);
  //
  // // following two funcs are EXPERIMENTAL (do not use unless you know exactly what you do)
  // static void quantizeVector(float *vec, int dim, int N, float bnds[2], int clamp_mode=0);
  // static void quantizeVector(float *src, int dim, int N, float bnds[2], uchar *dst);
  //
  // // patch_data must be a 32x32 array (no row padding)
  // float* getPosterior(uchar* patch_data);
  // const float* getPosterior(uchar* patch_data) const;
  // uchar* getPosterior2(uchar* patch_data);
  // const uchar* getPosterior2(uchar* patch_data) const;
  //
  // void read(const char* file_name, int num_quant_bits);
  // void read(std::istream &is, int num_quant_bits);
  // void write(const char* file_name) const;
  // void write(std::ostream &os) const;
  //
  // int classes() { return classes_; }
  // int depth() { return depth_; }
  //
  // //void setKeepFloatPosteriors(bool b) { keep_float_posteriors_ = b; }
  // void discardFloatPosteriors() { freePosteriors(1); }
  //
  // inline void applyQuantization(int num_quant_bits) { makePosteriors2(num_quant_bits); }
  //
  // // debug
  // void savePosteriors(String url, bool append=false);
  // void savePosteriors2(String url, bool append=false);
  //
  // private:
  // int classes_;
  // int depth_;
  // int num_leaves_;
  // std::vector<RTreeNode> nodes_;
  // float **posteriors_;        // 16-bytes aligned posteriors
  // uchar **posteriors2_;     // 16-bytes aligned posteriors
  // std::vector<int> leaf_counts_;
  //
  // void createNodes(int num_nodes, RNG &rng);
  // void allocPosteriorsAligned(int num_leaves, int num_classes);
  // void freePosteriors(int which);    // which: 1=posteriors_, 2=posteriors2_, 3=both
  // void init(int classes, int depth, RNG &rng);
  // void addExample(int class_id, uchar* patch_data);
  // void finalize(size_t reduced_num_dim, int num_quant_bits);
  // int getIndex(uchar* patch_data) const;
  // inline float* getPosteriorByIndex(int index);
  // inline const float* getPosteriorByIndex(int index) const;
  // inline uchar* getPosteriorByIndex2(int index);
  // inline const uchar* getPosteriorByIndex2(int index) const;
  // //void makeRandomMeasMatrix(float *cs_phi, PHI_DISTR_TYPE dt, size_t reduced_num_dim);
  // void convertPosteriorsToChar();
  // void makePosteriors2(int num_quant_bits);
  // void compressLeaves(size_t reduced_num_dim);
  // void estimateQuantPercForPosteriors(float perc[2]);
  // };
  //
  //
  // inline uchar* getData(IplImage* image)
  // {
  // return reinterpret_cast<uchar*>(image->imageData);
  // }
  //
  // inline float* RandomizedTree::getPosteriorByIndex(int index)
  // {
  // return const_cast<float*>(const_cast<const RandomizedTree*>(this)->getPosteriorByIndex(index));
  // }
  //
  // inline const float* RandomizedTree::getPosteriorByIndex(int index) const
  // {
  // return posteriors_[index];
  // }
  //
  // inline uchar* RandomizedTree::getPosteriorByIndex2(int index)
  // {
  // return const_cast<uchar*>(const_cast<const RandomizedTree*>(this)->getPosteriorByIndex2(index));
  // }
  //
  // inline const uchar* RandomizedTree::getPosteriorByIndex2(int index) const
  // {
  // return posteriors2_[index];
  // }
  //
  // struct CV_EXPORTS RTreeNode
  // {
  // short offset1, offset2;
  //
  // RTreeNode() {}
  // RTreeNode(uchar x1, uchar y1, uchar x2, uchar y2)
  // : offset1(y1*RandomizedTree::PATCH_SIZE + x1),
  // offset2(y2*RandomizedTree::PATCH_SIZE + x2)
  // {}
  //
  // //! Left child on 0, right child on 1
  // inline bool operator() (uchar* patch_data) const
  // {
  // return patch_data[offset1] > patch_data[offset2];
  // }
  // };
  //
  // class CV_EXPORTS RTreeClassifier
  // {
  // public:
  // static const int DEFAULT_TREES = 48;
  // static const size_t DEFAULT_NUM_QUANT_BITS = 4;
  //
  // RTreeClassifier();
  // void train(std::vector<BaseKeypoint> const& base_set,
  // RNG &rng,
  // int num_trees = RTreeClassifier::DEFAULT_TREES,
  // int depth = RandomizedTree::DEFAULT_DEPTH,
  // int views = RandomizedTree::DEFAULT_VIEWS,
  // size_t reduced_num_dim = RandomizedTree::DEFAULT_REDUCED_NUM_DIM,
  // int num_quant_bits = DEFAULT_NUM_QUANT_BITS);
  // void train(std::vector<BaseKeypoint> const& base_set,
  // RNG &rng,
  // PatchGenerator &make_patch,
  // int num_trees = RTreeClassifier::DEFAULT_TREES,
  // int depth = RandomizedTree::DEFAULT_DEPTH,
  // int views = RandomizedTree::DEFAULT_VIEWS,
  // size_t reduced_num_dim = RandomizedTree::DEFAULT_REDUCED_NUM_DIM,
  // int num_quant_bits = DEFAULT_NUM_QUANT_BITS);
  //
  // // sig must point to a memory block of at least classes()*sizeof(float|uchar) bytes
  // void getSignature(IplImage *patch, uchar *sig) const;
  // void getSignature(IplImage *patch, float *sig) const;
  // void getSparseSignature(IplImage *patch, float *sig, float thresh) const;
  // // TODO: deprecated in favor of getSignature overload, remove
  // void getFloatSignature(IplImage *patch, float *sig) const { getSignature(patch, sig); }
  //
  // static int countNonZeroElements(float *vec, int n, double tol=1e-10);
  // static inline void safeSignatureAlloc(uchar **sig, int num_sig=1, int sig_len=176);
  // static inline uchar* safeSignatureAlloc(int num_sig=1, int sig_len=176);
  //
  // inline int classes() const { return classes_; }
  // inline int original_num_classes() const { return original_num_classes_; }
  //
  // void setQuantization(int num_quant_bits);
  // void discardFloatPosteriors();
  //
  // void read(const char* file_name);
  // void read(std::istream &is);
  // void write(const char* file_name) const;
  // void write(std::ostream &os) const;
  //
  // // experimental and debug
  // void saveAllFloatPosteriors(String file_url);
  // void saveAllBytePosteriors(String file_url);
  // void setFloatPosteriorsFromTextfile_176(String url);
  // float countZeroElements();
  //
  // std::vector<RandomizedTree> trees_;
  //
  // private:
  // int classes_;
  // int num_quant_bits_;
  // mutable uchar **posteriors_;
  // mutable unsigned short *ptemp_;
  // int original_num_classes_;
  // bool keep_floats_;
  // };
  //
  (* ***************************************************************************************\
    // *                                     One-Way Descriptor                                 *
    // \*************************************************************************************** *)
  //
  /// / CvAffinePose: defines a parameterized affine transformation of an image patch.
  /// / An image patch is rotated on angle phi (in degrees), then scaled lambda1 times
  /// / along horizontal and lambda2 times along vertical direction, and then rotated again
  /// / on angle (theta - phi).
  // class CV_EXPORTS CvAffinePose
  // {
  // public:
  // float phi;
  // float theta;
  // float lambda1;
  // float lambda2;
  // };
  //
  // class CV_EXPORTS OneWayDescriptor
  // {
  // public:
  // OneWayDescriptor();
  // ~OneWayDescriptor();
  //
  // // allocates memory for given descriptor parameters
  // void Allocate(int pose_count, CvSize size, int nChannels);
  //
  // // GenerateSamples: generates affine transformed patches with averaging them over small transformation variations.
  // // If external poses and transforms were specified, uses them instead of generating random ones
  // // - pose_count: the number of poses to be generated
  // // - frontal: the input patch (can be a roi in a larger image)
  // // - norm: if nonzero, normalizes the output patch so that the sum of pixel intensities is 1
  // void GenerateSamples(int pose_count, IplImage* frontal, int norm = 0);
  //
  // // GenerateSamplesFast: generates affine transformed patches with averaging them over small transformation variations.
  // // Uses precalculated transformed pca components.
  // // - frontal: the input patch (can be a roi in a larger image)
  // // - pca_hr_avg: pca average vector
  // // - pca_hr_eigenvectors: pca eigenvectors
  // // - pca_descriptors: an array of precomputed descriptors of pca components containing their affine transformations
  // //   pca_descriptors[0] corresponds to the average, pca_descriptors[1]-pca_descriptors[pca_dim] correspond to eigenvectors
  // void GenerateSamplesFast(IplImage* frontal, CvMat* pca_hr_avg,
  // CvMat* pca_hr_eigenvectors, OneWayDescriptor* pca_descriptors);
  //
  // // sets the poses and corresponding transforms
  // void SetTransforms(CvAffinePose* poses, CvMat** transforms);
  //
  // // Initialize: builds a descriptor.
  // // - pose_count: the number of poses to build. If poses were set externally, uses them rather than generating random ones
  // // - frontal: input patch. Can be a roi in a larger image
  // // - feature_name: the feature name to be associated with the descriptor
  // // - norm: if 1, the affine transformed patches are normalized so that their sum is 1
  // void Initialize(int pose_count, IplImage* frontal, const char* feature_name = 0, int norm = 0);
  //
  // // InitializeFast: builds a descriptor using precomputed descriptors of pca components
  // // - pose_count: the number of poses to build
  // // - frontal: input patch. Can be a roi in a larger image
  // // - feature_name: the feature name to be associated with the descriptor
  // // - pca_hr_avg: average vector for PCA
  // // - pca_hr_eigenvectors: PCA eigenvectors (one vector per row)
  // // - pca_descriptors: precomputed descriptors of PCA components, the first descriptor for the average vector
  // // followed by the descriptors for eigenvectors
  // void InitializeFast(int pose_count, IplImage* frontal, const char* feature_name,
  // CvMat* pca_hr_avg, CvMat* pca_hr_eigenvectors, OneWayDescriptor* pca_descriptors);
  //
  // // ProjectPCASample: unwarps an image patch into a vector and projects it into PCA space
  // // - patch: input image patch
  // // - avg: PCA average vector
  // // - eigenvectors: PCA eigenvectors, one per row
  // // - pca_coeffs: output PCA coefficients
  // void ProjectPCASample(IplImage* patch, CvMat* avg, CvMat* eigenvectors, CvMat* pca_coeffs) const;
  //
  // // InitializePCACoeffs: projects all warped patches into PCA space
  // // - avg: PCA average vector
  // // - eigenvectors: PCA eigenvectors, one per row
  // void InitializePCACoeffs(CvMat* avg, CvMat* eigenvectors);
  //
  // // EstimatePose: finds the closest match between an input patch and a set of patches with different poses
  // // - patch: input image patch
  // // - pose_idx: the output index of the closest pose
  // // - distance: the distance to the closest pose (L2 distance)
  // void EstimatePose(IplImage* patch, int& pose_idx, float& distance) const;
  //
  // // EstimatePosePCA: finds the closest match between an input patch and a set of patches with different poses.
  // // The distance between patches is computed in PCA space
  // // - patch: input image patch
  // // - pose_idx: the output index of the closest pose
  // // - distance: distance to the closest pose (L2 distance in PCA space)
  // // - avg: PCA average vector. If 0, matching without PCA is used
  // // - eigenvectors: PCA eigenvectors, one per row
  // void EstimatePosePCA(CvArr* patch, int& pose_idx, float& distance, CvMat* avg, CvMat* eigenvalues) const;
  //
  // // GetPatchSize: returns the size of each image patch after warping (2 times smaller than the input patch)
  // CvSize GetPatchSize() const
  // {
  // return m_patch_size;
  // }
  //
  // // GetInputPatchSize: returns the required size of the patch that the descriptor is built from
  // // (2 time larger than the patch after warping)
  // CvSize GetInputPatchSize() const
  // {
  // return cvSize(m_patch_size.width*2, m_patch_size.height*2);
  // }
  //
  // // GetPatch: returns a patch corresponding to specified pose index
  // // - index: pose index
  // // - return value: the patch corresponding to specified pose index
  // IplImage* GetPatch(int index);
  //
  // // GetPose: returns a pose corresponding to specified pose index
  // // - index: pose index
  // // - return value: the pose corresponding to specified pose index
  // CvAffinePose GetPose(int index) const;
  //
  // // Save: saves all patches with different poses to a specified path
  // void Save(const char* path);
  //
  // // ReadByName: reads a descriptor from a file storage
  // // - fs: file storage
  // // - parent: parent node
  // // - name: node name
  // // - return value: 1 if succeeded, 0 otherwise
  // int ReadByName(CvFileStorage* fs, CvFileNode* parent, const char* name);
  //
  // // ReadByName: reads a descriptor from a file node
  // // - parent: parent node
  // // - name: node name
  // // - return value: 1 if succeeded, 0 otherwise
  // int ReadByName(const FileNode &parent, const char* name);
  //
  // // Write: writes a descriptor into a file storage
  // // - fs: file storage
  // // - name: node name
  // void Write(CvFileStorage* fs, const char* name);
  //
  // // GetFeatureName: returns a name corresponding to a feature
  // const char* GetFeatureName() const;
  //
  // // GetCenter: returns the center of the feature
  // CvPoint GetCenter() const;
  //
  // void SetPCADimHigh(int pca_dim_high) {m_pca_dim_high = pca_dim_high;};
  // void SetPCADimLow(int pca_dim_low) {m_pca_dim_low = pca_dim_low;};
  //
  // int GetPCADimLow() const;
  // int GetPCADimHigh() const;
  //
  // CvMat** GetPCACoeffs() const {return m_pca_coeffs;}
  //
  // protected:
  // int m_pose_count; // the number of poses
  // CvSize m_patch_size; // size of each image
  // IplImage** m_samples; // an array of length m_pose_count containing the patch in different poses
  // IplImage* m_input_patch;
  // IplImage* m_train_patch;
  // CvMat** m_pca_coeffs; // an array of length m_pose_count containing pca decomposition of the patch in different poses
  // CvAffinePose* m_affine_poses; // an array of poses
  // CvMat** m_transforms; // an array of affine transforms corresponding to poses
  //
  // String m_feature_name; // the name of the feature associated with the descriptor
  // CvPoint m_center; // the coordinates of the feature (the center of the input image ROI)
  //
  // int m_pca_dim_high; // the number of descriptor pca components to use for generating affine poses
  // int m_pca_dim_low; // the number of pca components to use for comparison
  // };
  //
  //
  /// / OneWayDescriptorBase: encapsulates functionality for training/loading a set of one way descriptors
  /// / and finding the nearest closest descriptor to an input feature
  // class CV_EXPORTS OneWayDescriptorBase
  // {
  // public:
  //
  // // creates an instance of OneWayDescriptor from a set of training files
  // // - patch_size: size of the input (large) patch
  // // - pose_count: the number of poses to generate for each descriptor
  // // - train_path: path to training files
  // // - pca_config: the name of the file that contains PCA for small patches (2 times smaller
  // // than patch_size each dimension
  // // - pca_hr_config: the name of the file that contains PCA for large patches (of patch_size size)
  // // - pca_desc_config: the name of the file that contains descriptors of PCA components
  // OneWayDescriptorBase(CvSize patch_size, int pose_count, const char* train_path = 0, const char* pca_config = 0,
  // const char* pca_hr_config = 0, const char* pca_desc_config = 0, int pyr_levels = 1,
  // int pca_dim_high = 100, int pca_dim_low = 100);
  //
  // OneWayDescriptorBase(CvSize patch_size, int pose_count, const String &pca_filename, const String &train_path = String(), const String &images_list = String(),
  // float _scale_min = 0.7f, float _scale_max=1.5f, float _scale_step=1.2f, int pyr_levels = 1,
  // int pca_dim_high = 100, int pca_dim_low = 100);
  //
  //
  // virtual ~OneWayDescriptorBase();
  // void clear ();
  //
  //
  // // Allocate: allocates memory for a given number of descriptors
  // void Allocate(int train_feature_count);
  //
  // // AllocatePCADescriptors: allocates memory for pca descriptors
  // void AllocatePCADescriptors();
  //
  // // returns patch size
  // CvSize GetPatchSize() const {return m_patch_size;};
  // // returns the number of poses for each descriptor
  // int GetPoseCount() const {return m_pose_count;};
  //
  // // returns the number of pyramid levels
  // int GetPyrLevels() const {return m_pyr_levels;};
  //
  // // returns the number of descriptors
  // int GetDescriptorCount() const {return m_train_feature_count;};
  //
  // // CreateDescriptorsFromImage: creates descriptors for each of the input features
  // // - src: input image
  // // - features: input features
  // // - pyr_levels: the number of pyramid levels
  // void CreateDescriptorsFromImage(IplImage* src, const std::vector<KeyPoint>& features);
  //
  // // CreatePCADescriptors: generates descriptors for PCA components, needed for fast generation of feature descriptors
  // void CreatePCADescriptors();
  //
  // // returns a feature descriptor by feature index
  // const OneWayDescriptor* GetDescriptor(int desc_idx) const {return &m_descriptors[desc_idx];};
  //
  // // FindDescriptor: finds the closest descriptor
  // // - patch: input image patch
  // // - desc_idx: output index of the closest descriptor to the input patch
  // // - pose_idx: output index of the closest pose of the closest descriptor to the input patch
  // // - distance: distance from the input patch to the closest feature pose
  // // - _scales: scales of the input patch for each descriptor
  // // - scale_ranges: input scales variation (float[2])
  // void FindDescriptor(IplImage* patch, int& desc_idx, int& pose_idx, float& distance, float* _scale = 0, float* scale_ranges = 0) const;
  //
  // // - patch: input image patch
  // // - n: number of the closest indexes
  // // - desc_idxs: output indexes of the closest descriptor to the input patch (n)
  // // - pose_idx: output indexes of the closest pose of the closest descriptor to the input patch (n)
  // // - distances: distance from the input patch to the closest feature pose (n)
  // // - _scales: scales of the input patch
  // // - scale_ranges: input scales variation (float[2])
  // void FindDescriptor(IplImage* patch, int n, std::vector<int>& desc_idxs, std::vector<int>& pose_idxs,
  // std::vector<float>& distances, std::vector<float>& _scales, float* scale_ranges = 0) const;
  //
  // // FindDescriptor: finds the closest descriptor
  // // - src: input image
  // // - pt: center of the feature
  // // - desc_idx: output index of the closest descriptor to the input patch
  // // - pose_idx: output index of the closest pose of the closest descriptor to the input patch
  // // - distance: distance from the input patch to the closest feature pose
  // void FindDescriptor(IplImage* src, cv::Point2f pt, int& desc_idx, int& pose_idx, float& distance) const;
  //
  // // InitializePoses: generates random poses
  // void InitializePoses();
  //
  // // InitializeTransformsFromPoses: generates 2x3 affine matrices from poses (initializes m_transforms)
  // void InitializeTransformsFromPoses();
  //
  // // InitializePoseTransforms: subsequently calls InitializePoses and InitializeTransformsFromPoses
  // void InitializePoseTransforms();
  //
  // // InitializeDescriptor: initializes a descriptor
  // // - desc_idx: descriptor index
  // // - train_image: image patch (ROI is supported)
  // // - feature_label: feature textual label
  // void InitializeDescriptor(int desc_idx, IplImage* train_image, const char* feature_label);
  //
  // void InitializeDescriptor(int desc_idx, IplImage* train_image, const KeyPoint& keypoint, const char* feature_label);
  //
  // // InitializeDescriptors: load features from an image and create descriptors for each of them
  // void InitializeDescriptors(IplImage* train_image, const std::vector<KeyPoint>& features,
  // const char* feature_label = "", int desc_start_idx = 0);
  //
  // // Write: writes this object to a file storage
  // // - fs: output filestorage
  // void Write (FileStorage &fs) const;
  //
  // // Read: reads OneWayDescriptorBase object from a file node
  // // - fn: input file node
  // void Read (const FileNode &fn);
  //
  // // LoadPCADescriptors: loads PCA descriptors from a file
  // // - filename: input filename
  // int LoadPCADescriptors(const char* filename);
  //
  // // LoadPCADescriptors: loads PCA descriptors from a file node
  // // - fn: input file node
  // int LoadPCADescriptors(const FileNode &fn);
  //
  // // SavePCADescriptors: saves PCA descriptors to a file
  // // - filename: output filename
  // void SavePCADescriptors(const char* filename);
  //
  // // SavePCADescriptors: saves PCA descriptors to a file storage
  // // - fs: output file storage
  // void SavePCADescriptors(CvFileStorage* fs) const;
  //
  // // GeneratePCA: calculate and save PCA components and descriptors
  // // - img_path: path to training PCA images directory
  // // - images_list: filename with filenames of training PCA images
  // void GeneratePCA(const char* img_path, const char* images_list, int pose_count=500);
  //
  // // SetPCAHigh: sets the high resolution pca matrices (copied to internal structures)
  // void SetPCAHigh(CvMat* avg, CvMat* eigenvectors);
  //
  // // SetPCALow: sets the low resolution pca matrices (copied to internal structures)
  // void SetPCALow(CvMat* avg, CvMat* eigenvectors);
  //
  // int GetLowPCA(CvMat** avg, CvMat** eigenvectors)
  // {
  // *avg = m_pca_avg;
  // *eigenvectors = m_pca_eigenvectors;
  // return m_pca_dim_low;
  // };
  //
  // int GetPCADimLow() const {return m_pca_dim_low;};
  // int GetPCADimHigh() const {return m_pca_dim_high;};
  //
  // void ConvertDescriptorsArrayToTree(); // Converting pca_descriptors array to KD tree
  //
  // // GetPCAFilename: get default PCA filename
  // static String GetPCAFilename () { return "pca.yml"; }
  //
  // virtual bool empty() const { return m_train_feature_count <= 0 ? true : false; }
  //
  // protected:
  // CvSize m_patch_size; // patch size
  // int m_pose_count; // the number of poses for each descriptor
  // int m_train_feature_count; // the number of the training features
  // OneWayDescriptor* m_descriptors; // array of train feature descriptors
  // CvMat* m_pca_avg; // PCA average Vector for small patches
  // CvMat* m_pca_eigenvectors; // PCA eigenvectors for small patches
  // CvMat* m_pca_hr_avg; // PCA average Vector for large patches
  // CvMat* m_pca_hr_eigenvectors; // PCA eigenvectors for large patches
  // OneWayDescriptor* m_pca_descriptors; // an array of PCA descriptors
  //
  // cv::flann::Index* m_pca_descriptors_tree;
  // CvMat* m_pca_descriptors_matrix;
  //
  // CvAffinePose* m_poses; // array of poses
  // CvMat** m_transforms; // array of affine transformations corresponding to poses
  //
  // int m_pca_dim_high;
  // int m_pca_dim_low;
  //
  // int m_pyr_levels;
  // float scale_min;
  // float scale_max;
  // float scale_step;
  //
  // // SavePCAall: saves PCA components and descriptors to a file storage
  // // - fs: output file storage
  // void SavePCAall (FileStorage &fs) const;
  //
  // // LoadPCAall: loads PCA components and descriptors from a file node
  // // - fn: input file node
  // void LoadPCAall (const FileNode &fn);
  // };
  //
  // class CV_EXPORTS OneWayDescriptorObject : public OneWayDescriptorBase
  // {
  // public:
  // // creates an instance of OneWayDescriptorObject from a set of training files
  // // - patch_size: size of the input (large) patch
  // // - pose_count: the number of poses to generate for each descriptor
  // // - train_path: path to training files
  // // - pca_config: the name of the file that contains PCA for small patches (2 times smaller
  // // than patch_size each dimension
  // // - pca_hr_config: the name of the file that contains PCA for large patches (of patch_size size)
  // // - pca_desc_config: the name of the file that contains descriptors of PCA components
  // OneWayDescriptorObject(CvSize patch_size, int pose_count, const char* train_path, const char* pca_config,
  // const char* pca_hr_config = 0, const char* pca_desc_config = 0, int pyr_levels = 1);
  //
  // OneWayDescriptorObject(CvSize patch_size, int pose_count, const String &pca_filename,
  // const String &train_path = String (), const String &images_list = String (),
  // float _scale_min = 0.7f, float _scale_max=1.5f, float _scale_step=1.2f, int pyr_levels = 1);
  //
  //
  // virtual ~OneWayDescriptorObject();
  //
  // // Allocate: allocates memory for a given number of features
  // // - train_feature_count: the total number of features
  // // - object_feature_count: the number of features extracted from the object
  // void Allocate(int train_feature_count, int object_feature_count);
  //
  //
  // void SetLabeledFeatures(const std::vector<KeyPoint>& features) {m_train_features = features;};
  // std::vector<KeyPoint>& GetLabeledFeatures() {return m_train_features;};
  // const std::vector<KeyPoint>& GetLabeledFeatures() const {return m_train_features;};
  // std::vector<KeyPoint> _GetLabeledFeatures() const;
  //
  // // IsDescriptorObject: returns 1 if descriptor with specified index is positive, otherwise 0
  // int IsDescriptorObject(int desc_idx) const;
  //
  // // MatchPointToPart: returns the part number of a feature if it matches one of the object parts, otherwise -1
  // int MatchPointToPart(CvPoint pt) const;
  //
  // // GetDescriptorPart: returns the part number of the feature corresponding to a specified descriptor
  // // - desc_idx: descriptor index
  // int GetDescriptorPart(int desc_idx) const;
  //
  //
  // void InitializeObjectDescriptors(IplImage* train_image, const std::vector<KeyPoint>& features,
  // const char* feature_label, int desc_start_idx = 0, float scale = 1.0f,
  // int is_background = 0);
  //
  // // GetObjectFeatureCount: returns the number of object features
  // int GetObjectFeatureCount() const {return m_object_feature_count;};
  //
  // protected:
  // int* m_part_id; // contains part id for each of object descriptors
  // std::vector<KeyPoint> m_train_features; // train features
  // int m_object_feature_count; // the number of the positive features
  //
  // };
  //
  //
  (*
    // *  OneWayDescriptorMatcher
    // *)
  // class OneWayDescriptorMatcher;
  // typedef OneWayDescriptorMatcher OneWayDescriptorMatch;
  //
  // class CV_EXPORTS OneWayDescriptorMatcher : public GenericDescriptorMatcher
  // {
  // public:
  // class CV_EXPORTS Params
  // {
  // public:
  // static const int POSE_COUNT = 500;
  // static const int PATCH_WIDTH = 24;
  // static const int PATCH_HEIGHT = 24;
  // static float GET_MIN_SCALE() { return 0.7f; }
  // static float GET_MAX_SCALE() { return 1.5f; }
  // static float GET_STEP_SCALE() { return 1.2f; }
  //
  // Params( int poseCount = POSE_COUNT,
  // Size patchSize = Size(PATCH_WIDTH, PATCH_HEIGHT),
  // String pcaFilename = String(),
  // String trainPath = String(), String trainImagesList = String(),
  // float minScale = GET_MIN_SCALE(), float maxScale = GET_MAX_SCALE(),
  // float stepScale = GET_STEP_SCALE() );
  //
  // int poseCount;
  // Size patchSize;
  // String pcaFilename;
  // String trainPath;
  // String trainImagesList;
  //
  // float minScale, maxScale, stepScale;
  // };
  //
  // OneWayDescriptorMatcher( const Params& params=Params() );
  // virtual ~OneWayDescriptorMatcher();
  //
  // void initialize( const Params& params, const Ptr<OneWayDescriptorBase>& base=Ptr<OneWayDescriptorBase>() );
  //
  // // Clears keypoints storing in collection and OneWayDescriptorBase
  // virtual void clear();
  //
  // virtual void train();
  //
  // virtual bool isMaskSupported();
  //
  // virtual void read( const FileNode &fn );
  // virtual void write( FileStorage& fs ) const;
  //
  // virtual bool empty() const;
  //
  // virtual Ptr<GenericDescriptorMatcher> clone( bool emptyTrainData=false ) const;
  //
  // protected:
  // // Matches a set of keypoints from a single image of the training set. A rectangle with a center in a keypoint
  // // and size (patch_width/2*scale, patch_height/2*scale) is cropped from the source image for each
  // // keypoint. scale is iterated from DescriptorOneWayParams::min_scale to DescriptorOneWayParams::max_scale.
  // // The minimum distance to each training patch with all its affine poses is found over all scales.
  // // The class ID of a match is returned for each keypoint. The distance is calculated over PCA components
  // // loaded with DescriptorOneWay::Initialize, kd tree is used for finding minimum distances.
  // virtual void knnMatchImpl( const Mat& queryImage, std::vector<KeyPoint>& queryKeypoints,
  // std::vector<std::vector<DMatch> >& matches, int k,
  // const std::vector<Mat>& masks, bool compactResult );
  // virtual void radiusMatchImpl( const Mat& queryImage, std::vector<KeyPoint>& queryKeypoints,
  // std::vector<std::vector<DMatch> >& matches, float maxDistance,
  // const std::vector<Mat>& masks, bool compactResult );
  //
  // Ptr<OneWayDescriptorBase> base;
  // Params params;
  // int prevTrainCount;
  // };
  //
  (*
    // *  FernDescriptorMatcher
    // *)
  // class FernDescriptorMatcher;
  // typedef FernDescriptorMatcher FernDescriptorMatch;
  //
  // class CV_EXPORTS FernDescriptorMatcher : public GenericDescriptorMatcher
  // {
  // public:
  // class CV_EXPORTS Params
  // {
  // public:
  // Params( int nclasses=0,
  // int patchSize=FernClassifier::PATCH_SIZE,
  // int signatureSize=FernClassifier::DEFAULT_SIGNATURE_SIZE,
  // int nstructs=FernClassifier::DEFAULT_STRUCTS,
  // int structSize=FernClassifier::DEFAULT_STRUCT_SIZE,
  // int nviews=FernClassifier::DEFAULT_VIEWS,
  // int compressionMethod=FernClassifier::COMPRESSION_NONE,
  // const PatchGenerator& patchGenerator=PatchGenerator() );
  //
  // Params( const String& filename );
  //
  // int nclasses;
  // int patchSize;
  // int signatureSize;
  // int nstructs;
  // int structSize;
  // int nviews;
  // int compressionMethod;
  // PatchGenerator patchGenerator;
  //
  // String filename;
  // };
  //
  // FernDescriptorMatcher( const Params& params=Params() );
  // virtual ~FernDescriptorMatcher();
  //
  // virtual void clear();
  //
  // virtual void train();
  //
  // virtual bool isMaskSupported();
  //
  // virtual void read( const FileNode &fn );
  // virtual void write( FileStorage& fs ) const;
  // virtual bool empty() const;
  //
  // virtual Ptr<GenericDescriptorMatcher> clone( bool emptyTrainData=false ) const;
  //
  // protected:
  // virtual void knnMatchImpl( const Mat& queryImage, std::vector<KeyPoint>& queryKeypoints,
  // std::vector<std::vector<DMatch> >& matches, int k,
  // const std::vector<Mat>& masks, bool compactResult );
  // virtual void radiusMatchImpl( const Mat& queryImage, std::vector<KeyPoint>& queryKeypoints,
  // std::vector<std::vector<DMatch> >& matches, float maxDistance,
  // const std::vector<Mat>& masks, bool compactResult );
  //
  // void trainFernClassifier();
  // void calcBestProbAndMatchIdx( const Mat& image, const Point2f& pt,
  // float& bestProb, int& bestMatchIdx, std::vector<float>& signature );
  // Ptr<FernClassifier> classifier;
  // Params params;
  // int prevTrainCount;
  // };
  //
  //
  (*
    // * CalonderDescriptorExtractor
    // *)
  // template<typename T>
  // class CV_EXPORTS CalonderDescriptorExtractor : public DescriptorExtractor
  // {
  // public:
  // CalonderDescriptorExtractor( const String& classifierFile );
  //
  // virtual void read( const FileNode &fn );
  // virtual void write( FileStorage &fs ) const;
  //
  // virtual int descriptorSize() const { return classifier_.classes(); }
  // virtual int descriptorType() const { return DataType<T>::type; }
  //
  // virtual bool empty() const;
  //
  // protected:
  // virtual void computeImpl( const Mat& image, std::vector<KeyPoint>& keypoints, Mat& descriptors ) const;
  //
  // RTreeClassifier classifier_;
  // static const int BORDER_SIZE = 16;
  // };
  //
  // template<typename T>
  // CalonderDescriptorExtractor<T>::CalonderDescriptorExtractor(const String& classifier_file)
  // {
  // classifier_.read( classifier_file.c_str() );
  // }
  //
  // template<typename T>
  // void CalonderDescriptorExtractor<T>::computeImpl( const Mat& image,
  // std::vector<KeyPoint>& keypoints,
  // Mat& descriptors) const
  // {
  // // Cannot compute descriptors for keypoints on the image border.
  // KeyPointsFilter::runByImageBorder(keypoints, image.size(), BORDER_SIZE);
  //
  // /// @todo Check 16-byte aligned
  // descriptors.create((int)keypoints.size(), classifier_.classes(), cv::DataType<T>::type);
  //
  // int patchSize = RandomizedTree::PATCH_SIZE;
  // int offset = patchSize / 2;
  // for (size_t i = 0; i < keypoints.size(); ++i)
  // {
  // cv::Point2f pt = keypoints[i].pt;
  // IplImage ipl = image( Rect((int)(pt.x - offset), (int)(pt.y - offset), patchSize, patchSize) );
  // classifier_.getSignature( &ipl, descriptors.ptr<T>((int)i));
  // }
  // }
  //
  // template<typename T>
  // void CalonderDescriptorExtractor<T>::read( const FileNode& )
  // {}
  //
  // template<typename T>
  // void CalonderDescriptorExtractor<T>::write( FileStorage& ) const
  // {}
  //
  // template<typename T>
  // bool CalonderDescriptorExtractor<T>::empty() const
  // {
  // return classifier_.trees_.empty();
  // }
  //
  //
  /// ///////////////////// Brute Force Matcher //////////////////////////
  //
  // template<class Distance>
  // class CV_EXPORTS BruteForceMatcher : public BFMatcher
  // {
  // public:
  // BruteForceMatcher( Distance d = Distance() ) : BFMatcher(Distance::normType, false) {(void)d;}
  // virtual ~BruteForceMatcher() {}
  // };
  //
  //
  (* ***************************************************************************************\
    // *                                Planar Object Detection                                 *
    // \*************************************************************************************** *)
  //
  // class CV_EXPORTS PlanarObjectDetector
  // {
  // public:
  // PlanarObjectDetector();
  // PlanarObjectDetector(const FileNode& node);
  // PlanarObjectDetector(const std::vector<Mat>& pyr, int _npoints=300,
  // int _patchSize=FernClassifier::PATCH_SIZE,
  // int _nstructs=FernClassifier::DEFAULT_STRUCTS,
  // int _structSize=FernClassifier::DEFAULT_STRUCT_SIZE,
  // int _nviews=FernClassifier::DEFAULT_VIEWS,
  // const LDetector& detector=LDetector(),
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // virtual ~PlanarObjectDetector();
  // virtual void train(const std::vector<Mat>& pyr, int _npoints=300,
  // int _patchSize=FernClassifier::PATCH_SIZE,
  // int _nstructs=FernClassifier::DEFAULT_STRUCTS,
  // int _structSize=FernClassifier::DEFAULT_STRUCT_SIZE,
  // int _nviews=FernClassifier::DEFAULT_VIEWS,
  // const LDetector& detector=LDetector(),
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // virtual void train(const std::vector<Mat>& pyr, const std::vector<KeyPoint>& keypoints,
  // int _patchSize=FernClassifier::PATCH_SIZE,
  // int _nstructs=FernClassifier::DEFAULT_STRUCTS,
  // int _structSize=FernClassifier::DEFAULT_STRUCT_SIZE,
  // int _nviews=FernClassifier::DEFAULT_VIEWS,
  // const LDetector& detector=LDetector(),
  // const PatchGenerator& patchGenerator=PatchGenerator());
  // Rect getModelROI() const;
  // std::vector<KeyPoint> getModelPoints() const;
  // const LDetector& getDetector() const;
  // const FernClassifier& getClassifier() const;
  // void setVerbose(bool verbose);
  //
  // void read(const FileNode& node);
  // void write(FileStorage& fs, const String& name=String()) const;
  // bool operator()(const Mat& image, CV_OUT Mat& H, CV_OUT std::vector<Point2f>& corners) const;
  // bool operator()(const std::vector<Mat>& pyr, const std::vector<KeyPoint>& keypoints,
  // CV_OUT Mat& H, CV_OUT std::vector<Point2f>& corners,
  // CV_OUT std::vector<int>* pairs=0) const;
  //
  // protected:
  // bool verbose;
  // Rect modelROI;
  // std::vector<KeyPoint> modelPoints;
  // LDetector ldetector;
  // FernClassifier fernClassifier;
  // };
  //
  // }
  //
  /// / 2009-01-12, Xavier Delacour <xavier.delacour@gmail.com>
  //
  // struct lsh_hash {
  // int h1, h2;
  // };
  //
  // struct CvLSHOperations
  // {
  // virtual ~CvLSHOperations() {}
  //
  // virtual int vector_add(const void* data) = 0;
  // virtual void vector_remove(int i) = 0;
  // virtual const void* vector_lookup(int i) = 0;
  // virtual void vector_reserve(int n) = 0;
  // virtual unsigned int vector_count() = 0;
  //
  // virtual void hash_insert(lsh_hash h, int l, int i) = 0;
  // virtual void hash_remove(lsh_hash h, int l, int i) = 0;
  // virtual int hash_lookup(lsh_hash h, int l, int* ret_i, int ret_i_max) = 0;
  // };
  //
  // #endif

  (* Splits color or grayscale image into multiple connected components
    // of nearly the same color/brightness using modification of Burt algorithm.
    // comp with contain a pointer to sequence (CvSeq)
    // of connected components (CvConnectedComp) *)
  // CVAPI(void) cvPyrSegmentation( IplImage* src, IplImage* dst,
  // CvMemStorage* storage, CvSeq** comp,
  // int level, double threshold1,
  // double threshold2 );
procedure cvPyrSegmentation(src: pIplImage; dst: pIplImage; storage: pCvMemStorage;

  var comp: pCvSeq; level: Integer; threshold1: double; threshold2: double); cdecl;

(* ***************************************************************************************\
  // *                              Planar subdivisions                                       *
  // \*************************************************************************************** *)
type

  pCvSubdiv2DEdge = ^TCvSubdiv2DEdge;

  TCvSubdiv2DEdge = size_t;
  //
  // #define CV_QUADEDGE2D_FIELDS()     \
  // int flags;                     \
  // struct CvSubdiv2DPoint* pt[4]; \
  // CvSubdiv2DEdge  next[4];
  //
  // #define CV_SUBDIV2D_POINT_FIELDS()\
  // int            flags;      \
  // CvSubdiv2DEdge first;      \
  // CvPoint2D32f   pt;         \
  // int id;
  //
  // #define CV_SUBDIV2D_VIRTUAL_POINT_FLAG (1 << 30)
  //
  // typedef struct CvQuadEdge2D
  // {
  // CV_QUADEDGE2D_FIELDS()
  // }
  // CvQuadEdge2D;
  //
  // typedef struct CvSubdiv2DPoint
  // {
  // CV_SUBDIV2D_POINT_FIELDS()
  // }
  // CvSubdiv2DPoint;
  //
  // #define CV_SUBDIV2D_FIELDS()    \
  // CV_GRAPH_FIELDS()           \
  // int  quad_edges;            \
  // int  is_geometry_valid;     \
  // CvSubdiv2DEdge recent_edge; \
  // CvPoint2D32f  topleft;      \
  // CvPoint2D32f  bottomright;
  //
  // typedef struct CvSubdiv2D
  // {
  // CV_SUBDIV2D_FIELDS()
  // }
  // CvSubdiv2D;

Type
  TCvSubdiv2DPointLocation = Integer;

const
  { CvSubdiv2DPointLocation enum }
  CV_PTLOC_ERROR        = -2;
  CV_PTLOC_OUTSIDE_RECT = -1;
  CV_PTLOC_INSIDE       = 0;
  CV_PTLOC_VERTEX       = 1;
  CV_PTLOC_ON_EDGE      = 2;

Type
  TCvNextEdgeType = Integer;

const
  { CvNextEdgeType enum }
  CV_NEXT_AROUND_ORG   = $00;
  CV_NEXT_AROUND_DST   = $22;
  CV_PREV_AROUND_ORG   = $11;
  CV_PREV_AROUND_DST   = $33;
  CV_NEXT_AROUND_LEFT  = $13;
  CV_NEXT_AROUND_RIGHT = $31;
  CV_PREV_AROUND_LEFT  = $20;
  CV_PREV_AROUND_RIGHT = $02;

  (* get the next edge with the same origin point (counterwise) *)
  // #define  CV_SUBDIV2D_NEXT_EDGE( edge )  (((CvQuadEdge2D*)((edge) & ~3))->next[(edge)&3])

  (* Initializes Delaunay triangulation *)
  // CVAPI(void)  cvInitSubdivDelaunay2D( CvSubdiv2D* subdiv, CvRect rect );
procedure cvInitSubdivDelaunay2D(subdiv: pCvSubdiv2D; rect: TCvRect); cdecl;

(* Creates new subdivision *)
// CVAPI(CvSubdiv2D*)  cvCreateSubdiv2D( int subdiv_type, int header_size,
// int vtx_size, int quadedge_size,
// CvMemStorage* storage );
function cvCreateSubdiv2D(subdiv_type: Integer; header_size: Integer; vtx_size: Integer; quadedge_size: Integer;
  storage: pCvMemStorage): pCvSubdiv2D; cdecl;

(* ************************ high-level subdivision functions ************************** *)
//
(* Simplified Delaunay diagram creation *)
// CV_INLINE  CvSubdiv2D* cvCreateSubdivDelaunay2D( CvRect rect, CvMemStorage* storage )
// {
// CvSubdiv2D* subdiv = cvCreateSubdiv2D( CV_SEQ_KIND_SUBDIV2D, sizeof(*subdiv),
// sizeof(CvSubdiv2DPoint), sizeof(CvQuadEdge2D), storage );
//
// cvInitSubdivDelaunay2D( subdiv, rect );
// return subdiv;
// }

(* Inserts new point to the Delaunay triangulation *)
// CVAPI(CvSubdiv2DPoint*)  cvSubdivDelaunay2DInsert( CvSubdiv2D* subdiv, CvPoint2D32f pt);
function cvSubdivDelaunay2DInsert(subdiv: pCvSubdiv2D; pt: TCvPoint2D32f): pCvSubdiv2DPoint; cdecl;

(* Locates a point within the Delaunay triangulation (finds the edge
  // the point is left to or belongs to, or the triangulation point the given
  // point coinsides with *)
// CVAPI(CvSubdiv2DPointLocation)  cvSubdiv2DLocate(
// CvSubdiv2D* subdiv, CvPoint2D32f pt,
// CvSubdiv2DEdge* edge,
// CvSubdiv2DPoint** vertex CV_DEFAULT(NULL) );

function cvSubdiv2DLocate(subdiv: pCvSubdiv2D; pt: TCvPoint2D32f; edge: pCvSubdiv2DEdge; vertex: pCvSubdiv2DPoint = nil)
  : TCvSubdiv2DPointLocation; cdecl;

(* Calculates Voronoi tesselation (i.e. coordinates of Voronoi points) *)
// CVAPI(void)  cvCalcSubdivVoronoi2D( CvSubdiv2D* subdiv );
procedure cvCalcSubdivVoronoi2D(subdiv: pCvSubdiv2D); cdecl;

(* Removes all Voronoi points from the tesselation *)
// CVAPI(void)  cvClearSubdivVoronoi2D( CvSubdiv2D* subdiv );
//
//
(* Finds the nearest to the given point vertex in subdivision. *)
// CVAPI(CvSubdiv2DPoint*) cvFindNearestPoint2D( CvSubdiv2D* subdiv, CvPoint2D32f pt );
//
//
(* *********** Basic quad-edge navigation and operations *********** *)
//
// CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DNextEdge( CvSubdiv2DEdge edge )
// {
// return  CV_SUBDIV2D_NEXT_EDGE(edge);
// }

// CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DRotateEdge( CvSubdiv2DEdge edge, int rotate )
// {
// return  (edge & ~3) + ((edge + rotate) & 3);
// }
function cvSubdiv2DRotateEdge(edge: TCvSubdiv2DEdge; rotate: Integer): TCvSubdiv2DEdge; // inline;

// CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DSymEdge( CvSubdiv2DEdge edge )
// {
// return edge ^ 2;
// }

// CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DGetEdge( CvSubdiv2DEdge edge, CvNextEdgeType type )
// {
// CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
// edge = e->next[(edge + (int)type) & 3];
// return  (edge & ~3) + ((edge + ((int)type >> 4)) & 3);
// }
function cvSubdiv2DGetEdge(edge: TCvSubdiv2DEdge; _type: TCvNextEdgeType): TCvSubdiv2DEdge; // inline;

// CV_INLINE  CvSubdiv2DPoint*  cvSubdiv2DEdgeOrg( CvSubdiv2DEdge edge )
// {
// CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
// return (CvSubdiv2DPoint*)e->pt[edge & 3];
// }
function cvSubdiv2DEdgeOrg(edge: TCvSubdiv2DEdge): pCvSubdiv2DPoint; // inline;

// CV_INLINE  CvSubdiv2DPoint*  cvSubdiv2DEdgeDst( CvSubdiv2DEdge edge )
// {
// CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
// return (CvSubdiv2DPoint*)e->pt[(edge + 2) & 3];
// }
function cvSubdiv2DEdgeDst(edge: TCvSubdiv2DEdge): pCvSubdiv2DPoint; // inline;

(* ***************************************************************************************\
  // *                           Additional operations on Subdivisions                        *
  // \*************************************************************************************** *)
//
/// / paints voronoi diagram: just demo function
// CVAPI(void)  icvDrawMosaic( CvSubdiv2D* subdiv, IplImage* src, IplImage* dst );
//
/// / checks planar subdivision for correctness. It is not an absolute check,
/// / but it verifies some relations between quad-edges
// CVAPI(int)   icvSubdiv2DCheck( CvSubdiv2D* subdiv );
//
/// / returns squared distance between two 2D points with floating-point coordinates.
// CV_INLINE double icvSqDist2D32f( CvPoint2D32f pt1, CvPoint2D32f pt2 )
// {
// double dx = pt1.x - pt2.x;
// double dy = pt1.y - pt2.y;
//
// return dx*dx + dy*dy;
// }
//
//
//
//
// CV_INLINE  double  cvTriangleArea( CvPoint2D32f a, CvPoint2D32f b, CvPoint2D32f c )
// {
// return ((double)b.x - a.x) * ((double)c.y - a.y) - ((double)b.y - a.y) * ((double)c.x - a.x);
// }
//
//
(* Constructs kd-tree from set of feature descriptors *)
// CVAPI(struct CvFeatureTree*) cvCreateKDTree(CvMat* desc);
//
(* Constructs spill-tree from set of feature descriptors *)
// CVAPI(struct CvFeatureTree*) cvCreateSpillTree( const CvMat* raw_data,
// const int naive CV_DEFAULT(50),
// const double rho CV_DEFAULT(.7),
// const double tau CV_DEFAULT(.1) );
//
(* Release feature tree *)
// CVAPI(void) cvReleaseFeatureTree(struct CvFeatureTree* tr);
//
(* Searches feature tree for k nearest neighbors of given reference points,
  // searching (in case of kd-tree/bbf) at most emax leaves. *)
// CVAPI(void) cvFindFeatures(struct CvFeatureTree* tr, const CvMat* query_points,
// CvMat* indices, CvMat* dist, int k, int emax CV_DEFAULT(20));
//
(* Search feature tree for all points that are inlier to given rect region.
  // Only implemented for kd trees *)
// CVAPI(int) cvFindFeaturesBoxed(struct CvFeatureTree* tr,
// CvMat* bounds_min, CvMat* bounds_max,
// CvMat* out_indices);
//
//
(* Construct a Locality Sensitive Hash (LSH) table, for indexing d-dimensional vectors of
  // given type. Vectors will be hashed L times with k-dimensional p-stable (p=2) functions. *)
// CVAPI(struct CvLSH*) cvCreateLSH(struct CvLSHOperations* ops, int d,
// int L CV_DEFAULT(10), int k CV_DEFAULT(10),
// int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
// int64 seed CV_DEFAULT(-1));
//
(* Construct in-memory LSH table, with n bins. *)
// CVAPI(struct CvLSH*) cvCreateMemoryLSH(int d, int n, int L CV_DEFAULT(10), int k CV_DEFAULT(10),
// int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
// int64 seed CV_DEFAULT(-1));
//
(* Free the given LSH structure. *)
// CVAPI(void) cvReleaseLSH(struct CvLSH** lsh);
//
(* Return the number of vectors in the LSH. *)
// CVAPI(unsigned int) LSHSize(struct CvLSH* lsh);
//
(* Add vectors to the LSH structure, optionally returning indices. *)
// CVAPI(void) cvLSHAdd(struct CvLSH* lsh, const CvMat* data, CvMat* indices CV_DEFAULT(0));
//
(* Remove vectors from LSH, as addressed by given indices. *)
// CVAPI(void) cvLSHRemove(struct CvLSH* lsh, const CvMat* indices);
//
(* Query the LSH n times for at most k nearest points; data is n x d,
  // indices and dist are n x k. At most emax stored points will be accessed. *)
// CVAPI(void) cvLSHQuery(struct CvLSH* lsh, const CvMat* query_points,
// CvMat* indices, CvMat* dist, int k, int emax);
//
(* Kolmogorov-Zabin stereo-correspondence algorithm (a.k.a. KZ1) *)
// #define CV_STEREO_GC_OCCLUDED  SHRT_MAX

Type
  pCvStereoGCState = ^TCvStereoGCState;

  TCvStereoGCState = record
    Ithreshold: Integer;
    interactionRadius: Integer;
    K, lambda, lambda1, lambda2: Single;
    occlusionCost: Integer;
    minDisparity: Integer;
    numberOfDisparities: Integer;
    maxIters: Integer;
    left: pCvMat;
    right: pCvMat;
    dispLeft: pCvMat;
    dispRight: pCvMat;
    ptrLeft: pCvMat;
    ptrRight: pCvMat;
    vtxBuf: pCvMat;
    edgeBuf: pCvMat;
  end;

  // CVAPI(CvStereoGCState*) cvCreateStereoGCState( int numberOfDisparities, int maxIters );
function cvCreateStereoGCState(numberOfDisparities: Integer; maxIters: Integer): pCvStereoGCState; cdecl;

// CVAPI(void) cvReleaseStereoGCState( CvStereoGCState** state );
procedure cvReleaseStereoGCState(

  Var state: pCvStereoGCState); cdecl;

{
  CVAPI(void) cvFindStereoCorrespondenceGC(
  const CvArr* left,
  const CvArr* right,
  CvArr* disparityLeft,
  CvArr* disparityRight,
  CvStereoGCState* state,
  int useDisparityGuess CV_DEFAULT(0) );
}

procedure cvFindStereoCorrespondenceGC(const left: pIplImage;

  const right: pIplImage; disparityLeft: pCvMat; disparityRight: pCvMat; state: pCvStereoGCState;
  useDisparityGuess: Integer = 0); cdecl;

(* Calculates optical flow for 2 images using classical Lucas & Kanade algorithm *)
// CVAPI(void)  cvCalcOpticalFlowLK( const CvArr* prev, const CvArr* curr,
// CvSize win_size, CvArr* velx, CvArr* vely );
//
(* Calculates optical flow for 2 images using block matching algorithm *)
// CVAPI(void)  cvCalcOpticalFlowBM( const CvArr* prev, const CvArr* curr,
// CvSize block_size, CvSize shift_size,
// CvSize max_range, int use_previous,
// CvArr* velx, CvArr* vely );
//
(* Calculates Optical flow for 2 images using Horn & Schunck algorithm *)
// CVAPI(void)  cvCalcOpticalFlowHS( const CvArr* prev, const CvArr* curr,
// int use_previous, CvArr* velx, CvArr* vely,
// double lambda, CvTermCriteria criteria );
//
//
(* ***************************************************************************************\
  // *                           Background/foreground segmentation                           *
  // \*************************************************************************************** *)
//
(* We discriminate between foreground and background pixels
  // * by building and maintaining a model of the background.
  // * Any pixel which does not fit this model is then deemed
  // * to be foreground.
  // *
  // * At present we support two core background models,
  // * one of which has two variations:
  // *
  // *  o CV_BG_MODEL_FGD: latest and greatest algorithm, described in
  // *
  // *	 Foreground Object Detection from Videos Containing Complex Background.
  // *	 Liyuan Li, Weimin Huang, Irene Y.H. Gu, and Qi Tian.
  // *	 ACM MM2003 9p
  // *
  // *  o CV_BG_MODEL_FGD_SIMPLE:
  // *       A code comment describes this as a simplified version of the above,
  // *       but the code is in fact currently identical
  // *
  // *  o CV_BG_MODEL_MOG: "Mixture of Gaussians", older algorithm, described in
  // *
  // *       Moving target classification and tracking from real-time video.
  // *       A Lipton, H Fujijoshi, R Patil
  // *       Proceedings IEEE Workshop on Application of Computer Vision pp 8-14 1998
  // *
  // *       Learning patterns of activity using real-time tracking
  // *       C Stauffer and W Grimson  August 2000
  // *       IEEE Transactions on Pattern Analysis and Machine Intelligence 22(8):747-757
  // *)
//
const
  CV_BG_MODEL_FGD        = 0;
  CV_BG_MODEL_MOG        = 1; // * "Mixture of Gaussians".	*)
  CV_BG_MODEL_FGD_SIMPLE = 2;

Type

  ppCvBGStatModel = ^pCvBGStatModel;
  pCvBGStatModel  = ^TCvBGStatModel;

  // typedef void (CV_CDECL * CvReleaseBGStatModel)( struct CvBGStatModel** bg_model );
  TCvReleaseBGStatModel = procedure(

    Var bg_model: pCvBGStatModel); cdecl;
  // typedef int (CV_CDECL * CvUpdateBGStatModel)( IplImage* curr_frame, struct CvBGStatModel* bg_model, double learningRate );
  TCvUpdateBGStatModel = function(curr_frame: pIplImage; bg_model: pCvBGStatModel; learningRate: double)
    : Integer; cdecl;

  TCvBGStatModel = record
    _type: Integer; // *type of BG model
    release: TCvReleaseBGStatModel;
    update: TCvUpdateBGStatModel;
    background: pIplImage;
    // *8UC3 reference background image
    foreground: pIplImage; // *8UC1 foreground image
    layers: pIplImage; // *8UC3 reference background image, can be null
    layer_count: Integer; // * can be zero
    storage: pCvMemStorage; // *storage for foreground_regions
    foreground_regions: pCvSeq; // *foreground object contours
  end;

  // #define CV_BG_STAT_MODEL_FIELDS()                                               \
  // int             type; (*type of BG model*)                                      \
  // CvReleaseBGStatModel release;                                                   \
  // CvUpdateBGStatModel update;                                                     \
  // IplImage*       background;   (*8UC3 reference background image*)               \
  // IplImage*       foreground;   (*8UC1 foreground image*)                         \
  // IplImage**      layers;       (*8UC3 reference background image, can be null *) \
  // int             layer_count;  (* can be zero *)                                 \
  // CvMemStorage*   storage;      (*storage for foreground_regions*)                \
  // CvSeq*          foreground_regions (*foreground object contours*)

  /// / Releases memory used by BGStatModel
  // CVAPI(void) cvReleaseBGStatModel( CvBGStatModel** bg_model );
procedure cvReleaseBGStatModel(Var bg_model: pCvBGStatModel); cdecl;

// Updates statistical model and returns number of found foreground regions
// CVAPI(int) cvUpdateBGStatModel( IplImage* current_frame, CvBGStatModel*  bg_model,
// double learningRate CV_DEFAULT(-1));
function cvUpdateBGStatModel(current_frame: pIplImage; bg_model: pCvBGStatModel; learningRate: double = -1)
  : Integer; cdecl;

/// / Performs FG post-processing using segmentation
/// / (all pixels of a region will be classified as foreground if majority of pixels of the region are FG).
/// / parameters:
/// /      segments - pointer to result of segmentation (for example MeanShiftSegmentation)
/// /      bg_model - pointer to CvBGStatModel structure
// CVAPI(void) cvRefineForegroundMaskBySegm( CvSeq* segments, CvBGStatModel*  bg_model );
//
(* Common use change detection function *)
// CVAPI(int)  cvChangeDetection( IplImage*  prev_frame,
// IplImage*  curr_frame,
// IplImage*  change_mask );

//
// Interface of ACM MM2003 algorithm
//

const
  // Default parameters of foreground detection algorithm:
  CV_BGFG_FGD_LC  = 128;
  CV_BGFG_FGD_N1C = 15;
  CV_BGFG_FGD_N2C = 25;

  CV_BGFG_FGD_LCC  = 64;
  CV_BGFG_FGD_N1CC = 25;
  CV_BGFG_FGD_N2CC = 40;
  // Background reference image update parameter: *)
  CV_BGFG_FGD_ALPHA_1 = 0.1;

  (* stat model update parameter
    // * 0.002f ~ 1K frame(~45sec), 0.005 ~ 18sec (if 25fps and absolutely static BG)
    // *)
  CV_BGFG_FGD_ALPHA_2 = 0.005;

  // * start value for alpha parameter (to fast initiate statistic model) *)
  CV_BGFG_FGD_ALPHA_3         = 0.1;
  CV_BGFG_FGD_DELTA           = 2;
  CV_BGFG_FGD_T               = 0.9;
  CV_BGFG_FGD_MINAREA         = 15;
  CV_BGFG_FGD_BG_UPDATE_TRESH = 0.5;

  (* See the above-referenced Li/Huang/Gu/Tian paper
    // * for a full description of these background-model
    // * tuning parameters.
    // *
    // * Nomenclature:  'c'  == "color", a three-component red/green/blue vector.
    // *                         We use histograms of these to model the range of
    // *                         colors we've seen at a given background pixel.
    // *
    // *                'cc' == "color co-occurrence", a six-component vector giving
    // *                         RGB color for both this frame and preceding frame.
    // *                             We use histograms of these to model the range of
    // *                         color CHANGES we've seen at a given background pixel.
    // *)
Type
  pCvFGDStatModelParams = ^TCvFGDStatModelParams;

  TCvFGDStatModelParams = record
    Lc: Integer;
    // Quantized levels per 'color' component. Power of two, typically 32, 64 or 128.
    N1c: Integer;
    // Number of color vectors used to model normal background color variation at a given pixel.
    N2c: Integer;
    // Number of color vectors retained at given pixel.  Must be > N1c, typically ~ 5/3 of N1c.
    // Used to allow the first N1c vectors to adapt over time to changing background.
    Lcc: Integer;
    // Quantized levels per 'color co-occurrence' component.  Power of two, typically 16, 32 or 64.
    N1cc: Integer;
    // Number of color co-occurrence vectors used to model normal background color variation at a given pixel.
    N2cc: Integer;
    // Number of color co-occurrence vectors retained at given pixel.  Must be > N1cc, typically ~ 5/3 of N1cc.
    // Used to allow the first N1cc vectors to adapt over time to changing background.
    is_obj_without_holes: Integer;
    // If TRUE we ignore holes within foreground blobs. Defaults to TRUE.
    perform_morphing: Integer;
    // Number of erode-dilate-erode foreground-blob cleanup iterations.
    // These erase one-pixel junk blobs and merge almost-touching blobs. Default value is 1.
    alpha1: Single;
    // How quickly we forget old background pixel values seen.  Typically set to 0.1
    alpha2: Single;
    // "Controls speed of feature learning". Depends on T. Typical value circa 0.005.
    alpha3: Single;
    // Alternate to alpha2, used (e.g.) for quicker initial convergence. Typical value 0.1.
    delta: Single;
    // Affects color and color co-occurrence quantization, typically set to 2.
    T: Single;
    // "A percentage value which determines when new features can be recognized as new background." (Typically 0.9).
    minArea: Single;
    // Discard foreground blobs whose bounding box is smaller than this threshold.
  end;
  //
  // typedef struct CvBGPixelCStatTable
  // {
  // float          Pv, Pvb;
  // uchar          v[3];
  // } CvBGPixelCStatTable;
  //
  // typedef struct CvBGPixelCCStatTable
  // {
  // float          Pv, Pvb;
  // uchar          v[6];
  // } CvBGPixelCCStatTable;
  //
  // typedef struct CvBGPixelStat
  // {
  // float                 Pbc;
  // float                 Pbcc;
  // CvBGPixelCStatTable*  ctable;
  // CvBGPixelCCStatTable* cctable;
  // uchar                 is_trained_st_model;
  // uchar                 is_trained_dyn_model;
  // } CvBGPixelStat;
  //
  //
  // typedef struct CvFGDStatModel
  // {
  // CV_BG_STAT_MODEL_FIELDS();
  // CvBGPixelStat*         pixel_stat;
  // IplImage*              Ftd;
  // IplImage*              Fbd;
  // IplImage*              prev_frame;
  // CvFGDStatModelParams   params;
  // } CvFGDStatModel;

  (* Creates FGD model *)
  // CVAPI(CvBGStatModel*) cvCreateFGDStatModel( IplImage* first_frame, CvFGDStatModelParams* parameters CV_DEFAULT(NULL));
function cvCreateFGDStatModel(first_frame: pIplImage; parameters: pCvFGDStatModelParams = nil): pCvBGStatModel;
cdecl

// Interface of Gaussian mixture algorithm
//
// "An improved adaptive background mixture model for real-time tracking with shadow detection"
// P. KadewTraKuPong and R. Bowden,
// Proc. 2nd European Workshp on Advanced Video-Based Surveillance Systems, 2001."
// http://personal.ee.surrey.ac.uk/Personal/R.Bowden/publications/avbs01/avbs01.pdf
//
(* Note:  "MOG" == "Mixture Of Gaussians": *)
const
  CV_BGFG_MOG_MAX_NGAUSSIANS = 500;

  // * default parameters of gaussian background detection algorithm *)
  CV_BGFG_MOG_BACKGROUND_THRESHOLD = 0.7;
  // * threshold sum of weights for background test *)
  CV_BGFG_MOG_STD_THRESHOLD = 2.5; // * lambda=2.5 is 99% *)
  CV_BGFG_MOG_WINDOW_SIZE   = 200; // * Learning rate; alpha = 1/CV_GBG_WINDOW_SIZE *)
  CV_BGFG_MOG_NGAUSSIANS    = 5; // * = K = number of Gaussians in mixture *)
  CV_BGFG_MOG_WEIGHT_INIT   = 0.05;
  CV_BGFG_MOG_SIGMA_INIT    = 30;
  CV_BGFG_MOG_MINAREA       = 15;

  CV_BGFG_MOG_NCOLORS = 3;

type
  pCvGaussBGStatModelParams = ^TCvGaussBGStatModelParams;

  TCvGaussBGStatModelParams = record
    win_size: Integer; // * = 1/alpha
    n_gauss: Integer;
    bg_threshold, std_threshold, minArea: double;
    weight_init, variance_init: double;
  end;

  pCvGaussBGValues = ^TCvGaussBGValues;

  TCvGaussBGValues = record
    match_sum: Integer;
    weight: double;
    variance: array [0 .. CV_BGFG_MOG_NCOLORS - 1] of double;
    mean: array [0 .. CV_BGFG_MOG_NCOLORS - 1] of double;
  end;

  pCvGaussBGPoint = ^TCvGaussBGPoint;

  TCvGaussBGPoint = record
    g_values: pCvGaussBGValues;
  end;

  pCvGaussBGModel = ^TCvGaussBGModel;

  TCvGaussBGModel = record
    // CV_BG_STAT_MODEL_FIELDS();
    _type: Integer; // type of BG model
    release: TCvReleaseBGStatModel;
    update: TCvUpdateBGStatModel;
    background: pIplImage; // 8UC3 reference background image
    foreground: pIplImage; // 8UC1 foreground image
    layers: pIplImage; // 8UC3 reference background image, can be null
    layer_count: Integer; // can be zero
    storage: pCvMemStorage; // storage for foreground_regions
    foreground_regions: pCvSeq; // foreground object contours
    params: TCvGaussBGStatModelParams;
    g_point: pCvGaussBGPoint;
    countFrames: Integer;
    mog: pointer;
  end;

  // * Creates Gaussian mixture background model *)
  // CVAPI(CvBGStatModel*) cvCreateGaussianBGModel( IplImage* first_frame, CvGaussBGStatModelParams* parameters CV_DEFAULT(NULL));
function cvCreateGaussianBGModel(first_frame: pIplImage; parameters: pCvGaussBGStatModelParams = nil)
  : pCvBGStatModel; cdecl;

type
  pCvBGCodeBookElem = ^TCvBGCodeBookElem;

  TCvBGCodeBookElem = record
    next: pCvBGCodeBookElem;
    tLastUpdate: Integer;
    stale: Integer;
    boxMin: array [0 .. 2] of byte;
    boxMax: array [0 .. 2] of byte;
    learnMin: array [0 .. 2] of byte;
    learnMax: array [0 .. 2] of byte;
  end;

  pCvBGCodeBookModel = ^TCvBGCodeBookModel;

  TCvBGCodeBookModel = record
    size: TCvSize;
    T: Integer;
    cbBounds: array [0 .. 2] of byte;
    modMin: array [0 .. 2] of byte;
    modMax: array [0 .. 2] of byte;
    cbmap: pCvBGCodeBookElem;
    storage: pCvMemStorage;
    freeList: pCvBGCodeBookElem;
  end;

  // CVAPI(CvBGCodeBookModel*) cvCreateBGCodeBookModel( void );
function cvCreateBGCodeBookModel: pCvBGCodeBookModel; cdecl;
// CVAPI(void) cvReleaseBGCodeBookModel( CvBGCodeBookModel** model );
procedure cvReleaseBGCodeBookModel(model: pCvBGCodeBookModel); cdecl;
// CVAPI(void) cvBGCodeBookUpdate( CvBGCodeBookModel* model, const CvArr* image, CvRect roi CV_DEFAULT(cvRect(0,0,0,0)),const CvArr* mask CV_DEFAULT(0) );
procedure cvBGCodeBookUpdate(model: pCvBGCodeBookModel;

  const image: pIplImage; roi: TCvRect { =CV_DEFAULT(cvRect(0,0,0,0)) };

  const mask: pCvArr { =0 } ); cdecl;
// CVAPI(int) cvBGCodeBookDiff( const CvBGCodeBookModel* model, const CvArr* image, CvArr* fgmask, CvRect roi CV_DEFAULT(cvRect(0,0,0,0)) );
function cvBGCodeBookDiff(

  const model: pCvBGCodeBookModel;

  const image: pCvArr; fgmask: pCvArr; roi: TCvRect { = cvRect(0,0,0,0) } ): Integer; cdecl;
// CVAPI(void) cvBGCodeBookClearStale( CvBGCodeBookModel* model, int staleThresh, CvRect roi CV_DEFAULT(cvRect(0,0,0,0)), const CvArr* mask CV_DEFAULT(0) );
procedure cvBGCodeBookClearStale(model: pCvBGCodeBookModel; staleThresh: Integer; roi: TCvRect { =cvRect(0,0,0,0) };

  const mask: pCvArr = nil); cdecl;
// CVAPI(CvSeq*) cvSegmentFGMask( CvArr *fgmask, int poly1Hull0 CV_DEFAULT(1), float perimScale CV_DEFAULT(4.f), CvMemStorage* storage CV_DEFAULT(0), CvPoint offset CV_DEFAULT(cvPoint(0,0)));
function cvSegmentFGMask(fgmask: pCvArr; poly1Hull0: Integer { =1 }; perimScale: Single { = 4 };
  storage: pCvMemStorage { =nil }; offset: TCvPoint { =cvPoint(0,0) } ): pCvSeq; cdecl;

const
  CV_UNDEF_SC_PARAM        = 12345; // default value of parameters
  CV_IDP_BIRCHFIELD_PARAM1 = 25;
  CV_IDP_BIRCHFIELD_PARAM2 = 5;
  CV_IDP_BIRCHFIELD_PARAM3 = 12;
  CV_IDP_BIRCHFIELD_PARAM4 = 15;
  CV_IDP_BIRCHFIELD_PARAM5 = 25;
  CV_DISPARITY_BIRCHFIELD  = 0;
  (*
    F///////////////////////////////////////////////////////////////////////////
    //
    //    Name:    cvFindStereoCorrespondence
    //    Purpose: find stereo correspondence on stereo-pair
    //    Context:
    //    Parameters:
    //      leftImage - left image of stereo-pair (format 8uC1).
    //      rightImage - right image of stereo-pair (format 8uC1).
    //   mode - mode of correspondence retrieval (now CV_DISPARITY_BIRCHFIELD only)
    //      dispImage - destination disparity image
    //      maxDisparity - maximal disparity
    //      param1, param2, param3, param4, param5 - parameters of algorithm
    //    Returns:
    //    Notes:
    //      Images must be rectified.
    //      All images must have format 8uC1.
    //F
  *)
  (*
    CVAPI(void)
    cvFindStereoCorrespondence(
    const  CvArr* leftImage, const  CvArr* rightImage,
    int     mode,
    CvArr*  dispImage,
    int     maxDisparity,
    double  param1 CV_DEFAULT(CV_UNDEF_SC_PARAM),
    double  param2 CV_DEFAULT(CV_UNDEF_SC_PARAM),
    double  param3 CV_DEFAULT(CV_UNDEF_SC_PARAM),
    double  param4 CV_DEFAULT(CV_UNDEF_SC_PARAM),
    double  param5 CV_DEFAULT(CV_UNDEF_SC_PARAM) );
  *)
procedure cvFindStereoCorrespondence(const leftImage: pCvArr; const rightImage: pCvArr; mode: Integer;
  dispImage: pCvArr; maxDisparity: Integer; param1: double = CV_UNDEF_SC_PARAM; param2: double = CV_UNDEF_SC_PARAM;
  param3: double = CV_UNDEF_SC_PARAM; param4: double = CV_UNDEF_SC_PARAM; param5: double = CV_UNDEF_SC_PARAM); cdecl;

(*
  ***************************************************************************************
*)
(*
  *********** Epiline functions ******************
*)
(* typedef  struct CvStereoLineCoeff
  {
  double Xcoef;
  double XcoefA;
  double XcoefB;
  double XcoefAB;

  double Ycoef;
  double YcoefA;
  double YcoefB;
  double YcoefAB;

  double Zcoef;
  double ZcoefA;
  double ZcoefB;
  double ZcoefAB;
  }CvStereoLineCoeff; *)
(* typedef  struct CvCamera
  {
  float   imgSize[2]; /* size of the camera view, used during calibration */
  float   matrix[9]; /* intinsic camera parameters:  [ fx 0 cx; 0 fy cy; 0 0 1 ] */
  float   distortion[4]; /* distortion coefficients - two coefficients for radial distortion
  and another two for tangential: [ k1 k2 p1 p2 ] */
  float   rotMatr[9];
  float   transVect[3]; /* rotation matrix and transition vector relatively
  to some reference point in the space. */
  } CvCamera; *)
(* typedef  struct CvStereoCamera
  {
  CvCamera* camera[2]; /* two individual camera parameters */
  float fundMatr[9]; /* fundamental matrix */

  /* New part for stereo */
  CvPoint3D32f epipole[2];
  CvPoint2D32f quad[2][4]; /* coordinates of destination quadrangle after
  epipolar geometry rectification */
  double coeffs[2][3][3];/* coefficients for transformation */
  CvPoint2D32f border[2][4];
  CvSize warpSize;
  CvStereoLineCoeff* lineCoeffs;
  int needSwapCameras;/* flag set to 1 if need to swap cameras for good reconstruction */
  float rotMatrix[9];
  float transVector[3];
  } CvStereoCamera; *)
(* typedef  struct CvContourOrientation
  {
  float egvals[2];
  float egvects[4];

  float max, min; // minimum and maximum projections
  int imax, imin;
  } CvContourOrientation; *)

Type
  TicvConvertWarpCoordinatesCoeff = array [0 .. 2, 0 .. 2] of double;
  (*
    CVAPI(int) icvConvertWarpCoordinates(double coeffs[3][3],
    CvPoint2D32f* cameraPoint,
    CvPoint2D32f* warpPoint,
    int direction);
  *)
function icvConvertWarpCoordinates(coeffs: TicvConvertWarpCoordinatesCoeff; cameraPoint: pCvPoint2D32f;
  warpPoint: pCvPoint2D32f; direction: Integer): Integer; cdecl;
(*
  CVAPI(int) icvGetSymPoint3D(  CvPoint3D64f pointCorner,
  CvPoint3D64f point1,
  CvPoint3D64f point2,
  CvPoint3D64f *pointSym2);
*)
function icvGetSymPoint3D(pointCorner: TCvPoint3D64f; point1: TCvPoint3D64f; point2: TCvPoint3D64f;
  pointSym2: pCvPoint3D64f): Integer; cdecl;
(*
  CVAPI(void) icvGetPieceLength3D(CvPoint3D64f point1,CvPoint3D64f point2,double* dist);
*)
procedure icvGetPieceLength3D(point1: TCvPoint3D64f; point2: TCvPoint3D64f; dist: pdouble); cdecl;
(*
  CVAPI(int) icvCompute3DPoint(    double alpha,double betta,
  CvStereoLineCoeff* coeffs,
  CvPoint3D64f* point);
*)
function icvCompute3DPoint(alpha: double; betta: double; coeffs: pCvStereoLineCoeff; point: pCvPoint3D64f)
  : Integer; cdecl;
(*
  CVAPI(int) icvCreateConvertMatrVect( double*     rotMatr1,
  double*     transVect1,
  double*     rotMatr2,
  double*     transVect2,
  double*     convRotMatr,
  double*     convTransVect);
*)
function icvCreateConvertMatrVect(rotMatr1: pdouble; transVect1: pdouble; rotMatr2: pdouble; transVect2: pdouble;
  convRotMatr: pdouble; convTransVect: pdouble): Integer; cdecl;
(*
  CVAPI(int) icvConvertPointSystem(CvPoint3D64f  M2,
  CvPoint3D64f* M1,
  double*     rotMatr,
  double*     transVect
  );
*)
function icvConvertPointSystem(M2: TCvPoint3D64f; M1: pCvPoint3D64f; rotMatr: pdouble; transVect: pdouble)
  : Integer; cdecl;
(*
  CVAPI(int) icvComputeCoeffForStereo(  CvStereoCamera* stereoCamera);
*)
function icvComputeCoeffForStereo(stereoCamera: pCvStereoCamera): Integer; cdecl;
(*
  CVAPI(int) icvGetCrossPieceVector(CvPoint2D32f p1_start,CvPoint2D32f p1_end,CvPoint2D32f v2_start,CvPoint2D32f v2_end,CvPoint2D32f *cross);
*)
function icvGetCrossPieceVector(p1_start: TCvPoint2D32f; p1_end: TCvPoint2D32f; v2_start: TCvPoint2D32f;
  v2_end: TCvPoint2D32f; cross: pCvPoint2D32f): Integer; cdecl;
(*
  CVAPI(int) icvGetCrossLineDirect(CvPoint2D32f p1,CvPoint2D32f p2,float a,float b,float c,CvPoint2D32f* cross);
*)
function icvGetCrossLineDirect(p1: TCvPoint2D32f; p2: TCvPoint2D32f; a: float; b: float; c: float; cross: pCvPoint2D32f)
  : Integer; cdecl;
(*
  CVAPI(float) icvDefinePointPosition(CvPoint2D32f point1,CvPoint2D32f point2,CvPoint2D32f point);
*)
function icvDefinePointPosition(point1: TCvPoint2D32f; point2: TCvPoint2D32f; point: TCvPoint2D32f): float; cdecl;
(*
  CVAPI(int) icvStereoCalibration( int numImages,
  int* nums,
  CvSize imageSize,
  CvPoint2D32f* imagePoints1,
  CvPoint2D32f* imagePoints2,
  CvPoint3D32f* objectPoints,
  CvStereoCamera* stereoparams
  );
*)
function icvStereoCalibration(numImages: Integer; nums: PInteger; imageSize: TCvSize; imagePoints1: pCvPoint2D32f;
  imagePoints2: pCvPoint2D32f; objectPoints: pCvPoint3D32f; stereoparams: pCvStereoCamera): Integer; cdecl;
(*
  CVAPI(int) icvComputeRestStereoParams(CvStereoCamera *stereoparams);
*)
function icvComputeRestStereoParams(stereoparams: pCvStereoCamera): Integer; cdecl;
(*
  CVAPI(void) cvComputePerspectiveMap( const double coeffs[3][3], CvArr* rectMapX, CvArr* rectMapY );
*)
procedure cvComputePerspectiveMap(const coeffs: TicvConvertWarpCoordinatesCoeff; rectMapX: pCvArr;
  rectMapY: pCvArr); cdecl;
(*
  CVAPI(int) icvComCoeffForLine(   CvPoint2D64f point1,
  CvPoint2D64f point2,
  CvPoint2D64f point3,
  CvPoint2D64f point4,
  double*    camMatr1,
  double*    rotMatr1,
  double*    transVect1,
  double*    camMatr2,
  double*    rotMatr2,
  double*    transVect2,
  CvStereoLineCoeff*    coeffs,
  int* needSwapCameras);
*)
function icvComCoeffForLine(point1: TCvPoint2D64f; point2: TCvPoint2D64f; point3: TCvPoint2D64f; point4: TCvPoint2D64f;
  camMatr1: pdouble; rotMatr1: pdouble; transVect1: pdouble; camMatr2: pdouble; rotMatr2: pdouble; transVect2: pdouble;
  coeffs: pCvStereoLineCoeff; needSwapCameras: PInteger): Integer; cdecl;
(*
  CVAPI(int) icvGetDirectionForPoint(  CvPoint2D64f point,
  double* camMatr,
  CvPoint3D64f* direct);
*)
function icvGetDirectionForPoint(point: TCvPoint2D64f; camMatr: pdouble; direct: pCvPoint3D64f): Integer; cdecl;
(*
  CVAPI(int) icvGetCrossLines(CvPoint3D64f point11,CvPoint3D64f point12,
  CvPoint3D64f point21,CvPoint3D64f point22,
  CvPoint3D64f* midPoint);
*)
function icvGetCrossLines(point11: TCvPoint3D64f; point12: TCvPoint3D64f; point21: TCvPoint3D64f;
  point22: TCvPoint3D64f; midPoint: pCvPoint3D64f): Integer; cdecl;
(*
  CVAPI(int) icvComputeStereoLineCoeffs(   CvPoint3D64f pointA,
  CvPoint3D64f pointB,
  CvPoint3D64f pointCam1,
  double gamma,
  CvStereoLineCoeff*    coeffs);
*)
function icvComputeStereoLineCoeffs(pointA: TCvPoint3D64f; pointB: TCvPoint3D64f; pointCam1: TCvPoint3D64f;
  gamma: double; coeffs: pCvStereoLineCoeff): Integer; cdecl;
(*
  CVAPI(int) icvComputeFundMatrEpipoles ( double* camMatr1,
  double*     rotMatr1,
  double*     transVect1,
  double*     camMatr2,
  double*     rotMatr2,
  double*     transVect2,
  CvPoint2D64f* epipole1,
  CvPoint2D64f* epipole2,
  double*     fundMatr);
*)
(*
  CVAPI(int) icvGetAngleLine( CvPoint2D64f startPoint, CvSize imageSize,CvPoint2D64f *point1,CvPoint2D64f *point2);
*)
function icvGetAngleLine(startPoint: TCvPoint2D64f; imageSize: TCvSize; point1: pCvPoint2D64f; point2: pCvPoint2D64f)
  : Integer; cdecl;
(*
  CVAPI(void) icvGetCoefForPiece(   CvPoint2D64f p_start,CvPoint2D64f p_end,
  double *a,double *b,double *c,
  int* result);
*)
procedure icvGetCoefForPiece(p_start: TCvPoint2D64f; p_end: TCvPoint2D64f; a: pdouble; b: pdouble; c: pdouble;
  result: PInteger); cdecl;
(*
  CVAPI(void) icvGetCommonArea( CvSize imageSize,
  CvPoint2D64f epipole1,CvPoint2D64f epipole2,
  double* fundMatr,
  double* coeff11,double* coeff12,
  double* coeff21,double* coeff22,
  int* result);
*)
(*
  CVAPI(void) icvComputeeInfiniteProject1(double*    rotMatr,
  double*    camMatr1,
  double*    camMatr2,
  CvPoint2D32f point1,
  CvPoint2D32f *point2);
*)
procedure icvComputeeInfiniteProject1(rotMatr: pdouble; camMatr1: pdouble; camMatr2: pdouble; point1: TCvPoint2D32f;
  point2: pCvPoint2D32f); cdecl;
(*
  CVAPI(void) icvComputeeInfiniteProject2(double*    rotMatr,
  double*    camMatr1,
  double*    camMatr2,
  CvPoint2D32f* point1,
  CvPoint2D32f point2);
*)
procedure icvComputeeInfiniteProject2(rotMatr: pdouble; camMatr1: pdouble; camMatr2: pdouble; point1: pCvPoint2D32f;
  point2: TCvPoint2D32f); cdecl;
(*
  CVAPI(void) icvGetCrossDirectDirect(  double* direct1,double* direct2,
  CvPoint2D64f *cross,int* result);
*)
procedure icvGetCrossDirectDirect(direct1: pdouble; direct2: pdouble; cross: pCvPoint2D64f; result: PInteger); cdecl;
(*
  CVAPI(void) icvGetCrossPieceDirect(   CvPoint2D64f p_start,CvPoint2D64f p_end,
  double a,double b,double c,
  CvPoint2D64f *cross,int* result);
*)
procedure icvGetCrossPieceDirect(p_start: TCvPoint2D64f; p_end: TCvPoint2D64f; a: double; b: double; c: double;
  cross: pCvPoint2D64f; result: PInteger); cdecl;
(*
  CVAPI(void) icvGetCrossPiecePiece( CvPoint2D64f p1_start,CvPoint2D64f p1_end,
  CvPoint2D64f p2_start,CvPoint2D64f p2_end,
  CvPoint2D64f* cross,
  int* result);
*)
procedure icvGetCrossPiecePiece(p1_start: TCvPoint2D64f; p1_end: TCvPoint2D64f; p2_start: TCvPoint2D64f;
  p2_end: TCvPoint2D64f; cross: pCvPoint2D64f; result: PInteger); cdecl;
(*
  CVAPI(void) icvGetPieceLength(CvPoint2D64f point1,CvPoint2D64f point2,double* dist);
*)
procedure icvGetPieceLength(point1: TCvPoint2D64f; point2: TCvPoint2D64f; dist: pdouble); cdecl;
(*
  CVAPI(void) icvGetCrossRectDirect(    CvSize imageSize,
  double a,double b,double c,
  CvPoint2D64f *start,CvPoint2D64f *end,
  int* result);
*)
procedure icvGetCrossRectDirect(imageSize: TCvSize; a: double; b: double; c: double; start: pCvPoint2D64f;
  end_: pCvPoint2D64f; result: PInteger); cdecl;
(*
  CVAPI(void) icvProjectPointToImage(   CvPoint3D64f point,
  double* camMatr,double* rotMatr,double* transVect,
  CvPoint2D64f* projPoint);
*)
procedure icvProjectPointToImage(point: TCvPoint3D64f; camMatr: pdouble; rotMatr: pdouble; transVect: pdouble;
  projPoint: pCvPoint2D64f); cdecl;
(*
  CVAPI(void) icvGetQuadsTransform( CvSize        imageSize,
  double*     camMatr1,
  double*     rotMatr1,
  double*     transVect1,
  double*     camMatr2,
  double*     rotMatr2,
  double*     transVect2,
  CvSize*       warpSize,
  double quad1[4][2],
  double quad2[4][2],
  double*     fundMatr,
  CvPoint3D64f* epipole1,
  CvPoint3D64f* epipole2
  );
*)

Type
  TicvGetQuadsTransformQuad = array [0 .. 3, 0 .. 1] of double;

procedure icvGetQuadsTransform(imageSize: TCvSize; camMatr1: pdouble; rotMatr1: pdouble; transVect1: pdouble;
  camMatr2: pdouble; rotMatr2: pdouble; transVect2: pdouble; warpSize: pCvSize; quad1: TicvGetQuadsTransformQuad;
  quad2: TicvGetQuadsTransformQuad; fundMatr: pdouble; epipole1: pCvPoint3D64f; epipole2: pCvPoint3D64f); cdecl;
(*
  CVAPI(void) icvGetQuadsTransformStruct(  CvStereoCamera* stereoCamera);
*)
procedure icvGetQuadsTransformStruct(stereoCamera: pCvStereoCamera); cdecl;
(*
  CVAPI(void) icvComputeStereoParamsForCameras(CvStereoCamera* stereoCamera);
*)
procedure icvComputeStereoParamsForCameras(stereoCamera: pCvStereoCamera); cdecl;
(*
  CVAPI(void) icvGetCutPiece(   double* areaLineCoef1,double* areaLineCoef2,
  CvPoint2D64f epipole,
  CvSize imageSize,
  CvPoint2D64f* point11,CvPoint2D64f* point12,
  CvPoint2D64f* point21,CvPoint2D64f* point22,
  int* result);
*)
procedure icvGetCutPiece(areaLineCoef1: pdouble; areaLineCoef2: pdouble; epipole: TCvPoint2D64f; imageSize: TCvSize;
  point11: pCvPoint2D64f; point12: pCvPoint2D64f; point21: pCvPoint2D64f; point22: pCvPoint2D64f;
  result: PInteger); cdecl;
(*
  CVAPI(void) icvGetMiddleAnglePoint(   CvPoint2D64f basePoint,
  CvPoint2D64f point1,CvPoint2D64f point2,
  CvPoint2D64f* midPoint);
*)
procedure icvGetMiddleAnglePoint(basePoint: TCvPoint2D64f; point1: TCvPoint2D64f; point2: TCvPoint2D64f;
  midPoint: pCvPoint2D64f); cdecl;
(*
  CVAPI(void) icvGetNormalDirect(double* direct,CvPoint2D64f point,double* normDirect);
*)
procedure icvGetNormalDirect(direct: pdouble; point: TCvPoint2D64f; normDirect: pdouble); cdecl;
(*
  CVAPI(double) icvGetVect(CvPoint2D64f basePoint,CvPoint2D64f point1,CvPoint2D64f point2);
*)
function icvGetVect(basePoint: TCvPoint2D64f; point1: TCvPoint2D64f; point2: TCvPoint2D64f): double; cdecl;
(*
  CVAPI(void) icvProjectPointToDirect(  CvPoint2D64f point,double* lineCoeff,
  CvPoint2D64f* projectPoint);
*)
procedure icvProjectPointToDirect(point: TCvPoint2D64f; lineCoeff: pdouble; projectPoint: pCvPoint2D64f); cdecl;
(*
  CVAPI(void) icvGetDistanceFromPointToDirect( CvPoint2D64f point,double* lineCoef,double*dist);
*)
{$EXTERNALSYM icvGetDistanceFromPointToDirect}
procedure icvGetDistanceFromPointToDirect(point: TCvPoint2D64f; lineCoef: pdouble; dist: pdouble); cdecl;
(*
  CVAPI(IplImage * )icvCreateIsometricImage(IplImage * src, IplImage * dst, int desired_depth, int desired_num_channels);
*)
function icvCreateIsometricImage(src: pIplImage; dst: pIplImage; desired_depth: Integer; desired_num_channels: Integer)
  : pIplImage; cdecl;
(*
  CVAPI(void) cvDeInterlace( const CvArr* frame, CvArr* fieldEven, CvArr* fieldOdd );
*)
procedure cvDeInterlace(

  const frame: pCvArr; fieldEven: pCvArr; fieldOdd: pCvArr); cdecl;
(*
  CVAPI(int) icvSelectBestRt(           int           numImages,
  int*          numPoints,
  CvSize        imageSize,
  CvPoint2D32f* imagePoints1,
  CvPoint2D32f* imagePoints2,
  CvPoint3D32f* objectPoints,

  CvMatr32f     cameraMatrix1,
  CvVect32f     distortion1,
  CvMatr32f     rotMatrs1,
  CvVect32f     transVects1,

  CvMatr32f     cameraMatrix2,
  CvVect32f     distortion2,
  CvMatr32f     rotMatrs2,
  CvVect32f     transVects2,

  CvMatr32f     bestRotMatr,
  CvVect32f     bestTransVect
  );
*)
(*
  ***************************************************************************************\
  *                                     Contour Tree                                       *
  \***************************************************************************************
*)
(*
  Contour tree header
*)
(* typedef  struct CvContourTree
  {
  CV_SEQUENCE_FIELDS()
  CvPoint p1;            /* the first point of the binary tree root segment */
  CvPoint p2;            /* the last point of the binary tree root segment */
  } CvContourTree; *)
(*
  Builds hierarhical representation of a contour
*)
(*
  CVAPI(CvContourTree * ) cvCreateContourTree(const CvSeq * contour, CvMemStorage * storage, double threshold);
*)

function cvCreateContourTree(const contour: pCvSeq; storage: pCvMemStorage; threshold: double): pCvContourTree; cdecl;
(*
  Reconstruct (completelly or partially) contour a from contour tree
*)
(*
  CVAPI(CvSeq * ) cvContourFromContourTree(const CvContourTree * tree, CvMemStorage * storage, CvTermCriteria criteria);
*)
function cvContourFromContourTree(const tree: pCvContourTree; storage: pCvMemStorage; criteria: TCvTermCriteria)
  : pCvSeq; cdecl;

const
  (*
    Compares two contour trees
  *)
  (* enum  { CV_CONTOUR_TREES_MATCH_I1 = 1 }; *)
  CV_CONTOUR_TREES_MATCH_I1 = 1;
  (*
    CVAPI(double)  cvMatchContourTrees( const CvContourTree* tree1,
    const CvContourTree* tree2,
    int method, double threshold );
  *)
function cvMatchContourTrees(const tree1: pCvContourTree; const tree2: pCvContourTree; method: Integer;
  threshold: double): double; cdecl;
(*
  ***************************************************************************************\
  *                                   Contour Morphing                                     *
  \***************************************************************************************
*)
(*
  finds correspondence between two contours
*)

(*
  ***************************************************************************************\
  *                                   Contour Morphing                                     *
  \***************************************************************************************
*)
(*
  finds correspondence between two contours
*)
(*
  CVAPI(CvSeq* ) cvCalcContoursCorrespondence( const CvSeq* contour1,
  const CvSeq* contour2,
  CvMemStorage* storage);
*)
function cvCalcContoursCorrespondence(const contour1: pCvSeq; const contour2: pCvSeq; storage: pCvMemStorage)
  : pCvSeq; cdecl;
(*
  morphs contours using the pre-calculated correspondence:
  alpha=0 ~ contour1, alpha=1 ~ contour2
*)
(*
  CVAPI(CvSeq* ) cvMorphContours( const CvSeq* contour1, const CvSeq* contour2,
  CvSeq* corr, double alpha,
  CvMemStorage* storage );
*)
function cvMorphContours(const contour1: pCvSeq; const contour2: pCvSeq; corr: pCvSeq; alpha: double;
  storage: pCvMemStorage): pCvSeq; cdecl;

(*
  ***************************************************************************************\
  *                                    Texture Descriptors                                 *
  \***************************************************************************************
*)
// #define CV_GLCM_OPTIMIZATION_NONE                   -2
// #define CV_GLCM_OPTIMIZATION_LUT                    -1
// #define CV_GLCM_OPTIMIZATION_HISTOGRAM              0
// #define CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST    10
// #define CV_GLCMDESC_OPTIMIZATION_ALLOWTRIPLENEST    11
// #define CV_GLCMDESC_OPTIMIZATION_HISTOGRAM          4
// #define CV_GLCMDESC_ENTROPY                         0
// #define CV_GLCMDESC_ENERGY                          1
// #define CV_GLCMDESC_HOMOGENITY                      2
// #define CV_GLCMDESC_CONTRAST                        3
// #define CV_GLCMDESC_CLUSTERTENDENCY                 4
// #define CV_GLCMDESC_CLUSTERSHADE                    5
// #define CV_GLCMDESC_CORRELATION                     6
// #define CV_GLCMDESC_CORRELATIONINFO1                7
// #define CV_GLCMDESC_CORRELATIONINFO2                8
// #define CV_GLCMDESC_MAXIMUMPROBABILITY              9
// #define CV_GLCM_ALL                                 0
// #define CV_GLCM_GLCM                                1
// #define CV_GLCM_DESC                                2
(* typedef  struct CvGLCM CvGLCM; *)
(*
  CVAPI(CvGLCM* ) cvCreateGLCM( const IplImage* srcImage,
  int stepMagnitude,
  const int* stepDirections CV_DEFAULT(0),
  int numStepDirections CV_DEFAULT(0),
  int optimizationType CV_DEFAULT(CV_GLCM_OPTIMIZATION_NONE));
*)
function cvCreateGLCM(const srcImage: pIplImage; stepMagnitude: Integer; const stepDirections: PInteger = nil;
  numStepDirections: Integer = 0; optimizationType: Integer = CV_GLCM_OPTIMIZATION_NONE): pCvGLCM; cdecl;
(*
  CVAPI(void) cvReleaseGLCM( CvGLCM** GLCM, int flag CV_DEFAULT(CV_GLCM_ALL));
*)
procedure cvReleaseGLCM(var GLCM: pCvGLCM; flag: Integer = CV_GLCM_ALL); cdecl;
(*
  CVAPI(void) cvCreateGLCMDescriptors( CvGLCM* destGLCM,
  int descriptorOptimizationType
  CV_DEFAULT(CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST));
*)
procedure cvCreateGLCMDescriptors(destGLCM: pCvGLCM;
  descriptorOptimizationType: Integer = CV_GLCMDESC_OPTIMIZATION_ALLOWDOUBLENEST); cdecl;
(*
  CVAPI(double) cvGetGLCMDescriptor( CvGLCM* GLCM, int step, int descriptor );
*)
function cvGetGLCMDescriptor(GLCM: pCvGLCM; step: Integer; descriptor: Integer): double; cdecl;
(*
  CVAPI(void) cvGetGLCMDescriptorStatistics( CvGLCM* GLCM, int descriptor,
  double* average, double* standardDeviation );
*)
procedure cvGetGLCMDescriptorStatistics(GLCM: pCvGLCM; descriptor: Integer; average: pdouble;
  standardDeviation: pdouble); cdecl;
(*
  CVAPI(IplImage* ) cvCreateGLCMImage( CvGLCM* GLCM, int step );
*)
function cvCreateGLCMImage(GLCM: pCvGLCM; step: Integer): pIplImage; cdecl;

(*
  ***************************************************************************************\
  *                                  Face eyes&mouth tracking                              *
  \***************************************************************************************
*)
type
  (* typedef  struct CvFaceTracker CvFaceTracker; *)
  pCvFaceTracker = ^TCvFaceTracker;

  TCvFaceTracker = record

  end;

  // #define CV_NUM_FACE_ELEMENTS    3
  (* enum  CV_FACE_ELEMENTS
    {
    CV_FACE_MOUTH = 0,
    CV_FACE_LEFT_EYE = 1,
    CV_FACE_RIGHT_EYE = 2
    }; *)
  (*
    CVAPI(CvFaceTracker* ) cvInitFaceTracker(CvFaceTracker* pFaceTracking, const IplImage* imgGray,
    CvRect* pRects, int nRects);
  *)
function cvInitFaceTracker(pFaceTracking: pCvFaceTracker; const imgGray: pIplImage; pRects: pCvRect; nRects: Integer)
  : pCvFaceTracker; cdecl;
(*
  CVAPI(int) cvTrackFace( CvFaceTracker* pFaceTracker, IplImage* imgGray,
  CvRect* pRects, int nRects,
  CvPoint* ptRotate, double* dbAngleRotate);
*)
function cvTrackFace(pFaceTracker: pCvFaceTracker; imgGray: pIplImage; pRects: pCvRect; nRects: Integer;
  ptRotate: pCvPoint; dbAngleRotate: pdouble): Integer; cdecl;
(*
  CVAPI(void) cvReleaseFaceTracker(CvFaceTracker** ppFaceTracker);
*)
procedure cvReleaseFaceTracker(var ppFaceTracker: pCvFaceTracker); cdecl;
(* typedef  struct CvFace
  {
  CvRect MouthRect;
  CvRect LeftEyeRect;
  CvRect RightEyeRect;
  } CvFaceData; *)
(*
  CVAPI(CvSeq* ) cvFindFace(IplImage * Image,CvMemStorage* storage);
*)
function cvFindFace(image: pIplImage; storage: pCvMemStorage): pCvSeq; cdecl;
(*
  CVAPI(CvSeq* ) cvPostBoostingFindFace(IplImage * Image,CvMemStorage* storage);
*)
function cvPostBoostingFindFace(image: pIplImage; storage: pCvMemStorage): pCvSeq; cdecl;

(*
  ***************************************************************************************\
  *                                         3D Tracker                                     *
  \***************************************************************************************
*)
Type
  (* typedef  unsigned char CvBool; *)
  TCvBool = uchar;
  (* typedef  struct Cv3dTracker2dTrackedObject
    {
    int id;
    CvPoint2D32f p; // pgruebele: So we do not loose precision, this needs to be float
    } Cv3dTracker2dTrackedObject; *)

  pCv3dTracker2dTrackedObject = ^TCv3dTracker2dTrackedObject;

  TCv3dTracker2dTrackedObject = record
    id: Integer;
    p: TCvPoint2D32f; // pgruebele: So we do not loose precision, this needs to be float
  end;

  (* CV_INLINE  Cv3dTracker2dTrackedObject cv3dTracker2dTrackedObject(int id, CvPoint2D32f p)
    {
    Cv3dTracker2dTrackedObject r;
    r.id = id;
    r.p = p;
    return r;
    } *)

  (* typedef  struct Cv3dTrackerTrackedObject
    {
    int id;
    CvPoint3D32f p;             // location of the tracked object
    } Cv3dTrackerTrackedObject; *)
  pCv3dTrackerTrackedObject = ^TCv3dTrackerTrackedObject;

  TCv3dTrackerTrackedObject = record
    id: Integer;
    p: TCvPoint3D32f; // location of the tracked object
  end;

  (* CV_INLINE  Cv3dTrackerTrackedObject cv3dTrackerTrackedObject(int id, CvPoint3D32f p)
    {
    Cv3dTrackerTrackedObject r;
    r.id = id;
    r.p = p;
    return r;
    } *)
  (* typedef  struct Cv3dTrackerCameraInfo
    {
    CvBool valid;
    float mat[4][4];              /* maps camera coordinates to world coordinates */
    CvPoint2D32f principal_point; /* copied from intrinsics so this structure */
    /* has all the info we need */
    } Cv3dTrackerCameraInfo; *)
  pCv3dTrackerCameraInfo = ^TCv3dTrackerCameraInfo;

  TCv3dTrackerCameraInfo = record
    valid: TCvBool;
    mat: array [0 .. 3, 0 .. 3] of Single; (* maps camera coordinates to world coordinates *)
    principal_point: TCvPoint2D32f; (* copied from intrinsics so this structure *)
    (* has all the info we need *)
  end;

  (* typedef  struct Cv3dTrackerCameraIntrinsics
    {
    CvPoint2D32f principal_point;
    float focal_length[2];
    float distortion[4];
    } Cv3dTrackerCameraIntrinsics; *)

  pCv3dTrackerCameraIntrinsics = ^TCv3dTrackerCameraIntrinsics;

  TCv3dTrackerCameraIntrinsics = record
    principal_point: TCvPoint2D32f;
    focal_length: array [0 .. 1] of Single;
    distortion: array [0 .. 3] of Single;
  end;
  (*
    CVAPI(CvBool) cv3dTrackerCalibrateCameras(int num_cameras,
    const Cv3dTrackerCameraIntrinsics camera_intrinsics[], /* size is num_cameras */
    CvSize etalon_size,
    float square_size,
    IplImage *samples[],                                   /* size is num_cameras */
    Cv3dTrackerCameraInfo camera_info[]);
  *)

{$EXTERNALSYM cv3dTrackerCalibrateCameras}

function cv3dTrackerCalibrateCameras(num_cameras: Integer; camera_intrinsics: pCv3dTrackerCameraIntrinsics;
  etalon_size: TCvSize; square_size: Single; var samples: pIplImage; camera_info: pCv3dTrackerCameraInfo)
  : TCvBool; cdecl;

(*
  CVAPI(int)  cv3dTrackerLocateObjects(int num_cameras, int num_objects,
  const Cv3dTrackerCameraInfo camera_info[],        /* size is num_cameras */
  const Cv3dTracker2dTrackedObject tracking_info[], /* size is num_objects*num_cameras */
  Cv3dTrackerTrackedObject tracked_objects[]);
*)
{$EXTERNALSYM cv3dTrackerLocateObjects}
function cv3dTrackerLocateObjects(num_cameras: Integer; num_objects: Integer; camera_info: pCv3dTrackerCameraInfo;
  tracking_info: pCv3dTracker2dTrackedObject; tracked_objects: pCv3dTrackerTrackedObject): Integer; cdecl;

(*
  ***************************************************************************************
  tracking_info is a rectangular array; one row per camera, num_objects elements per row.
  The id field of any unused slots must be -1. Ids need not be ordered or consecutive. On
  completion, the return value is the number of objects located; i.e., the number of objects
  visible by more than one camera. The id field of any unused slots in tracked objects is
  set to -1.
  ***************************************************************************************
*)
(*
  ***************************************************************************************\
  *                           Skeletons and Linear-Contour Models                          *
  \***************************************************************************************
*)
type
  (* typedef  enum CvLeeParameters
    {
    CV_LEE_INT = 0,
    CV_LEE_FLOAT = 1,
    CV_LEE_DOUBLE = 2,
    CV_LEE_AUTO = -1,
    CV_LEE_ERODE = 0,
    CV_LEE_ZOOM = 1,
    CV_LEE_NON = 2
    } CvLeeParameters; *)
  TCvLeeParameters = (CV_LEE_INT = 0, CV_LEE_FLOAT = 1, CV_LEE_DOUBLE = 2, CV_LEE_AUTO = -1, CV_LEE_ERODE = 0,
    CV_LEE_ZOOM = 1, CV_LEE_NON = 2);

  // #define CV_NEXT_VORONOISITE2D( SITE ) ((SITE)->edge[0]->site[((SITE)->edge[0]->site[0] == (SITE))])
  // #define CV_PREV_VORONOISITE2D( SITE ) ((SITE)->edge[1]->site[((SITE)->edge[1]->site[0] == (SITE))])
  // #define CV_FIRST_VORONOIEDGE2D( SITE ) ((SITE)->edge[0])
  // #define CV_LAST_VORONOIEDGE2D( SITE ) ((SITE)->edge[1])
  // #define CV_NEXT_VORONOIEDGE2D( EDGE, SITE ) ((EDGE)->next[(EDGE)->site[0] != (SITE)])
  // #define CV_PREV_VORONOIEDGE2D( EDGE, SITE ) ((EDGE)->next[2 + ((EDGE)->site[0] != (SITE))])
  // #define CV_VORONOIEDGE2D_BEGINNODE( EDGE, SITE ) ((EDGE)->node[((EDGE)->site[0] != (SITE))])
  // #define CV_VORONOIEDGE2D_ENDNODE( EDGE, SITE ) ((EDGE)->node[((EDGE)->site[0] == (SITE))])
  // #define CV_TWIN_VORONOISITE2D( SITE, EDGE ) ( (EDGE)->site[((EDGE)->site[0] == (SITE))])

  pCvVoronoiSite2D = ^TCvVoronoiSite2D;
  pCvVoronoiEdge2D = ^TCvVoronoiEdge2D;
  pCvVoronoiNode2D = ^TCvVoronoiNode2D;

  // #define CV_VORONOISITE2D_FIELDS()    \
  // struct CvVoronoiNode2D *node[2]; \
  // struct CvVoronoiEdge2D *edge[2];

  TCV_VORONOISITE2D_FIELDS = record
    node: array [0 .. 1] of pCvVoronoiNode2D;
    edge: array [0 .. 1] of pCvVoronoiEdge2D;
  end;

  (* typedef  struct CvVoronoiSite2D
    {
    CV_VORONOISITE2D_FIELDS()
    struct CvVoronoiSite2D *next[2];
    } CvVoronoiSite2D; *)
  TCvVoronoiSite2D = record
    CV_VORONOISITE2D_FIELDS: TCV_VORONOISITE2D_FIELDS;
    next: array [0 .. 1] of pCvVoronoiSite2D;
  end;

  // #define CV_VORONOIEDGE2D_FIELDS()    \
  // struct CvVoronoiNode2D *node[2]; \
  // struct CvVoronoiSite2D *site[2]; \
  // struct CvVoronoiEdge2D *next[4];
  TCV_VORONOIEDGE2D_FIELDS = record
    node: array [0 .. 1] of pCvVoronoiNode2D;
    site: array [0 .. 1] of pCvVoronoiSite2D;
    next: array [0 .. 3] of pCvVoronoiEdge2D;
  end;

  (* typedef  struct CvVoronoiEdge2D
    {
    CV_VORONOIEDGE2D_FIELDS()
    } CvVoronoiEdge2D; *)
  TCvVoronoiEdge2D = record
    CV_VORONOIEDGE2D_FIELDS: TCV_VORONOIEDGE2D_FIELDS;
  end;

  (* typedef  struct CvVoronoiNode2D
    {
    CV_VORONOINODE2D_FIELDS()
    } CvVoronoiNode2D; *)
  TCvVoronoiNode2D = record
    // CV_VORONOINODE2D_FIELDS:TCV_VORONOINODE2D_FIELDS;
    CV_SET_ELEM_FIELDS: TCV_SET_ELEM_FIELDS<TCvVoronoiNode2D>;
    pt: TCvPoint2D32f;
    radius: Single;
  end;

  // #define CV_VORONOINODE2D_FIELDS()       \
  // CV_SET_ELEM_FIELDS(CvVoronoiNode2D) \
  // CvPoint2D32f pt;                    \
  // float radius;
  TCV_VORONOINODE2D_FIELDS = record
    CV_SET_ELEM_FIELDS: TCV_SET_ELEM_FIELDS<TCvVoronoiNode2D>;
    pt: TCvPoint2D32f;
    radius: Single;
  end;

  // #define CV_VORONOIDIAGRAM2D_FIELDS() \
  // CV_GRAPH_FIELDS()                \
  // CvSet *sites;
  TCV_VORONOIDIAGRAM2D_FIELDS = record
    CV_GRAPH_FIELDS: TCV_GRAPH_FIELDS;
    sites: PCvSet;
  end;

  (* typedef  struct CvVoronoiDiagram2D
    {
    CV_VORONOIDIAGRAM2D_FIELDS()
    } CvVoronoiDiagram2D; *)

  pCvVoronoiDiagram2D = ^TCvVoronoiDiagram2D;

  TCvVoronoiDiagram2D = record
    CV_VORONOIDIAGRAM2D_FIELDS: TCV_VORONOIDIAGRAM2D_FIELDS;
  end;

  (*
    Computes Voronoi Diagram for given polygons with holes
  *)
  (*
    CVAPI(int)  cvVoronoiDiagramFromContour(CvSeq* ContourSeq,
    CvVoronoiDiagram2D** VoronoiDiagram,
    CvMemStorage* VoronoiStorage,
    CvLeeParameters contour_type CV_DEFAULT(CV_LEE_INT),
    int contour_orientation CV_DEFAULT(-1),
    int attempt_number CV_DEFAULT(10));
  *)
function cvVoronoiDiagramFromContour(ContourSeq: pCvSeq; var VoronoiDiagram: pCvVoronoiDiagram2D;
  VoronoiStorage: pCvMemStorage; contour_type: TCvLeeParameters = CV_LEE_INT; contour_orientation: Integer = -1;
  attempt_number: Integer = 10): Integer; cdecl;
(*
  Computes Voronoi Diagram for domains in given image
*)
(*
  CVAPI(int)  cvVoronoiDiagramFromImage(IplImage* pImage,
  CvSeq** ContourSeq,
  CvVoronoiDiagram2D** VoronoiDiagram,
  CvMemStorage* VoronoiStorage,
  CvLeeParameters regularization_method CV_DEFAULT(CV_LEE_NON),
  float approx_precision CV_DEFAULT(CV_LEE_AUTO));
*)
function cvVoronoiDiagramFromImage(pImage: pIplImage; var ContourSeq: pCvSeq; var VoronoiDiagram: pCvVoronoiDiagram2D;
  VoronoiStorage: pCvMemStorage; regularization_method: TCvLeeParameters = CV_LEE_NON;
  approx_precision: float = -1 { CV_LEE_AUTO } ): Integer; cdecl;
(*
  Deallocates the storage
*)
(*
  CVAPI(void) cvReleaseVoronoiStorage(CvVoronoiDiagram2D* VoronoiDiagram,
  CvMemStorage** pVoronoiStorage);
*)
procedure cvReleaseVoronoiStorage(VoronoiDiagram: pCvVoronoiDiagram2D; var pVoronoiStorage: pCvMemStorage); cdecl;
(*
  ********************** Linear-Contour Model ***************************
*)
(* struct  CvLCMEdge; *)
(* struct  CvLCMNode; *)
(* typedef  struct CvLCMEdge
  {
  CV_GRAPH_EDGE_FIELDS()
  CvSeq* chain;
  float width;
  int index1;
  int index2;
  } CvLCMEdge; *)
(* typedef  struct CvLCMNode
  {
  CV_GRAPH_VERTEX_FIELDS()
  CvContour* contour;
  } CvLCMNode; *)
(*
  Computes hybrid model from Voronoi Diagram
*)
(*
  CVAPI(CvGraph* ) cvLinearContorModelFromVoronoiDiagram(CvVoronoiDiagram2D* VoronoiDiagram,
  float maxWidth);
*)
function cvLinearContorModelFromVoronoiDiagram(VoronoiDiagram: pCvVoronoiDiagram2D; maxWidth: float): pCvGraph; cdecl;
(*
  Releases hybrid model storage
*)
(*
  CVAPI(int) cvReleaseLinearContorModelStorage(CvGraph** Graph);
*)
function cvReleaseLinearContorModelStorage(var Graph: pCvGraph): Integer; cdecl;

(*
  two stereo-related functions
*)
(*
  CVAPI(void) cvInitPerspectiveTransform( CvSize size, const CvPoint2D32f vertex[4], double matrix[3][3],
  CvArr* rectMap );
*)
Type
  TcvInitPerspectiveTransformVertex = array [0 .. 3] of TCvPoint2D32f;
  TcvInitPerspectiveTransformMatrix = array [0 .. 2, 0 .. 2] of double;

procedure cvInitPerspectiveTransform(size: TCvSize; const vertex: TcvInitPerspectiveTransformVertex;
  matrix: TcvInitPerspectiveTransformMatrix; rectMap: pCvArr); cdecl;

(*
  CVAPI(void) cvInitStereoRectification( CvStereoCamera* params,
  CvArr* rectMap1, CvArr* rectMap2,
  int do_undistortion );
*)
(*
  ************************** View Morphing Functions ***********************
*)
Type
  (* typedef  struct CvMatrix3
    {
    float m[3][3];
    } CvMatrix3; *)
  pCvMatrix3 = ^TCvMatrix3;

  TCvMatrix3 = record
    m: array [0 .. 2, 0 .. 2] of Single;
  end;

  (*
    The order of the function corresponds to the order they should appear in
    the view morphing pipeline
  *)
  (*
    Finds ending points of scanlines on left and right images of stereo-pair
  *)
  (*
    CVAPI(void)  cvMakeScanlines( const CvMatrix3* matrix, CvSize  img_size,
    int*  scanlines1, int*  scanlines2,
    int*  lengths1, int*  lengths2,
    int*  line_count );
  *)
procedure cvMakeScanlines(const matrix: pCvMatrix3; img_size: TCvSize; scanlines1: PInteger; scanlines2: PInteger;
  lengths1: PInteger; lengths2: PInteger; line_count: PInteger); cdecl;
(*
  Grab pixel values from scanlines and stores them sequentially
  (some sort of perspective image transform)
*)
(*
  CVAPI(void)  cvPreWarpImage( int       line_count,
  IplImage* img,
  uchar*    dst,
  int*      dst_nums,
  int*      scanlines);
*)
procedure cvPreWarpImage(line_count: Integer; img: pIplImage; dst: puchar; dst_nums: PInteger;
  scanlines: PInteger); cdecl;
(*
  Approximate each grabbed scanline by a sequence of runs
  (lossy run-length compression)
*)
(*
  CVAPI(void)  cvFindRuns( int    line_count,
  uchar* prewarp1,
  uchar* prewarp2,
  int*   line_lengths1,
  int*   line_lengths2,
  int*   runs1,
  int*   runs2,
  int*   num_runs1,
  int*   num_runs2);
*)
procedure cvFindRuns(line_count: Integer; prewarp1: puchar; prewarp2: puchar; line_lengths1: PInteger;
  line_lengths2: PInteger; runs1: PInteger; runs2: PInteger; num_runs1: PInteger; num_runs2: PInteger); cdecl;
(*
  Compares two sets of compressed scanlines
*)
(*
  CVAPI(void)  cvDynamicCorrespondMulti( int  line_count,
  int* first,
  int* first_runs,
  int* second,
  int* second_runs,
  int* first_corr,
  int* second_corr);
*)
procedure cvDynamicCorrespondMulti(line_count: Integer; first: PInteger; first_runs: PInteger; second: PInteger;
  second_runs: PInteger; first_corr: PInteger; second_corr: PInteger); cdecl;
(*
  Finds scanline ending coordinates for some intermediate "virtual" camera position
*)
(*
  CVAPI(void)  cvMakeAlphaScanlines( int*  scanlines1,
  int*  scanlines2,
  int*  scanlinesA,
  int*  lengths,
  int   line_count,
  float alpha);
*)
procedure cvMakeAlphaScanlines(scanlines1: PInteger; scanlines2: PInteger; scanlinesA: PInteger; lengths: PInteger;
  line_count: Integer; alpha: float); cdecl;
(*
  Blends data of the left and right image scanlines to get
  pixel values of "virtual" image scanlines
*)
(*
  CVAPI(void)  cvMorphEpilinesMulti( int    line_count,
  uchar* first_pix,
  int*   first_num,
  uchar* second_pix,
  int*   second_num,
  uchar* dst_pix,
  int*   dst_num,
  float  alpha,
  int*   first,
  int*   first_runs,
  int*   second,
  int*   second_runs,
  int*   first_corr,
  int*   second_corr);
*)
procedure cvMorphEpilinesMulti(line_count: Integer; first_pix: puchar; first_num: PInteger; second_pix: puchar;
  second_num: PInteger; dst_pix: puchar; dst_num: PInteger; alpha: float; first: PInteger; first_runs: PInteger;
  second: PInteger; second_runs: PInteger; first_corr: PInteger; second_corr: PInteger); cdecl;
(*
  Does reverse warping of the morphing result to make
  it fill the destination image rectangle
*)
(*
  CVAPI(void)  cvPostWarpImage( int       line_count,
  uchar*    src,
  int*      src_nums,
  IplImage* img,
  int*      scanlines);
*)
procedure cvPostWarpImage(line_count: Integer; src: puchar; src_nums: PInteger; img: pIplImage;
  scanlines: PInteger); cdecl;
(*
  Deletes Moire (missed pixels that appear due to discretization)
*)
(*
  CVAPI(void)  cvDeleteMoire( IplImage*  img );
*)
procedure cvDeleteMoire(img: pIplImage); cdecl;

Type
  (* typedef  struct CvConDensation
    {
    int MP;
    int DP;
    float* DynamMatr;       /* Matrix of the linear Dynamics system  */
    float* State;           /* Vector of State                       */
    int SamplesNum;         /* Number of the Samples                 */
    float** flSamples;      /* arr of the Sample Vectors             */
    float** flNewSamples;   /* temporary array of the Sample Vectors */
    float* flConfidence;    /* Confidence for each Sample            */
    float* flCumulative;    /* Cumulative confidence                 */
    float* Temp;            /* Temporary vector                      */
    float* RandomSample;    /* RandomVector to update sample set     */
    struct CvRandState* RandS; /* Array of structures to generate random vectors */
    } CvConDensation; *)
  pCvConDensation = ^TCvConDensation;

  TCvConDensation = record
    MP: Integer;
    DP: Integer;
    DynamMatr: PSingle; (* Matrix of the linear Dynamics system *)
    state: PSingle; (* Vector of State *)
    SamplesNum: Integer; (* Number of the Samples *)
    flSamples: ^PSingle; (* arr of the Sample Vectors *)
    flNewSamples: ^PSingle; (* temporary array of the Sample Vectors *)
    flConfidence: PSingle; (* Confidence for each Sample *)
    flCumulative: PSingle; (* Cumulative confidence *)
    Temp: PSingle; (* Temporary vector *)
    RandomSample: PSingle; (* RandomVector to update sample set *)
    RandS: PCvRandState; (* Array of structures to generate random vectors *)
  end;

  (*
    Creates ConDensation filter state
  *)
  (*
    CVAPI(CvConDensation* )  cvCreateConDensation( int dynam_params,
    int measure_params,
    int sample_count );
  *)
function cvCreateConDensation(dynam_params: Integer; measure_params: Integer; sample_count: Integer)
  : pCvConDensation; cdecl;
(*
  Releases ConDensation filter state
*)
(*
  CVAPI(void)  cvReleaseConDensation( CvConDensation** condens );
*)
procedure cvReleaseConDensation(var condens: pCvConDensation); cdecl;
(*
  Updates ConDensation filter by time (predict future state of the system)
*)
(*
  CVAPI(void)  cvConDensUpdateByTime( CvConDensation* condens);
*)
procedure cvConDensUpdateByTime(condens: pCvConDensation); cdecl;
(*
  Initializes ConDensation filter samples
*)
(*
  CVAPI(void)  cvConDensInitSampleSet( CvConDensation* condens, CvMat* lower_bound, CvMat* upper_bound );
*)
procedure cvConDensInitSampleSet(condens: pCvConDensation; lower_bound: pCvMat; upper_bound: pCvMat); cdecl;
(* CV_INLINE  int iplWidth( const IplImage* img )
  {
  return !img ? 0 : !img->roi ? img->width : img->roi->width;
  } *)
(* CV_INLINE  int iplHeight( const IplImage* img )
  {
  return !img ? 0 : !img->roi ? img->height : img->roi->height;
  } *)

(*
  ***************************************************************************************\
  *                              Planar subdivisions                                       *
  \***************************************************************************************
*)

(*
  ************************ high-level subdivision functions **************************
*)
(*
  Simplified Delaunay diagram creation
*)
(* CV_INLINE   CvSubdiv2D* cvCreateSubdivDelaunay2D( CvRect rect, CvMemStorage* storage )
  {
  CvSubdiv2D* subdiv = cvCreateSubdiv2D( CV_SEQ_KIND_SUBDIV2D, sizeof(*subdiv),
  sizeof(CvSubdiv2DPoint), sizeof(CvQuadEdge2D), storage );

  cvInitSubdivDelaunay2D( subdiv, rect );
  return subdiv;
  } *)

(*
  Removes all Voronoi points from the tesselation

  CVAPI(void)  cvClearSubdivVoronoi2D( CvSubdiv2D* subdiv );
*)
procedure cvClearSubdivVoronoi2D(subdiv: pCvSubdiv2D); cdecl;
(*
  Finds the nearest to the given point vertex in subdivision.

  CVAPI(CvSubdiv2DPoint* ) cvFindNearestPoint2D( CvSubdiv2D* subdiv, CvPoint2D32f pt );
*)
function cvFindNearestPoint2D(subdiv: pCvSubdiv2D; pt: TCvPoint2D32f): pCvSubdiv2DPoint; cdecl;
(*
  *********** Basic quad-edge navigation and operations ***********
*)
(* CV_INLINE   CvSubdiv2DEdge  cvSubdiv2DNextEdge( CvSubdiv2DEdge edge )
  {
  return  CV_SUBDIV2D_NEXT_EDGE(edge);
  } *)
(* CV_INLINE   CvSubdiv2DEdge  cvSubdiv2DRotateEdge( CvSubdiv2DEdge edge, int rotate )
  {
  return  (edge & ~3) + ((edge + rotate) & 3);
  } *)
(* CV_INLINE   CvSubdiv2DEdge  cvSubdiv2DSymEdge( CvSubdiv2DEdge edge )
  {
  return edge ^ 2;
  } *)
(* CV_INLINE   CvSubdiv2DEdge  cvSubdiv2DGetEdge( CvSubdiv2DEdge edge, CvNextEdgeType type )
  {
  CvQuadEdge2D* e = (CvQuadEdge2D* )(edge & ~3);
  edge = e->next[(edge + (int)type) & 3];
  return  (edge & ~3) + ((edge + ((int)type >> 4)) & 3);
  } *)
(* CV_INLINE   CvSubdiv2DPoint*  cvSubdiv2DEdgeOrg( CvSubdiv2DEdge edge )
  {
  CvQuadEdge2D* e = (CvQuadEdge2D* )(edge & ~3);
  return (CvSubdiv2DPoint* )e->pt[edge & 3];
  } *)
(* CV_INLINE   CvSubdiv2DPoint*  cvSubdiv2DEdgeDst( CvSubdiv2DEdge edge )
  {
  CvQuadEdge2D* e = (CvQuadEdge2D* )(edge & ~3);
  return (CvSubdiv2DPoint* )e->pt[(edge + 2) & 3];
  } *)
(*
  ***************************************************************************************\
  *                           Additional operations on Subdivisions                        *
  \***************************************************************************************
*)
// paints voronoi diagram: just demo function
(*
  CVAPI(void)  icvDrawMosaic( CvSubdiv2D* subdiv, IplImage* src, IplImage* dst );
*)
procedure icvDrawMosaic(subdiv: pCvSubdiv2D; src: pIplImage; dst: pIplImage); cdecl;
// checks planar subdivision for correctness. It is not an absolute check,
// but it verifies some relations between quad-edges
(*
  CVAPI(int)   icvSubdiv2DCheck( CvSubdiv2D* subdiv );
*)
function icvSubdiv2DCheck(subdiv: pCvSubdiv2D): Integer; cdecl;
// returns squared distance between two 2D points with floating-point coordinates.
(* CV_INLINE  double icvSqDist2D32f( CvPoint2D32f pt1, CvPoint2D32f pt2 )
  {
  double dx = pt1.x - pt2.x;
  double dy = pt1.y - pt2.y;

  return dx*dx + dy*dy;
  } *)
(* CV_INLINE   double  cvTriangleArea( CvPoint2D32f a, CvPoint2D32f b, CvPoint2D32f c )
  {
  return ((double)b.x - a.x) * ((double)c.y - a.y) - ((double)b.y - a.y) * ((double)c.x - a.x);
  } *)
(*
  Constructs kd-tree from set of feature descriptors

  CVAPI(struct CvFeatureTree* ) cvCreateKDTree(CvMat* desc);
*)
function cvCreateKDTree(desc: pCvMat): pCvFeatureTree; cdecl;
(*
  Constructs spill-tree from set of feature descriptors
*)
(*
  CVAPI(struct CvFeatureTree* ) cvCreateSpillTree( const CvMat* raw_data,
  const int naive CV_DEFAULT(50),
  const double rho CV_DEFAULT(.7),
  const double tau CV_DEFAULT(.1) );
*)
function cvCreateSpillTree(const raw_data: pCvMat; const naive: Integer = 50; const rho: double = 0.7;
  const tau: double = 0.1): pCvFeatureTree; cdecl;
(*
  Release feature tree
*)
(*
  CVAPI(void) cvReleaseFeatureTree(struct CvFeatureTree* tr);
*)
procedure cvReleaseFeatureTree(tr: pCvFeatureTree); cdecl;
(*
  Searches feature tree for k nearest neighbors of given reference points,
  searching (in case of kd-tree/bbf) at most emax leaves.
*)
(*
  CVAPI(void) cvFindFeatures(struct CvFeatureTree* tr, const CvMat* query_points,
  CvMat* indices, CvMat* dist, int k, int emax CV_DEFAULT(20));
*)
procedure cvFindFeatures(tr: pCvFeatureTree; const query_points: pCvMat; indices: pCvMat; dist: pCvMat; K: Integer;
  emax: Integer = 20); cdecl;
(*
  Search feature tree for all points that are inlier to given rect region.
  Only implemented for kd trees
*)
(*
  CVAPI(int) cvFindFeaturesBoxed(struct CvFeatureTree* tr,
  CvMat* bounds_min, CvMat* bounds_max,
  CvMat* out_indices);
*)
function cvFindFeaturesBoxed(tr: pCvFeatureTree; bounds_min: pCvMat; bounds_max: pCvMat; out_indices: pCvMat)
  : Integer; cdecl;
(*
  Construct a Locality Sensitive Hash (LSH) table, for indexing d-dimensional vectors of
  given type. Vectors will be hashed L times with k-dimensional p-stable (p=2) functions.
*)
(*
  CVAPI(struct CvLSH* ) cvCreateLSH(struct CvLSHOperations* ops, int d,
  int L CV_DEFAULT(10), int k CV_DEFAULT(10),
  int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
  int64 seed CV_DEFAULT(-1));
*)
function cvCreateLSH(ops: pCvLSHOperations; d: Integer; L: Integer { =10 }; K: Integer { =10 };
  type_: Integer { =CV_64FC1 }; r: double { =4 }; seed: int64 { =-1 } ): pCvLSH; cdecl;
(*
  Construct in-memory LSH table, with n bins.
*)
(*
  CVAPI(struct CvLSH* ) cvCreateMemoryLSH(int d, int n, int L CV_DEFAULT(10), int k CV_DEFAULT(10),
  int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
  int64 seed CV_DEFAULT(-1));
*)
function cvCreateMemoryLSH(d: Integer; n: Integer; L: Integer { =10 }; K: Integer { =10 }; type_: Integer { =CV_64FC1 };
  r: double { =4 }; seed: int64 { =-1 } ): pCvLSH; cdecl;
(*
  Free the given LSH structure.
*)
(*
  CVAPI(void) cvReleaseLSH(struct CvLSH** lsh);
*)
procedure cvReleaseLSH(lsh: pCvLSH); cdecl;
(*
  Return the number of vectors in the LSH.
*)
(*
  CVAPI(unsigned int) LSHSize(struct CvLSH* lsh);
*)
function LSHSize(lsh: pCvLSH): uint; cdecl;
(*
  Add vectors to the LSH structure, optionally returning indices.
*)
(*
  CVAPI(void) cvLSHAdd(struct CvLSH* lsh, const CvMat* data, CvMat* indices CV_DEFAULT(0));
*)
procedure cvLSHAdd(lsh: pCvLSH; const data: pCvMat; indices: pCvMat = nil); cdecl;
(*
  Remove vectors from LSH, as addressed by given indices.
*)
(*
  CVAPI(void) cvLSHRemove(struct CvLSH* lsh, const CvMat* indices);
*)
procedure cvLSHRemove(lsh: pCvLSH; const indices: pCvMat); cdecl;
(*
  Query the LSH n times for at most k nearest points; data is n x d,
  indices and dist are n x k. At most emax stored points will be accessed.
*)
(*
  CVAPI(void) cvLSHQuery(struct CvLSH* lsh, const CvMat* query_points,
  CvMat* indices, CvMat* dist, int k, int emax);
*)
procedure cvLSHQuery(lsh: pCvLSH; const query_points: pCvMat; indices: pCvMat; dist: pCvMat; K: Integer;
  emax: Integer); cdecl;
(*
  Kolmogorov-Zabin stereo-correspondence algorithm (a.k.a. KZ1)
*)
// #define CV_STEREO_GC_OCCLUDED  SHRT_MAX
(* typedef  struct CvStereoGCState
  {
  int Ithreshold;
  int interactionRadius;
  float K, lambda, lambda1, lambda2;
  int occlusionCost;
  int minDisparity;
  int numberOfDisparities;
  int maxIters;

  CvMat* left;
  CvMat* right;
  CvMat* dispLeft;
  CvMat* dispRight;
  CvMat* ptrLeft;
  CvMat* ptrRight;
  CvMat* vtxBuf;
  CvMat* edgeBuf;
  } CvStereoGCState; *)

(*
  Calculates optical flow for 2 images using classical Lucas & Kanade algorithm
*)
(*
  CVAPI(void)  cvCalcOpticalFlowLK( const CvArr* prev, const CvArr* curr,
  CvSize win_size, CvArr* velx, CvArr* vely );
*)
procedure cvCalcOpticalFlowLK(const prev: pCvArr; const curr: pCvArr; win_size: TCvSize; velx: pCvArr;
  vely: pCvArr); cdecl;
(*
  Calculates optical flow for 2 images using block matching algorithm
*)
(*
  CVAPI(void)  cvCalcOpticalFlowBM( const CvArr* prev, const CvArr* curr,
  CvSize block_size, CvSize shift_size,
  CvSize max_range, int use_previous,
  CvArr* velx, CvArr* vely );
*)
procedure cvCalcOpticalFlowBM(const prev: pCvArr; const curr: pCvArr; block_size: TCvSize; shift_size: TCvSize;
  max_range: TCvSize; use_previous: Integer; velx: pCvArr; vely: pCvArr); cdecl;
(*
  Calculates Optical flow for 2 images using Horn & Schunck algorithm
*)
(*
  CVAPI(void)  cvCalcOpticalFlowHS( const CvArr* prev, const CvArr* curr,
  int use_previous, CvArr* velx, CvArr* vely,
  double lambda, CvTermCriteria criteria );
*)
procedure cvCalcOpticalFlowHS(const prev: pCvArr; const curr: pCvArr; use_previous: Integer; velx: pCvArr; vely: pCvArr;
  lambda: double; criteria: TCvTermCriteria); cdecl;
(*
  ***************************************************************************************\
  *                           Background/foreground segmentation                           *
  \***************************************************************************************
*)
(*
  We discriminate between foreground and background pixels
  * by building and maintaining a model of the background.
  * Any pixel which does not fit this model is then deemed
  * to be foreground.
  *
  * At present we support two core background models,
  * one of which has two variations:
  *
  *  o CV_BG_MODEL_FGD: latest and greatest algorithm, described in
  *
  *	 Foreground Object Detection from Videos Containing Complex Background.
  *	 Liyuan Li, Weimin Huang, Irene Y.H. Gu, and Qi Tian.
  *	 ACM MM2003 9p
  *
  *  o CV_BG_MODEL_FGD_SIMPLE:
  *       A code comment describes this as a simplified version of the above,
  *       but the code is in fact currently identical
  *
  *  o CV_BG_MODEL_MOG: "Mixture of Gaussians", older algorithm, described in
  *
  *       Moving target classification and tracking from real-time video.
  *       A Lipton, H Fujijoshi, R Patil
  *       Proceedings IEEE Workshop on Application of Computer Vision pp 8-14 1998
  *
  *       Learning patterns of activity using real-time tracking
  *       C Stauffer and W Grimson  August 2000
  *       IEEE Transactions on Pattern Analysis and Machine Intelligence 22(8):747-757

*)
// #define CV_BG_MODEL_FGD		0
// #define CV_BG_MODEL_MOG		1			/* "Mixture of Gaussians".	*/
// #define CV_BG_MODEL_FGD_SIMPLE	2
(* struct  CvBGStatModel; *)
(* typedef  void (CV_CDECL * CvReleaseBGStatModel)( struct CvBGStatModel** bg_model ); *)
(* typedef  int (CV_CDECL * CvUpdateBGStatModel)( IplImage* curr_frame, struct CvBGStatModel* bg_model,
  double learningRate ); *)
// #define CV_BG_STAT_MODEL_FIELDS()                                               \
// int             type; /*type of BG model*/                                      \
// CvReleaseBGStatModel release;                                                   \
// CvUpdateBGStatModel update;                                                     \
// IplImage*       background;   /*8UC3 reference background image*/               \
// IplImage*       foreground;   /*8UC1 foreground image*/                         \
// IplImage**      layers;       /*8UC3 reference background image, can be null */ \
// int             layer_count;  /* can be zero */                                 \
// CvMemStorage*   storage;      /*storage for foreground_regions*/                \
// CvSeq*          foreground_regions /*foreground object contours*/
(* typedef  struct CvBGStatModel
  {
  CV_BG_STAT_MODEL_FIELDS();
  } CvBGStatModel; *)

// Performs FG post-processing using segmentation
// (all pixels of a region will be classified as foreground if majority of pixels of the region are FG).
// parameters:
// segments - pointer to result of segmentation (for example MeanShiftSegmentation)
// bg_model - pointer to CvBGStatModel structure
(*
  CVAPI(void) cvRefineForegroundMaskBySegm( CvSeq* segments, CvBGStatModel*  bg_model );
*)
procedure cvRefineForegroundMaskBySegm(segments: pCvSeq; bg_model: pCvBGStatModel); cdecl;
(*
  Common use change detection function
*)
(*
  CVAPI(int)  cvChangeDetection( IplImage*  prev_frame,
  IplImage*  curr_frame,
  IplImage*  change_mask );
*)
function cvChangeDetection(prev_frame: pIplImage; curr_frame: pIplImage; change_mask: pIplImage): Integer; cdecl;
(*

  Interface of ACM MM2003 algorithm

*)
(*
  Default parameters of foreground detection algorithm:
*)
// #define  CV_BGFG_FGD_LC              128
// #define  CV_BGFG_FGD_N1C             15
// #define  CV_BGFG_FGD_N2C             25
// #define  CV_BGFG_FGD_LCC             64
// #define  CV_BGFG_FGD_N1CC            25
// #define  CV_BGFG_FGD_N2CC            40
(*
  Background reference image update parameter:
*)
// #define  CV_BGFG_FGD_ALPHA_1         0.1f
(*
  stat model update parameter
  * 0.002f ~ 1K frame(~45sec), 0.005 ~ 18sec (if 25fps and absolutely static BG)

*)
// #define  CV_BGFG_FGD_ALPHA_2         0.005f
(*
  start value for alpha parameter (to fast initiate statistic model)
*)
// #define  CV_BGFG_FGD_ALPHA_3         0.1f
// #define  CV_BGFG_FGD_DELTA           2
// #define  CV_BGFG_FGD_T               0.9f
// #define  CV_BGFG_FGD_MINAREA         15.f
// #define  CV_BGFG_FGD_BG_UPDATE_TRESH 0.5f
(*
  See the above-referenced Li/Huang/Gu/Tian paper
  * for a full description of these background-model
  * tuning parameters.
  *
  * Nomenclature:  'c'  == "color", a three-component red/green/blue vector.
  *                         We use histograms of these to model the range of
  *                         colors we've seen at a given background pixel.
  *
  *                'cc' == "color co-occurrence", a six-component vector giving
  *                         RGB color for both this frame and preceding frame.
  *                             We use histograms of these to model the range of
  *                         color CHANGES we've seen at a given background pixel.

*)
(* typedef  struct CvFGDStatModelParams
  {
  int    Lc;			/* Quantized levels per 'color' component. Power of two, typically 32, 64 or 128.				*/
  int    N1c;			/* Number of color vectors used to model normal background color variation at a given pixel.			*/
  int    N2c;			/* Number of color vectors retained at given pixel.  Must be > N1c, typically ~ 5/3 of N1c.			*/
  /* Used to allow the first N1c vectors to adapt over time to changing background.				*/

  int    Lcc;			/* Quantized levels per 'color co-occurrence' component.  Power of two, typically 16, 32 or 64.			*/
  int    N1cc;		/* Number of color co-occurrence vectors used to model normal background color variation at a given pixel.	*/
  int    N2cc;		/* Number of color co-occurrence vectors retained at given pixel.  Must be > N1cc, typically ~ 5/3 of N1cc.	*/
  /* Used to allow the first N1cc vectors to adapt over time to changing background.				*/

  int    is_obj_without_holes;/* If TRUE we ignore holes within foreground blobs. Defaults to TRUE.						*/
  int    perform_morphing;	/* Number of erode-dilate-erode foreground-blob cleanup iterations.						*/
  /* These erase one-pixel junk blobs and merge almost-touching blobs. Default value is 1.			*/

  float  alpha1;		/* How quickly we forget old background pixel values seen.  Typically set to 0.1  				*/
  float  alpha2;		/* "Controls speed of feature learning". Depends on T. Typical value circa 0.005. 				*/
  float  alpha3;		/* Alternate to alpha2, used (e.g.) for quicker initial convergence. Typical value 0.1.				*/

  float  delta;		/* Affects color and color co-occurrence quantization, typically set to 2.					*/
  float  T;			/* "A percentage value which determines when new features can be recognized as new background." (Typically 0.9).*/
  float  minArea;		/* Discard foreground blobs whose bounding box is smaller than this threshold.					*/
  } CvFGDStatModelParams; *)
(* typedef  struct CvBGPixelCStatTable
  {
  float          Pv, Pvb;
  uchar          v[3];
  } CvBGPixelCStatTable; *)
(* typedef  struct CvBGPixelCCStatTable
  {
  float          Pv, Pvb;
  uchar          v[6];
  } CvBGPixelCCStatTable; *)
(* typedef  struct CvBGPixelStat
  {
  float                 Pbc;
  float                 Pbcc;
  CvBGPixelCStatTable*  ctable;
  CvBGPixelCCStatTable* cctable;
  uchar                 is_trained_st_model;
  uchar                 is_trained_dyn_model;
  } CvBGPixelStat; *)
(* typedef  struct CvFGDStatModel
  {
  CV_BG_STAT_MODEL_FIELDS();
  CvBGPixelStat*         pixel_stat;
  IplImage*              Ftd;
  IplImage*              Fbd;
  IplImage*              prev_frame;
  CvFGDStatModelParams   params;
  } CvFGDStatModel; *)

(*

  Interface of Gaussian mixture algorithm

  "An improved adaptive background mixture model for real-time tracking with shadow detection"
  P. KadewTraKuPong and R. Bowden,
  Proc. 2nd European Workshp on Advanced Video-Based Surveillance Systems, 2001."
  http://personal.ee.surrey.ac.uk/Personal/R.Bowden/publications/avbs01/avbs01.pdf

*)
(*
  Note:  "MOG" == "Mixture Of Gaussians":
*)
// #define CV_BGFG_MOG_MAX_NGAUSSIANS 500
(*
  default parameters of gaussian background detection algorithm
*)
// #define CV_BGFG_MOG_BACKGROUND_THRESHOLD     0.7     /* threshold sum of weights for background test */
// #define CV_BGFG_MOG_STD_THRESHOLD            2.5     /* lambda=2.5 is 99% */
// #define CV_BGFG_MOG_WINDOW_SIZE              200     /* Learning rate; alpha = 1/CV_GBG_WINDOW_SIZE */
// #define CV_BGFG_MOG_NGAUSSIANS               5       /* = K = number of Gaussians in mixture */
// #define CV_BGFG_MOG_WEIGHT_INIT              0.05
// #define CV_BGFG_MOG_SIGMA_INIT               30
// #define CV_BGFG_MOG_MINAREA                  15.f
// #define CV_BGFG_MOG_NCOLORS                  3
(* typedef  struct CvGaussBGStatModelParams
  {
  int     win_size;               /* = 1/alpha */
  int     n_gauss;
  double  bg_threshold, std_threshold, minArea;
  double  weight_init, variance_init;
  }CvGaussBGStatModelParams; *)
(* typedef  struct CvGaussBGValues
  {
  int         match_sum;
  double      weight;
  double      variance[CV_BGFG_MOG_NCOLORS];
  double      mean[CV_BGFG_MOG_NCOLORS];
  } CvGaussBGValues; *)
(* typedef  struct CvGaussBGPoint
  {
  CvGaussBGValues* g_values;
  } CvGaussBGPoint; *)
(* typedef  struct CvGaussBGModel
  {
  CV_BG_STAT_MODEL_FIELDS();
  CvGaussBGStatModelParams   params;
  CvGaussBGPoint*            g_point;
  int                        countFrames;
  void*                      mog;
  } CvGaussBGModel; *)

(* typedef  struct CvBGCodeBookElem
  {
  struct CvBGCodeBookElem* next;
  int tLastUpdate;
  int stale;
  uchar boxMin[3];
  uchar boxMax[3];
  uchar learnMin[3];
  uchar learnMax[3];
  } CvBGCodeBookElem; *)
(* typedef  struct CvBGCodeBookModel
  {
  CvSize size;
  int t;
  uchar cbBounds[3];
  uchar modMin[3];
  uchar modMax[3];
  CvBGCodeBookElem** cbmap;
  CvMemStorage* storage;
  CvBGCodeBookElem* freeList;
  } CvBGCodeBookModel; *)

implementation

uses ocv.lib;

function cvCreateStereoGCState; external legacy_lib;
procedure cvFindStereoCorrespondenceGC; external legacy_lib;
procedure cvReleaseStereoGCState; external legacy_lib;
procedure cvSnakeImage; external legacy_lib;
function cvCreateSubdiv2D; external legacy_lib;
procedure cvInitSubdivDelaunay2D; external legacy_lib;

function cvSubdiv2DEdgeOrg(edge: TCvSubdiv2DEdge): pCvSubdiv2DPoint; inline;
Var
  e: pCvQuadEdge2D;
begin
  // CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
  e := pCvQuadEdge2D(edge and (not 3));
  // return (CvSubdiv2DPoint*)e->pt[edge & 3];
  result := pCvSubdiv2DPoint(e^.pt[edge and 3]);
end;

function cvSubdiv2DEdgeDst(edge: TCvSubdiv2DEdge): pCvSubdiv2DPoint;
Var
  e: pCvQuadEdge2D;
begin
  // CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
  e := pCvQuadEdge2D(edge and (not 3));
  // return (CvSubdiv2DPoint*)e->pt[(edge + 2) & 3];
  result := pCvSubdiv2DPoint(e^.pt[(edge + 2) and 3]);
end;

function cvSubdiv2DLocate; external legacy_lib;

function cvSubdiv2DGetEdge(edge: TCvSubdiv2DEdge; _type: TCvNextEdgeType): TCvSubdiv2DEdge;
Var
  e: pCvQuadEdge2D;
begin
  // CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
  e := pCvQuadEdge2D(edge and (not 3));
  // edge = e->next[(edge + (int)type) & 3];
  edge := e^.next[(edge + _type) and 3];
  // return  (edge & ~3) + ((edge + ((int)type >> 4)) & 3);
  result := (edge and (not 3)) + ((edge + (_type shr 4)) and 3);
end;

function cvSubdiv2DRotateEdge(edge: TCvSubdiv2DEdge; rotate: Integer): TCvSubdiv2DEdge;
begin
  // return  (edge & ~3) + ((edge + rotate) & 3);
  result := (edge and (not 3)) + ((edge + rotate) and 3);
end;

procedure cvCalcSubdivVoronoi2D; external legacy_lib;
function cvSubdivDelaunay2DInsert; external legacy_lib;
function cvCreateGaussianBGModel; external legacy_lib;
function cvUpdateBGStatModel; external legacy_lib;
procedure cvReleaseBGStatModel; external legacy_lib;
function cvCreateFGDStatModel; external legacy_lib;
function cvCreateBGCodeBookModel; external legacy_lib;
procedure cvReleaseBGCodeBookModel; external legacy_lib;
procedure cvBGCodeBookUpdate; external legacy_lib;
function cvBGCodeBookDiff; external legacy_lib;
procedure cvBGCodeBookClearStale; external legacy_lib;
function cvSegmentFGMask; external legacy_lib;
procedure cvPyrSegmentation; external legacy_lib;
procedure cvCalcEigenObjects; external legacy_lib;
procedure cvEigenDecomposite; external legacy_lib;
function cvSegmentImage; external legacy_lib;
procedure cvCalcCovarMatrixEx; external legacy_lib;
function cvCalcDecompCoeff; external legacy_lib;
procedure cvEigenProjection; external legacy_lib;
function icvCreate1DHMM; external legacy_lib;
function icvRelease1DHMM; external legacy_lib;
function icvUniform1DSegm; external legacy_lib;
function icvInit1DMixSegm; external legacy_lib;
function icvEstimate1DHMMStateParams; external legacy_lib;
function icvEstimate1DObsProb; external legacy_lib;
function icvEstimate1DTransProb; external legacy_lib;
function icvViterbi; external legacy_lib;
function icv1DMixSegmL2; external legacy_lib;
function cvCreate2DHMM; external legacy_lib;
procedure cvRelease2DHMM; external legacy_lib;
function cvCreateObsInfo; external legacy_lib;
procedure cvReleaseObsInfo; external legacy_lib;
procedure cvImgToObs_DCT; external legacy_lib;
procedure cvUniformImgSegm; external legacy_lib;
procedure cvInitMixSegm; external legacy_lib;
procedure cvEstimateHMMStateParams; external legacy_lib;
procedure cvEstimateTransProb; external legacy_lib;
procedure cvEstimateObsProb; external legacy_lib;
function cvEViterbi; external legacy_lib;
procedure cvMixSegmL2; external legacy_lib;
procedure cvCreateHandMask; external legacy_lib;
procedure cvFindHandRegion; external legacy_lib;
procedure cvFindHandRegionA; external legacy_lib;
procedure cvCalcImageHomography; external legacy_lib;
procedure cvCalcPGH; external legacy_lib;
function cvFindDominantPoints; external legacy_lib;
procedure cvFindStereoCorrespondence; external legacy_lib;
function icvConvertWarpCoordinates; external legacy_lib;
function icvGetSymPoint3D; external legacy_lib;
procedure icvGetPieceLength3D; external legacy_lib;
function icvCompute3DPoint; external legacy_lib;
function icvCreateConvertMatrVect; external legacy_lib;
function icvConvertPointSystem; external legacy_lib;
function icvComputeCoeffForStereo; external legacy_lib;
function icvGetCrossPieceVector; external legacy_lib;
function icvGetCrossLineDirect; external legacy_lib;
function icvDefinePointPosition; external legacy_lib;
function icvStereoCalibration; external legacy_lib;
function icvComputeRestStereoParams; external legacy_lib;
procedure cvComputePerspectiveMap; external legacy_lib;
function icvComCoeffForLine; external legacy_lib;
function icvGetDirectionForPoint; external legacy_lib;
function icvGetCrossLines; external legacy_lib;
function icvComputeStereoLineCoeffs; external legacy_lib;
function icvGetAngleLine; external legacy_lib;
procedure icvGetCoefForPiece; external legacy_lib;
procedure icvComputeeInfiniteProject1; external legacy_lib;
procedure icvComputeeInfiniteProject2; external legacy_lib;
procedure icvGetCrossDirectDirect; external legacy_lib;
procedure icvGetCrossPieceDirect; external legacy_lib;
procedure icvGetCrossPiecePiece; external legacy_lib;
procedure icvGetPieceLength; external legacy_lib;
procedure icvGetCrossRectDirect; external legacy_lib;
procedure icvProjectPointToImage; external legacy_lib;
procedure icvGetQuadsTransform; external legacy_lib;
procedure icvGetQuadsTransformStruct; external legacy_lib;
procedure icvComputeStereoParamsForCameras; external legacy_lib;
procedure icvGetCutPiece; external legacy_lib;
procedure icvGetMiddleAnglePoint; external legacy_lib;
procedure icvGetNormalDirect; external legacy_lib;
function icvGetVect; external legacy_lib;
procedure icvProjectPointToDirect; external legacy_lib;
procedure icvGetDistanceFromPointToDirect; external legacy_lib;
function icvCreateIsometricImage; external legacy_lib;
procedure cvDeInterlace; external legacy_lib;
function cvCreateContourTree; external legacy_lib;
function cvContourFromContourTree; external legacy_lib;
function cvMatchContourTrees; external legacy_lib;
function cvCalcContoursCorrespondence; external legacy_lib;
function cvMorphContours; external legacy_lib;
function cvCreateGLCM; external legacy_lib;
procedure cvReleaseGLCM; external legacy_lib;
procedure cvCreateGLCMDescriptors; external legacy_lib;
function cvGetGLCMDescriptor; external legacy_lib;
procedure cvGetGLCMDescriptorStatistics; external legacy_lib;
function cvCreateGLCMImage; external legacy_lib;
function cvInitFaceTracker; external legacy_lib;
function cvTrackFace; external legacy_lib;
procedure cvReleaseFaceTracker; external legacy_lib;
function cvFindFace; external legacy_lib;
function cvPostBoostingFindFace; external legacy_lib;
function cv3dTrackerCalibrateCameras; external legacy_lib;
function cv3dTrackerLocateObjects; external legacy_lib;
function cvVoronoiDiagramFromContour; external legacy_lib;
function cvVoronoiDiagramFromImage; external legacy_lib;
procedure cvReleaseVoronoiStorage; external legacy_lib;
function cvLinearContorModelFromVoronoiDiagram; external legacy_lib;
function cvReleaseLinearContorModelStorage; external legacy_lib;
procedure cvInitPerspectiveTransform; external legacy_lib;
procedure cvMakeScanlines; external legacy_lib;
procedure cvPreWarpImage; external legacy_lib;
procedure cvFindRuns; external legacy_lib;
procedure cvDynamicCorrespondMulti; external legacy_lib;
procedure cvMakeAlphaScanlines; external legacy_lib;
procedure cvMorphEpilinesMulti; external legacy_lib;
procedure cvPostWarpImage; external legacy_lib;
procedure cvDeleteMoire; external legacy_lib;
function cvCreateConDensation; external legacy_lib;
procedure cvReleaseConDensation; external legacy_lib;
procedure cvConDensUpdateByTime; external legacy_lib;
procedure cvConDensInitSampleSet; external legacy_lib;
procedure cvClearSubdivVoronoi2D; external legacy_lib;
function cvFindNearestPoint2D; external legacy_lib;
procedure icvDrawMosaic; external legacy_lib;
function icvSubdiv2DCheck; external legacy_lib;
function cvCreateKDTree; external legacy_lib;
function cvCreateSpillTree; external legacy_lib;
procedure cvReleaseFeatureTree; external legacy_lib;
procedure cvFindFeatures; external legacy_lib;
function cvFindFeaturesBoxed; external legacy_lib;
function cvCreateLSH; external legacy_lib;
function cvCreateMemoryLSH; external legacy_lib;
procedure cvReleaseLSH; external legacy_lib;
function LSHSize; external legacy_lib;
procedure cvLSHAdd; external legacy_lib;
procedure cvLSHRemove; external legacy_lib;
procedure cvLSHQuery; external legacy_lib;
procedure cvCalcOpticalFlowLK; external legacy_lib;
procedure cvCalcOpticalFlowBM; external legacy_lib;
procedure cvCalcOpticalFlowHS; external legacy_lib;
procedure cvRefineForegroundMaskBySegm; external legacy_lib;
function cvChangeDetection; external legacy_lib;

end.
