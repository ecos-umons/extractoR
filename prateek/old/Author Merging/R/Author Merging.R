start<-function()
{
  library(RODBC)
  library(combinat)
  library(RecordLinkage)
#parsemtr()
  parseauthor()
}
intdb<-function()
{
  channel<-odbcConnect('r',uid="root",pwd="root")
  sqlQuery(channel,"use finaldb;")
  return(channel)
}
closedb<-function()
{
  odbcCloseAll()
}
dbwrite<-function(pkgid,name,email,role)
{
  if(length(pkgid)==1)
  {
    if(length(name)==0)
  {
    name<-c("NULL")
  }
  if(length(email)==0)
  {
    email<-c("NULL")
  }
  if(length(role)==0)
  {
    role<-c("Unknown")
  }
    
  channel<-intdb()
  dbperson<-sqlFetch(channel,'persons',rownames=F,colnames=F)
    authid<-c(1)
    if(length(dbperson[,1])>0)
    {
      authid<-(max(dbperson[,1])+1)
    }
    data<-data.frame(authid,name,email,stringsAsFactors=F)
    names(data)<-c("aid","name","email")
    data2<-data.frame(pkgid,authid,role,stringsAsFactors=F)
    names(data2)<-c("pkgid","personid","rolecol")
    #print(data)
    #print(data2)
    if(email!="NULL")
    {
      p<-match(email,dbperson[,3],nomatch=-1)
      # if emailmatch
      if(p!=-1)
      {
        if(name!="NULL")
        {tp<-match(name,dbperson[,2][p],nomatch=-1)
         # if names match
         if(tp!=-1)
         {
           timepass<-sqlFetch(channel,'role',rownames=F,colnames=F)
           taid<-dbperson[,1][p] #aid of the matched email and name id
          temp<-match(taid,timepass[,2],nomatch=-1)
           #check if they are same packages
           if(temp!=-1)
           {
             pid<-timepass[,1][temp]
             #if they are different packages then only add to role table
             if(pid!=pkgid)
             {
               authid<-taid
               data2<-data.frame(pid,authid,role)
               names(data2)<-c("pkgid","personid","rolecol")
               try(sqlSave(channel,data2,tablename='role',append=T,rownames=F,colnames=F))
             }
           }
         }
         #if names don't match then add to persons and role table
         else
         {
           try(sqlSave(channel,data,tablename='persons',append=T,rownames=F,colnames=F))
           try(sqlSave(channel,data2,tablename='role',append=T,rownames=F,colnames=F))
         }
        }
        # if name is NULL then add to person and role table
        else
        {
          try(sqlSave(channel,data,tablename='persons',append=T,rownames=F,colnames=F))
          try(sqlSave(channel,data2,tablename='role',append=T,rownames=F,colnames=F))
        } 
        }
      # if email don't match then add to persons and role table
      else
      {
        try(sqlSave(channel,data,tablename='persons',append=T,rownames=F,colnames=F))
        try(sqlSave(channel,data2,tablename='role',append=T,rownames=F,colnames=F))
      } 
      
      }
    # if email is NULL then add to persons and role table
    else
    {
      try(sqlSave(channel,data,tablename='persons',append=T,rownames=F,colnames=F))
      try(sqlSave(channel,data2,tablename='role',append=T,rownames=F,colnames=F))
    }
    closedb()
    }    
}
readauthor<-function()
{
  channel<-intdb()
  author<-sqlFetch(channel,'package',colnames=F,rownames=F)[,7]
  pkgid<-sqlFetch(channel,'package',colnames=F,rownames=F)[,1]
  closedb()
  #print(pkgid)
  return(list(author,pkgid))
}
readmtr<-function()
{
  channel<-intdb()
  author<-sqlFetch(channel,'package',colnames=F,rownames=F)[,8]
  pkgid<-sqlFetch(channel,'package',colnames=F,rownames=F)[,1]
  closedb()
  return(list(author,pkgid))
}
parsemtr<-function()
{
  mtr<-readmtr()[[1]]
  pkgid<-readmtr()[[2]]
  if(length(mtr)>0)
  {
  for(i in 1:length(mtr))
  {
    if(length(mtr[i])>0)
    {
      temp<-unlist(strsplit(as.vector(mtr[i]),"<"))
      if(length(temp)==2)  #according to the guidelines of r maintainer field
      {
        email<-NULL
        name<-NULL
        t<-(grep("@",(gsub(">","",temp))))
        temp<-(gsub(">","",temp))
        if(length(t)<=1)
        {
          email<-temp[t]            #extracting email
          name<-temp[temp!=email]   #extracting name
          name<-sub(" ","",name)    #remove preponded and postponded spaces
          revname<-paste(rev(unlist(strsplit(name,""))),collapse="")
          revname<-sub(" ","",revname)
          name<-paste(rev(unlist(strsplit(revname,""))),collapse="")
          revemail<-paste(rev(unlist(strsplit(email,""))),collapse="")
          revemail<-sub(" ","",revemail)
          email<-paste(rev(unlist(strsplit(revemail,""))),collapse="")
          pid<-pkgid[i]
          role<-c("maintainer")
          dbwrite(pid,name,email,role)
        }
      }
    }
  }}
}
parseauthor<-function()
{
  author<-as.vector(readauthor()[[1]])
  pkgid<-as.vector(readauthor()[[2]])
 if(length(author)>0)
 {
   input<-NULL
   lemail<-NULL
   for(i in (1:length(author)))
{
     
     auth<-author[i]
     pid<-pkgid[i]
    # print(pid)
     tp<-paste(c("!"),pid,collapse=NULL)
     tp<-gsub("\\s","",tp)
     #print(tp)
     input<-c(input,tp,auth)  #for writing to the text file that has to be parsed by ner for name resolution
     role<-c("author")
     temp<-unlist(strsplit(auth,"<|>")) #creating list of pkgid with corresponding emails of author field
     t<-(temp[grep("@",temp)])
     if(length(t)>0)
     {
       lemail<-c(lemail,list(c(pid,t)))

     }
   }
   # for executing ner we have to change environment to that directory.Computer specific thing.
   setwd("C:\\ner")
   fileConn<-file(".//input.txt")
   writeLines(input, fileConn)
   close(fileConn)
   ner(lemail)
 }
}
ner<-function(lemail)
{ 
  if(length(readLines("input.txt")[readLines("input.txt")!=""])>0)
  {
  cmd<-c("ner input.txt")
  output<-system(cmd,intern=T,wait=T)
  temp<-NULL
  if(length(output)>9)
  {
    temp<-(output[9:(length(output)-1)]) # from analysing the output of ner only these
  }
  if(length(temp)>0)
  {
    for(n in temp)
    {
      timepass<-(unlist(strsplit(n,"\\/O")))
      pid<-timepass[1]  # as pid is always the first element
      auth<-timepass[grep("\\/PERSON",timepass)]
      auth<-gsub("\\/PERSON|<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.","",auth) # cleaning unncessary symbols
      auth<-sub(" ","",auth)    #remove preponded and postponded spaces
      author<-NULL
      for(n in auth)
      {revauthor<-paste(rev(unlist(strsplit(n,""))),collapse="")
      revauthor<-sub(" ","",revauthor)
      n<-paste(rev(unlist(strsplit(revauthor,""))),collapse="")
      author<-c(author,n)   # final author names of the particular package
    }
     # print(pid)
     # print(author)
     #print(lemail)
      merge(pid,author,lemail)
    # start from here
    }
  }
}}
