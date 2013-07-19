dependency<- function(fvector)
{
  depends<-NULL
  depends<-c(fvector[grep("Imports:",fvector)])# To maintain R processing order
  depends<-c(depends,fvector[grep("Depends:|Requires:",fvector)])
  if(length(depends)>=1)
  {
    temp<-gsub("Depends:|\\s|Imports:|Requires:","",depends)
    temp<- paste(temp[1:length(temp)],collapse=",")   #merging vectors
    if(length(temp >=1) && temp[1] !="")
    {fd<-unlist(strsplit(temp,","))
     fd<-fd[fd!=""]
    }
  }
}
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
priority<- function(fvector)
{
  depends<-fvector[grep("Priority:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Priority:|\\s","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
package<- function(fvector)
{
  depends<-fvector[grep("Package:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Package:|\\s","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-(temp)
    }
  }
}
date<- function(fvector)
{
  depends<-fvector[grep("Date:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Date:","",depends)
    temp<- paste(temp[1:length(temp)],collapse=",") 
   
    {fd<-(temp)
    }
  }
}
title<- function(fvector)
{
  depends<-fvector[grep("Title:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Title:","",depends)
   
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
author<- function(fvector)
{
  depends<-fvector[grep("Author:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Author:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
maintainer<- function(fvector)
{
  depends<-fvector[grep("Maintainer:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Maintainer:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
description<- function(fvector)
{
  depends<-fvector[grep("Description:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Description:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
license<- function(fvector)
{
  depends<-fvector[grep("License:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("License:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
url<- function(fvector)
{
  depends<-fvector[grep("URL:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("URL:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
packaged<- function(fvector)
{
  depends<-fvector[grep("Packaged:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Packaged:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
authorsatr<- function(fvector)
{
  depends<-fvector[grep("Authors@R:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Authors@R:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
encoding<- function(fvector)
{
  depends<-fvector[grep("Encoding:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Encoding:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
copyright<- function(fvector)
{
  depends<-fvector[grep("Copyright:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Copyright:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
sysreq<- function(fvector)
{
  depends<-fvector[grep("SystemRequirements:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("SystemRequirements:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
suggests<- function(fvector)
{
  depends<-fvector[grep("Suggests:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Suggests:|\\s","",depends)
    temp<- paste(temp[1:length(temp)],collapse=",") 
    if(length(temp >=1) && temp[1] !="")
    {fd<-(unlist(strsplit(temp,",")))
     fd<-fd[fd!=""]
    }
  }
}
enhances<- function(fvector)
{
  depends<-fvector[grep("Enhances:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Enhances:|\\s","",depends)
    temp<- paste(temp[1:length(temp)],collapse=",") 
    if(length(temp >=1) && temp[1] !="")
    {fd<-(unlist(strsplit(temp,",")))
     fd<-fd[fd!=""]
    }
  }
}
collate<- function(fvector)
{
  depends<-fvector[grep("Collate:",fvector)]
  if(length(depends)>=1)
  {
    
    temp<-strsplit(gsub("Collate:|'","",depends),"\\s+")[[1]]
           fd<-temp[temp!=""]
}
}
collate.windows<- function(fvector)
{
  depends<-fvector[grep("Collate\\.windows:",fvector)]
  if(length(depends)>=1)
  {
    
    temp<-strsplit(gsub("Collate\\.windows:|'","",depends),"\\s+")[[1]]
    fd<-temp[temp!=""]
  }
}
collate.unix<- function(fvector)
{
  depends<-fvector[grep("Collate\\.unix:",fvector)]
  if(length(depends)>=1)
  {
    
    temp<-strsplit(gsub("Collate\\.unix:|'","",depends),"\\s+")[[1]]
    fd<-temp[temp!=""]
  }
}
revision<- function(fvector)
{
  depends<-fvector[grep("Revision:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Revision:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
bugreports<- function(fvector)
{
  depends<-fvector[grep("BugReports:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("BugReports:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
biocviews<- function(fvector)
{
  depends<-fvector[grep("biocViews:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("biocViews:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
bundledes<- function(fvector)
{
  depends<-fvector[grep("BundleDescription:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("BundleDescription:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
keepsrc<- function(fvector)
{
  depends<-fvector[grep("KeepSource:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("KeepSource:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
lazydata<- function(fvector)
{
  depends<-fvector[grep("LazyData:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("LazyData:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
lazyload<- function(fvector)
{
  depends<-fvector[grep("LazyLoad:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("LazyLoad:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
bytecompile<- function(fvector)
{
  depends<-fvector[grep("ByteCompile:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("ByteCompile:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
zipdata<- function(fvector)
{
  depends<-fvector[grep("ZipData:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("ZipData:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
biarch<- function(fvector)
{
  depends<-fvector[grep("Biarch:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Biarch:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
buildvig<- function(fvector)
{
  depends<-fvector[grep("BuildVignettes:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("BuildVignettes:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
vigbuilder<- function(fvector)
{
  depends<-fvector[grep("VignetteBuilder:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("VignetteBuilder:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
needcompile<- function(fvector)
{
  depends<-fvector[grep("NeedsCompilation:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("NeedsCompilation:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
os<- function(fvector)
{
  depends<-fvector[grep("OS_type:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("OS_type:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
acm<- function(fvector)
{
  depends<-fvector[grep("Classification\\/ACM:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Classification\\/ACM:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
jel<- function(fvector)
{
  depends<-fvector[grep("Classification\\/JEL:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Classification\\/JEL:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
msc<- function(fvector)
{
  depends<-fvector[grep("Classification\\/MSC:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Classification\\/MSC:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
lng<- function(fvector)
{
  depends<-fvector[grep("Language:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Language:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
built<- function(fvector)
{
  depends<-fvector[grep("Built:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Built:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
note<- function(fvector)
{
  depends<-fvector[grep("Note:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Note:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
contact<- function(fvector)
{
  depends<-fvector[grep("Contact:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Contact:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
mailinglst<- function(fvector)
{
  depends<-fvector[grep("MailingList:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("MailingList:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
repo<- function(fvector)
{
  depends<-fvector[grep("Repository:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Repository:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
datepub<- function(fvector)
{
  depends<-fvector[grep("Date\\/Publication:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Date\\/Publication:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
arch<- function(fvector)
{
  depends<-fvector[grep("Architecture:|Arch:|Archs:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Architecture:","",depends)
    temp<-gsub("Archs:","",temp)
    temp<-gsub("Arch:","",temp)
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
contains<- function(fvector)
{
  depends<-fvector[grep("Contains:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Contains:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
typepkg<- function(fvector)
{
  depends<-fvector[grep("Type:",fvector)]
  if(length(depends)>=1)
  {
    temp<-gsub("Type:","",depends)
    
    if(length(temp >=1) && temp[1] !="")
    {fd<-temp
    }
  }
}
# separates R dependency from the dependency list of packages
deplist <-function(dpkg)
{
  if(length(dpkg)>0)
  {  
    temp<-grep("^R",dpkg)
    dvector <-setdiff(dpkg,dpkg[temp])
    if(length(temp)>=1)
    {
      for(i in temp)
      {
      temp2<-(grep("^R$",(unlist(strsplit(dpkg[i],"[({[]")))))
      if(length(temp2)==0)
      {
        dvector<-c(dvector,dpkg[i])
        
      }
    }
      }
return(dvector)}
}
# To read namespace files
nmsres<-function(namespace){
  if(length(namespace)>0)
  {temp<-readLines(namespace)
  temp<-temp[temp!=""]
}}
# To import dependent package from the import field of namepspace file
nmsimport<-function(vector){
  t<-gsub("import\\(|\\)|\\s","",vector[grep("import\\(",vector)])
  fd<-NULL
  if(length(t)>0)
  {for(p in t)
  {
    fd<-c(fd,unlist(strsplit(p,",")))
  }
  }
return(fd)}
#To analyse the import from field of the package
nmsimpfrm<-function(vector)
{
  ff<-NULL
  fname<-NULL
  temp<-vector[grep("importFrom\\(",vector)]
  for(t in temp)
  {tx<-gsub("importFrom\\(|\\)|\\s","",t)
  mother<-unlist(strsplit(tx,","))
    if(length(mother)>1)
    {
    fname[(length(fname)+1):(length(fname)+length(mother)-1)]<-mother[1]
    ff<-c(ff,mother[mother!=mother[1]])         #as we can't give both vector and its name in oneshot
    }
  }
  return(list(ff,fname))
}