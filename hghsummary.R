library(bibliometrix)
library(fs)
library(openxlsx)
library(ggplot2)
# base_dir="C:\\Users\\xuzhe\\Desktop\\SciMAT\\WOS 20240125"
# files=dir_ls(base_dir,regexp="download_.*")
# #file=c(paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"))
# biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")
source("biblio_data.R")
result=biblioAnalysis(biblio_df)

write_xlsx(result$MostCitedPapers,"D:\\hqh_sci_cailiao\\20240219_new\\MostCitedPapers.xlsx")
write_xlsx(result$Sources,"D:\\hqh_sci_cailiao\\20240219_new\\Sources.xlsx")
write_xlsx(as.data.frame(result$Affiliations),"D:\\hqh_sci_cailiao\\20240219_new\\Affiliations.xlsx")
write_xlsx(as.data.frame(result$Aff_frac),"D:\\hqh_sci_cailiao\\20240219_new\\Aff_frac.xlsx")
SUMMRAY_RESULTS=summary(result,k=11)

SUMMRAY_RESULTS$MainInformationDF

biblio_df_per_year_count=biblio_df%>%group_by(PY)%>%count()
#每年发文柱状图
ggplot(biblio_df_per_year_count,aes(x=PY, y=n))+geom_bar(stat = "identity")




biblio_df_per_year_count_1991_2020=biblio_df_per_year_count%>%filter(PY>=1991,PY<2020)

write.xlsx(biblio_df_per_year_count, file = "D:\\hqh_sci_cailiao\\20240219_new\\per_year_count.xlsx")
#拟合测试
y=biblio_df_per_year_count_1991_2020%>%pull(n)
x=biblio_df_per_year_count_1991_2020%>%pull(PY)
y=as.numeric(y)
model <- nls(y~a*exp(b*(x-1990)),start = list(a = 91.93241, b = 0.0562946))




# pred_nls_2 = function(m){
#   r=data.frame(x=m)
#   result=predictNLS(model,r,nsim = 10000, interval="conf",second.order=F) #通过second.order参数关闭二阶泰勒展开
#   return(result$summary)
# }
#y_prednls_2<-pred_nls_2(x_pred) 
ggplot(biblio_df_per_year_count,aes(x=PY, y=n))+
  geom_point(color="red")+
  geom_smooth(data=biblio_df_per_year_count_1991_2020, mapping=aes(x=PY, y=n),method="nls", se=F, formula=y~a*exp(b*(x-1990)),
              method.args=list(start=c(a=91.93245103, b=0.05629463 )))
ggsave("D:\\hqh_sci_cailiao\\fit_curve.pdf",width = 10,height = 10)
summary(model)
cor(y, predict(model))
trace(geom_smooth, edit = T) # 修改后保存

TC=biblio_df%>%group_by(AU_UN)%>%summarise(sum_value = sum(TC))%>%arrange(desc(sum_value))

result=biblioAnalysis(biblio_df,sep=";")
biblio_df=biblio_df%>%mutate(MYTC=result$TotalCitation)

biblio_df
result$TotalCitation
#result$M
summary(result,k=10,pause=FALSE)
result$Affiliations


tbl_country=result$Countries

df_country <- as.data.frame(tbl_country)

write.xlsx(df_country, file = "D:\\hqh_sci_cailiao\\country.xlsx")



