# To obtain the path of the source directory.
srcloc<-function(){
  if(length(scan(".//data//srcdir.txt",what=""))==0){
    path <- readline("Please enter the R source directory filepath: ")
    fileConn<-file(".//data//srcdir.txt")
    writeLines(path, fileConn)
    close(fileConn)
  }
  else {
    x<-readline("Do you want to use the stored path?(y/n) ")
    if(x=='y')
    {path<-readLines(".//data//srcdir.txt")}
    else{
      path <- readline("Please enter the R source directory filepath: ")
      fileConn<-file(".//data//srcdir.txt")
      writeLines(path, fileConn)
      close(fileConn) 
    }
  }
  repeat
  {
    path<- toString.default(readLines(".//data//srcdir.txt"))
    temp <-file.info(path)$isdir
    temp <- temp[!is.na(temp)]
    if((length(temp)==0) || (temp ==F)){
      path <-readline("You have entered the wrong directory path. Please enter the correct path: ")
    fileConn<-file(".//data//srcdir.txt")
    writeLines(path, fileConn)
    close(fileConn)}
  else{break   
  }
    }
}
# sorts out tar, tgz, zip files from the directory
tarloc <- function(){
  path<- readLines(".//data//srcdir.txt")
   arlst<- dir(path, pattern="zip|tar|tgz" , recursive =T)
  nlst<-grep("base\\/",arlst)
  tlst<-grep("base-prerelease",arlst)
  exception<-grep("locfit_1.00.tar|lme_3.1-0.tar|tripack",arlst)
  templst<-arlst[nlst]
  temp2lst <-arlst[tlst]
  temp3lst<-arlst[exception]
   arlst<-setdiff(arlst,templst)
  arlst <-setdiff(arlst,temp2lst)
  arlst<-setdiff(arlst,temp3lst)
  ofileconn<-file(".//data//pkgpaths.txt")        #preserving the path of the package
  writeLines(arlst,ofileconn)            
  close(ofileconn)
  wlst<-readLines(".//data//wpkg.txt")
  wlst<-wlst[wlst!=""]
  wlen<-length(wlst)
  if(wlen==0)
    {pendwrk(arlst) 
     
     }
  else 
    {pkganalysis()}  #crash recovery 

}
# finds new updates in the source library
pendwrk <- function(lst){
  ofileconn<-file(".//data//opkg.txt")
  olst <-readLines(ofileconn)
  close(ofileconn)
  olst<-olst[olst!=""]
  wlst<-setdiff(lst,olst)
  if(length(wlst)==0)
  {
    print("All items are scanned no more source remains.")
  }
  #if some new remains to be processed. 
  else{ wfileconn <- file(".//data//wpkg.txt")
        writeLines(wlst,wfileconn)
        close(wfileconn)
        pkganalysis()
  }
 
}
