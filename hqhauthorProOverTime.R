#高产作者动态
library(bibliometrix)
library(ggplot2)
library(fs)
base_dir="C:\\Users\\xuzhe\\Desktop\\SciMAT\\WOS 20240125"
files=dir_ls(base_dir,regexp="download_.*")
#file=c(paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"),paste0(base_dir,"download_1-500.txt"))
biblio_df=convert2df(files,dbsource = "wos",format = "plaintext")

#修改第10行，listAU <- (strsplit(M$AF, ";")) 将AU改成AF再计算
trace(authorProdOverTime, edit = T) # 修改后保存

TopAu<-authorProdOverTime(biblio_df,k=10,graph = TRUE)
plot(TopAu$graph)
plot(TopAu$graph+geom_point(size = TopAu$graph$data$freq,fill=TopAu$graph$data$TCpY))

ggsave(filename = "D:\\hqh_sci_cailiao\\20240219_new\\p6_authorProdOverTime.pdf", # 指定要保存的文件名和扩展名
      # plot = p_a,                  # ggplot对象，可以省略，默认会保存最后绘制的图
       width = 210,           # 图像宽度（单位：英寸）
       height = 150,          # 图像高度（单位：英寸）
       device = "pdf",units = "mm")             # 可选，指定设备类型（如png、pdf、jpeg等），默认根据文件扩展名自动判断



