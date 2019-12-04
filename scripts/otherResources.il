/* abIPar.il

Author     A.D.Beckett
Group      Custom IC (UK), Cadence Design Systems Ltd.
Language   SKILL
Date       Aug 28, 2003
Modified
By

Function that can be used in an opParamExprList()
CDF setup to get an instance's parameter value.

Note, this is not the _simulated_ value necessarily...

***************************************************

SCCS Info: @(#) abIPar.il 07/01/08.21:14:26 1.3

*/

(procedure (abIPar paramName @optional (inst ilInst) (slot 'value))
  (let (env lineage session cdf unevaluated evaluated compiled top)
       (setq top (geGetTopLevelCellView))
       (getWarn)
       (unless top (error "Can't find parameter %s" paramName))
       ;-----------------------------------------------------------------
       ; Get the original parameter value
       ;-----------------------------------------------------------------
       (setq cdf (cdfGetInstCDF inst))
       (setq unevaluated (get (get cdf (concat paramName)) slot))
       ;-----------------------------------------------------------------
       ; If it is a string, evaluate it as an AEL expression
       ;-----------------------------------------------------------------
       (if (stringp unevaluated)
           (progn
            (setq env (aelEnvCreate "f"))
            ;-----------------------------------------------------------
            ; set the path down to this element
            ;-----------------------------------------------------------
            (setq lineage (append1 (reverse
                                    (mapcar 'car (geGetHierMemInst)))
                                   top))
            (setq lineage (cons inst lineage))
            (aelSetLineage env lineage)
            ;-----------------------------------------------------------------
            ; Get the current session
            ;-----------------------------------------------------------------
            (setq session (asiGetSession (hiGetCurrentWindow)))
            ;-----------------------------------------------------------------
            ; define all the global variables
            ;-----------------------------------------------------------------
            (foreach designVar
                     (or (and session (asiGetDesignVarList session))
                         (artGetCellViewDesignVarList top))
                     (aelEnvSetGlobals env (car designVar) (cadr designVar))
                     )
            ;-----------------------------------------------------------------
            ; Evaluate the expression
            ;-----------------------------------------------------------------
            (if (or (null unevaluated)
                    (equal unevaluated ""))
                (setq evaluated 0.0)
                (progn
                 (setq compiled (aelEnvCompile env unevaluated))
                 (if compiled
                     (setq evaluated (aelNumber (aelEnvExecute compiled)))
                     (progn
                      (printf "*ERROR* %s " (aelEnvGetErrStr))
                      (setq evaluated nil)))
                 ))
            evaluated
            )
           ;-------------------------------------------------------------
           ; Otherwise, if not a string, return it as it is
           ;-------------------------------------------------------------
           unevaluated
           )
       )
  )
