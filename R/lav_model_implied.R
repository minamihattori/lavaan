# compute model implied statistics
lav_model_implied <- function(lavmodel = NULL) {

    stopifnot(inherits(lavmodel, "Model"))
    
    # model-implied variance/covariance matrix ('sigma hat')
    Sigma.hat <- computeSigmaHat(lavmodel = lavmodel)

    # model-implied mean structure ('mu hat')
    Mu.hat <-    computeMuHat(lavmodel = lavmodel)

    # if conditional.x, slopes
    if(lavmodel@conditional.x) {
        SLOPES <- computePI(lavmodel = lavmodel)
    } else {
        SLOPES <- vector("list", length = lavmodel@ngroups)
    }

    # if categorical, model-implied thresholds
    if(lavmodel@categorical) {
        TH <- computeTH(lavmodel = lavmodel)
    } else {
        TH <- vector("list", length = lavmodel@ngroups)
    }
 
    if(lavmodel@group.w.free) {
        w.idx <- which(names(lavmodel@GLIST) == "gw")
        GW <- unname(lavmodel@GLIST[ w.idx ])
        GW <- lapply(GW, as.numeric)
    } else {
        GW <- vector("list", length = lavmodel@ngroups)
    }

    # FIXME: should we use 'res.cov', 'res.int', 'res.th' if conditionl.x??
    # Yes, since 0.5-22
    if(lavmodel@conditional.x) {
        implied <- list(res.cov = Sigma.hat, res.int = Mu.hat, res.slopes = SLOPES, res.th = TH, group.w = GW)
    } else {
        implied <- list(cov = Sigma.hat, mean = Mu.hat, slopes = SLOPES, th = TH, group.w = GW)
    }

    implied
}
