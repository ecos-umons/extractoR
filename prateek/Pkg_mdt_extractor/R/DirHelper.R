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
  exception<-grep("locfit_1.00.tar|vines_1.|VLMC_1.3|zipfR_ |zipcode_1.0|TSEN_1.0|spectralGP_|lme_3.1|oblique.tree_|pcalg_1.1-6|odprism_1.1|localdepth_|hyperSpec_0.98-20120923|HH_2.3-37|HGLMMM_0.1.2|fit4NM_3.3.3|FitAR_1.94|dr_3.0.7|cobs_1.2-2|cec2005benchmark_1.0.3|cem_1.1.5|VLMC_|RDF_1.1|XML_3.95|tsDyn_|sp_|tree_|spectralGP_|rjags_1.0.3-6|sn_|samr_|sampling_|Rmpi_|RImageJ_|lme4_0.999375|R2HTML_2|R.oo_|R2HTML_1.5|pls_|plotAndPlayGTK_|pcalg_1.1-2|pcalg_1.1-4|pcalg_1.1-5|pbatR_1.0|pbdDMAT_0.2-0|oblique.tree_1.0|mi_|np_|lme4_0.999999|ibr_||kml_1.|kml_2.|kml3d_|flip_1.0|hyperSpec_0.98|HGLMMM_|ars_|bmd_|energy_1.4-0|EuclideanMaps_1.0|cobs_1.2-1|CoCoGraph_0.1.7.6|CoCoCg_0.1.7.6|CoCo_|cobs_1.2-0|cobs_1.1-5|cobs_1.1-6|BiplotGUI_0.0-4.1|bit_|BiplotGUI_0.0-6|BiplotGUI_0.0-5|BiDimRegression_1.0-3|bigmemory_4.2.1|bigmemory_4.4.0|bigmemory_4.3.0|bigmemory_4.2.3|bicreduc_0.4-7|ber_1.0|bibtex_|bethel_0.1|Bchron_1.2|AtelieR_0.22|Barnard_|bayesm_0.0-1|BADER_|BACprior_1.2|awsMethods_1.0-0|arrayMissPattern_1.3|AID_|aroma|arrayImpute_1.3|AdequacyModel_1.0|ape_|agilp_|adehabitat_|tripack|abind|ade4_|allelic_0.1|anaglyph_0.1-1|ALDqr_0.0|clines|RSvgDevice|alabama_2011.9-1|AdequacyModel_1.0.1|AID_1.2|boot|cluster|rcom|sp_0.9-1|lambda.r_1.1.1-3|Ace_",arlst)
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
