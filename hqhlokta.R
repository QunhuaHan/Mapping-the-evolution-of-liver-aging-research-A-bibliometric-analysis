#lokta
library(bibliometrix)
library(fs)
library(purrr)
library(writexl)
library(ggplot2)
library(dplyr)



base_dir="D:\\hqh_sci_cailiao\\NAFLD\\wos 20240215"
files=dir_ls(base_dir,regexp="download_.*")
biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")
sample_biblio<-function(df){
  # 假设你的数据框叫做 df
  set.seed(123)  # 设置随机种子以确保结果可复现
  n_samples <- nrow(df) * 0.8  # 计算抽取的样本数量
  df_sample <- df[sample(nrow(df), n_samples), ]  # 随机抽取80%的数据行
  return(df_sample)
}
sample_df=sample_biblio(biblio_df)
sample_results=biblioAnalysis(sample_df)

sample_L=lotka(results =sample_results)

#修改 26行 将M$AU修改为 M$AF
# if ("AU" %in% Tags) {
#   listAU = strsplit(as.character(M$AF), sep)
#   listAU = lapply(listAU, function(l) trim(l))
trace(biblioAnalysis, edit = T) # 修改后保存

results=biblioAnalysis(biblio_df)

L=lotka(results =results)
#R^2=0.942561
#beta=2.778674
#C=0.6011787
write_xlsx(L$AuthorProd,"D:\\hqh_sci_cailiao\\20240219_new\\lotka.xlsx")

Observed=L$AuthorProd[,3]

Theoretical=10^(log10(L$C)-2*log10(L$AuthorProd[,1]))
plot(L$AuthorProd[,1],Theoretical,type="l",col="red",ylim=c(0,1))
lines(L$AuthorProd[,1],Observed,col="blue")

df_plot <- data.frame(AuthorProd = L$AuthorProd[,1], Theoretical = Theoretical, Observed = Observed)

# 使用 ggplot2 进行作图
ggplot(df_plot, aes(x = AuthorProd)) +
  geom_area(aes(y = Theoretical),fill = "red",position = "identity", alpha = 0.3) +
  #geom_line(aes(y = Theoretical), color = "red") +
  geom_area(aes(y = Observed),fill = "blue",position = "identity", alpha = 0.3) +
  #geom_line(aes(y = Observed), color = "blue") +
  labs(x = "Author Productivity", y = "Freq", title = "Lotka Analysis \nTheoretical(red) vs Observed(blue)") 
ggsave("D:\\hqh_sci_cailiao\\20240219_new\\lotka.pdf",width = 105,height = 105,units = "mm")

#bradfor
bradford_result=bradford(biblio_df)
bradford_result_df=as.data.frame(bradford_result$table)


biblio_df%>%distinct(SO)%>%count()
# Zone       n
# <chr>  <int>
#   1 Zone 1    51
# 2 Zone 2   289
# 3 Zone 3  1748
#k=50,n=5.9 k*n=295,k*n^2=1741; k:k*n:k*^2=50:295:1741

#非酒精性脂肪肝
#Zone1：zone2：Zone2=23:106:620
#k=22 n=5.2 k:k*n:k*^2=22:114:594

#新肝衰老
#实际值：Zone1：zone2：Zone2=32：181：935
#理论值：k=32 n=5.4 k:k*n:k*^2=32:173:933
bradford_result_df%>%group_by(Zone)%>%count()

# 51  

biblio_df%>%group_by(SO)%>%count()%>%arrange(desc(n))