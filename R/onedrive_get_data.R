#'
#' List Trocaire data files from One Drive
#' 
#' @param od A `ms_drive` class object created via a call to
#'   [Microsoft365R::get_business_onedrive()] to login to the shared Microsoft
#'   One Drive service.
#' @param path Character value for name of directory to access from the shared
#'   Microsoft One Drive.
#' 
#' @returns A [data.frame()] of files contained within `path` in the shared
#'   Microsoft One Drive.
#'

onedrive_list_trocaire_files <- function(od,
                                         path = "trocaire_somalia_cmam") {
  data_files <- od$list_files(path)

  data_files
}


#'
#' Download data from One Drive
#' 

onedrive_download_data <- function(od,
                                   file_name, dest_dir, 
                                   overwrite = FALSE) {
  file_path <- file.path(dest_dir, basename(file_name))

  if (file.exists(file_path)) {
    if (overwrite) {
      od$download_file(src = file_name, dest = file_path, overwrite = overwrite)
    } else {
      file_path
    }
  } else {
    od$download_file(src = file_name, dest = file_path, overwrite = overwrite)
  }
  
  file_path
}
