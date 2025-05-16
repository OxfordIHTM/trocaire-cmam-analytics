#'
#' 
#' 

gdrive_list_trocaire_files <- function(path) {
  googledrive::drive_auth(path = Sys.getenv("GOOGLE_AUTH_FILE"))

  googledrive::drive_ls(path = path)
}


#'
#' Download data from Google Drive
#' 

gdrive_download_data <- function(file, 
                                 dest_dir, 
                                 overwrite = FALSE) {
  file_path <- file.path(dest_dir, basename(file))

  if (file.exists(file_path)) {
    if (overwrite) {
      drive_download(file = file, path = file_path, overwrite = overwrite)
    } else {
      file_path
    }
  } else {
    drive_download(file = file, path = file_path, overwrite = overwrite)
  }

  file_path
}