###################################################################
# cjgb
# 20120305
# Reads a generic microdata file
# Changes:
#   20160806: changed workhorse to readr::read_fwf
#   20170427: some microdata files are read outside this function
#   20200324: changed workhorse to vroom::vroom_fwf for fastering reading
###################################################################
## IMPORTANT: Remember to set the file_path variable to the Microdatos files.
## Below is an example of where I put one in my local computer
## file_path <-
## file_path <- "/home/jorge/repositories/spain_census/data/MicrodatosCP_NV_per_nacional_3VAR.txt"
## file.mdat.1 <- system.file( "metadata", "censo_2010_mdat1.txt", package = "MicroDatosEs" )
## file.mdat.2 <- system.file( "metadata", "censo_2010_mdat2.txt", package = "MicroDatosEs" )
## fileEncoding <- "UTF-8"

read.fwf.microdata <- function(file_path, file.mdat.1, file.mdat.2, fileEncoding = "UTF-8") {
  
  ## read metadata
  foo <- function(x) read.table(x, header = T, sep = "\t", 
                                fileEncoding = fileEncoding,
                                stringsAsFactors = FALSE)
  mdat.1 <- foo(file.mdat.1)
  mdat.2 <- foo(file.mdat.2)

  ## read fixed file using mdat1 metadata file
  ## hides messages by vroom_fwf
  ## 20170427: some microdata files are read outside this function
  if (!is.data.frame(file_path)){
    width_options <- vroom::fwf_widths(mdat.1$width, col_names = mdat.1$var)

    suppressMessages(
      dat <- vroom::vroom_fwf(file_path, width_options)
    )
    
  } else {
    dat <- file_path
  }
  
  # Replaces keys in raw data by actual column values
  assign.labels <-  function(v, metadat) {
    
    # happens!
    if (all(is.na(v))) return(v)

    # For censo2001 which I haven't updated the codebook for each variable
    if (nrow(metadat) == 0) return(v)
    
    # special cases: numeric, etc.
    if (nrow(metadat) == 1 && metadat$tipo != "D") {
      if (!is.na(metadat$nulo) && any(v == metadat$nulo, na.rm = T))
        v[v == metadat$nulo] <- NA
      
      if (metadat$tipo == "N")
        return(as.numeric(v))
      
      if(metadat$tipo == "HHMM"){
        v <- as.numeric(v)
        return(v %/% 100 + ( v %% 100 ) / 60)
      }
      return(v)
    }

    # Check whether keys are numbers (usual case)
    # Mind the double negation!
    # Then, format codes (maybe like "07") into codes such like "7"
    v <- factor(v)
    if (!grepl("[^0-9]", paste(levels(v), collapse = ""))){
      levels(v) <- as.character(as.numeric(levels(v)))
    }
    
    # replace codes by descriptions (where available)
    # if no match, leave underlying code: it may correspond to municipality, etc.
    # indeed, in some cases (e.g., municipality) codes correspond to municipalities
    # and extra codes mark small size municipalities
    levels(v) <- sapply(levels(v), function(x) { 
      if (length(where <- which(metadat$llave == x)) > 0)
        metadat$valor[where]
      else x
    })
    
    as.character(v)
  }
  
  for(colname in colnames(dat))
    dat[[colname]] <- assign.labels(dat[[colname]], mdat.2[mdat.2$var == colname,])

  dat
}

## I was trying to check it using an lapply call instead of a for loop
## towards the end helped to improve timing. R crashed. You can see
## the benchmark attempts below. For now I exclude this.

## read.fwf.microdata_new <- function(file_path, file.mdat.1, file.mdat.2, fileEncoding = "UTF-8") {
  
##   ## read metadata
##   foo <- function(x) read.table(x, header = T, sep = "\t", 
##                                 fileEncoding = fileEncoding,
##                                 stringsAsFactors = FALSE)
##   mdat.1 <- foo(file.mdat.1)
##   mdat.2 <- foo(file.mdat.2)

##   ## read fixed file using mdat1 metadata file
##   ## hides messages by vroom_fwf
##   ## 20170427: some microdata files are read outside this function
##   if (!is.data.frame(file_path)){
##     width_options <- vroom::fwf_widths(mdat.1$width, col_names = mdat.1$var)

##     suppressMessages(
##       dat <- vroom::vroom_fwf(file_path, width_options)
##     )
    
##   } else {
##     dat <- file_path
##   }
  
##   # Replaces keys in raw data by actual column values
##   assign.labels <-  function(v, metadat) {
    
##     # happens!
##     if (all(is.na(v))) return(v)
    
##     # special cases: numeric, etc.
##     if (nrow(metadat) == 1 && metadat$tipo != "D") {
##       if (!is.na(metadat$nulo) && any(v == metadat$nulo, na.rm = T))
##         v[v == metadat$nulo] <- NA
      
##       if (metadat$tipo == "N")
##         return(as.numeric(v))
      
##       if(metadat$tipo == "HHMM"){
##         v <- as.numeric(v)
##         return(v %/% 100 + ( v %% 100 ) / 60)
##       }
##       return(v)
##     }

##     # Check whether keys are numbers (usual case)
##     # Mind the double negation!
##     # Then, format codes (maybe like "07") into codes such like "7"
##     v <- factor(v)
##     if (!grepl("[^0-9]", paste(levels(v), collapse = ""))){
##       levels(v) <- as.character(as.numeric(levels(v)))
##     }
    
##     # replace codes by descriptions (where available)
##     # if no match, leave underlying code: it may correspond to municipality, etc.
##     # indeed, in some cases (e.g., municipality) codes correspond to municipalities
##     # and extra codes mark small size municipalities
##     levels(v) <- sapply(levels(v), function(x) { 
##       if (length(where <- which(metadat$llave == x)) > 0)
##         metadat$valor[where]
##       else x
##     })
    
##     as.character(v)
##   }
  
##   dat[] <- lapply(colnames(dat),
##                   function(x) assign.labels(dat[[x]], mdat.2[mdat.2$var == x,]))
##   dat
## }


## file_path <- "/home/jorge/repositories/spain_census/data/MicrodatosCP_NV_per_nacional_3VAR.txt"
## file.mdat.1 <- system.file( "metadata", "censo_2010_mdat1.txt", package = "MicroDatosEs" )
## file.mdat.2 <- system.file( "metadata", "censo_2010_mdat2.txt", package = "MicroDatosEs" )
## fileEncoding <- "UTF-8"

## res <-
##   bench::mark(
##     old_way = read.fwf.microdata(file_path, file.mdat.1, file.mdat.2, fileEncoding),
##     new_way = read.fwf.microdata_new(file_path, file.mdat.1, file.mdat.2, fileEncoding),
##     max_iterations = 1)

## This was for testing manually the assign.labels function and try to optimize
## it

## colname <- "CPRO"
## v <- dat[[colname]]
## metadat <- mdat.2[mdat.2$var == colname,]
