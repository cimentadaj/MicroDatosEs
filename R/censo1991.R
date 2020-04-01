#' Download data from 1991 Spanish Census from INE
#' 
#' This function reads the data from 1991 Spanish Census using the information
#' provided by the Spanish Statistical Office (INE).
#' 
#' @param file Character string with the name of the microdata files provided by
#' the INE on the \href{https://www.ine.es/censos2011_datos/cen11_datos_microdatos.htm#}{Census}
#' section. For the complete data, the path to the \code{txt} file is enough.
#'
#' Alternatively, for \code{censo1991_provincias}, \code{file} needs to be
#' a vector with the path to the 52 province files.
#'
#' For both cases, it allows either a path to the files, or literal data
#' (single string or raw vector). It also allows compressed files in
#' \code{.gz}, \code{.bz2}, \code{.xz}, or \code{.zip} format.
#' 
#' @return \code{\link[tibble]{tibble}} with all avaliable requested data where
#' each row corresponds to an anonymised citizen.
#' 
#' @details This function reads microdata from the 1991 census in Spain. It was
#' originally built using the metadata for 2010 file but it may be used for
#' earlier/later years.
#' 
#' Note that the loaded object will be of considerable size and may require a
#' computer from 8 GB of RAM. In order to avoid this kind of computational
#' issues, you can also download the splitted version provided by the INE.
#' 
#' @author Jorge cimentada adapting the code from Carlos Neira and Carlos J. Gil Bellosta
#' @note The \code{file} parameter allows any flat file with fixed width.
#' @references http://www.ine.es/prodyser/microdatos.htm
#' @export
#' @examples
#'
#' # First download ftp://www.ine.es/temas/censopv/cen91_p/cen91_per_2.zip
#' # Suppose that the file path to the zip file in your local computer is
#' # contained in x. Then:
#' 
#' \dontrun{
#' raw <- censo1991(x)
#' summary(raw)
#' }
#'
#'
#' # Downloading the province data is also possible
#'
#' \dontrun{
#' prov_paths <-
#'   paste0("ftp://www.ine.es/temas/censopv/cen91_p/p",
#'          formatC(1:52, width = "2", flag = "0"),
#'          "mper_cen91.zip")
#'
#' for (i in prov_paths) {
#'   dir_save <- paste0("./", basename(i))
#'   download.file(i, dir_save)
#' }
#' 
#' all_paths <- list.files(".",
#'                         pattern = paste0(basename(prov_paths), collapse = "|"),
#'                         full.names = TRUE)
#' 
#' raw <- censo1991_provincias(all_paths)
#' summary(raw)
#' }
#' 
#' @seealso \code{\link[vroom]{vroom_fwf}} to read fixed width files.
censo1991 <- function(file) {
  read.fwf.microdata(file, 
                     system.file( "metadata", "censo_1991_mdat1.txt", package = "MicroDatosEs" ),
                     ## TODO: I still need to add the variable codings
                     ## I'm lazy since they provide it in word and it's
                     # difficult to parse.
                     system.file( "metadata", "censo_1991_mdat2.txt", package = "MicroDatosEs" ),
                     fileEncoding = "UTF-8")
}

#' @rdname censo1991
#' @export
censo1991_provincias <- function(file) {
  # In the 1991 census, the province metadata is the same as the complete file metadata.
  # However, since I already included censo2001_provincias (in which the metadata files are different),
  # for consistency, I also include it here. However, it's the same thing from censo1991.
  censo1991(file)
}
