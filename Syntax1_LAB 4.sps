* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
RECODE sex ('female'=0) ('male'=1) INTO sex_dummy.
EXECUTE.

DESCRIPTIVES VARIABLES=pain age STAI_trait pain_cat cortisol_serum sex_dummy mindfulness
  /STATISTICS=MEAN SUM STDDEV MIN MAX.


MIXED pain WITH age sex_dummy STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age sex_dummy STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital_numeric) COVTYPE(VC)
  /SAVE=FIXPRED.

MIXED pain WITH age sex_dummy STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age sex_dummy STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital_numeric) COVTYPE(VC)
  /SAVE=FIXPRED.

DESCRIPTIVES VARIABLES=FXPRED_1
  /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.

                                        MODEL B dataset

DATASET ACTIVATE DataSet2.
RECODE sex ('female'=0) ('male'=1) INTO sex_dummy.
EXECUTE.

COMPUTE predicted_pain=2.562622 + (-0.022589  * age) + (0.200128  * sex_dummy) + (-0.046043  * 
    STAI_trait) + (0.081194  * pain_cat) + (0.626308 * cortisol_serum) + (-0.183630 * mindfulness).
EXECUTE.


COMPUTE Residuals=pain - predicted_pain.
EXECUTE.

COMPUTE Residuals_Squared=Residuals * Residuals.
EXECUTE.

DESCRIPTIVES VARIABLES=Residuals_Squared
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

DESCRIPTIVES VARIABLES=pain
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

COMPUTE residual_mean=pain - 4.85.
EXECUTE.

COMPUTE residual_mean_squared=residual_mean * residual_mean.
EXECUTE.

DESCRIPTIVES VARIABLES=residual_mean_squared
  /STATISTICS=MEAN SUM STDDEV MIN MAX.


