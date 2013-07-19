start<-function()
{
  library(RODBC)
  srcloc()
  consume()
}
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
consume<- function()
{
  path<- readLines(".//data//srcdir.txt")
  winlst<- list.files(path, pattern="Windows" , recursive =T)
  macxlst<- list.files(path, pattern="Macx" , recursive =T)
  rversion<-NULL
  os<-NULL
  dpath<-NULL
 for(t in winlst)
 {
   counter<-1
   tempos<-c("Windows")
   temprversion<-gsub("Windows|PACKAGES|\\+|\\.htm|\\.html","",t)
   temp<-readLines((file.path(path,t)))
   if(length(temp)>0)
   {
    
   for(i in (1:length(temp)))
   {
     if(temp[i]=="")
     {
       if(i!=1)
       {
         os<-c(os,tempos)
         rversion<-c(rversion,temprversion)
         dpath<-c(dpath,paste(temp[counter:(i-1)],collapse="+++"))
         counter<-(i+1)
       }
     }
   }
 }}
  for(t in macxlst)
  {
    counter<-1
    tempos<-c("MacOsx")
    temprversion<-gsub("Macx|PACKAGES|\\+|\\.htm|\\.html","",t)
    temp<-readLines((file.path(path,t)))
    if(length(temp)>0)
    {
      
      for(i in (1:length(temp)))
      {
        if(temp[i]=="")      # separating each package description by blank lines.
        {
          if(i!=1)
          {
            os<-c(os,tempos)
            rversion<-c(rversion,temprversion)
            dpath<-c(dpath,paste(temp[counter:(i-1)],collapse="+++"))
            counter<-(i+1)
          }
        }
      }
    }}
  despath<-NULL
  if(length(dpath)>0)
  {  for(t in 1:length(dpath))
  {                                               # convert in the form for which processing is easy  
    despath<-unlist(strsplit(dpath[t],split="\\+\\+\\+"))
    desexplore(despath,rversion[t],os[t])  # passing description of a package to its explorer
  }}
}
# our function that is supposed to explore description given
desexplore <-function(despath,rversion,os)
{
  fvector<-finalvector(despath)
  dframe(fvector,rversion,os)
}
# final vector consisiting of all the information about a particular package
finalvector<-function(dpath)
{
  
  fvector<-NULL #for separating each specific fields of the description file and storing it in a separate index
  temp <- (grep("Package:|Priority:|Version:|Date:|Title:|Author:|Maintainer:|Depends:|Description:|License:|URL:|Packaged:|Authors@R:|Encoding:|Copyright:|SystemRequirements:|Imports:|Suggests:|Enhances:|Revision:|BugReports:|biocViews:|BundleDescription:|Collate\\.unix:|Collate\\.windows:|Collate:|KeepSource:|LazyData:|LazyLoad:|ByteCompile:|ZipData:|Biarch:|BuildVignettes:|VignetteBuilder:|NeedsCompilation:|OS_type:|Classification\\/ACM:|Classification\\/JEL:|Classification\\/MSC:|Language:|Built:|Note:|Contact:|MailingList:|Repository:|Date\\/Publication:|Architecture:|Archs:|Requires:|Contains:|Type:",dpath))  
  if(length(temp)>=1)
  {
    if(length(temp>1))
    {      for(i in 1:(length(temp)-1))
    {
      fvector<-c(fvector,(paste(dpath[temp[i]:((temp[i+1])-1)],collapse="")))   #for collating description        
    }
    }
    #for collating last line of the description
    fvector<-c(fvector,(paste(dpath[temp[length(temp)]:length(dpath)],collapse="")))}
}
#To extract the package information
package<- function(fvector)
{
  depends<-fvector[grep("Package:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Package:|\\s","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-(temp)
    }
  }}
# To extract the version information
version<- function(fvector)
{
  depends<-fvector[grep("Version:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Version:|\\s","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
