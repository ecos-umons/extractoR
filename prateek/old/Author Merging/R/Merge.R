merge<-function(pid,author,lemail)
{
  emailindex<-NULL
  if(length(lemail)>0)
  {
    for(i in 1:length(lemail))
    {
      temp<-lemail[[i]][1]
      emailindex<-c(emailindex,temp)
    }
  }
  email<-NULL
 # print(pid)
  test<-(match(pid,emailindex,nomatch=-1))
  if(test!=-1) # for the case where both names and email address are found. Merging between author names and email id has to be done
  {
    email<-lemail[[test]]
    email<-email[email!=email[1]]
   # print(author)
    nematch(pid,author,email)
  }
 else # case in which only names are there.  No email id so it will be assigned NULL in the database
  {
   # print(pid)
  #  print(author)
    mail<-c("NULL")
    role<-c("author")
    for(n in author)
    {
      dbwrite(pid,n,mail,role)
  }
    
  }
  
}
nematch<-function(pid,author,email)
{
# print(email) 
  author<-tolower(author)
  templst<-NULL
  #print(author)
 #print(email)
  t1author<-author
  for(aut in t1author)
  {
    #print("here")
    posid<-NULL
    nameparts<-(unlist(strsplit(aut," ")))
    # genrating possible email ids with full names
    posid<-gpe(nameparts)
    #print(nameparts)
   # print(posid)
    #p.rastogi and r.prateek type id
   for(name in nameparts)
   {
     timepass<-nameparts[nameparts!=name]
    timepass<-c(timepass,unlist(strsplit(name,""))[1])
     temp<-gpe(timepass)
     posid<-c(posid,temp)
   }
    #print(posid)
    #print(aut)
   templst<-nmperfect(email,posid,aut,t1author,pid) # in case of perfect matching
   # print(email)
    if(length(setdiff(email,setdiff(email,(templst[[1]]))))>0)
    {
      email<-setdiff(email,setdiff(email,(templst[[1]])))
    }
   # print(author)
    if(length(setdiff(author,setdiff(author,(templst[[2]]))))>0)
    {
      author<-setdiff(author,setdiff(author,(templst[[2]])))
    }
    #print(author)
  }
# print("maadar chod")
 # print(author)
# print("bkl") 
  tauthor<-author
  #print(tauthor)
  #print(email)
  for(aut in tauthor)
{
    templst2<-NULL
    # no email ids left to match
    if(length(email)==0)
    {
        mail<-c("NULL")
        role<-c("NULL")
        dbwrite(pid,aut,mail,role)
        #print("here")
    }
    else
    {
     # print("here")
      #print(tauthor)
      templst2<-nmapprox(email,aut,tauthor,pid)
      #print(templst2)
    }
   # print(setdiff(email,(templst2[[1]])))
    if(length(templst2[[1]])>0)
    {
      #print(email)
      email<-setdiff(email,(templst2[[1]]))
     # print("fuck off")
     # print(email)
    }
    # print(author)
    if(length(templst2[[2]])>0)
    {
     # print(author)
      author<-setdiff(author,templst2[[2]])
      #print("fuck off")
      #print(author)
    }
  #print(email)
    #print(author)
   # print("loop")
}
  #print("behen chod")
 # print(email)
#print(author)
  # assign all the remaining authors and mail as separate identity
    if(length(author)>0)
    {
      for(t in author)
      {
        dmail<-c("NULL")
        role<-c("author")
        dauth<-t
       # print("here")
       # print(pid)
        dbwrite(pid,dauth,dmail,role)
      }
    }
  if(length(email)>0)
  {
    for(t in email)
    {
      dauth<-c("NULL")
      role<-c("author")
      dmail<-t
     # print("yaha maa chuda raha hu")
     # print(pid)
      dbwrite(pid,dauth,dmail,role)
    }
  }

}
# generate possible email ids
gpe<-function(author)
{
  list<-permn(author)
  posid<-NULL
  if(length(list)>0)
  {
    for(t in (1:length(list)))
      {
      posid<-c(posid,paste(list[[t]],collapse="."))
      posid<-c(posid,paste(list[[t]],collapse=" "))
      posid<-c(posid,paste(list[[t]],collapse="+"))
      posid<-c(posid,paste(list[[t]],collapse="-"))
      posid<-c(posid,paste(list[[t]],collapse="_"))
    }
  }
  return(posid)
}
nmperfect<-function(email,posid,aut,author,pid)
{
 # print(posid)
 # print(email)
  #print(aut)
  #print("in nmperfect")
 normail<-NULL  # all email ids of the author field in normal form
# print(email)
  for(t in email)
  {
    #print("fuck here")
   # print(t)
  normail<-c(normail,unlist(strsplit(t,"@"))[1])
  }
#print(normail)
 #print(posid)
 
 if(length(normail)>0)
  {#print(posid)
   #print(normail[i])
   for(i in (1:length(normail)))
  {
    #print(normail[i])
    #print(email[i])
 # print(tposid)
   # tposid<-NULL
    #print(posid)
       test<-(setdiff(normail[i],setdiff(normail[i],posid)))
   # print(posid)
       
 # print(normail[i])
    
    if(length(test)>0)
    {
     #print(normail[i])
      role<-c("author")
     dbwrite(pid,aut,email[i],role)
      #print(email[i])
      #print(email)
      email<-email[email!=email[i]]
      #print(author)
      author<-author[author!=aut]
      #print(author)
      #print(email)
      return(list(email,author))
      break
    }
  }
}
}
nmapprox<-function(email,aut,author,pid)
{
 # print("in nmapprox")
  temail<-email
  #print(temail)
  for(t in temail)
  {
    #print(t)
    role<-c("author")
    temp<-unlist(strsplit(t,"@"))[1]
   temp2<-unlist(strsplit(temp,"<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.| "))
    temp2<-gsub("<|!|>|[|]|$|%|&|(|\\^|\\+|\\-|)|,|\\.| ","",temp2)
    lst<-permn(temp2)
    #print(temp2)
    if(length(lst)>0)
    {
      #print(lst)
      for(p in lst)
      {
        #print(p)
       comparator<-(paste(p,collapse=" "))
      # print(comparator)
       sim<-levenshteinSim(aut,comparator)
     #print(sim)
      # print(t)
      # print(email)
    # print(aut)
       if(sim>0.7)   ####### threshold if crossed
       {
         remail<-email
         rauthor<-aut
         dbwrite(pid,aut,t,role)
         
         #print(aut)
        # print(t)
         #print(remail)
        # print(rauthor)
         return(list(remail,rauthor))
         break
       }
      }
    }
  }
}